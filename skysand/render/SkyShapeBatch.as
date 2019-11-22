package skysand.render
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DFillMode;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DBufferUsage;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import skysand.display.SkyShape;
	
	/**
	 * ...
	 * @author codecoregames
	 */
	public class SkyShapeBatch extends SkyBatchBase
	{
		/**
		 * Количество данный на одну вершину.
		 */
		public static const DATA_PER_VERTEX:uint = 7;
		
		/**
		 * Флаг для загрузки вершин в видеопамять.
		 */
		public var isUploaded:Boolean = false;
		
		/**
		 * Проверка на изменение размеров вершинного и индексного буфферов.
		 */
		private var isChanged:Boolean;
		
		/**
		 * Смещение индексов относительно последних добавленных.
		 */
		private var position:int;
		
		/**
		 * Объекты в данном пакете.
		 */
		private var objects:Vector.<SkyShape>;
		
		/**
		 * Количество индексов для одного объекта.
		 */
		private var sizes:Vector.<int>;
		
		/**
		 * Индексы для триангуляции.
		 */
		private var list:Vector.<uint>;
		
		/**
		 * Матрица для вычисления текстурных координат.
		 */
		private var matrix:Matrix;
		
		/**
		 * Прямоугольник для ограничения отрисовки.
		 */
		private var mScissorRect:Rectangle;
		
		
		public function SkyShapeBatch()
		{
			
		}
		
		/**
		 * Прямоугольник для ограничения отрисовки.
		 */
		public function set scissorRect(value:Rectangle):void
		{
			mScissorRect = value;
		}
		
		/**
		 * Прямоугольник для ограничения отрисовки.
		 */
		public function get scissorRect():Rectangle
		{
			return mScissorRect;
		}
		
		/**
		 * Инициализировать пакет.
		 * @param	context3D ссылка на контекст.
		 * @param	mvpMatrix model view матрица
		 * @param	name название пакета.
		 */
		override public function initialize(context3D:Context3D, mvpMatrix:Matrix3D, worldMatrix:Matrix3D, name:String):void
		{
			super.initialize(context3D, mvpMatrix, worldMatrix, name);
			
			objects = new Vector.<SkyShape>();
			sizes = new Vector.<int>();
			list = new Vector.<uint>();
			
			isChanged = false;
			_name = name;
			position = 0;
			
			var vertexShader:String = "";
			vertexShader += "m44 op, va0, vc0 \n";
			vertexShader += "mov v0, va1";
			
			var pixelShader:String = "";
			pixelShader += "mov ft0, v0 \n";
			pixelShader += "mul ft0.xyz, ft0.xyz, v0.w \n";//alpha
			pixelShader += "mov oc, ft0";
			
			setShader(vertexShader, pixelShader);
		}
		
		/**
		 * Добавить новый объект для отрисовки в пакет.
		 * @param	object объект который нужно отрисовать.
		 */
		public function add(object:SkyShape, shapeIndices:Vector.<uint> = null):void
		{
			var length:int = object.verticesCount;
			
			var r:Number = ((object.color >> 16) & 0xFF) / 255;
			var g:Number = ((object.color >> 8) & 0xFF) / 255;
			var b:Number = (object.color & 0xFF) / 255;
			
			for (var i:int = 0; i < length; i++)
			{
				verteces.push(0, 0, object.depth, r, g, b, object.alpha);
			}
			
			sizes.push(indices.length);
			
			if (shapeIndices == null) triangulate(object.vertices);
			else concat(shapeIndices);
			
			object.indexID = position;
			position = verteces.length;
			objects.push(object);
			
			isChanged = true;
		}
		
		/**
		 * Удалить объект из пакета.
		 * @param	object объект.
		 */
		public function remove(object:SkyShape):void
		{
			var index:int = objects.indexOf(object);
			
			if (index < 0) return;
			
			var size:int = object.verticesCount * DATA_PER_VERTEX;
			var indexCount:int = index + 1 != sizes.length ? sizes[index + 1] - sizes[index] : indices.length - sizes[index];
			var length:int = 0;
			
			verteces.splice(object.indexID, size);
			indices.splice(sizes[index], indexCount);
			
			length = indices.length;
			
			for (var i:int = sizes[index]; i < length; i++)
			{
				indices[i] -= size / DATA_PER_VERTEX;
			}
			
			objects.removeAt(index);
			sizes.removeAt(index);
			
			position -= size;
			
			length = objects.length;
			
			for (i = index; i < length; i++)
			{
				objects[i].indexID -= size;
				sizes[i] -= indexCount;
			}
			
			isChanged = true;
			
			if (verteces.length == 0) free();
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			list.length = 0;
			list = null;
			
			sizes.length = 0;
			sizes = null;
			
			objects.length = 0;
			objects = null;
			
			super.free();
		}
		
		/**
		 * Отрисовать все спрайты в пакете.
		 */
		override public function render():void
		{
			super.render();
			
			if (verteces.length == 0) return;//с пустым пакетом вылетает ошибка.
			if (isChanged && verteces.length > 0)
			{
				vertexBuffer = context3D.createVertexBuffer(verteces.length / DATA_PER_VERTEX, DATA_PER_VERTEX, Context3DBufferUsage.DYNAMIC_DRAW);
				indexBuffer = context3D.createIndexBuffer(indices.length);
				indexBuffer.uploadFromVector(indices, 0, indices.length);
				
				isChanged = false;
			}
			
			if (!isUploaded)
			{
				vertexBuffer.uploadFromVector(verteces, 0, verteces.length / DATA_PER_VERTEX);
				isUploaded = true;
			}
			
			context3D.setProgram(program);
			context3D.setTextureAt(0, null);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, currentMatrix, true);
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
			
			if (mScissorRect != null) context3D.setScissorRectangle(mScissorRect);
			
			context3D.drawTriangles(indexBuffer);
			context3D.setScissorRectangle(null);
		}
		
		/**
		 * Посчитать текстурные координаты.
		 * @param	mesh меш.
		 * @param	data данные о текстуре.
		 * @param	atlasWidth ширина текстуры.
		 * @param	atlasHeight высота текстуры.
		 */
		/*private function calculateUV(mesh:SkyMesh, data:SkyAtlasSprite, atlas:SkyTextureAtlas):void
		{
			matrix.identity();
			matrix.scale(data.width / mesh.width, data.height / mesh.height);//???
			
			var verteces:Vector.<Number> = mesh.vertices;
			var length:int = verteces.length / 2;
			
			for (var i:int = 0; i < length; i++)
			{
				var x:int = verteces[i * 2];
				var y:int = verteces[i * 2 + 1];
				
				var dx:Number = data.pivotX + x * matrix.a + y * matrix.c;
				var dy:Number = data.pivotY + x * matrix.b + y * matrix.d;
				
				//uvs.push(dx / atlas.width, dy / atlas.height);
			}
		}*/
		
		/**
		 * Трианугляция многоугольника без самопересечений.
		 * @param	verteces массив координат многоугольника.
		 */
		private function triangulate(verteces:Vector.<Number>):void
		{
			if (verteces.length < 6)
			{
				indices.push(position / DATA_PER_VERTEX, position / DATA_PER_VERTEX + 1, position / DATA_PER_VERTEX + 2);
				
				return;
			}
			
			list.length = 0;
			
			var i:int = 0;
			var temp:Vector.<Number> = verteces.concat();
			var length:int = verteces.length;
			var min:Number = verteces[0];
			var minIndex:int = 0;
			
			for (i = 0; i < length / 2; i++)
			{
				list.push(i);
				
				if (min > verteces[i * 2])
				{
					min = verteces[i * 2];
					minIndex = i * 2;
				}
			}
			
			var x:Number = verteces[minIndex];//check posible optimisation
			var y:Number = verteces[minIndex + 1];
			var xnext:Number = verteces[minIndex + 2 > length - 1 ? 0 : minIndex + 2];
			var ynext:Number = verteces[minIndex + 3 > length - 1 ? 1 : minIndex + 3];
			var xprev:Number = verteces[minIndex - 2 < 0 ? length - 2 : minIndex - 2];
			var yprev:Number = verteces[minIndex - 1 < 0 ? length - 1 : minIndex - 1];
			var clockwise:Number = (xnext - x) * (yprev - y) - (ynext - y) * (xprev - x);
			
			i = 0;
			
			while (length > 6)
			{
				var ax:Number = temp[i];//check posible optimisation
				var ay:Number = temp[i + 1];
				var bx:Number = temp[i + 2 > length - 1 ? 0 : i + 2];
				var by:Number = temp[i + 3 > length - 1 ? 1 : i + 3];
				var cx:Number = temp[i + 4 > length - 1 ? i + 4 - length : i + 4];
				var cy:Number = temp[i + 5 > length - 1 ? i + 5 - length : i + 5];
				
				var d:Number = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax);
				
				if ((d < 0 && clockwise < 0) || (d > 0 && clockwise > 0))
				{
					var isEmpty:Boolean = true;
					
					for (var j:int = 0; j < length; j += 2)
					{
						x = temp[j];
						y = temp[j + 1];
						
						if ((x == ax && y == ay) || (x == bx && y == by) || (x == cx && y == cy)) continue;
						
						var n1:Number = (by - ay) * (x - ax) - (bx - ax) * (y - ay);
						var n2:Number = (cy - by) * (x - bx) - (cx - bx) * (y - by);
						var n3:Number = (ay - cy) * (x - cx) - (ax - cx) * (y - cy);
						
						if ((n1 > 0 && n2 > 0 && n3 > 0) || (n1 < 0 && n2 < 0 && n3 < 0))
						{
							isEmpty = false;
							break;
						}
					}
					
					if (isEmpty)
					{
						indices.push(list[i / 2] + position / DATA_PER_VERTEX);//check posible optimisation
						indices.push((i / 2 + 1 > length / 2 - 1 ? list[0] : list[i / 2 + 1]) + position / DATA_PER_VERTEX);
						indices.push((i / 2 + 2 > length / 2 - 1 ? list[i / 2 + 2 - length / 2] : list[i / 2 + 2]) + position / DATA_PER_VERTEX);
						list.removeAt(i / 2 + 1 > length / 2 - 1 ? 0 : i / 2 + 1);
						temp.splice(i + 4 > length ? 0 : i + 2, 2);
						
						i -= 2;
						length -= 2;
					}
				}
				
				i = i + 2 > length - 1 ? 0 : i + 2;
			}
			
			indices.push(list[0] + position / DATA_PER_VERTEX, list[1] + position / DATA_PER_VERTEX, list[2] + position / DATA_PER_VERTEX);
		}
		
		/**
		 * Добавить индексы фигуры в общий массив применив к ним смещение.
		 * @param	objectIndices массив индексов для построения треугольников фигуры.
		 */
		private function concat(objectIndices:Vector.<uint>):void
		{
			var length:int = objectIndices.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				objectIndices[i] += position / DATA_PER_VERTEX;
				indices.push(objectIndices[i]);
			}
		}
	}
}