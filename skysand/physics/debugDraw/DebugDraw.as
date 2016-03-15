package skysand.physics.debugDraw 
{
	import skysand.utils.f2Vec;
	import src.physics.Body2D;
	import src.physics.f2Circle;
	import src.physics.PolygonShape2D;
	import skysand.physics.PhysicsCore;
	
	import flash.display.Sprite;
	
	public class DebugDraw extends Sprite
	{
		private const STATIC_COLOR:uint = 0x660993;
		private const DYNAMIC_COLOR:uint = 0x4678AF;
		private const SENSOR_COLOR:uint = 0x000000;
		private const SLEEP_COLOR:uint = 0x000000;
		private const AABB_COLOR:uint = 0x12;
		
		private var core:PhysicsCore;
		
		public function DebugDraw() 
		{
			
		}
		
		public function init(_core:PhysicsCore):void
		{
			core = _core;
		}
		
		public function drawBody(body:Body2D):Sprite
		{
			var sprite:Sprite = new Sprite();
			
			switch(body.type)
			{
				case Body2D.STATIC : sprite.graphics.lineStyle(1, STATIC_COLOR); break;
				case Body2D.DYNAMIC : sprite.graphics.lineStyle(1, DYNAMIC_COLOR); break;
				case Body2D.NONE : sprite.graphics.lineStyle(1, 0x000000); break;
			}
			
			if (body is f2Circle)
			{
				var radius:Number = (body as f2Circle).radius;
				
				sprite.graphics.drawCircle(0, 0, radius);
				sprite.graphics.moveTo(0, 0);
				sprite.graphics.lineTo(radius, 0);
			}
			else if (body is PolygonShape2D)
			{
				var vertices:Vector.<f2Vec> = (body as PolygonShape2D).vertices;
				
				sprite.graphics.moveTo(vertices[0].x, vertices[0].y);
				
				for (var i:int = 1; i < vertices.length; i++) 
				{
					var point:f2Vec = vertices[i];
					
					sprite.graphics.lineTo(point.x, point.y);
				}
				
				sprite.graphics.lineTo(vertices[0].x, vertices[0].y);
				//sprite.graphics.moveTo(0, 0);
				//sprite.graphics.lineTo(vertices[1].x, vertices[1].y);
				
				sprite.graphics.lineStyle(1, AABB_COLOR, 0.5);
				sprite.graphics.drawRect(-body.aabb.half_width, -body.aabb.half_height, body.aabb.half_width * 2, body.aabb.half_height * 2);
			}
			
			return sprite;
		}
		
		public function drawVector():void
		{
			
		}
		
		public function update():void
		{
			for (var i:int = 0; i < core.bodyCount; i++) 
			{
				var body:Body2D = core.bodies[i];
				
				body.debug_sprite.x = body.x;
				body.debug_sprite.y = body.y;
				body.debug_sprite.rotation = body.rotation;
			}
		}
	}
}