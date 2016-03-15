package skysand.physics.bodies 
{
	public class f2Circle extends Body2D
	{
		public var radius:Number;
		
		public function f2Circle()
		{
			
		}
		
		override public function init(_x:Number, _y:Number):void 
		{
			super.init(_x, _y);
			
			calculateMass();
		}
		
		override public function free():void
		{
			super.free();
		}
		
		private function calculateMass():void
		{
			//massData.mass = radius * radius * Math.PI * massData.density;
			//massData.inv_mass = 1 / massData.mass;
		}
	}
}