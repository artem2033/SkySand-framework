package skysand.utils
{
	import flash.geom.Point;
	
	public class SkyMath
	{
		public static const PI_2:Number = Math.PI * 2;
		public static const HALF_PI:Number = Math.PI / 2;
		
		/**
		 * Константа хранящее значение 1 радиана в градусах.
		 */
		public static const RADIAN:Number = Math.PI / 180;
		
		/**
		 * Константа хранящее значение 1 градуса в радианах.
		 */
		public static const DEGREE:Number = 180 / Math.PI;
		
		/**
		 * Точка для расчёта поворота точки.
		 */
		private static var point:Point = new Point();
		
		public function SkyMath()
		{
			//time = 0;
			//point = new Point();
		}
		/*
		public function contains(x:Number, y:Number):Boolean
        {
            // Algorithm & implementation thankfully taken from:
            // -> http://alienryderflex.com/polygon/

            var i:int, j:int = numVertices - 1;
            var oddNodes:uint = 0;

            for (i=0; i<numVertices; ++i)
            {
                var ix:Number = _coords[i * 2];
                var iy:Number = _coords[i * 2 + 1];
                var jx:Number = _coords[j * 2];
                var jy:Number = _coords[j * 2 + 1];

                if ((iy < y && jy >= y || jy < y && iy >= y) && (ix <= x || jx <= x))
                    oddNodes ^= uint(ix + (y - iy) / (jy - iy) * (jx - ix) < x);

                j = i;
            }

            return oddNodes != 0;
        }
		*/
		/**
		 * Проверка на попадание точки в контур.
		 * @param	x координата точки.
		 * @param	y координата точки.
		 * @param	xPoints массив координат контура.
		 * @param	yPoints массив координта контура.
		 * @param	offset начальная точка обхода контура.
		 * @param	length количество точек. Если явно не указано, то будет присвоена длинна массива.
		 * @return возвращает true - столкновение, false - отсутствие столкновения.
		 */
		public static function containsPoint(x:Number, y:Number, xPoints:Vector.<Number>, yPoints:Vector.<Number>, offset:int = 0, length:int = -1):Boolean
		{
			length = length == -1 ? xPoints.length : length;
			
			var i:int, j:int = length - 1;
			var oddNodes:uint = 0;
			
			for (i = offset; i < length; ++i)
			{
				var ix:Number = xPoints[i];
				var iy:Number = yPoints[i];
				var jx:Number = xPoints[j];
				var jy:Number = yPoints[j];
				
				if ((iy < y && jy >= y || jy < y && iy >= y) && (ix <= x || jx <= x))
					oddNodes ^= uint(ix + (y - iy) / (jy - iy) * (jx - ix) < x);
				
				j = i;
			}
			
			return oddNodes != 0;
		}
		
		/**
		 * Расстояние между двумя точками.
		 * @param	a точка 1.
		 * @param	b точка 2.
		 * @return возращает результат.
		 */
		[Inline]
		public static function distance(ax:Number, ay:Number, bx:Number, by:Number):Number
		{
			var dx:Number = ax - bx;
			var dy:Number = ay - by;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * Расстояние между двумя точками в квадрате.
		 * @param	a точка 1.
		 * @param	b точка 2.
		 * @return возращает результат.
		 */
		[Inline]
		public static function distanceSQR(ax:Number, ay:Number, bx:Number, by:Number):Number
		{
			var dx:Number = ax - bx;
			var dy:Number = ay - by;
			
			return dx * dx + dy * dy;
		}
		
		/**
		 * Угол в радианах между 2 - мя точками.
		 * @param	a точка 1.
		 * @param	b точка 2.
		 * @return возращает угол.
		 */
		[Inline]
		public static function radian(ax:Number, ay:Number, bx:Number, by:Number):Number
		{
			var dx:Number = ax - bx;
			var dy:Number = ay - by;
			
			return Math.atan2(dy, dx);
		}
		
		/**
		 * Перевод угла из радиан в градусы.
		 * @param	radian радианы.
		 * @return возвращает значение угла в градусах.
		 */
		[Inline]
		public static function toDegrees(radian:Number):Number
		{
			return radian * DEGREE;
		}
		
		/**
		 * Перевод угла из градусов в радианы.
		 * @param	degrees градусы.
		 * @return возвращает значение угла в радианах.
		 */
		[Inline]
		public static function toRadian(degrees:Number):Number
		{
			return degrees * RADIAN;
		}
		
		/**
		 * Нормализовать угол в градусах, т. е. перевести угол в промежуток от 0 до 360.
		 * @param	degrees исходное значение.
		 * @return возвращает результат.
		 */
		[Inline]
		public static function normalizeDegrees(degrees:Number):Number
		{
			return degrees % 360;
		}
		
		/**
		 * Нормализовать угол в радианах, т. е. перевести угол в промежуток от 0 до 2PI.
		 * @param	radian исходное значение.
		 * @return возвращает результат.
		 */
		[Inline]
		public static function normalizeRadian(radian:Number):Number
		{
			return radian % (Math.PI * 2);
		}
		
		/**
		 * Повернуть точку относительно заданной оси на определённый угол с уже рассчитанными значениями синуса и косинуса.
		 * @param	x координата точки.
		 * @param	y координата точки.
		 * @param	axisX координата оси.
		 * @param	axisY координита оси.
		 * @param	cos косинус угла.
		 * @param	sin синус угла.
		 * @return возвращает точку с результирующими координатами.
		 */
		[Inline]
		public static function rotatePointWithConst(x:Number, y:Number, axisX:Number, axisY:Number, cos:Number, sin:Number):Point
		{
			var dx:Number = x - axisX;
			var dy:Number = y - axisY;
			
			point.x = axisX + dx * cos - dy * sin;
			point.y = axisY + dy * cos + dx * sin;
			
			return point;
		}
		
		/**
		 * Повернуть точку относительно заданной оси на определённый угол.
		 * @param	x координата точки.
		 * @param	y координата точки.
		 * @param	axisX координата оси.
		 * @param	axisY координита оси.
		 * @param	angle угол в радианах.
		 * @return возвращает точку с результирующими координатами.
		 */
		[Inline]
		public static function rotatePoint(x:Number, y:Number, axisX:Number, axisY:Number, angle:Number):Point
		{
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			
			var dx:Number = x - axisX;
			var dy:Number = y - axisY;
			
			point.x = axisX + dx * cos - dy * sin;
			point.y = axisY + dy * cos + dx * sin;
			
			return point;
		}
		
		/**
		 * Получить случайное число в заданном промежутке.
		 * @param	max максимальное число.
		 * @param	min минимальное число.
		 * @return возвращает получившееся число.
		 */
		[Inline]
		public static function generateNumber(max:Number, min:Number):Number
		{
			return min + Math.random() * (max - min);
		}
	}
}