package skysand.display
{
	import air.update.states.HSM;
	import flash.display.Stage;
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
		public var depth:uint;
		
		/**
		 * Глобальная глубина.
		 */
		protected var globalDepth:uint;
		
		public var isOk:Boolean;
		public var globalR:Point;
		public var localR:Point;
		
		public var isAdded:Boolean;
		public var isVisible:Boolean;
		private var _stage:Stage;
		public var globalVisible:uint;
		
		public function SkyRenderObject()
		{
			globalVisible = 1;
			isOk = false;
			isAdded = false;
			isVisible = false;
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
			globalR = new Point();
			localR = new Point();
			_stage = SkySand.STAGE;
		}
		
		public function remove():void
		{
			
		}
		
		public function init():void
		{
			
		}
		
		public function get stage():Stage
		{
			return _stage;
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
        }
		
		/**
		 * override this method.
		 */
		public function updateData():void
		{
			
		}
	}
}