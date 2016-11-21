package skysand.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import skysand.render.hardware.SkyHardwareRender;
	import skysand.utils.SkyMath;
	
	public class SkyRenderObject extends Object
	{
		private static var DEPTH_COUNTER:Number = 0;
		
		/**
		 * Координата x.
		 */
		public var x:Number;
		
		/**
		 * Координата y.
		 */
		public var y:Number;
		
		/**
		 * Ширина.
		 */
		public var width:Number;
		
		/**
		 * Высота.
		 */
		public var height:Number;
		
		/**
		 * Угол поврота.
		 */
		public var rotation:Number;
		
		/**
		 * Прозрачность от 0 до 1.
		 */
		public var alpha:Number;
		
		/**
		 * Видимость объекта.
		 */
		public var visible:Boolean;
		
		/**
		 * Горизонтальное масштабирование.
		 */
		public var scaleX:Number;
		
		/**
		 * Вертикальное масштабирование.
		 */
		public var scaleY:Number;
		
		/**
		 * Координата центра по оси x.
		 */
		public var pivotX:Number;
		
		/**
		 * Координата центра по оси у.
		 */
		public var pivotY:Number;
		
		/**
		 * Глобальная координата х.
		 */
		public var globalX:Number;
		
		/**
		 * Глобальная координата у.
		 */
		public var globalY:Number;
		
		/**
		 * Глобальный угол поворота.
		 */
		public var globalRotation:Number;
		
		/**
		 * Глобальное горизонтальное масштабирование.
		 */
		public var globalScaleX:Number;
		
		/**
		 * Глобальное вертикальное масштабирование.
		 */
		public var globalScaleY:Number;
		
		/**
		 * Глубина на сцене.
		 */
		public var depth:Number;
		
		/**
		 * Глобальная глубина.
		 */
		protected var globalDepth:uint;
		
		public var globalR:Point;
		public var localR:Point;
		
		public function SkyRenderObject()
		{
			x = 0;
			y = 0;
			width = 0;
			height = 0;
			rotation = 0;
			alpha = 1;
			visible = true;
			depth = 0;
			scaleX = 1;
			scaleY = 1;
			pivotX = 0;
			pivotY = 0;
			globalX = 0;
			globalY = 0;
			globalRotation = 0;
			globalDepth = 0;
			globalScaleX = 1;
			globalScaleY = 1;
		}
		
		/**
		 * Получить ограничивающий прямоугольник.
		 * Нужно переделать.
		 * @param	child дочерний объект
		 * @return возвращает прямогульник(Rectangle).
		 */
		public function getBounds(child:SkyRenderObject):Rectangle
		{
			return new Rectangle(globalX, globalY, width, height);
		}
		
		public function getRect(targetCoordinateSpace:SkyRenderObject):Rectangle
		{
			return null;
		}
		
		public function hitTestObject(object:SkyRenderObject):Boolean
		{
			return false;
		}
		
		public function hitTestPoint(x:Number, y:Number):Boolean
		{
			if (x > globalX + width - pivotX) return false;
			if (x < globalX - pivotX) return false;
			if (y > globalY + height - pivotY) return false;
			if (y < globalY - pivotY) return false;
			
			return true;
            // Algorithm & implementation thankfully taken from:
            // -> http://alienryderflex.com/polygon/
			
            /*var i:int, j:int = numVertices - 1;
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
			
            return oddNodes != 0;*/
        }
		
		/**
		 * override this method.
		 */
		public function updateCoordinates():void
		{
			
		}
	}
}