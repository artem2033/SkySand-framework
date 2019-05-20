package skysand.render.effects 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.TextureBase;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyBaseTextureRender extends Object
	{
		private var verteces:Vector.<Number>;
		private var uv:Vector.<Number>;
		
		private var target:RectangleTexture;
		
		private var context3D:Context3D;
		private var shader:Program3D;
		private var indexBuffer:IndexBuffer3D;
		private var vertexBuffer:VertexBuffer3D;
		private var uvBuffer:VertexBuffer3D;
		
		public function SkyBaseTextureRender() 
		{
			uv = new Vector.<Number>();
			uv.push(0, 0);
			uv.push(1, 0);
			uv.push(0, 1);
			uv.push(1, 1);
			
			var indeces:Vector.<uint> = new Vector.<uint>();
			indeces.push(0, 1, 2);
			indeces.push(1, 3, 2);
			
			var vertexShader:String = "";
			vertexShader += "m44 op, va0, vc0 \n";
			vertexShader += "mov v0, va1";
			
			var pixelShader:String = "";
			pixelShader += "tex oc, v0, fs0 <2d, clamp, linear, mipnone>";
			pixelShader += "sub ft1, ft1, fc0.w \n";
			pixelShader += "kil ft1.w \n";
			pixelShader += "mul ft1.a, ft1.a, fc0.z \n";
			pixelShader += "mov oc, ft1";
			
			target = context3D.createRectangleTexture(SkySand.SCREEN_WIDTH, SkySand.SCREEN_HEIGHT, Context3DTextureFormat.BGRA, true);
			target.uploadFromBitmapData(new BitmapData(1, 1));
			
			indexBuffer = context3D.createIndexBuffer(6);
			indexBuffer.uploadFromVector(indeces, 0, 6);
			
			uvBuffer = context3D.createVertexBuffer(4, 2);
			uvBuffer.uploadFromVector(uv, 0, 4);
			
			vertexBuffer = context3D.createVertexBuffer(4, 3);
			vertexBuffer.uploadFromVector(verteces, 0, 4);
			
			threshold = new Vector.<Number>();
			threshold.push(0, 0, 20, 0.2);
			
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			shader = assembler.assemble2(context3D, 3, vertexShader, pixelShader);
			context3D.setProgram(shader);
			
			drawSample();
			
			spriteBatch = new SkyStandartQuadBatch();
			spriteBatch.initialize(context3D, SkyHardwareRender.instance.modelViewMatrix, "fluidParticles");
			particles = new Vector.<SkySprite>();
			
			
		}
		
		public function initialize():void
		{
			context3D = SkySand.CONTEXT_3D;
			
			verteces = new Vector.<Number>();
			verteces.push(0, 0, 0);
			verteces.push(SkySand.SCREEN_WIDTH, 0, 0);
			verteces.push(0, SkySand.SCREEN_HEIGHT, 0);
			verteces.push(SkySand.SCREEN_WIDTH, SkySand.SCREEN_HEIGHT, 0);
		}
		
		public function renderTexture(texture:TextureBase, width:Number, height:Number):void
		{
			context3D.setProgram(shader);
			context3D.setTextureAt(0, target);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, SkyHardwareRender.instance.modelViewMatrix, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, threshold);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(2, null);
			context3D.drawTriangles(indexBuffer);
		}
	}
}