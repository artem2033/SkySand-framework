package skysand.utils 
{
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
		private var sx:Number;
		private var sy:Number;
		
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
			sx = 1;
			sy = 1;
		}
		
		/**
		 * Сбросить все значения.
		 */
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
			sx = 1;
			sy = 1;
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
		
		public function transformSprite(width:Number, height:Number, px:Number, py:Number, offset:int, out:Vector.<Number>):void
		{
			var x:Number = tx - px * a - py * c;
			var y:Number = ty - px * b - py * d;
			
			out[offset] = x;
			out[offset + 1] = y;
			out[offset + 7] = width * a + x;
			out[offset + 8] = width * b + y;
			out[offset + 14] = height * c + x;
			out[offset + 15] = height * d + y;
			out[offset + 21] = width * a + height * c + x;
			out[offset + 22] = width * b + height * d + y;
		}
		
		public function transformPoint(origin:Vector.<Number>, out:Vector.<Number>, offset:int, sx:Number, sy:Number, px:Number, py:Number):void
        {
			var length:int = origin.length / 2;
			
			for (var i:int = 0; i < length; i++) 
			{
				var x:Number = origin[i * 2] - px;
				var y:Number = origin[i * 2 + 1] - py;
				out[i * 7 + offset] = x * a * sx + y * c * sy + tx;
				out[i * 7 + offset + 1] = x * b * sx + y * d * sy + ty;
			}
        }
		
		/**
		 * Поворот.
		 * @param	angle угол в радианах.
		 */
		public function rotate(angle:Number):void
		{
			sin = Math.sin(angle);
            cos = Math.cos(angle);
			
            a = sx * cos;
            b = sx * sin;
            c = -sy * sin;
            d = sy * cos;
		}
		
		/**
		 * Масштаб.
		 * @param	x ось х.
		 * @param	y ось у.
		 */
		public function scale(x:Number, y:Number):void
		{
			sx = x;
			sy = y;
			a = x * cos;
            b = x * sin;
            c = -y * sin;
            d = y * cos;
		}
		
		/**
		 * Смещение.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function translate(x:Number, y:Number):void
		{
			tx = x;
            ty = y;
		}
		
		/**
		 * Трансформировать матрицу.
		 * @param	scaleX масштаб по оси х.
		 * @param	scaleY масштаб по оси у.
		 * @param	x смещение по оси х.
		 * @param	y смещение по оси у.
		 * @param	angle угол поворота в радианах.
		 */
		public function transform(scaleX:Number, scaleY:Number, x:Number, y:Number, angle:Number):void
        {
			sin = Math.sin(angle);
            cos = Math.cos(angle);
			sx = scaleX;
			sy = scaleY;
			
            a = sx * cos;
            b = sx * sin;
            c = -sy * sin;
            d = sy * cos;
            tx = x;
            ty = y;
        }
		
		/**
		 * Трансформировать и перемножить данные на матрицу и сохранить результат.
		 * @param	x координата х.
		 * @param	y координата у.
		 * @param	cos косинус угла.
		 * @param	sin синус угла.
		 * @param	sx масштаб по оси х.
		 * @param	sy масштаб по оси у.
		 * @param	right ссылка на матрицу.
		 */
		public function multiplyOnTransformation(x:Number, y:Number, cos:Number, sin:Number, sx:Number, sy:Number, right:SkyMatrix):void
		{
			a = cos * sx * right.a + sin * sx * right.c;
            b = cos * sx * right.b + sin * sx * right.d;
            c = -sin * sy * right.a + cos * sy * right.c;
            d = -sin * sy * right.b + cos * sy * right.d;
            tx = x * right.a + y * right.c + right.tx;
            ty = x * right.b + y * right.d + right.ty;
		}
		
		/**
		 * Умножить на матрицу.
		 * @param	matrix ссылка на умножаемую матрицу.
		 */
		public function multiplyOn(matrix:SkyMatrix):void
		{
			var ta:Number = a * matrix.a + b * matrix.c;
            var tb:Number = a * matrix.b + b * matrix.d;
            var tc:Number = c * matrix.a + d * matrix.c;
            var td:Number = c * matrix.b + d * matrix.d;
            var ttx:Number = tx * matrix.a + ty * matrix.c + matrix.tx;
            var tty:Number = tx * matrix.b + ty * matrix.d + matrix.ty;
			
			a = ta;
			b = tb;
			c = tc;
			d = td;
			tx = ttx;
			ty = tty;
		}
		
		/**
		 * Перемножить матрицы и сохранить результат в текущую.
		 * @param	left первая матрица.
		 * @param	right вторая матрица.
		 */
		public function multiply(left:SkyMatrix, right:SkyMatrix):void
		{
			a = left.a * right.a + left.b * right.c;
            b = left.a * right.b + left.b * right.d;
            c = left.c * right.a + left.d * right.c;
            d = left.c * right.b + left.d * right.d;
            tx = left.tx * right.a + left.ty * right.c + right.tx;
            ty = left.tx * right.b + left.ty * right.d + right.ty;
		}
		
		/**
		 * Преобразовать значения матрицы в строку.
		 * @return возвращает строку.
		 */
		public function toString():String
		{
			var string:String = "(a=" + a + ", b=" + b;
			string += ", c=" + c + ", d=" + d;
			string += ", tx=" + tx + ", ty=" + ty + ")";
			
			return string;
		}
	}
}