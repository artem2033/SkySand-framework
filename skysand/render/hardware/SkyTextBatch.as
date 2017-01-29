package skysand.render.hardware 
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	
	import skysand.text.SkyTextField;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyTextBatch extends SkyBatchBase
	{
		/**
		 * Массив текстурных координат + альфа канал.
		 */
		public var uvs:Vector.<Number>;
		
		/**
		 * Буффер текстурных координат + альфа канал.
		 */
		private var uvBuffer:VertexBuffer3D;
		
		/**
		 * Текстура.
		 */
		public var texture:Texture;
		
		/**
		 * Проверка на изменение размера массивов.
		 */
		private var isChanged:Boolean;
		
		/**
		 * Порядковый номер спрайта.
		 */
		private var id:int;
		
		public function SkyTextBatch() 
		{
			
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
			
			isChanged = false;
			_name = name;
			id = 0;
			
			uvs = new Vector.<Number>();
			
			var vertexShader:String = "";
			vertexShader += "m44 op, va0, vc0 \n";
			vertexShader += "mov v0, va1";
			
			var pixelShader:String = "";
			pixelShader += "tex ft0, v0.xy, fs0 <2d, clamp, linear, nomip> \n";
			pixelShader += "mul ft0, ft0, v0.z \n";
			pixelShader += "mov oc, ft0";
			
			setShader(vertexShader, pixelShader);
		}
		
		/**
		 * Деструктор.
		 */
		override public function free():void 
		{
			uvs.length = 0;
			uvs = null;
			
			if (uvBuffer) 
			{
				uvBuffer.dispose();
				uvBuffer = null;
			}
			
			if (texture)
			{
				texture.dispose();
				texture = null;
			}
			
			super.free();
		}
		
		/**
		 * Добавить текстовое поле в пакет.
		 * @param	textField текстовое поле.
		 */
		public function add(textField:SkyTextField):void
		{
			texture = SkySand.CONTEXT_3D.createTexture(2, 2, Context3DTextureFormat.BGRA, false);
			textField.indexID = id * 12;
			
			indeces.push(id * 4, id * 4 + 1, id * 4 + 2, id * 4 + 1, id * 4 + 3, id * 4 + 2);
			
			uvs.push(0, 0, textField.alpha);
			uvs.push(1, 0, textField.alpha);
			uvs.push(0, 1, textField.alpha);
			uvs.push(1, 1, textField.alpha);
			
			verteces.push(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			
			isChanged = true;
			id++
		}
		
		/**
		 * Удалить текстовое поле из пакета.
		 * @param	textField текстовое поле.
		 */
		public function remove(textField:SkyTextField):void
		{
			verteces.splice(textField.indexID, 12);
			indeces.splice(textField.indexID / 2, 6);
			uvs.splice(textField.indexID, 12);
			isChanged = true;
			
			if (verteces.length == 0) free();
		}
		
		/**
		 * Отрисовать все спрайты в пакете.
		 */
		override public function render():void
		{
			super.render();
			
			if (isChanged && verteces.length > 0)
			{
				vertexBuffer = context3D.createVertexBuffer(verteces.length / 3, 3);
				indexBuffer = context3D.createIndexBuffer(indeces.length);
				uvBuffer = context3D.createVertexBuffer(uvs.length / 3, 3);
				
				indexBuffer.uploadFromVector(indeces, 0, indeces.length);
				
				isChanged = false;
			}
			
			vertexBuffer.uploadFromVector(verteces, 0, verteces.length / 3);
			uvBuffer.uploadFromVector(uvs, 0, uvs.length / 3);
			
			context3D.setProgram(program);
			context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mvpMatrix, true);
			context3D.setTextureAt(0, texture);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.drawTriangles(indexBuffer);
		}
	}
}