package skysand.render
{
	import adobe.utils.CustomActions;
	import flash.display3D.Context3DBufferUsage;
	import flash.display3D.Context3DFillMode;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Rectangle;
	import skysand.display.SkyMesh;
	import skysand.file.SkyAtlasSprite;
	import skysand.file.SkyTextureAtlas;
	
	import skysand.interfaces.IBatch;
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
		 * Текстурные координаты.
		 */
		public var uvs:Vector.<Number>;
		
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
		 * Текстура для отрисовки меша
		 */
		private var texture:TextureBase;
		
		/**
		 * Буффер текстурных координат.
		 */
		private var uvBuffer:VertexBuffer3D;
		
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
		 * Задать текстуру.
		 * @param	texture текстура.
		 */
		public function setTexture(texture:TextureBase):void
		{
			if (this.texture != texture) this.texture = texture;
		}
		
		/**
		 * Инициализировать пакет.
		 * @param	context3D ссылка на контекст.
		 * @param	mvpMatrix model view матрица
		 * @param	name название пакета.
		 */
		override public function initialize(context3D:Context3D, mvpMatrix:Matrix3D, name:String):void
		{
			super.initialize(context3D, mvpMatrix, name);
			
			objects = new Vector.<SkyShape>();
			sizes = new Vector.<int>();
			list = new Vector.<uint>();
			
			isChanged = false;
			_name = name;
			position = 0;
			
			if (texture != null)
			{
				matrix = new Matrix();
				uvs = new Vector.<Number>();
				
				var vertexShader:String = "";
				vertexShader += "m44 op, va0, vc0 \n";
				vertexShader += "mov v0, va1 \n";//color
				vertexShader += "mov v1, va2";//uv
				
				var pixelShader:String = "";
				pixelShader += "tex ft0, v1, fs0 <2d, " + Context3DWrapMode.CLAMP + ", " + Context3DTextureFilter.ANISOTROPIC16X + "> \n";
				pixelShader += "mul ft0, ft0, v0 \n";
				pixelShader += "mov oc, ft0";
			}
			else
			{
				vertexShader = "";
				vertexShader += "m44 op, va0, vc0 \n";
				vertexShader += "mov v0, va1";
				
				pixelShader = "";
				pixelShader += "mov ft0, v0 \n";
				pixelShader += "mul ft0.xyz, ft0.xyz, v0.w \n";//alpha
				pixelShader += "mov oc, ft0";
			}
			
			setShader(vertexShader, pixelShader);
		}
		
		public function addMesh(mesh:SkyMesh, data:SkyAtlasSprite, atlas:SkyTextureAtlas):void
		{
			var length:int = mesh.vertecesCount;
			
			for (var i:int = 0; i < length; i++)
			{
				verteces.push(0, 0, 0, 1, 1, 1, 1);
			}
			
			sizes.push(indices.length);
			triangulate(mesh.getVertices());
			calculateUV(mesh, data, atlas);
			mesh.indexID = position;
			position = verteces.length;
			objects.push(mesh);
			
			isChanged = true;
		}
		
		/**
		 * Добавить новый объект для отрисовки в пакет.
		 * @param	object объект который нужно отрисовать.
		 */
		public function add(object:SkyShape):void
		{
			var length:int = object.vertecesCount;
			
			for (var i:int = 0; i < length; i++)
			{
				verteces.push(0, 0, 0, 1, 1, 1, 1);
			}
			
			sizes.push(indices.length);
			triangulate(object.getVertices());
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
			
			var size:int = object.vertecesCount * DATA_PER_VERTEX;
			var indexCount:int = index + 1 != sizes.length ? sizes[index + 1] - sizes[index] : indices.length - sizes[index];
			var length:int = 0;
			
			verteces.splice(object.indexID, size);
			indices.splice(sizes[index], indexCount);
			if (uvs != null) uvs.splice(object.indexID / 7 * 2, object.vertecesCount * 2);
			
			length = indices.length;
			
			for (var i:int = sizes[index]; i < length; i++)
			{
				indices[i] -= size / DATA_PER_VERTEX;
			}
			
			objects.splice(index, 1);
			sizes.splice(index, 1);
			
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
			
			if (texture)
			{
				texture = null;
				
				uvs.length = 0;
				uvs = null;
				
				uvBuffer.dispose();
				uvBuffer = null;
				
				matrix = null;
			}
			
			super.free();
		}
		
		/**
		 * Отрисовать все спрайты в пакете.
		 */
		override public function render():void
		{
			super.render();
			
			if (isChanged && verteces.length > 0)
			{
				if (texture)
				{
					uvBuffer = context3D.createVertexBuffer(uvs.length / 2, 2);
					uvBuffer.uploadFromVector(uvs, 0, uvs.length / 2);
				}
				
				vertexBuffer = context3D.createVertexBuffer(verteces.length / DATA_PER_VERTEX, DATA_PER_VERTEX, Context3DBufferUsage.DYNAMIC_DRAW);
				indexBuffer = context3D.createIndexBuffer(indices.length);
				indexBuffer.uploadFromVector(indices, 0, indices.length);
				
				isChanged = false;
			}
			
			vertexBuffer.uploadFromVector(verteces, 0, verteces.length / DATA_PER_VERTEX);
			
			context3D.setProgram(program);
			context3D.setTextureAt(0, texture);
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
			context3D.setVertexBufferAt(2, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			
			if (mScissorRect != null) context3D.setScissorRectangle(mScissorRect);
			
			context3D.drawTriangles(indexBuffer);
			context3D.setScissorRectangle(null);
			context3D.setVertexBufferAt(2, null);
		}
		
		/**
		 * Посчитать текстурные координаты.
		 * @param	mesh меш.
		 * @param	data данные о текстуре.
		 * @param	atlasWidth ширина текстуры.
		 * @param	atlasHeight высота текстуры.
		 */
		private function calculateUV(mesh:SkyMesh, data:SkyAtlasSprite, atlas:SkyTextureAtlas):void
		{
			matrix.identity();
			matrix.scale(data.width / mesh.width, data.height / mesh.height);
			
			var verteces:Vector.<Number> = mesh.getVertices();
			var length:int = verteces.length / 2;
			
			for (var i:int = 0; i < length; i++)
			{
				var x:int = verteces[i * 2];
				var y:int = verteces[i * 2 + 1];
				
				var dx:Number = data.pivotX + x * matrix.a + y * matrix.c;
				var dy:Number = data.pivotY + x * matrix.b + y * matrix.d;
				
				uvs.push(dx / atlas.width, dy / atlas.height);
			}
		}
		
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
	}
}