package skysand.physics.collision 
{
	import skysand.utils.f2Vec;
	
	public class CollisionData 
	{
		public var collide:Boolean = false;
		public var normalVector:f2Vec = new f2Vec(0, 0);
		public var overlap:Number = 0;
		
		public function reset():void
		{
			collide = false;
			normalVector.Set(0, 0);
			overlap = 0;
		}
	}
}