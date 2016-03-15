package skysand.utils
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class SkyMath
	{
		public const VERSION:String = "Version of MathClass 1.2, 23 June 2015";
		public static const DEGREE_IN_RADIAN:Number = 180 / Math.PI;
		public static const RADIAN_IN_DEGREE:Number = Math.PI / 180;
		private const MOUSE:String = "16:05 in 28.06.2015"
		private static var time:uint = 0;
		
		public function SkyMath()
		{
			
		}
		
		public static function min(a:Number, b:Number):Number
		{
			return a < b ? a : b;
		}
		
		//растояние между 2-мя точками
		public static function distance(a:SkyVector2D, b:SkyVector2D):Number
		{
			return Math.sqrt(distanceSQR(a, b));
		}
		
		public static function distanceSQR(a:SkyVector2D, b:SkyVector2D):Number
		{
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			
			return dx * dx + dy * dy;
		}
		
		//радианы 2 обьектами
		public static function radian(a:Point, b:Point):Number
		{
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			
			return Math.atan2(dy, dx);
		}
		
		//сгенерировать рандомное число
		public function generateNumber(Max:Number, Min:Number):Number
		{
			var num:Number = Math.random() * Max;
			
			while (num <= Min)
			{
				num = Math.random() * Max;
			}
			
			return num;
		}
		//Из радиан в градусы.
		public static function toDegrees(radian:Number):Number
		{
			return radian * DEGREE_IN_RADIAN;
		}
		//Из градусов в радианы.
		public static function toRadian(angle:Number):Number
		{
			return angle * RADIAN_IN_DEGREE;
		}
		
		public static function radianToNormal(radian:Number):Number
		{
			while (radian < -Math.PI) radian += Math.PI * 2;
			while (radian > Math.PI) radian -= Math.PI * 2;
			
			return radian;
		}
		
		public static function setTime():void
		{
			time = getTimer();
		}
		
		public static function getTime():String
		{
			return "Time passed: " + String(getTimer() - time) + " ms.";
		}
		
		public static function getSize(object:*):uint
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			
			return byteArray.length;
		}
		
		public static function generateNumber(max:Number, min:Number):Number
		{
			var value:Number = Math.random() * max;
			
			while (value < min)
			{
				value = Math.random() * max;
			}
			
			return value;
		}
	}
}