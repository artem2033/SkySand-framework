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
		
		/**
		 * Тон.
		 */
		public static var hue:Number = 0;
		
		/**
		 * Насыщенность.
		 */
		public static var saturation:Number = 0;
		
		/**
		 * Яркость.
		 */
		public static var value:Number = 0;
		
		public function SkyUtils()
		{
			
		}
		
		/**
		 * Конвертировать строку в булево значение.
		 * @param	string строка.
		 * @return возращает результат.
		 */
		public static function stringToBool(string:String):Boolean
		{
			return string == "false" ? false : true;
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
		 * Получить имя класса через объект.
		 * @param	object ссылка на объект.
		 * @return возвращает строку.
		 */
		public static function getClassName(object:*):String
		{
			return Object(object).constructor;
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
		
		public static function setColor(red:uint, green:uint, blue:uint):uint
		{
			return (red << 16) | (green << 8) | blue;
		}
		
		[Inline]
		public static function isPowerOfTwo(value:int):Boolean
		{
			return !(value & (value - 1));
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
		
		/**
		 * Получить значение цвета из hsv схемы в rgb.
		 * @param	hue значение от 0 до 360.
		 * @param	saturation значение от 0 до 1.
		 * @param	value значение от 0 до 1.
		 * @return возвращает rgb цвет. 
		 */
		[Inline]
		public static function HSVToRGB(hue:Number, saturation:Number, value:Number):uint
		{
			var c:Number = saturation * value;
			var x:Number = c * (1 - Math.abs((hue / 60) % 2 - 1));
			var m:Number = value - c;
			
			var red:Number = (hue < 60) ? c : (hue < 120) ? x : (hue < 240) ? 0 : (hue < 300) ? x : c;
			var green:Number = (hue < 60) ? x : (hue < 180) ? c : (hue < 240) ? x : 0;
			var blue:Number = (hue < 120) ? 0 : (hue < 180) ? x : (hue < 300) ? c : x;
			
			return ((red + m) * 255 << 16) | ((green + m) * 255 << 8) | (blue + m) * 255;
		}
		
		/**
		 * Преобразовать цвет из rgb в hsv.
		 * @param	color
		 */
		public static function RGBToHSV(color:uint):void
		{
			var r:Number = ((color >> 16) & 0xFF) / 255;
			var g:Number = ((color >> 8) & 0xFF) / 255;
			var b:Number = (color & 0xFF) / 255;
			
			var cmax:Number = Math.max(Math.max(r, g), b);
			var cmin:Number = Math.min(Math.min(r, g), b);
			var delta:Number = cmax - cmin;
			
			saturation = cmax != 0 ? delta / cmax : 0;
			value = cmax;
			
			if (delta == 0)
			{
				hue = 0;
				return;
			}
			
			if (cmax == r)
			{
				hue = ((g - b) / delta) % 6 * 60;
				hue = hue < 0 ? 360 + hue : hue;
				
				return;
			}
			
			if (cmax == g)
			{
				hue = (((b - r) / delta) + 2) * 60;
				hue = hue < 0 ? 360 + hue : hue;
				
				return;
			}
			
			if (cmax == b)
			{
				hue = (((r - g) / delta) + 4) * 60;
				hue = hue < 0 ? 360 + hue : hue;
				
				return;
			}
		}
		
		
		public static function closestPowerOfTwo(value:Number):Number
		{
			value--;
			value |= value >> 1;
			value |= value >> 2;
			value |= value >> 4;
			value |= value >> 8;
			value |= value >> 16;
			value++;
			
			return value;
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