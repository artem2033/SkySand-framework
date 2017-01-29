package skysand.utils  
{
	public class f2Vec 
	{
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function f2Vec(_x:Number, _y:Number) 
		{
			x = _x;
			y = _y;
		}
		
		public function normalR():f2Vec
		{
			return new f2Vec( -y, x);
		}
		
		public function normalL():f2Vec
		{
			return new f2Vec( y, -x);
		}
		
		public function normalize():void
		{
			var len:Number = length();
			
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
		
		public function length():Number
		{
			return Math.sqrt(x * x + y * y);
		}
		
		public function multiply(num:Number):f2Vec
		{
			return new f2Vec(x * num, y * num);
		}
		
		public function multiplyVec(vec:f2Vec):void
		{
			x *= vec.x;
			y *= vec.y;
		}
		
		public function trancate(vec:f2Vec):f2Vec
		{
			return new f2Vec(x - vec.x, y - vec.y);
		}
		
		public function plus(vec:f2Vec):f2Vec
		{
			return new f2Vec(x + vec.x, y + vec.y);
		}
		
		public function plusNumber(value:Number):f2Vec
		{
			return new f2Vec(x + value, y + value);
		}
		
		public function print():void
		{
			trace("x: " + x + ", " + "y: " + y);
		}
		
		public function Set(_x:Number, _y:Number):void
		{
			x = _x;
			y = _y;
		}
		
		public function dotProduct(vec:f2Vec):Number
		{
			return x * vec.x + y * vec.y;
		}
		
		public function perpDot(vector:f2Vec):Number
		{
			return x * vector.y - y * vector.x;
		}
	}
}