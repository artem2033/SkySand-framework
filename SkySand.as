package
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	
	import skysand.text.SkyFont;
	import skysand.input.SkyKey;
	import skysand.input.SkyMouse;
	import skysand.input.SkyKeyboard;
	import skysand.debug.Console;
	import skysand.debug.SkyOutput;
	import skysand.debug.SkyProfiler;
	import skysand.interfaces.IUpdatable;
	import skysand.file.SkyFilesCache;
	import skysand.display.SkyCamera;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.render.SkyHardwareRender;
	
	public class SkySand extends Sprite
	{
		/**
		 * Версия фреймворка.
		 */
		public static const VERSION:String = "SKYSAND framework version 0.85, 8 December 2017";
		
		/**
		 * Ссылка на сцену.
		 */
		public static var STAGE:Stage;
		
		/**
		 * Ссылка на контекст для рендера.
		 */
		public static var CONTEXT_3D:Context3D;
		
		/**
		 * Частота кадров приложения.
		 */
		public static var FRAME_RATE:uint;
		
		/**
		 * Текущий размер окна приложения в ширину.
		 */
		public static var SCREEN_WIDTH:Number;
		
		/**
		 * Текущий размер окна приложения в высоту.
		 */
		public static var SCREEN_HEIGHT:Number;
		
		/**
		 * Переключить движок в режим разработки.
		 */
		public var isDevelopMode:Boolean;
		
		/**
		 * Кэш для файлов.
		 */
		private static var mCache:SkyFilesCache;
		
		/**
		 * Окно для отображения откладочной информации.
		 */
		private static var output:SkyOutput;
		
		/**
		 * Ссылка на рендер.
		 */
		private static var hardwareRender:SkyHardwareRender;
		
		/**
		 * Главный класс приложения.
		 */
		private var mainClass:Class;
		
		/**
		 * Ссылка на класс с клавиатурой.
		 */
		private var keyboard:SkyKeyboard;
		
		/**
		 * Ссылка на мышь.
		 */
		private var mouse:SkyMouse;
		
		/**
		 * Класс для обновления.
		 */
		private var applicationUpdatableClass:IUpdatable;
		
		/**
		 * Время прошедшея с прошлого обновления кадра.
		 */
		private var newTime:Number;
		
		/**
		 * Время до обновления кадра.
		 */
		private var oldTime:Number;
		
		/**
		 * Разница во времени между кадрами.
		 */
		private var deltaTime:Number;
		
		/**
		 * Инвертированная частота кадров.
		 */
		private var invFrameRate:int;
		
		/**
		 * Профайлер для откладки.
		 */
		private var profiler:SkyProfiler;
		
		/**
		 * Косоль для откладки.
		 */
		private var console:Console;
		
		/**
		 * Ссылка на 3-х мерную сцену.
		 */
		private var stage3D:Stage3D;
		
		public function SkySand()
		{
			isDevelopMode = false;
			newTime = 0;
			oldTime = 0;
			deltaTime = 0;
			invFrameRate = 0;
		}
		
		/**
		 * Задать камеру.
		 * @param	camera ссылка на камеру.
		 */
		public static function setCamera(camera:SkyCamera):void
		{
			hardwareRender.setCamera(camera);
		}
		
		/**
		 * Задать минимальные размеры окна
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public static function setWindowMinSize(width:Number, height:Number):void
		{
			SCREEN_WIDTH = width;
			SCREEN_HEIGHT = height;
			
			STAGE.nativeWindow.minSize = new Point(width, height);
			STAGE.nativeWindow.width = width;
			STAGE.nativeWindow.height = height;
		}
		
		/**
		 * Задать максимальные размеры окна
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public static function setWindowMaxSize(width:Number, height:Number):void
		{
			STAGE.nativeWindow.maxSize = new Point(width, height);
		}
		
		/**
		 * Задать разрешение приложения.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public static function setApplicationResolution(width:Number, height:Number):void
		{
			hardwareRender.setResolution(width, height);
		}
		
		/**
		 * Перейти в полноэкранный режим.
		 */
		public static function enableFullscreen():void
		{
			STAGE.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		/**
		 * Выйти из полноэкранного режима.
		 */
		public static function disableFullscreen():void
		{
			STAGE.displayState = StageDisplayState.NORMAL;
		}
		
		/**
		 * Получить доступ к рендеру.
		 */
		public static function get render():SkyHardwareRender
		{
			return hardwareRender;
		}
		
		/**
		 * Получить доступ к глобальному кэшу.
		 */
		public static function get cache():SkyFilesCache
		{
			return mCache;
		}
		
		/**
		 * Отображать любую информацию в окне вывода.
		 * @param	value данные.
		 */
		public static function watch(value:*):void
		{
			output.watch(value);
		}
		
		/**
		 * Настроить внешний вид окна вывода информации.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	headColor цвет верхней панели окна.
		 * @param	bodyColor цвет окна.
		 * @param	textColor цвет текста.
		 * @param	font шрифт.
		 * @param	fontSize размер шрифта.
		 */
		public static function setOutputViewsetOutputView(width:Number, height:Number, headColor:uint, bodyColor:uint, textColor:uint, font:String, fontSize:int):void
		{
			output.setOutputView(width, height, headColor, bodyColor, textColor, font, fontSize);
		}
		
		/**
		 * Инициализация фреймворка.
		 * @param	mStage ссылка на сцену.
		 * @param	mainClass класс приложения.
		 * @param	contextProfile профиль контекста.
		 */
		public function initialize(mStage:Stage, mainClass:Class, contextProfile:String = Context3DProfile.ENHANCED):void
		{
			SCREEN_HEIGHT = mStage.stageHeight;
			SCREEN_WIDTH = mStage.stageWidth;
			FRAME_RATE = mStage.frameRate;
			STAGE = mStage;
			
			invFrameRate = 1 / FRAME_RATE;
			this.mainClass = mainClass;
			
			mStage.align = StageAlign.TOP_LEFT;
			mStage.scaleMode = StageScaleMode.NO_SCALE;
			
			SkyFont.register();
			
			mouse = SkyMouse.instance;
			mouse.initialize(mStage);
			
			keyboard = new SkyKeyboard();
			keyboard.initialize(mStage);
			
			mCache = new SkyFilesCache();
			mCache.initialize();
			
			stage3D = mStage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			stage3D.requestContext3D(Context3DRenderMode.AUTO, contextProfile);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		public function destroy():void
		{
			
		}
		
		/**
		 * Событие при запросе на создание контекста.
		 * @param	event событие.
		 */
		private function onContext3DCreated(event:Event):void
		{
			removeEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			
			CONTEXT_3D = stage3D.context3D;
			
			hardwareRender = new SkyHardwareRender();
			hardwareRender.initialize();
			
			if (isDevelopMode)
			{
				profiler = SkyProfiler.instance;
				profiler.visible = false;
				
				console = Console.instance;
				console.initialize();
				console.visible = false;
				console.message(VERSION, Console.GREEN);
				console.registerCommand("showProfiler", profiler.show, []);
				
				output = new SkyOutput();
				output.initialize(200, 200, 0xDBB71E, 0x151E27, 0xFFFFFF, SkyFont.HOOGE, 15);
				output.visible = false;
				
				var application:SkyRenderObjectContainer = new mainClass();
				application.isAdded = true;
				applicationUpdatableClass = application as IUpdatable;
				
				var root:SkyRenderObjectContainer = new SkyRenderObjectContainer();
				root.isAdded = true;
				root.addChild(application);
				root.addChild(profiler);
				root.addChild(console);
				root.addChild(output);
				hardwareRender.setRoot(root);
			}
			else
			{
				application = new mainClass();
				application.isAdded = true;
				applicationUpdatableClass = application as IUpdatable;
				hardwareRender.setRoot(application);
			}
		}
		
		private var pause:Boolean = false;
		
		/**
		 * Обработчик событий на каждый кадр.
		 * @param	event событие.
		 */
		private function onEnterFrameHandler(event:Event):void
		{
			oldTime = newTime;
			newTime = getTimer();
			deltaTime = (newTime - oldTime) / 1000;
			deltaTime = (deltaTime < invFrameRate) ? invFrameRate : deltaTime;
			
			if (SkyKeyboard.isPressed(SkyKey.F9)) pause = !pause;
			
			if (isDevelopMode)
			{
				if (!pause)
				{
					CONTEXT_3D.clear();//
					profiler.totalUpdateTime = getTimer();
					keyboard.update();
					console.update();
					
					profiler.applicationUpdateTime = getTimer();
					applicationUpdatableClass.update(deltaTime);
					profiler.applicationUpdateTime = getTimer() - profiler.applicationUpdateTime;
					
					profiler.renderTime = getTimer();
					hardwareRender.update(deltaTime);
					profiler.renderTime = getTimer() - profiler.renderTime;
					
					output.update();
					mouse.reset();
					keyboard.reset();
					
					profiler.totalUpdateTime = getTimer() - profiler.totalUpdateTime;
					profiler.update();
				}
			}
			else
			{
				CONTEXT_3D.clear();//
				keyboard.update();
				applicationUpdatableClass.update(deltaTime);
				hardwareRender.update(deltaTime);
				mouse.reset();
				keyboard.reset();
			}
		}
	}
}