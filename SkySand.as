package  
{
	import flash.text.TextField;
	import skysand.animation.SkyAnimation;
	import skysand.animation.SkyAnimationCache;
	import skysand.console.Console;
	import skysand.utils.SkyMath;
	import skysand.interfaces.IUpdatable;
	import skysand.keyboard.SkyKeyboard;
	import skysand.utils.f2Vec;
	import skysand.mouse.SkyMouse;
	import skysand.render.Render;
	import skysand.render.RenderObject;
	import skysand.text.SkyTextField;
	import skysand.text.TextArea;
	import skysand.utils.SkyProfiler;
	import skysand.utils.SkyWatcher;
	//import src.physics.f2World;
	import flash.events.Event;
	import skysand.keyboard.SkyKey;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.getTimer;
	import flash.system.Capabilities;
	import flash.text.Font;
	import skysand.interfaces.IFrameworkUpdatable;
	
	public class SkySand extends Sprite
	{
		//date of deleting 9th of december 2016.
		public static const STAGE_WIDTH:int = 800;
		public static const STAGE_HEIGHT:int = 600;
		public static var STAGE:Stage;
		
		public static var NUM_OF_RENDER_OBJECTS:int = 0;
		public static var NUM_ON_STAGE:int = 0;
		
		private var keyboard:SkyKeyboard;
		private var render:Render;
		private var mainGameClass:RenderObject;
		private var gameUpdatableClass:IUpdatable;
		private var newTime:Number;
		private var oldTime:Number;
		private var deltaTime:Number;
		private var invFrameRate:int;
		private var watcher:SkyWatcher;
		private var profiler:SkyProfiler;
		public static var root:RenderObject;
		private var pause:Boolean = false;
		
		//public var world:f2World;
		public var console:Console;
		private var text:TextArea;
		
		[Embed(source="skysand/resources/CyrBit.ttf", fontName = "cyrbit", embedAsCFF = "false")]
		protected var cyrbitFont:Class;
		
		[Embed(source="skysand/resources/Just_Square.otf", fontName = "square", embedAsCFF = "false")]
		protected var squareFont:Class;
		
		[Embed(source = "skysand/resources/Inconsolata.ttf", fontName = "inconsolota", embedAsCFF = "false")]
		protected var inconsolataFont:Class;
		
		[Embed(source = "skysand/resources/iFlash.ttf", fontName = "flash", embedAsCFF = "false")]
		protected var iFlashFont:Class;
		
		[Embed(source = "skysand/resources/Hooge.ttf", fontName = "hooge", embedAsCFF = "false")]
		protected var hoogeFont:Class;
		
		[Embed(source="skysand/resources/Anonymous.ttf", fontName = "anonymous", embedAsCFF = "false")]
		protected var anonymousFont:Class;
		
		public function SkySand() 
		{
			
		}
		
		private function registerFonts():void
		{
			Font.registerFont(cyrbitFont);
			Font.registerFont(squareFont);
			Font.registerFont(inconsolataFont);
			Font.registerFont(iFlashFont);
			Font.registerFont(hoogeFont);
			Font.registerFont(anonymousFont);
		}
		
		private function prepareFrameworkGraphics():void
		{
			var normalState:Sprite = new Sprite();
			normalState.graphics.beginFill(0x151E27);
			normalState.graphics.moveTo( -5, -3);
			normalState.graphics.lineTo( -3, -5);
			normalState.graphics.lineTo(3, -5);
			normalState.graphics.lineTo(5, -3);
			normalState.graphics.lineTo(5, 3);
			normalState.graphics.lineTo(3, 5);
			normalState.graphics.lineTo( -3, 5);
			normalState.graphics.lineTo( -5, 3);
			normalState.graphics.beginFill(0xDBB71E);
			normalState.graphics.moveTo( -3, -5);
			normalState.graphics.lineTo(3, -5);
			normalState.graphics.lineTo(0, -2);
			normalState.graphics.moveTo(5, -3);
			normalState.graphics.lineTo(5, 3);
			normalState.graphics.lineTo(2, 0);
			normalState.graphics.moveTo(3, 5);
			normalState.graphics.lineTo( -3, 5);
			normalState.graphics.lineTo(0, 2);
			normalState.graphics.moveTo( -5, 3);
			normalState.graphics.lineTo( -5, -3);
			normalState.graphics.lineTo( -2, 0);
			
			var downState:Sprite = new Sprite();
			downState.graphics.beginFill(0xDBB71E);
			downState.graphics.moveTo( -5, -3);
			downState.graphics.lineTo( -3, -5);
			downState.graphics.lineTo(3, -5);
			downState.graphics.lineTo(5, -3);
			downState.graphics.lineTo(5, 3);
			downState.graphics.lineTo(3, 5);
			downState.graphics.lineTo( -3, 5);
			downState.graphics.lineTo( -5, 3);
			downState.graphics.beginFill(0x151E27);
			downState.graphics.moveTo( -3, -5);
			downState.graphics.lineTo(3, -5);
			downState.graphics.lineTo(0, -2);
			downState.graphics.moveTo(5, -3);
			downState.graphics.lineTo(5, 3);
			downState.graphics.lineTo(2, 0);
			downState.graphics.moveTo(3, 5);
			downState.graphics.lineTo( -3, 5);
			downState.graphics.lineTo(0, 2);
			downState.graphics.moveTo( -5, 3);
			downState.graphics.lineTo( -5, -3);
			downState.graphics.lineTo( -2, 0);
			
			var animation:SkyAnimation = new SkyAnimation();
			animation.makeFrameFromSprite(normalState);
			animation.makeFrameFromSprite(downState);
			animation.frames[2] = animation.frames[1];
			animation.name = "skyCloseButton";
			
			SkyAnimationCache.instance.addAnimation(animation);
		}
		
		public function initialize(_stage:Stage, frameRate:int, gameScreenWidth:Number = 800, gameScreenHeight:Number = 600, _fillColor:uint = 0x0):void
		{
			SkySand.STAGE = _stage;
			invFrameRate = 1 / frameRate;
			
			registerFonts();
			prepareFrameworkGraphics();
			
			console = Console.instance;
			console.initialize();
			console.visible = false;
			
			render = Render.instance;
			render.initialize(gameScreenWidth, gameScreenHeight, _fillColor);
			addChildAt(render, 0);
			
			SkyMouse.instance.initialize(_stage);
			keyboard = SkyKeyboard.instance;
			keyboard.initialize(_stage);
			keyboard.addFunctionToKey(SkyKey.F9, setPause, true);
			
			//watcher = SkyWatcher.instance;
			//watcher.x = 700;
			
			profiler = SkyProfiler.instance;
			profiler.visible = false;
			
			console.registerCommand("showProfiler", profiler.show, []);
			console.registerCommand("getNumOfRenderObjects", getNumRenderObjects, []);
			
			oldTime = 0;
			newTime = 0;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function getNumRenderObjects():void
		{
			console.message("Число отрисовываемых объектов: " + String(SkySand.NUM_OF_RENDER_OBJECTS));
		}
		
		public function set mainClass(value:RenderObject):void
		{
			SkySand.root = value;
			mainGameClass = value;
			mainGameClass.addChild(console);
			//mainGameClass.addChild(watcher);
			mainGameClass.addChild(profiler);
			
			gameUpdatableClass = IUpdatable(mainGameClass);
			
			render.rootRenderObject = mainGameClass;
		}
		
		public function get mainClass():RenderObject
		{
			return mainGameClass;
		}
		
		private function setPause():void
		{
			pause = !pause;
		}
		
		/*public function createPhysicsWorld(gravity:f2Vec, allowSleep:Boolean):void
		{
			world = new f2World();
			world.init(gravity, allowSleep);
			world.debug_draw();
			world.createWalls();
			addChild(world);
			
			console.message("Engine: Physics world created.");
		}*/
		
		private function onEnterFrameHandler(event:Event = null):void
		{
			oldTime = newTime;
			newTime = getTimer();
			deltaTime = (newTime - oldTime) / 1000;
			deltaTime = (deltaTime < invFrameRate) ? invFrameRate : deltaTime;
			
			profiler.totalUpdateTime = getTimer();
			//watcher.update();
			keyboard.update();
			console.update();
			
			profiler.applicationUpdateTime = getTimer();
			if (!pause) gameUpdatableClass.update(deltaTime);
			profiler.applicationUpdateTime = getTimer() - profiler.applicationUpdateTime;
			
			profiler.renderTime = getTimer();
			render.update();
			profiler.renderTime = getTimer() - profiler.renderTime;
			
			profiler.totalUpdateTime = getTimer() - profiler.totalUpdateTime;
			profiler.update();
		}
	}
}