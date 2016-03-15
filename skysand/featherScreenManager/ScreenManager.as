package skysand.featherScreenManager 
{
	import code.featherEngine.featherAntimation.FeatherAnimationCache;
	import code.featherEngine.featherAntimation.FeatherClip;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class ScreenManager extends Sprite
	{
		private static var _instance:ScreenManager;
		
		private var currentScreen:String;
		private var screens:Object;
		public var screen:Sprite;
		
		public function ScreenManager()
		{
			if (_instance != null)
			{
				throw("Error: bitch try harder!");
			}
			_instance = this;
			
			screens = new Object();
			screen = new Sprite();
			addChild(screen);
		}
		
		public static function get instance():ScreenManager
		{
			return (_instance == null) ? new ScreenManager() : _instance;
		}
		
		public function getScreenOnScene():String
		{
			return currentScreen;
		}
		
		public function nextScreen(id:String):void
		{
			if (screens[id] != null)
			{
				if (currentScreen == null)
				{
					currentScreen = id;
					screen.addChild(screens[id]);
				}
				else
				{
					removeScreen(currentScreen);
					currentScreen = id;
					screen.addChild(screens[id]);
				}
			}
			else
			{
				throw("Error! Screen is Empty");
			}
		}
		
		public function addScreen(clip:Class, id:String):void
		{
			var _cache:FeatherAnimationCache = FeatherAnimationCache.getInstance();
			_cache.addAnimationToCache(clip, id);
			var _scene:FeatherClip = new FeatherClip();
			_scene.setAnim(id);
			_scene.x = 320;
			_scene.y = 240;
			screens[id] = _scene;
		}
		
		public function addToScene(clip:*):void
		{
			screen.addChild(clip);
		}
		
		public function addToSceneAt(clip:Sprite, index:int):void
		{
			screen.addChildAt(clip, index);
		}
		
		public function removeFromScene(clip:*):void
		{
			screen.removeChild(clip);
		}
		
		public function getMaxIndex():int
		{
			return screen.numChildren;
		}
		
		public function removeScreen(id:String, del:String = "hide"):void
		{
			var num:int = screen.numChildren;
			
			if (del == "full" && id != null)
			{
				while (num--)
				{
					screen.removeChildAt(0);
				}
				screens[id] = null;
			}
			else if (del == "hide" && id != null)
			{
				while (num--)
				{
					screen.removeChildAt(0);
				}
			}
		}
	}
}