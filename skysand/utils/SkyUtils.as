package skysand.utils 
{
	import flash.utils.getTimer;
	import flash.utils.ByteArray;
	
	public class SkyUtils extends Object
	{
		/**
		 * Время начала отсчёта.
		 */
		private static var time:int = 0;
		
		public function SkyUtils()
		{
			
		}
		
		/**
		 * Получить рамер объекта в байтах.
		 * @param	object объект.
		 * @return возращает результат.
		 */
		public static function getSize(object:*):uint
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			
			return byteArray.length;
		}
		
		/**
		 * Засечь время.
		 */
		public static function setTime():void
		{
			time = getTimer();
		}
		
		/**
		 * Получить время в ms прошедшее с вызова функции setTime().
		 * @return время в миллисекундах.
		 */
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