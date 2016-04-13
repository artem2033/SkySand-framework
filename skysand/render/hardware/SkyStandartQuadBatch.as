package skysand.render.hardware
{
	import code.PerspectiveMatrix3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import skysand.utils.SkyFilesCache;
	
	public class SkyStandartQuadBatch extends SkyQuadBatchBase
	{
		private var mvpMatrix:Matrix3D;
		
		public function SkyStandartQuadBatch()
		{
			
		}
		
		public function setMatrix(matrix:Matrix3D):void
		{
			mvpMatrix = matrix;
		}
		
		public function setTexture(textureName:String):void
		{
			texture = SkyFilesCache.instance.getTexture();
		}
		
		override public function initialize(context3D:Context3D):void 
		{
			super.initialize(context3D);
			
			name = "standart";
			
			initShaders();
		}
		
		private function initShaders():void
		{
			var vertexShader:String = "";
			vertexShader += "m33 op, va0, vc0 \n";
			vertexShader += "mov v0, va1";
			
			var pixelShader:String = "";
			pixelShader += "tex ft0, v0, fs0 <2d, linear, clamp, miplinear> \n";
			pixelShader += "mov oc, ft0";
			
			setShader(vertexShader, pixelShader);
		}
		
		override public function render():void 
		{
			super.render();
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mvpMatrix, true);
			context3D.setTextureAt(0, texture);
			
			context3D.drawTriangles(indexBuffer, 0, indeces.length);
		}
	}
}