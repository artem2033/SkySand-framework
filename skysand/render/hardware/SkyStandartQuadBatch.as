package skysand.render.hardware
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import skysand.utils.SkyFilesCache;
	import skysand.interfaces.IQuadBatch;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyTextureAtlas;
	import skysand.display.SkyRenderObjectContainer;
	
	public class SkyStandartQuadBatch extends Object implements IQuadBatch
	{
		private var mvpMatrix:Matrix3D;
		private var textureAtlas:SkyTextureAtlas;
		protected var verteces:Vector.<Number>;
		protected var indeces:Vector.<uint>;
		protected var uvs:Vector.<Number>;
		protected var vertexBuffer:VertexBuffer3D;
		protected var indexBuffer:IndexBuffer3D;
		protected var uvBuffer:VertexBuffer3D;
		protected var context3D:Context3D;
		protected var program:Program3D
		protected var texture:Texture;
		protected var textureName:String;
		private var fl:Boolean = false;
		private var matrix:Matrix = new Matrix();
		private var id:int = 0;
		private var objects:Vector.<SkyRenderObjectContainer>;
		private var atlas:SkyTextureAtlas;
		
		public function SkyStandartQuadBatch()
		{
			
		}
		
		public function setMatrix(matrix:Matrix3D):void
		{
			mvpMatrix = matrix;
		}
		
		public function setTexture(textureName:String, spriteName:String):void
		{
			if (texture == null)
			{
				if (spriteName == "")
				{
					texture = SkyFilesCache.instance.getTexture(textureName).texture;
				}
				else
				{
					texture = SkyFilesCache.instance.getAtlas(textureName).texture;
				}
				
				this.textureName = textureName;
			}
			else throw new Error("Texture for this batch is created!");
		}
		
		public function initialize(context3D:Context3D):void
		{
			this.context3D = context3D;
			
			textureName = "";
			
			verteces = new Vector.<Number>();
			indeces = new Vector.<uint>();
			uvs = new Vector.<Number>();
			objects = new Vector.<SkyRenderObjectContainer>();
			
			initShaders();
		}
		
		public function setShader(vertexShader:String, pixelShader:String):void
		{
			/*var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			
			var vertexProgram:ByteArray = assembler.assemble(Context3DProgramType.VERTEX, vertexShader);
			var pixelProgram:ByteArray = assembler.assemble(Context3DProgramType.FRAGMENT, pixelShader);
			*/
			
			var vertexProgram:AGALMiniAssembler = new AGALMiniAssembler();
			vertexProgram.assemble(Context3DProgramType.VERTEX, vertexShader);
			
			var pixelProgram:AGALMiniAssembler = new AGALMiniAssembler();
			pixelProgram.assemble(Context3DProgramType.FRAGMENT, pixelShader);
			
			program = context3D.createProgram();
			program.upload(vertexProgram.agalcode, pixelProgram.agalcode);
		}
		
		public function get name():String
		{
			return textureName;
		}
		
		public function add(object:SkyRenderObject, spriteName:String, textureName:String):void
		{
			object.setBatchVertices(verteces, id);
			
			var index:int = id * 4;
			
			indeces.push(index, index + 1, index + 2, index + 1, index + 3, index + 2);
			
			if (spriteName == "")
			{
				uvs.push(0, 0);
				uvs.push(1, 0);
				uvs.push(0, 1);
				uvs.push(1, 1);
			}
			else
			{
				var atlasUV:Vector.<Number> = SkyFilesCache.instance.getAtlasUV(spriteName, textureName);
				
				uvs.push(atlasUV[0], atlasUV[1]);
				uvs.push(atlasUV[2], atlasUV[3]);
				uvs.push(atlasUV[4], atlasUV[5]);
				uvs.push(atlasUV[6], atlasUV[7]);
			}
			
			fl = false;
			id++			
		}
		
		private function initShaders():void
		{
			var vertexShader:String = "";
			vertexShader += "m44 op va0, vc0 \n";
			vertexShader += "mov v0, va1";
			
			var pixelShader:String = "";
			pixelShader += "tex oc, v0, fs0 <2d, clamp, linear, nomip>";
			
			setShader(vertexShader, pixelShader);
		}
		
		public function render():void 
		{
			if (!fl)
			{
				vertexBuffer = context3D.createVertexBuffer(verteces.length / 3, 3);
				indexBuffer = context3D.createIndexBuffer(indeces.length);
				uvBuffer = context3D.createVertexBuffer(uvs.length / 2, 2);
				indexBuffer.uploadFromVector(indeces, 0, indeces.length);
				uvBuffer.uploadFromVector(uvs, 0, uvs.length / 2);
				
				fl = true;
			}
			
			context3D.setProgram(program);
			context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mvpMatrix, true);
			context3D.setTextureAt(0, texture);
			
			vertexBuffer.uploadFromVector(verteces, 0, verteces.length / 3);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			
			context3D.drawTriangles(indexBuffer);
		}
	}
}