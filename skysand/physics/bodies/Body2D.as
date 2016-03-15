package skysand.physics.bodies 
{
	import skysand.utils.f2Vec;
	
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class Body2D
	{
		//Виды физического тела.
		public static const NONE:uint = 0;
		public static const STATIC:uint = 1;
		public static const DYNAMIC:uint = 2;
		public static const SENSOR:uint = 3;
		//----------------------------------
		
		/**
		 * Текущий тип физического тела.
		 */
		public var type:uint;
		
		/**
		 * Масса тела.
		 */
		public var mass:Number = 1;
		
		/**
		 * Инверсная масса тела.
		 */
		public var invMass:Number = 1;
		
		/**
		 * Момент инерции тела.
		 */
		public var I:Number;
		
		/**
		 * Инверсный момент тела.
		 */
		public var invI:Number;
		
		/**
		 * Упругость тела
		 */
		public var restitution:Number;
		
		/**
		 * Плотность тела.
		 */
		public var density:Number;
		
		/**
		 * Трение тела.
		 */
		public var friction:Number;
		
		/**
		 * Линейная скорость тела.
		 */
		public var linearVelocity:f2Vec;
		
		/**
		 * Угловая скорость.
		 */
		public var angularVelocity:Number;
		
		/**
		 * Общая сила действующая на тело.
		 */
		public var force:f2Vec;
		
		/**
		 * 
		 */
		public var debug_sprite:Sprite;
		
		/**
		 * Минимальный ограничивающий 4-х угольник.
		 */
		public var aabb:AABB;
		
		/**
		 * Координаты физического тела.
		 */
		private var position:f2Vec;
		
		private var angle:Number;
		private var transformMatrix:Matrix;
		
		public function Body2D() 
		{
		}
		
		public function init(_x:Number, _y:Number):void
		{
			linearVelocity = new f2Vec(0, 0);
			force = new f2Vec(0, 0);
			position = new f2Vec(_x, _y);
			aabb = new AABB();
			aabb.x = _x;
			aabb.y = _y;
			
			density = 1;
			friction = 0.2;
			restitution = 0.4;
		}
		
		public function free():void
		{
		}
		
		public function get x():Number
		{
			return position.x;
		}
		
		public function set x(value:Number):void
		{
			aabb.x = value;
			position.x = value;
		}
		
		public function get y():Number
		{
			return position.y;
		}
		
		public function set y(value:Number):void
		{
			aabb.y = value;
			position.y = value;
		}
		
		public function get rotation():Number
		{
			return angle;
		}
		
		public function set rotation(value:Number):void
		{
			angle = value;
		}
		
		public function applyImpulse(vec:f2Vec, point:f2Vec):void
		{
			if (type != DYNAMIC) return;
			
			//angularSpeed += (point.x * vec.y - point.y * vec.x) * invI;
			
			linearVelocity.x += vec.x * invMass;
			linearVelocity.y += vec.y * invMass;
		}
		
		public function applyForce(vector:f2Vec):void
		{
			if (type != DYNAMIC) return;
			
			force.x += vector.x;
			force.y += vector.y;
		}
	}
}