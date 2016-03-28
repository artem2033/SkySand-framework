package skysand.display
{
	import flash.geom.Matrix;
	
	public class SkyRenderObject extends Object
	{
		public var transformMatrix:Matrix
		public var x:Number;
		public var y:Number;
		public var alpha:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var rotation:Number;
		public var width:Number;
		public var height:Number;
		public var depth:Number;
		public var renderType:uint;
		public var verteces:Vector.<Number>;
		public var indeces:Vector.<int>;
		//public var uv
		
		public function SkyRenderObject()
		{
			
		}
	}
}