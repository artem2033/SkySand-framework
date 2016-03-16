package skysand.render.hardware 
{
	import flash.display3D.Context3D;
	/**
	 * ...
	 * @author 
	 */
	public class SkyQuadBatchBase extends Object
	{
		internal var context3D:Context3D;
		
		public function SkyQuadBatchBase() 
		{
			super();
		}
		
		public function initialize(context3D:Context3D):void
		{
			this.context3D = context3D;
		}
		
		public function render():void
		{
			
		}
	}
}