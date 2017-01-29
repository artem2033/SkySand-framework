package skysand.utils  
{
	import flash.geom.Point;
	
	public class SkyVector2D 
	{
		public var x:Number = 0;
		public var y:Number = 0;
		private var point:Point;
		
		public function SkyVector2D(_x:Number = 0, _y:Number = 0) 
		{
			x = _x;
			y = _y;
			point = new Point();
		}
		
		public function normalR():SkyVector2D
		{
			return new SkyVector2D( -y, x);;
		}
		
		public function normalL():SkyVector2D
		{
			return new SkyVector2D( y, -x);
		}
		
		public function normalize():void
		{
			var len:Number = length;
			
			if (len != 0)
			{
				x /= len;
				y /= len;
			}
			else
			{
				x = 0;
				y = 0;
			}
		}
		
		public function get length():Number
		{
			return Math.sqrt(x * x + y * y);
		}
		
		public function multiply(value:Number):void
		{
			x *= value;
			y *= value;
		}
		
		public function multiplyVec(vec:SkyVector2D):void
		{
			x *= vec.x;
			y *= vec.y;
		}
		
		public function set length(value:Number):void
		{
			var a:Number = angle();
			x = Math.cos(a) * value;
			y = Math.sin(a) * value;
		}
		
		public function set maxXY(value:Number):void
		{
			var a:Number = angle();
			
			x = x > value ? value * Math.cos(a) : x;
			y = y > value ? value * Math.sin(a) : y;
		}
		
		public function trancate(value:Number):void
		{
			length = Math.min(value, length);
		}
		
		public function add(vec:SkyVector2D):void
		{
			x += vec.x;
			y += vec.y;
		}
		
		public function remove(vec:SkyVector2D):SkyVector2D
		{
			return new SkyVector2D(x - vec.x, y - vec.y);
		}
		
		public function divide(value:Number):void
		{
			x /= value;
			y /= value;
		}
		
		public function subtract(vector:SkyVector2D):SkyVector2D
		{
			return new SkyVector2D(x - vector.x, y - vector.y);
		}
		
		public function plusNumber(value:Number):SkyVector2D
		{
			return new SkyVector2D(x + value, y + value);
		}
		
		public function print():void
		{
			trace("x: " + x + ", " + "y: " + y);
		}
		
		public function setTo(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function angle():Number
		{
			return Math.atan2(y, x);
		}
		
		public function dotProduct(vec:SkyVector2D):Number
		{
			return x * vec.x + y * vec.y;
		}
		
		public function perpDot(vector:SkyVector2D):Number
		{
			return x * vector.y - y * vector.x;
		}
		
		/**
		 * Преобразовать вектор в точку. 
		 * @return возвращает Point.
		 */
		public function toPoint():Point
		{
			point.x = x;
			point.y = y;
			
			return point;
		}
	}
}