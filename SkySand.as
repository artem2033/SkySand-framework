package  
{
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.text.TextField;
	import skysand.animation.SkyAnimation;
	import skysand.animation.SkyAnimationCache;
	import skysand.console.Console;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.render.hardware.SkyHardwareRender;
	import skysand.utils.SkyFilesCache;
	import skysand.utils.SkyMath;
	import skysand.interfaces.IUpdatable;
	import skysand.keyboard.SkyKeyboard;
	//import skysand.utils.f2Vec;
	import skysand.mouse.SkyMouse;
	import skysand.render.Render;
	import skysand.render.RenderObject;
	import skysand.text.SkyTextField;
	import skysand.text.TextArea;
	import skysand.utils.SkyProfiler;
	import skysand.utils.SkyWatcher;
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
		[Embed(source="skysand/resources/CyrBit.ttf", fontName = "cyrbit", embedAsCFF = "false")]
		private var cyrbitFont:Class;
		
		[Embed(source="skysand/resources/Just_Square.otf", fontName = "square", embedAsCFF = "false")]
		private var squareFont:Class;
		
		[Embed(source = "skysand/resources/Inconsolata.ttf", fontName = "inconsolata", embedAsCFF = "false")]
		private var inconsolataFont:Class;
		
		[Embed(source = "skysand/resources/iFlash.ttf", fontName = "flash", embedAsCFF = "false")]
		private var iFlashFont:Class;
		
		[Embed(source = "skysand/resources/Hooge.ttf", fontName = "hooge", embedAsCFF = "false")]
		private var hoogeFont:Class;
		
		[Embed(source="skysand/resources/Anonymous.ttf", fontName = "anonymous", embedAsCFF = "false")]
		private var anonymousFont:Class;
		
		public static const HARDWARE_RENDER:uint = 1;
		public static const SOFTWARE_RENDER:uint = 2;
		public static const VERSION:String = "Framework version 1.45, 18 January 2017";
		
		public static var STAGE:Stage;
		public static var NUM_OF_RENDER_OBJECTS:int = 0;
		public static var NUM_ON_STAGE:int = 0;
		public static var drawCalls:int = 0;
		public static var CONTEXT_3D:Context3D;
		public static var root:SkyRenderObjectContainer;
		public static var FRAME_RATE:uint = 0;
		
		private var mMain:Class;
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
		private var pause:Boolean = false;
		private var hardwareRender:SkyHardwareRender;
		private var context3D:Context3D;
		private var stage3D:Stage3D;
		public var console:Console;
		private var text:TextArea;
		private var screenWidth:Number;
		private var screenHeight:Number;
		private var _root:SkyRenderObject;
		
		public function SkySand() 
		{
			
		}
		
		public function initialize(_stage:Stage, _class:Class, frameRate:int, gameScreenWidth:Number = 800, gameScreenHeight:Number = 600, _fillColor:uint = 0x0, renderType:uint = SOFTWARE_RENDER):void
		{
			_stage.align = StageAlign.TOP_LEFT;
			//_stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			SkySand.STAGE = _stage;
			SkySand.FRAME_RATE = frameRate;
			mMain = _class;
			invFrameRate = 1 / frameRate;
			
			screenWidth = gameScreenWidth;
			screenHeight = gameScreenHeight;
			
			registerFonts();
			
			SkyMouse.instance.initialize(_stage);
			keyboard = SkyKeyboard.instance;
			keyboard.initialize(_stage);
			keyboard.addFunctionToKey(SkyKey.F9, setPause, true);
			
			if (renderType == HARDWARE_RENDER)
			{
				stage3D = _stage.stage3Ds[0];
				stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
				stage3D.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.STANDARD_EXTENDED);
			}
			else
			{
				render = Render.instance;
				render.initialize(gameScreenWidth, gameScreenHeight, _fillColor);
				addChildAt(render, 0);
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onContext3DCreated(event:Event):void
		{
			removeEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			
			context3D = stage3D.context3D;
			CONTEXT_3D = stage3D.context3D;
			
			/*
			var cache:SkyFilesCache = SkyFilesCache.instance;
			cache.initialize(context3D);
			*/
			hardwareRender = SkyHardwareRender.instance;
			hardwareRender.initialize(context3D, screenWidth, screenHeight);
			
			console = Console.instance;
			console.initialize();
			//console.visible = false;
			
			profiler = SkyProfiler.instance;
			//profiler.visible = false;
			
			var game:SkyRenderObjectContainer = new mMain();
			gameUpdatableClass = game as IUpdatable;
			SkySand.root = game;
			
			game.isAdded = true;
			game.addChild(profiler);
			game.addChild(console);
			
			console.registerCommand("showProfiler", profiler.show, []);
		}
		
		//lalka
		private function getNumRenderObjects():void
		{
			//console.message("Число отрисовываемых объектов: " + String(SkySand.NUM_OF_RENDER_OBJECTS));
		}
		
		public function set mainClass(value:RenderObject):void
		{
			/*_root = value;
			
			SkySand.root = value;
			mainGameClass = value;
			mainGameClass.addChild(console);
			//mainGameClass.addChild(watcher);
			mainGameClass.addChild(profiler);
			
			gameUpdatableClass = IUpdatable(mainGameClass);
			
			render.rootRenderObject = mainGameClass;*/
		}
		
		/*public function get mainClass():RenderObject
		{
			return _root;
		}*/
		
		private function setPause():void
		{
			pause = !pause;
		}
		
		public static var nPolygons:int = 0;
		
		private function onEnterFrameHandler(event:Event = null):void
		{
			/*if (hardwareRender != null)
			{*/
				profiler.totalUpdateTime = getTimer();
				keyboard.update();
				
				profiler.applicationUpdateTime = getTimer();
				profiler.applicationUpdateTime = getTimer() - profiler.applicationUpdateTime;
				
				profiler.renderTime = getTimer();
				drawCalls = 0;
				hardwareRender.update();
				console.update();
				profiler.renderTime = getTimer() - profiler.renderTime;
				profiler.totalUpdateTime = getTimer() - profiler.totalUpdateTime;
				profiler.update();
			/*}
			else
			{
				
				
				
				render.update();
				
				
				
			}*/
			
			if (!pause) if(gameUpdatableClass) gameUpdatableClass.update(deltaTime);
		}
		
		/**
		 * Добавить шрифты.
		 */
		private function registerFonts():void
		{
			Font.registerFont(cyrbitFont);
			Font.registerFont(squareFont);
			Font.registerFont(inconsolataFont);
			Font.registerFont(iFlashFont);
			Font.registerFont(hoogeFont);
			Font.registerFont(anonymousFont);
		}
	}
}