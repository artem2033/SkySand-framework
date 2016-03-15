package skysand.physics.collision 
{
	import src.physics.f2Circle;
	import skysand.utils.SkyMath;
	import flash.geom.Point;
	
	public class f2CircleCollision 
	{
		private var collisionData:CollisionData;
		private var point0:Point;
		private var point1:Point;
		
		public function f2CircleCollision() 
		{
			collisionData = new CollisionData();
			point0 = new Point();
			point1 = new Point();
		}
		
		public function check(circle0:f2Circle, circle1:f2Circle):CollisionData
		{
			var sum_radius:Number = circle0.radius + circle1.radius;
			
			point0.x = circle0.position.x
			point1.x = circle1.position.x;
			point0.y = circle0.position.y;
			point1.y = circle1.position.y;
			
			var distance_sqr:Number = SkyMath.DistanceSQR(point0, point1);
			
			if (distance_sqr <= sum_radius * sum_radius)
			{
				collisionData.collide = true;
				collisionData.overlap = sum_radius - Math.sqrt(distance_sqr);
				collisionData.normalVector.x = SkyMath.DeltaX(point0, point1);
				collisionData.normalVector.y = SkyMath.DeltaY(point0, point1);
				collisionData.normalVector.normalize();
				
				return collisionData;
			}
			else
			{
				collisionData.reset();
			}
			
			return collisionData;
		}
	}
}