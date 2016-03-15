package skysand.physics 
{
	import skysand.utils.f2Vec;
	imposrc.physicsrt skysand.utils.f2Vec;
	import src.physics.Body2D;
	import src.physics.f2Circle;
	import src.physics.PolygonShape2D;
	import src.physics.DebugDraw;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Artem Andrienko
	 */
	public class f2World extends Sprite
	{
		public var physicsCore:PhysicsCore;
		private var gravity:f2Vec;
		private var allowSleep:Boolean;
		private var debugDraw:DebugDraw;
		
		public function f2World()
		{
		}
		
		public function init(_gravity:f2Vec, _allowSleep:Boolean):void
		{
			gravity = _gravity;
			allowSleep = _allowSleep;
			
			physicsCore = new PhysicsCore();
			physicsCore.initialize();
		}
		
		public function addBody(body:Body2D):void
		{
			physicsCore.addBody(body);
			
			if (debugDraw != null)
			{
				body.debug_sprite = debugDraw.drawBody(body);
				addChild(body.debug_sprite);
			}
		}
		
		public function debug_draw():void
		{
			debugDraw = new DebugDraw();
			debugDraw.init(physicsCore);
			addChild(debugDraw);
		}
		
		public function createWalls():void
		{
			var _width:Number = 640;
			var _height:Number = 480;
			
			var body:PolygonShape2D = new PolygonShape2D();
			body.type = Body2D.STATIC;
			body.createRectangle(_width / 2, 5, _width, 10);
			addBody(body);
			
			body = new PolygonShape2D();
			body.type = Body2D.STATIC;
			body.createRectangle(_width / 2, _height - 5, _width, 10);
			addBody(body);
			
			body = new PolygonShape2D();
			body.type = Body2D.STATIC;
			body.createRectangle(5, _height / 2, 10, _height);
			addBody(body);
			
			body = new PolygonShape2D();
			body.type = Body2D.STATIC;
			body.createRectangle(_width - 5, _height / 2, 10, _height);
			addBody(body);
		}
		
		public function update(delta_time:Number):void
		{
			if (physicsCore != null)
			{
				physicsCore.update(delta_time, gravity);
			}
			
			if (debugDraw != null)
			{
				debugDraw.update();
			}
		}
	}
}