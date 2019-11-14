package skysand.render
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DBufferUsage;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	
	import skysand.input.SkyKey;
	import skysand.input.SkyKeyboard;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyTextBatch extends SkyBatchBase
	{
		/**
		 * Нужно ли отрисовывать пакет.
		 */
		public var isNeedToRender:Boolean;
		
		/**
		 * Текстура.
		 */
		private var texture:SkyTexture;
		
		/**
		 * Буффер текстурных координат + альфа канал.
		 */
		private var uvBuffer:VertexBuffer3D;
		
		/**
		 * Коэффициент, на который умножается исходный цвет.
		 */
		private var sourceBlendFactor:String;
		
		/**
		 * Коэффициент, на который умножается целевой цвет.
		 */
		private var destinationBlendFactor:String;
		
		public function SkyTextBatch()
		{
			
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
		 * Обновить текстуру и загрузить изображение в неё.
		 * @param	bitmapData битмапа для загрузки.
		 */
		public function uploadToTexture(bitmapData:BitmapData):void
		{
			if (texture == null) texture = new SkyTexture(bitmapData.width, bitmapData.height);
			else texture.setSize(bitmapData.width, bitmapData.height);
			
			texture.uploadFromBitmapData(bitmapData);
		}
		
		/**
		 * Обновить буффер вершин.
		 */
		public function updateVertexBuffer():void
		{
			vertexBuffer.uploadFromVector(verteces, 0, verteces.length / 4);
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
			sourceBlendFactor = Context3DBlendFactor.ONE;
			isNeedToRender = true;
			
			var vertexShader:String = "";
			vertexShader += "m44 op, va0, vc0 \n";
			vertexShader += "mov v0, va2 \n";
			vertexShader += "mov v0.z, va1.x";
			
			var pixelShader:String = "";
			pixelShader += "tex ft0, v0.xy, fs0 <2d, clamp, linear, nomip> \n";
			pixelShader += "mul ft0, ft0, v0.z \n";
			pixelShader += "mov oc, ft0";
			
			setShader(vertexShader, pixelShader);
			
			indices.push(0, 1, 2, 1, 3, 2);
			verteces.push(0, 0, 0, 1,
						  0, 0, 0, 1,
						  0, 0, 0, 1,
						  0, 0, 0, 1);
			
			var uvs:Vector.<Number> = new Vector.<Number>();
			uvs.push(0, 0);
			uvs.push(1, 0);
			uvs.push(0, 1);
			uvs.push(1, 1);
			
			uvBuffer = context3D.createVertexBuffer(4, 2);
			uvBuffer.uploadFromVector(uvs, 0, 4);
			
			indexBuffer = context3D.createIndexBuffer(6);
			indexBuffer.uploadFromVector(indices, 0, 6);
			
			vertexBuffer = context3D.createVertexBuffer(4, 4, Context3DBufferUsage.DYNAMIC_DRAW);
			vertexBuffer.uploadFromVector(verteces, 0, 4);
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			if (uvBuffer != null)
			{
				uvBuffer.dispose();
				uvBuffer = null;
			}
			
			if (texture != null)
			{
				texture.free();
				texture = null;
			}
			
			super.free();
		}
		
		/**
		 * Отрисовать все спрайты в пакете.
		 */
		override public function render():void
		{
			if (!isNeedToRender)
			{
				SkySand.render.notRenderedBatchesCount++;
				return;
			}
			
			context3D.setProgram(program);
			context3D.setBlendFactors(sourceBlendFactor, destinationBlendFactor);
			context3D.setTextureAt(0, texture.data);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, currentMatrix, true);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_1);
			context3D.setVertexBufferAt(2, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.drawTriangles(indexBuffer);
			
			context3D.setVertexBufferAt(2, null);
		}
	}
}