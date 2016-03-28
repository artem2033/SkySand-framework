package skysand.render.hardware
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.ByteArray;
	import skysand.display.SkyRenderObjectContainer;
	
	public class SkyQuadBatchBase extends Object
	{
		protected var verteces:Vector.<Number>;
		protected var indeces:Vector.<int>;
		protected var vertexBuffer:VertexBuffer3D;
		protected var indexBuffer:IndexBuffer3D;
		protected var uvs:VertexBuffer3D;
		protected var shader:Program3D
		protected var context3D:Context3D;
		
		public function SkyQuadBatchBase()
		{
			super();
		}
		
		public function initialize(context3D:Context3D):void
		{
			this.context3D = context3D;
		}
		
		public function setShader(vertexShader:String, pixelShader:String):void
		{
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			
			var vertexProgram:ByteArray = assembler.assemble(Context3DProgramType.VERTEX, vertexShader);
			var pixelProgram:ByteArray = assembler.assemble(Context3DProgramType.FRAGMENT, pixelShader);
			
			shader = context3D.createProgram();
			shader.upload(vertexProgram, pixelProgram);
		}
		
		public function add(object:SkyRenderObjectContainer):void
		{
			
		}
		
		public function render():void
		{
		
		}
	}
}