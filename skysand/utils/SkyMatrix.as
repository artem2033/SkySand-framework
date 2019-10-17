package skysand.utils 
{
	import flash.concurrent.Mutex;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyMatrix 
	{
		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;
		public var tx:Number;
		public var ty:Number;
		private var cos:Number;
		private var sin:Number;
		
		public function SkyMatrix() 
		{
			a = 1;
			b = 0;
			c = 0;
			d = 1;
			tx = 0;
			ty = 0;
			cos = 0;
			sin = 1;
		}
		
		public function indentity():void
		{
			a = 1;
			b = 0;
			c = 0;
			d = 1;
			tx = 0;
			ty = 0;
			cos = 0;
			sin = 1;
		}
		
		public function transformTextField(width:Number, height:Number, offset:int, out:Vector.<Number>):void
		{
			out[offset] = tx;
			out[offset + 1] = ty;
			out[offset + 4] = width * a + tx;
			out[offset + 5] = width * b + ty;
			out[offset + 8] = height * c + tx;
			out[offset + 9] = height * d + ty;
			out[offset + 12] = width * a + height * c + tx;
			out[offset + 13] = width * b + height * d + ty;
		}
		
		public function transformSprite(width:Number, height:Number, offset:int, out:Vector.<Number>):void
		{
			out[offset] = tx;
			out[offset + 1] = ty;
			out[offset + 7] = width * a + tx;
			out[offset + 8] = width * b + ty;
			out[offset + 14] = height * c + tx;
			out[offset + 15] = height * d + ty;
			out[offset + 21] = width * a + height * c + tx;
			out[offset + 22] = width * b + height * d + ty;
		}
		
		public function transformPoint(origin:Vector.<Number>, out:Vector.<Number>, offset:int, sx:Number, sy:Number):void
        {
			var length:int = origin.length / 2;
			
			for (var i:int = 0; i < length; i++) 
			{
				var x:Number = origin[i * 2];
				var y:Number = origin[i * 2 + 1];
				out[i * 7 + offset] = x * a * sx + y * c * sy + tx;
				out[i * 7 + offset + 1] = x * b * sx + y * d * sy + ty;
			}
			
            //result.X = (origin.X * a) + (origin.Y * c) + tx + px;
            //result.Y = (origin.X * b) + (origin.Y * d) + ty + py;
        }
		
		public function rotate(angle:Number, scaleX:Number, scaleY:Number):void
		{
			sin = Math.sin(angle);
            cos = Math.cos(angle);
			
            a = scaleX * cos;
            b = scaleX * sin;
            c = -scaleY * sin;
            d = scaleY * cos;
		}
		
		public function translate(x:Number, y:Number):void
		{
			tx = x;
            ty = y;
		}
		
		public function Transformation(scaleX:Number, scaleY:Number, x:Number, y:Number, angle:Number):void
        {
			sin = Math.sin(angle);
            cos = Math.cos(angle);
			
            a = scaleX * cos;
            b = scaleX * sin;
            c = -scaleY * sin;
            d = scaleY * cos;
            tx = x;
            ty = y;
        }
		
		public function multiply(left:SkyMatrix, right:SkyMatrix):void
		{
			a = left.a * right.a + left.b * right.c;
            b = left.a * right.b + left.b * right.d;
            c = left.c * right.a + left.d * right.c;
            d = left.c * right.b + left.d * right.d;
            tx = left.tx * right.a + left.ty * right.c + right.tx;
            ty = left.tx * right.b + left.ty * right.d + right.ty;
		}
	}
}