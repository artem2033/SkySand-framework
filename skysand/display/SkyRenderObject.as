package skysand.display
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import skysand.input.SkyMouse;
	import skysand.utils.SkyMatrix;
	import skysand.utils.SkyMath;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyRenderObject extends Object
	{
		/**
		 * Индекс с которого начинаются считываться вершины.
		 */
		public var indexID:int;
		
		/**
		 * Ссылка на родителя.
		 */
		public var parent:SkyRenderObjectContainer;
		
		/**
		 * Глобальная координата х.
		 */
		public var globalX:Number;
		
		/**
		 * Глобальная координата у.
		 */
		public var globalY:Number;
		
		/**
		 * Глобальная видимость объекта.
		 */
		public var isVisible:Boolean;
		
		/**
		 * Добален ли объект на сцену.
		 */
		public var isAdded:Boolean;
		
		/**
		 * Имя объекта.
		 */
		public var name:String;
		
		/**
		 * Указывает на то трансформирован ли объект локально.
		 */
		public var isTransformed:Boolean;
		
		/**
		 * Указывает на то трансформирован ли объект глобально.
		 */
		public var globalTransformation:Boolean;
		
		/**
		 * Координата x.
		 */
		protected var mX:Number;
		
		/**
		 * Координата y.
		 */
		protected var mY:Number;
		
		/**
		 * Ширина.
		 */
		protected var mWidth:Number;
		
		/**
		 * Высота.
		 */
		protected var mHeight:Number;
		
		/**
		 * Угол поврота.
		 */
		protected var mRotation:Number;
		
		/**
		 * Прозрачность от 0 до 1.
		 */
		protected var mAlpha:Number;
		
		/**
		 * Горизонтальное масштабирование.
		 */
		protected var mScaleX:Number;
		
		/**
		 * Вертикальное масштабирование.
		 */
		protected var mScaleY:Number;
		
		/**
		 * Координата центра по оси x.
		 */
		protected var mPivotX:Number;
		
		/**
		 * Координата центра по оси у.
		 */
		protected var mPivotY:Number;
		
		/**
		 * Глубина на сцене.
		 */
		protected var mDepth:int;
		
		/**
		 * Цвет.
		 */
		protected var mColor:uint;
		
		/**
		 * Видимость объекта.
		 */
		protected var mVisible:Boolean;
		
		/**
		 * Глобальная матрица трансформации объекта.
		 */
		protected var worldMatrix:SkyMatrix;
		
		/**
		 * Посчитан ли ограничивающий прямоугольник.
		 */
		protected var boundsCalculated:Boolean;
		
		/**
		 * Ограничивающий прямоугольник.
		 */
		protected var bounds:Rectangle;
		
		/**
		 * Может ли мышь взаимодействовать с объектом.
		 */
		private var mMouseEnabled:Boolean;
		
		/**
		 * Перетаскивать или нет.
		 */
		private var drag:Boolean;
		
		/**
		 * Точка смещения при перемещении объекта.
		 */
		private var offsetDragPoint:Point;
		
		/**
		 * Заблокировать ось х при перемещении.
		 */
		private var isLockAxisX:Boolean;
		
		/**
		 * Заблокировать ось у при перемещении.
		 */
		private var isLockAxisY:Boolean;
		
		/**
		 * Нижняя граница при перемещении.
		 */
		private var downBorder:Number;
		
		/**
		 * Верхняя граница при перемещении.
		 */
		private var upBorder:Number;
		
		/**
		 * Левая граница при перемещении.
		 */
		private var leftBorder:Number;
		
		/**
		 * Правая граница при перемещении.
		 */
		private var rightBorder:Number;
		
		/**
		 * Ограничивать ли перемещение.
		 */
		private var border:Boolean;
		
		/**
		 * Косинус угла поворота.
		 */
		private var cos:Number;
		
		/**
		 * Синус угла поворота.
		 */
		private var sin:Number;
		
		public function SkyRenderObject()
		{
			offsetDragPoint = new Point();
			worldMatrix = new SkyMatrix();
			bounds = new Rectangle(0, 0, 1, 1);
			parent = null;
			
			drag = false;
			border = false;
			isAdded = false;
			mVisible = true;
			isVisible = true;
			isTransformed = true;
			mMouseEnabled = false;
			boundsCalculated = false;
			globalTransformation = true;
			
			name = "";
			
			mX = 0;
			mY = 0;
			cos = 1;
			sin = 0;
			mColor = 0xFFFFFF;
			mAlpha = 1;
			mDepth = -1;
			mWidth = 1;
			mHeight = 1;
			mScaleX = 1;
			mScaleY = 1;
			mPivotX = 0;
			mPivotY = 0;
			globalX = 0;
			globalY = 0;
			indexID = 0;
			mRotation = 0;
			upBorder = 0;
			downBorder = 0;
			leftBorder = 0;
			rightBorder = 0;
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			offsetDragPoint = null;
			parent = null;
		}
		
		/**
		 * Удалить объект.
		 */
		public function remove():void
		{
		}
		
		/**
		 * Инициализировать объект.
		 */
		public function init():void
		{
		}
		
		/**
		 * Получить ограничивающий прямоугольник.
		 * @param	child дочерний объект
		 * @return возвращает прямогульник(Rectangle).
		 */
		public function getBounds():Rectangle
		{
			return bounds;
		}
		
		/**
		 * Проверка на столкновение с другим объектом
		 */
		public function hitTestObject(object:SkyRenderObject):Boolean
		{
			var a:Rectangle = object.bounds;
			
			if (!boundsCalculated) calculateBounds();
			if (!object.boundsCalculated) object.calculateBounds();
			
			if (a.width + object.globalX < bounds.x + globalX || a.x + object.globalX > bounds.width + globalX) return false;
			if (a.height + object.globalY < bounds.y + globalY || a.y + object.globalY > bounds.height + globalY) return false;
			
			return true;
		}
		
		/**
		 * Проверка на столкновение с мышкой.
		 */
		public function hitTestMouse():Boolean
		{
			return false;
		}
		
		/**
		 * Проверка на столкновение с точкой.
		 */
		public function hitTestPoint(x:Number, y:Number):Boolean
		{
			return false;
		}
		
		/**
		 * Начать перемещение объекта за курсором мыши.
		 * @param	lockAxisX заблокировать ось х.
		 * @param	lockAxisY заблокировать ось у.
		 * @param	downBorder нижняя граница.
		 * @param	upBorder верхняя граница.
		 * @param	leftBorder левая граница.
		 * @param	rightBorder правая граница.
		 * @param	lockCentr игнорировать смещение курсора относительно центра объекта.
		 */
		public function startDrag(lockAxisX:Boolean = false, lockAxisY:Boolean = false, downBorder:Number = 0, upBorder:Number = 0, leftBorder:Number = 0, rightBorder:Number = 0, lockCentr:Boolean = false):void
		{
			if (!drag)
			{
				if (!lockCentr)
				{
					offsetDragPoint.x = SkyMouse.x - x;
					offsetDragPoint.y = SkyMouse.y - y;
				}
				else
				{
					offsetDragPoint.x = 0;
					offsetDragPoint.y = 0;
				}
				
				drag = true;
				
				isLockAxisX = lockAxisX;
				isLockAxisY = lockAxisY;
				border = upBorder != 0 || downBorder != 0 || leftBorder != 0 || rightBorder != 0 ? true : false;
				this.upBorder = upBorder;
				this.downBorder = downBorder;
				this.leftBorder = leftBorder;
				this.rightBorder = rightBorder;
			}
		}
		
		/**
		 * Остановить перетаскивание объекта.
		 * Объект следует за мышью.
		 */
		public function stopDrag():void
		{
			drag = false;
		}
		
		/**
		 * Проверка на столкновение курсора с границами объекта..
		 * @return возвращает true - столкновение, false - отсутствие столкновения.
		 */
		public function hitTestBoundsWithMouse():Boolean
		{
			var x:Number = SkyMouse.x;
			var y:Number = SkyMouse.y;
			
			if (!boundsCalculated) calculateBounds();
			if (x < bounds.x + globalX || x > bounds.width + globalX) return false;
			if (y < bounds.y + globalY || y > bounds.height + globalY) return false;
			
			return true;
		}
		
		/**
		 * Проверка на столкновение точки с границами объекта.
		 * @param	x координаты точки по оси х.
		 * @param	y координаты точки по оси у.
		 * @return возвращает true - столкновение, false - отсутствие столкновения.
		 */
		public function hitTestBounds(x:Number, y:Number):Boolean
		{
			if (!boundsCalculated) calculateBounds();
			if (x < bounds.x + globalX || x > bounds.width + globalX) return false;
			if (y < bounds.y + globalY || y > bounds.height + globalY) return false;
			
			return true;
		}
		
		/**
		 * Посчитать глобальную видимость.
		 */
		public function calculateGlobalVisible():void
		{
			isVisible = mVisible && parent.mVisible && isAdded && parent.isAdded && parent.isVisible;
			isTransformed = false;
		}
		
		/**
		 * Обновить трансформацию объекта.
		 */
		public function updateTransformation():void
		{
			worldMatrix.multiplyOnTransformation(mX, mY, cos, sin, mScaleX, mScaleY, parent.worldMatrix);
			
			globalX = worldMatrix.tx;
			globalY = worldMatrix.ty;
		}
		
		/**
		 * Обновить данные объекта.
		 */
		public function updateData(deltaTime:Number):void
		{
			if (drag)
			{
				x = isLockAxisX ? mX : SkyMouse.x - offsetDragPoint.x;
				y = isLockAxisY ? mY : SkyMouse.y - offsetDragPoint.y;
				
				if (border)
				{
					//if(isLockAxisX)
						x = mX >= rightBorder ? rightBorder : mX <= leftBorder ? leftBorder : mX;
					//if(isLockAxisY)
						y = mY >= downBorder ? downBorder : mY <= upBorder ? upBorder : mY;
						
				}
			}
		}
		
		/**
		 * Посчитать граничивающий прямоугольник.
		 */
		public function calculateBounds():void
		{
			bounds.setTo( -mPivotX * mScaleX, -mPivotY * mScaleY, (mWidth - mPivotX) * mScaleX, (mHeight - mPivotY) * mScaleY);
			boundsCalculated = true;
		}
		
		/**
		 * Перетаскивается ли в данный момент объект.
		 */
		public function get isDrag():Boolean
		{
			return drag;
		}
		
		/**
		 * Координата х.
		 */
		public function get x():Number
		{
			return mX;
		}
		
		/**
		 * Координата х.
		 */
		public function set x(value:Number):void
		{
			if (mX != value)
			{
				mX = value;
				isTransformed = false;
			}
		}
		
		/**
		 * Координата у.
		 */
		public function get y():Number
		{
			return mY;
		}
		
		/**
		 * Координата у.
		 */
		public function set y(value:Number):void
		{
			if (mY != value)
			{
				mY = value;
				isTransformed = false;
			}
		}
		
		/**
		 * Ось X.
		 */
		public function get pivotX():Number
		{
			return mPivotX;
		}
		
		/**
		 * Ось X.
		 */
		public function set pivotX(value:Number):void
		{
			if (mPivotX != value)
			{
				mPivotX = value;
				isTransformed = false;
				boundsCalculated = false;
			}
		}
		
		/**
		 * Ось Y.
		 */
		public function get pivotY():Number
		{
			return mPivotY;
		}
		
		/**
		 * Ось Y.
		 */
		public function set pivotY(value:Number):void
		{
			if (mPivotY != value)
			{
				mPivotY = value;
				isTransformed = false;
				boundsCalculated = false;
			}
		}
		
		/**
		 * Масштаб по оси X.
		 */
		public function get scaleX():Number
		{
			return mScaleX;
		}
		
		/**
		 * Масштаб по оси X.
		 */
		public function set scaleX(value:Number):void
		{
			if (mScaleX != value)
			{
				mScaleX = value;
				isTransformed = false;
				boundsCalculated = false;
			}
		}
		
		/**
		 * Масштаб по оси Y.
		 */
		public function get scaleY():Number
		{
			return mScaleY;
		}
		
		/**
		 * Масштаб по оси Y.
		 */
		public function set scaleY(value:Number):void
		{
			if (mScaleY != value)
			{
				mScaleY = value;
				isTransformed = false;
				boundsCalculated = false;
			}
		}
		
		/**
		 * Ширина.
		 */
		public function get width():Number
		{
			return mWidth;
		}
		
		/**
		 * Ширина.
		 */
		public function set width(value:Number):void
		{
			if (mWidth != value)
			{
				mWidth = value;
				isTransformed = false;
				boundsCalculated = false;
			}
		}
		
		/**
		 * Высота.
		 */
		public function get height():Number
		{
			return mHeight;
		}
		
		/**
		 * Высота.
		 */
		public function set height(value:Number):void
		{
			if (mHeight != value)
			{
				mHeight = value;
				isTransformed = false;
				boundsCalculated = false;
			}
		}
		
		/**
		 * Угол поворота в градусах.
		 */
		public function get rotation():Number
		{
			return mRotation;
		}
		
		/**
		 * Угол поворота в градусах.
		 */
		public function set rotation(value:Number):void
		{
			if (mRotation != value)
			{
				mRotation = value;
				cos = Math.cos(value * SkyMath.RADIAN);
				sin = Math.sin(value * SkyMath.RADIAN);
				isTransformed = false;
				boundsCalculated = false;
			}
		}
		
		/**
		 * Цвет.
		 */
		public function get color():uint
		{
			return mColor;
		}
		
		/**
		 * Цвет.
		 */
		public function set color(value:uint):void
		{
			mColor = value;
		}
		
		/**
		 * Глубина на сцене.
		 */
		public function get depth():int
		{
			return mDepth;
		}
		
		/**
		 * Глубина на сцене.
		 */
		public function set depth(value:int):void
		{
			mDepth = value;
		}
		
		/**
		 * Прозрачность от 0 до 1.
		 */
		public function get alpha():Number
		{
			return mAlpha;
		}
		
		/**
		 * Прозрачность от 0 до 1.
		 */
		public function set alpha(value:Number):void
		{
			mAlpha = value;
		}
		
		/**
		 * Видимость объекта.
		 */
		public function set visible(value:Boolean):void
		{
			if (mVisible != value)
			{
				mVisible = value;
				SkySand.render.calculateVisible = true;
			}
		}
		
		/**
		 * Видимость объекта.
		 */
		public function get visible():Boolean
		{
			return mVisible;
		}
		
		/**
		 * Учитывать объект при поиске самого ближайщего к курсору. 
		 */
		public function set mouseEnabled(value:Boolean):void
		{
			mMouseEnabled = value;
			
			if (value) SkyMouse.instance.addObjectToClosestTest(this);
			else SkyMouse.instance.removeObjectFromClosestTest(this);
		}
		
		/**
		 * Учитывать объект при поиске самого ближайщего к курсору. 
		 */
		public function get mouseEnabled():Boolean
		{
			return mMouseEnabled;
		}
	}
}