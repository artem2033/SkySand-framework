package  
{
	import flash.display.Stage3D;
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
	import skysand.utils.f2Vec;
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
		protected var cyrbitFont:Class;
		
		[Embed(source="skysand/resources/Just_Square.otf", fontName = "square", embedAsCFF = "false")]
		protected var squareFont:Class;
		
		[Embed(source = "skysand/resources/Inconsolata.ttf", fontName = "inconsolata", embedAsCFF = "false")]
		protected var inconsolataFont:Class;
		
		[Embed(source = "skysand/resources/iFlash.ttf", fontName = "flash", embedAsCFF = "false")]
		protected var iFlashFont:Class;
		
		[Embed(source = "skysand/resources/Hooge.ttf", fontName = "hooge", embedAsCFF = "false")]
		protected var hoogeFont:Class;
		
		[Embed(source="skysand/resources/Anonymous.ttf", fontName = "anonymous", embedAsCFF = "false")]
		protected var anonymousFont:Class;
		
		//date of deleting 9th of december 2015.
		
		public static const HARDWARE_RENDER:uint = 1;
		public static const SOFTWARE_RENDER:uint = 2;
		
		public static var STAGE:Stage;
		public static var NUM_OF_RENDER_OBJECTS:int = 0;
		public static var NUM_ON_STAGE:int = 0;
		public static var drawCalls:int = 0;
		
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
		public static var root:RenderObject;
		private var pause:Boolean = false;
		private var hardwareRender:SkyHardwareRender;
		private var context3D:Context3D;
		private var stage3D:Stage3D;
		public var console:Console;
		private var text:TextArea;
		private var screenWidth:Number;
		private var screenHeight:Number;
		private var _root:SkyRenderObjectContainer;
		private var textField:TextField;
		
		public function SkySand() 
		{
			
		}
		
		public function initialize(_stage:Stage, _class:Class, frameRate:int, gameScreenWidth:Number = 800, gameScreenHeight:Number = 600, _fillColor:uint = 0x0, renderType:uint = SOFTWARE_RENDER):void
		{
			SkySand.STAGE = _stage;
			mMain = _class;
			invFrameRate = 1 / frameRate;
			
			screenWidth = gameScreenWidth;
			screenHeight = gameScreenHeight;
			
			registerFonts();
			prepareFrameworkGraphics();
			
			console = Console.instance;
			console.initialize();
			console.visible = false;
			
			/*render = Render.instance;
			render.initialize(gameScreenWidth, gameScreenHeight, _fillColor);
			addChildAt(render, 0);
			*/
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
			
			textField = new TextField();
			textField.width = 200;
			textField.height = 20;
			textField.textColor = 0xFFFFFF;
			addChild(textField);
			
			//watcher = SkyWatcher.instance;
			//watcher.x = 700;
			
			/*profiler = SkyProfiler.instance;
			profiler.visible = false;*/
			
			/*console.registerCommand("showProfiler", profiler.show, []);
			console.registerCommand("getNumOfRenderObjects", getNumRenderObjects, []);*/
			
			oldTime = 0;
			newTime = 0;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onContext3DCreated(event:Event):void
		{
			removeEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			
			context3D = stage3D.context3D;
			
			var cache:SkyFilesCache = SkyFilesCache.instance;
			cache.initialize(context3D);
			
			hardwareRender = SkyHardwareRender.instance;
			hardwareRender.initialize(context3D, screenWidth, screenHeight);
			
			var game:SkyRenderObjectContainer = new mMain();
			hardwareRender.setRoot(game);
			gameUpdatableClass = game as IUpdatable;
			
			_root = game;
		}
		
		private function getNumRenderObjects():void
		{
			//console.message("Число отрисовываемых объектов: " + String(SkySand.NUM_OF_RENDER_OBJECTS));
		}
		
		public function set mainClass(value:SkyRenderObjectContainer):void
		{
			_root = value;
			hardwareRender.setRoot(value);
			
			/*SkySand.root = value;
			mainGameClass = value;
			mainGameClass.addChild(console);
			//mainGameClass.addChild(watcher);
			mainGameClass.addChild(profiler);
			
			gameUpdatableClass = IUpdatable(mainGameClass);
			
			render.rootRenderObject = mainGameClass;*/
		}
		
		public function get mainClass():SkyRenderObjectContainer
		{
			return _root;
		}
		
		private function setPause():void
		{
			pause = !pause;
		}
		
		private function onEnterFrameHandler(event:Event = null):void
		{
			oldTime = newTime;
			newTime = getTimer();
			deltaTime = (newTime - oldTime) / 1000;
			deltaTime = (deltaTime < invFrameRate) ? invFrameRate : deltaTime;
			
			//profiler.totalUpdateTime = getTimer();
			//watcher.update();
			keyboard.update();
			//console.update();
			
			//profiler.applicationUpdateTime = getTimer();
			/*if (!pause)*/ if(gameUpdatableClass) gameUpdatableClass.update(deltaTime);
			//profiler.applicationUpdateTime = getTimer() - profiler.applicationUpdateTime;
			
			//profiler.renderTime = getTimer();
			//render.update();
			//profiler.renderTime = getTimer() - profiler.renderTime;
			
			//profiler.totalUpdateTime = getTimer() - profiler.totalUpdateTime;
			//profiler.update();
			
			if (hardwareRender != null)
			{
				drawCalls = 0;
				hardwareRender.update();
				textField.text = "Draw calls: " + drawCalls;
			}
		}
		
		/**
		 * Нарисовать кнопку закрытия окна.
		 */
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
			downState.graphics.beginFill(0x3C447B);
			downState.graphics.moveTo( -5, -3);
			downState.graphics.lineTo( -3, -5);
			downState.graphics.lineTo(3, -5);
			downState.graphics.lineTo(5, -3);
			downState.graphics.lineTo(5, 3);
			downState.graphics.lineTo(3, 5);
			downState.graphics.lineTo( -3, 5);
			downState.graphics.lineTo( -5, 3);
			downState.graphics.beginFill(0xDBB71E);
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