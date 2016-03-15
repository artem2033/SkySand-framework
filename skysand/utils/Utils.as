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
	}
}