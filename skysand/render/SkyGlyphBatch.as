package skysand.render
{
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Program3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DFillMode;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DBufferUsage;
	import flash.display3D.Context3DVertexBufferFormat;
	import skysand.render.shaders.SkyBaseShaderList;
	
	import skysand.display.SkyShape;
	
	/**
	 * ...
	 * @author codecoregames
	 */
	public class SkyGlyphBatch extends SkyShapeBatch
	{
		public function SkyGlyphBatch()
		{
			
		}
		
		override public function initialize(context3D:Context3D, mvpMatrix:Matrix3D, worldMatrix:Matrix3D, name:String):void 
		{
			super.initialize(context3D, mvpMatrix, worldMatrix, name);
			
			destinationFactor = Context3DBlendFactor.ONE;
			sourceFactor = Context3DBlendFactor.ONE;
			texture = new SkyRenderTarget(1000, 600, Context3DTextureFormat.BGRA, true);
			
			glyphProgram = new SkyBaseShaderList().create();
			
			consts = new Vector.<Number>();
			consts.push(1, 2, 0, 255);
			drawCallCount = 2;
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, consts, 1);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, cc, 1);
			
			targetMatrix = texture.targetMatrix;
		}
		
		private var cc:Vector.<Number> = new <Number>[1000, 600, 2, 0];
		private var texture:SkyRenderTarget;
		private var glyphProgram:Program3D;
		private var consts:Vector.<Number>;
		private var targetMatrix:Matrix3D;
		
		
		override public function render():void 
		{
			updatePreRender();
			
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setTextureAt(0, null);
			context3D.setRenderToTexture(texture.data, false, 0);
			context3D.clear(0, 0, 0, 1);
			context3D.setProgram(program);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, texture.targetMatrix, true);
			context3D.setBlendFactors(sourceFactor, destinationFactor);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
			context3D.drawTriangles(indexBuffer);
			
			context3D.setRenderToBackBuffer();
				//blend modes one zero are faster
				//context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
			context3D.setVertexBufferAt(1, null);
			context3D.setProgram(glyphProgram);
			context3D.setTextureAt(0, texture.data);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, currentMatrix, true);
			
			context3D.setBlendFactors(sourceFactor, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.drawTriangles(indexBuffer);
			context3D.setTextureAt(0, null);
			context3D.setCulling(Context3DTriangleFace.BACK);
		}
	}
}
