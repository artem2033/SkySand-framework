package skysand.utils 
{
	import flash.utils.getTimer;
	
	public class Utils extends Object
	{
		/**
		 * Ссылка на класс.
		 */
		private static var _instance:Utils;
		
		private static var time:int = 0;
		//1302-1508-1838-1410-2749-1871
		public function Utils()
		{
			if(_instance != null)
			{
				throw new Error("use instance");
			}
			
			_instance = this;
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():Utils
		{
			return (_instance == null) ? new Utils() : _instance;
		}
		
		public static function setTime():void
		{
			time = getTimer();
		}
		
		public static function getTime():int
		{
			return getTimer() - time;
		}
		
		public static function changeColorBright(color:uint, bright:Number):uint
		{
			var r:uint = (color >> 16) & 0xFF;
			var g:uint = (color >> 8) & 0xFF;
			var b:uint = color & 0xFF;
			
			r |= bright;
			g |= bright;
			b |= bright;
			
			var result:uint = (r << 16) | (g << 8) | b;
			
			return result;
		}
	}
}