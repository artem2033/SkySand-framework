package skysand.render
{
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Context3DWrapMode;
	import flash.display3D.Context3DMipFilter;
	import flash.display3D.Context3DBufferUsage;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import skysand.utils.SkyUtils;
	import skysand.display.SkySprite;
	import skysand.file.SkyAtlasSprite;
	import skysand.interfaces.ISpriteRenderer;
	import skysand.render.shaders.SkyBaseShaderList;
	
	public class SkyQuadBatch extends SkyBatchBase implements ISpriteRenderer
	{
		/**
		 * Массив текстурных координат + альфа канал.
		 */
		protected var mUvs:Vector.<Number>;
		
		/**
		 * Текстура.
		 */
		protected var texture:SkyTexture;
		
		/**
		 * Буффер текстурных координат + альфа канал.
		 */
		protected var uvBuffer:VertexBuffer3D;
		
		/**
		 * Проверка на изменение размера массивов.
		 */
		protected var isChanged:Boolean;
		
		/**
		 * Порядковый номер спрайта.
		 */
		protected var id:int;
		
		/**
		 * Массив спрайтов.
		 */
		protected var objects:Vector.<SkySprite>;
		
		/**
		 * Коэффициент, на который умножается исходный цвет.
		 */
		protected var sourceBlendFactor:String;
		
		/**
		 * Коэффициент, на который умножается целевой цвет.
		 */
		protected var destinationBlendFactor:String;
		
		/**
		 * Фильтрация текстуры.
		 */
		protected var textureFilter:String;
		
		/**
		 * Способ наложения текстуры.
		 */
		protected var wrapMode:String;
		
		/**
		 * Прямоугольник для ограничения отрисовки.
		 */
		protected var mScissorRect:Rectangle;
		
		protected var isUpload:Boolean = false;
		
		public function SkyQuadBatch()
		{
			
		}
		
		/**
		 * Обновить массив вершин.
		 */
		public function updateVertexBuffer():void
		{
			isUpload = false;
		}
		
		/**
		 * Указывает коэффициенты, используемые для наложения цвета вывода операции рисования на существующий цвет.
		 * @param	source коэффициент, на который умножается исходный цвет.
		 * @param	destination коэффициент, на который умножается целевой цвет.
		 */
		public function setBlendFactor(source:String, destination:String):void
		{
			sourceBlendFactor = source;
			destinationBlendFactor = destination;
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
			
			destinationBlendFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
			sourceBlendFactor = Context3DBlendFactor.SOURCE_ALPHA;
			textureFilter = Context3DTextureFilter.ANISOTROPIC16X;
			wrapMode = Context3DWrapMode.CLAMP;
			
			isChanged = true;
			_name = name;
			id = 0;
			drawCallCount = 1;
			
			mUvs = new Vector.<Number>();
			objects = new Vector.<SkySprite>();
			
			setShaderProgram(SkyBaseShaderList.SIMPLE_SPRITE);
		}
		
		/**
		 * Задать текстуру.
		 * @param	texture ссылка на текстуру.
		 */
		public function setTexture(texture:SkyTexture):void
		{
			if (this.texture == null)
				this.texture = texture;
		}
		
		/**
		 * Задать текстуру из битмапы.
		 * @param	bitmapData битмапа.
		 */
		public function setTextureFromBitmapData(bitmapData:BitmapData):void
		{
			if (texture == null) texture = new SkyTexture(bitmapData.width, bitmapData.height);
			else texture.setSize(bitmapData.width, bitmapData.height);
			
			texture.uploadFromBitmapData(bitmapData);
		}
		
		/**
		 * Сменить тип фильтрации текстур.
		 * @param	filter фильтрация.
		 */
		public function setTextureFilter(filter:String):void
		{
			textureFilter = filter;
			trace("add swap filter");
		}
		
		/**
		 * Сменить способ наложения текстуры.
		 * @param	mode способ наложения.
		 */
		public function setWrapMode(mode:String):void
		{
			wrapMode = mode;
			trace("add swap wrap mode");
		}
		
		/**
		 * Содержится ли данный спрайт в этом пакете.
		 * @param	object ссылка на спрайт.
		 */
		public function contains(object:SkySprite):Boolean
		{
			return objects.indexOf(object) >= 0;
		}
		
		/**
		 * Добавить спрайт в пакет.
		 * @param	sprite спрайт.
		 */
		public function add(object:SkySprite, data:SkyAtlasSprite):void
		{
			object.indexID = id * 28;
			
			indices.push(id * 4, id * 4 + 1, id * 4 + 2, id * 4 + 1, id * 4 + 3, id * 4 + 2);
			
			mUvs.push(data.uvs[0], data.uvs[1]);
			mUvs.push(data.uvs[2], data.uvs[3]);
			mUvs.push(data.uvs[4], data.uvs[5]);
			mUvs.push(data.uvs[6], data.uvs[7]);
			
			var r:Number = SkyUtils.getRed(object.color) / 255;
			var g:Number = SkyUtils.getGreen(object.color) / 255;
			var b:Number = SkyUtils.getBlue(object.color) / 255;
			
			verteces.push(0, 0, 0, r, g, b, object.alpha);
			verteces.push(0, 0, 0, r, g, b, object.alpha);
			verteces.push(0, 0, 0, r, g, b, object.alpha);
			verteces.push(0, 0, 0, r, g, b, object.alpha);
			
			objects.push(object);
			isChanged = true;
			id++
		}
		
		/**
		 * Удалить спрайт из пакета.
		 * @param	sprite спрайт.
		 */
		public function remove(object:SkySprite):void
		{
			if (objects.indexOf(object) < 0) return;
			
			verteces.splice(object.indexID, 28);
			indices.splice(indices.length - 6, 6);
			mUvs.splice(object.indexID / 7 * 2, 8);
			
			isChanged = true;
			id--;
			
			var length:int = objects.length;
			var index:int = objects.indexOf(object);
			
			for (var i:int = index; i < length; i++)
			{
				objects[i].indexID -= 28;
			}
			
			objects.removeAt(index);
			
			if (verteces.length == 0) free();
		}
		
		/**
		 * Отрисовать все спрайты в пакете.
		 */
		override public function render():void
		{
			if (objects.length == 0) return;
			
			super.render();
			
			if (isChanged)
			{
				vertexBuffer = context3D.createVertexBuffer(verteces.length / 7, 7, Context3DBufferUsage.DYNAMIC_DRAW);
				indexBuffer = context3D.createIndexBuffer(indices.length);
				indexBuffer.uploadFromVector(indices, 0, indices.length);
				uvBuffer = context3D.createVertexBuffer(mUvs.length / 2, 2);
				
				isChanged = false;
			}
			
			if (!isUpload)
			{
				vertexBuffer.uploadFromVector(verteces, 0, verteces.length / 7);
				isUpload = true;
			}
			
			uvBuffer.uploadFromVector(mUvs, 0, mUvs.length / 2);
			
			context3D.setProgram(program);
			context3D.setBlendFactors(sourceBlendFactor, destinationBlendFactor);
			context3D.setTextureAt(0, texture.data);
			//context3D.setSamplerStateAt(0, wrapMode, textureFilter, Context3DMipFilter.MIPNONE);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, currentMatrix, true);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
			context3D.setVertexBufferAt(2, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			
			if (mScissorRect != null) context3D.setScissorRectangle(mScissorRect);
			
			context3D.drawTriangles(indexBuffer);
			context3D.setScissorRectangle(null);
			context3D.setVertexBufferAt(2, null);
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
		 * Получить массив с текстурными координатами.
		 */
		public function get uvs():Vector.<Number>
		{
			return mUvs;
		}
		
		/**
		 * Получить массив с вершинами.
		 */
		public function get vertices():Vector.<Number>
		{
			return verteces;
		}
	}
}