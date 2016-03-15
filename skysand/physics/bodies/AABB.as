package skysand.physics.bodies 
{
	import skysand.utils.f2Vec;
	
	public class AABB
	{	
		public var x:Number = 0;
		public var y:Number = 0;
		public var half_width:Number = 0;
		public var half_height:Number = 0;
		
		public function AABB():void
		{
			
		}
		
		public function checkCollision(aabb:AABB):Boolean
		{
			var dx:Number = Math.abs(x - aabb.x);
			var dy:Number = Math.abs(y - aabb.y);
			var width:Number = half_width + aabb.half_width;
			var height:Number = half_height + aabb.half_height;
			
			if (dx > width) return false;
			if (dy > height) return false;
			
			return true;
		}
		
		public function combain(aabb:AABB):void
		{
			
		}
	}
}