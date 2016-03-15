package skysand.physics.collision 
{
	import src.physics.Body2D;
	import src.physics.PolygonShape2D;
	
	public class Collision
	{
		private var body0:Body2D;
		private var body1:Body2D;
		private var collision:f2PolygonCollision;
		
		public function Collision()
		{
			
		}
		
		public function init(_body0:Body2D, _body1:Body2D):void
		{
			body0 = _body0;
			body1 = _body1;
			collision = new f2PolygonCollision();
		}
		
		public function execute():void
		{
			var data:CollisionData = collision.check(body0 as PolygonShape2D, body1 as PolygonShape2D);
			
			body1.x -= data.normalVector.x * data.overlap;
			body1.y -= data.normalVector.y * data.overlap;
		}
		
		public function hitTest(aX:Number, aY:Number, aPixelFlag:Boolean = false):Boolean
		{
			var n:int = vertices.length;
			var res:Boolean = false;
			
			for (var i:int = 0, j:int = n - 1; i < n; j = i++)
			{
				if (((vertices[i].y > aY) != (vertices[j].y > aY)) && 
					(aX < (vertices[j].x - vertices[i].x) * (aY - vertices[i].y) / (vertices[j].y - vertices[i].y) + vertices[i].x))
				{
					res = !res;
				}
			}
			
			return res;
		}
	}
}