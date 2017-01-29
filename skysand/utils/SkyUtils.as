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
			
			r = bright + r > 255 ? 255 : bright + r < 0 ? 0 : bright + r;
			g = bright + g > 255 ? 255 : bright + g < 0 ? 0 : bright + g;
			b = bright + b > 255 ? 255 : bright + b < 0 ? 0 : bright + b;
			
			var result:uint = (r << 16) | (g << 8) | b;
			
			return result;
		}
		
		public static function getRed(color:uint):uint
		{
			return (color >> 16) & 0xFF;
		}
		
		public static function getGreen(color:uint):uint
		{
			return (color >> 8) & 0xFF;
		}
		
		public static function getBlue(color:uint):uint
		{
			return color & 0xFF;
		}
		
		public static function findMax(array:Vector.<uint>):uint
		{
			var max:uint = array[0];
			var length:int = array.length;
			
			for (var i:int = 1; i < length; i++) 
			{
				if (max < array[i]) max = array[i];
			}
			
			return max;
		}
	}
}