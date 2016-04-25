package skysand.render.hardware
{
	import adobe.utils.CustomActions;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.sampler.NewObjectSample;
	import flash.utils.ByteArray;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyTextureAtlas;
	
	public class SkyQuadBatchBase extends Object
	{
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
		
		public function SkyQuadBatchBase()
		{
			super();
		}
		
		public function initialize(context3D:Context3D):void
		{
			this.context3D = context3D;
			
			textureName = "";
			
			verteces = new Vector.<Number>();
			indeces = new Vector.<uint>();
			uvs = new Vector.<Number>();
			objects = new Vector.<SkyRenderObjectContainer>();
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
		
		public function add(object:SkyRenderObject):void
		{
			object.setBatchVertices(verteces, id);
			
			var index:int = id * 4;
			
			indeces.push(index, index + 1, index + 2, index + 1, index + 3, index + 2);
			
			uvs.push(0, 0);
			uvs.push(1, 0);
			uvs.push(0, 1);
			uvs.push(1, 1);
			
			fl = false;
			id++			
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
		}
	}
}