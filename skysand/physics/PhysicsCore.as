package skysand.physics 
{
	isrc.physicssrc.physicsmposrc.physicssrc.physicssrc.physicssrc.physicsrt adobe.utils.CustomActions;
	import skysand.utils.f2Vec;
	import src.physics.Body2D;
	import src.physics.f2Circle;
	import src.physics.PolygonShape2D;
	import src.physics.Collision;
	import src.physics.CollisionData;
	import src.physics.f2PolygonCollision;
	import flash.display.Sprite;
	import flash.globalization.NumberFormatter;

	public class PhysicsCore extends Sprite
	{
		public var bodies:Vector.<Body2D>;
		public var bodyCount:int;
		public var collisions:Vector.<Collision>;
		public var collisionsCount:int;
		public var collision:f2PolygonCollision;
		
		public function PhysicsCore() 
		{
			
		}
		
		public function initialize():void
		{
			bodies = new Vector.<Body2D>();
			bodyCount = 0;
			
			collisions = new Vector.<Collision>();
			collisionsCount = 0;
			
			collision = new f2PolygonCollision();
		}
		
		public function addBody(body:Body2D):void
		{
			bodies[bodyCount] = body;
			bodyCount++;
		}
		
		private function addCollisionTest(body0:Body2D, body1:Body2D):void
		{
			/*var collision:Collision = new Collision();
			collision.init(body0, body1);
			collisions[collisionsCount] = collision;
			collisionsCount++;*/
		}
		
		public function removeBody(body:Body2D):void
		{
			for (var i:int = 0; i < bodyCount; i++) 
			{
				if (body == bodies[i])
				{
					body.free();
					body = null;
					bodies.splice(i, 1);
					bodyCount--;
				}
			}
		}
		
		private function calculateImpulse(body0:Body2D, body1:Body2D, data:CollisionData):void
		{
			var RV:f2Vec = new f2Vec(body0.linearVelocity.x - body1.linearVelocity.x, body0.linearVelocity.y - body1.linearVelocity.y);
			
			var RVP:Number = RV.dotProduct(data.normalVector);
			
			var e:Number = Math.min(body0.restitution, body1.restitution);
			
			var J:Number = -(1 + e) * RVP;
			
			J /= body0.invMass + body1.invMass;
			
			var impulse:f2Vec = data.normalVector.multiply(J);
			
			body0.linearVelocity.x += body0.invMass * impulse.x;
			body0.linearVelocity.y += body0.invMass * impulse.y;
			
			body1.linearVelocity.x -= body1.invMass * impulse.x;
			body1.linearVelocity.y -= body1.invMass * impulse.y;
		}
		
		public function update(delta_time:Number, gravity:f2Vec):void
		{
			//for (var i:int = 0; i < 10; i++) 
			//{
				solve(delta_time, gravity);
			//}
		}
		
		private function solve(delta_time:Number, gravity:f2Vec):void
		{
			var body:Body2D;
			var body0:Body2D;
			
			for (var i:int = 0; i < bodyCount; i++) 
			{
				body = bodies[i];
				
				for (var j:int = i + 1; j < bodyCount; ++j) 
				{
					body0 = bodies[j];
					
					if (body.type == Body2D.STATIC && body0.type == Body2D.STATIC) continue;
					
					if(body0.aabb.checkCollision(body.aabb))
					{
						var data:CollisionData = collision.check(PolygonShape2D(body0), PolygonShape2D(body));
						
						if (data.collide)
						{
							calculateImpulse(body, body0, data);
							positionalCorrection(body, body0, data);
							//for (var l:int = 0; l < 10; l++)
							solvingTOI(body, body0, data);
						}
					}
				}
				
				if (body.type != Body2D.DYNAMIC) continue;
				
				body.linearVelocity.x += delta_time * (body.force.x * body.invMass + gravity.x);
				body.linearVelocity.y += delta_time * (body.force.y * body.invMass + gravity.y);
				
				body.x += body.linearVelocity.x * delta_time;
				body.y += body.linearVelocity.y * delta_time;
				
				//body.angularSpeed += body.invI * body.angularAcsel * delta_time;
				//body.rotation += body.angularSpeed * delta_time;
			}
		}
		
		private function applyFriction(body0:Body2D, body1:Body2D, data:CollisionData):void
		{
			var tangent:f2Vec = data.normalVector.normalL();
			var dVelocity:f2Vec = new f2Vec(body0.linearVelocity.x - body1.linearVelocity.x, body0.linearVelocity.y - body1.linearVelocity.y);
			
			var relativeVelocity:Number = tangent.dotProduct(dVelocity);
			var maxFriction:Number = (body0.friction > body1.friction) ? body0.friction : body1.friction;
			
			
		}
		
		private function positionalCorrection(body0:Body2D, body1:Body2D, data:CollisionData):void
		{
			var totalInvMass:Number = body0.invMass + body1.invMass;
			var massRatio0:Number = body0.invMass / totalInvMass;
			var massRatio1:Number = body1.invMass / totalInvMass;
			const KOEF:Number = 1.01;
			
			body0.x -= data.normalVector.x * data.overlap * KOEF * massRatio0;
			body0.y -= data.normalVector.y * data.overlap * KOEF * massRatio0;
			
			body1.x += data.normalVector.x * data.overlap * KOEF * massRatio1;
			body1.y += data.normalVector.y * data.overlap * KOEF * massRatio1;
		}
		
		private function solvingTOI(body0:Body2D, body1:Body2D, data:CollisionData):void
		{
			var velocity:f2Vec = new f2Vec(body0.linearVelocity.x - body1.linearVelocity.x, body0.linearVelocity.y - body1.linearVelocity.y);
			
			var relNv:Number = velocity.dotProduct(data.normalVector);
			
			var remove:Number = relNv + data.overlap / 0.016;
			
			var imp:Number = remove / (body0.invMass + body1.invMass);
			
			var e:Number = Math.min(body0.restitution, body1.restitution);
			
			var J:Number = -(1 + e) * relNv;
			
			var newImpulse:Number = imp + J;
			
			body0.linearVelocity.x -= imp * data.normalVector.x * body0.invMass;
			body0.linearVelocity.y -= imp * data.normalVector.y * body0.invMass;
			body1.linearVelocity.x += imp * data.normalVector.x * body1.invMass;
			body1.linearVelocity.y += imp * data.normalVector.y * body1.invMass;
		}
	}
}