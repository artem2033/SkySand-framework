package skysand.utils  
{
	import flash.geom.Point;
	
	import skysand.display.SkyShape;
	
	public class SkyVector2D extends Object
	{
		/**
		 * Координата х.
		 */
		public var x:Number;
		
		/**
		 * Координата у.
		 */
		public var y:Number;
		
		public function SkyVector2D(x:Number = 0, y:Number = 0) 
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Равны ли векторы между собой.
		 * @param	vector второй вектор.
		 */
		public function equals(vector:SkyVector2D):Boolean
		{
			return vector.x == x && vector.y == y;
		}
		
		/**
		 * Расстояние между векторами.
		 * @param	vector второй вектор.
		 * @return возвращает расстояние между векторами.
		 */
		public function distance(vector:SkyVector2D):Number
		{
			var dx:Number = vector.x - x;
			var dy:Number = vector.y - y;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * Расстояние между векторами в квадрате.
		 * @param	vector второй вектор.
		 * @return возвращает расстояние между векторами в квадрате.
		 */
		public function distanceSQR(vector:SkyVector2D):Number
		{
			var dx:Number = vector.x - x;
			var dy:Number = vector.y - y;
			
			return dx * dx + dy * dy;
		}
		
		/**
		 * Присвоить координаты другого вектора.
		 * @param	vector вектор, чьи координаты нужно присвоить.
		 */
		public function setFrom(vector:SkyVector2D):void
		{
			x = vector.x;
			y = vector.y;
		}
		
		/**
		 * Обнулить вектор.
		 */
		public function setZero():void
		{
			x = 0;
			y = 0;
		}
		
		/**
		 * Норамализовать вектор.
		 */
		public function normalize():void
		{
			var length:Number = Math.sqrt(x * x + y * y);
			
			x = length != 0 ? x / length : 0;
			y = length != 0 ? y / length : 0;
		}
		
		/**
		 * Инвертировать вектор.
		 */
		public function negate():void
		{
			x = -x;
			y = -y;
		}
		
		/**
		 * Прибавить вектор.
		 */
		public function add(vector:SkyVector2D):void
		{
			x += vector.x;
			y += vector.y;
		}
		
		/**
		 * Вычесть вектор.
		 */
		public function subtract(vector:SkyVector2D):void
		{
			x -= vector.x;
			y -= vector.y;
		}
		
		/**
		 * Умножить вектор на скаляр.
		 * @param	value число.
		 */
		public function multiply(value:Number):void
		{
			x *= value;
			y *= value;
		}
		
		/**
		 * Поделить вектор на скаляр.
		 * @param	value число.
		 */
		public function divide(value:Number):void
		{
			x /= value;
			y /= value;
		}
		
		/**
		 * Скалярное произведение векторов.
		 * @param	vector 2-ой вектор.
		 * @return возвращает результат.
		 */
		public function dotProduct(vector:SkyVector2D):Number
		{
			return x * vector.x + y * vector.y;
		}
		
		/**
		 * Угол между векторами.
		 * @param	vector второй вектор.
		 * @return возвращает угол в радианах.
		 */
		public function angleBetween(vector:SkyVector2D):Number
		{
			var l:Number = vector.length * length;
			
			return Math.acos((x * vector.x + y * vector.y) / l);
		}
		
		/**
		 * Задать значения.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function setTo(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Задать значения из точки.
		 * @param	point точка.
		 */
		public function fromPoint(point:Point):void
		{
			x = point.x;
			y = point.y;
		}
		
		/**
		 * Преобразовать вектор в точку. 
		 * @return возвращает Point.
		 */
		public function toPoint():Point
		{
			return new Point(x, y);
		}
		
		/**
		 * Преобразовать в строку.
		 */
		public function toString():String
		{
			return "x: " + x.toString() + ", " + "y: " + y.toString();
		}
		
		/**
		 * Нарисовать вектор.
		 * @param	shape форма с помощью которой отображать вектор.
		 * @param	x координата из которой рисовать вектор.
		 * @param	y координата из которой рисовать вектор.
		 */
		public function draw(shape:SkyShape, x:Number, y:Number):void
		{
			shape.x = x;
			shape.y = y;
			shape.width = length;
			shape.rotation = SkyMath.toDegrees(angle);
		}
		
		/**
		 * Получить правую нормаль от вектора.
		 */
		public function set normalR(vector:SkyVector2D):void
		{
			x = -vector.y;
			y = vector.x;
		}
		
		/**
		 * Получить левую нормаль от вектора.
		 */
		public function set normalL(vector:SkyVector2D):void
		{
			x = vector.y;
			y = -vector.x;
		}
		
		/**
		 * Получть угол.
		 */
		public function get angle():Number
		{
			return Math.atan2(y, x);
		}
		
		/**
		 * Задать угол.
		 */
		public function set rotate(value:Number):void
		{
			var cos:Number = Math.cos(value);
			var sin:Number = Math.sin(value);
			var dx:Number = x;
			var dy:Number = y;
			
			x = dx * cos - dy * sin;
			y = dy * cos + dx * sin;
		}
		
		/**
		 * Получить длину вектора.
		 */
		public function get length():Number
		{
			return Math.sqrt(x * x + y * y);
		}
		
		/**
		 * Задать длину вектора.
		 */
		public function set length(value:Number):void
		{
			var scale:Number = value / length;
			x *= scale;
			y *= scale;
		}
		
		/**
		 * Получить квадрат длины данного вектора.
		 */
		public function get lengthSquared():Number
		{
			return x * x + y * y;
		}
	}
}