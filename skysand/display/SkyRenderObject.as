package skysand.display
{
	import filecontrol.OpenManager;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.core.MovieClipLoaderAsset;
	import skysand.input.SkyKey;
	import skysand.input.SkyKeyboard;
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
		 * Координата x.
		 */
		public var mX:Number;
		
		/**
		 * Координата y.
		 */
		public var mY:Number;
		
		/**
		 * Ширина.
		 */
		private var mWidth:Number;
		
		/**
		 * Высота.
		 */
		private var mHeight:Number;
		
		/**
		 * Угол поврота.
		 */
		private var mRotation:Number;
		
		/**
		 * Прозрачность от 0 до 1.
		 */
		public var mAlpha:Number;
		
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
		public var mDepth:int;
		
		/**
		 * Имя объекта.
		 */
		public var name:String;
		
		/**
		 * Цвет.
		 */
		internal var mColor:uint;
		
		/**
		 * Глобальная видимость объекта.
		 */
		public var globalVisible:uint;
		
		/**
		 * Игнорировать мышь при проверке столкновения.
		 */
		//public var mouseEnabled:Boolean;
		
		/**
		 * Для расчёта поворота объекта.
		 */
		public var globalR:Point;
		
		/**
		 * Для расчёта поворота объекта.
		 */
		public var localR:Point;
		
		/**
		 * Добален ли объект на сцену.
		 */
		public var isAdded:Boolean;
		/**
		 * Кнопка мыши к которой привязан данный объект.
		 */
		//private var mouseButton:uint;
		
		/**
		 * Видимость объекта.
		 */
		private var mVisible:Boolean;
		
		/**
		 * Может ли мышь взаимодействовать с объектом.
		 */
		private var mMouseEnabled:Boolean;
		
		/**
		 * Перетаскивается ли сейчас объект.
		 */
		internal static var isDrag:Boolean = false;
		
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
		 * Для оптимизации перерасчёта глобального угла поворота.
		 */
		private var oldRotation:Number;
		
		public function SkyRenderObject()
		{
			offsetDragPoint = new Point();
			globalR = new Point();
			localR = new Point();
			parent = null;
			
			drag = false;
			border = false;
			isAdded = false;
			mVisible = true;
			mMouseEnabled = false;
			//mouseButton = SkyMouse.NONE;
			
			name = "";
			
			x = 0;
			y = 0;
			color = 0xFFFFFF;
			mAlpha = 1;
			mDepth = 0;
			width = 0;
			height = 0;
			scaleX = 1;
			scaleY = 1;
			pivotX = 0;
			pivotY = 0;
			globalX = 0;
			globalY = 0;
			indexID = 0;
			rotation = 0;
			upBorder = 0;
			downBorder = 0;
			leftBorder = 0;
			oldRotation = 0;
			rightBorder = 0;
			globalScaleX = 1;
			globalScaleY = 1;
			globalVisible = 1;
			globalRotation = 0;
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
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			offsetDragPoint = null;
			globalR = null;
			localR = null;
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
		public function getBounds(child:SkyRenderObject):Rectangle
		{
			return new Rectangle(globalX, globalY, width, height);
		}
		
		/**
		 * Проверка на столкновение с другим объектом
		 */
		public function hitTestObject(object:SkyRenderObject):Boolean
		{
			if (object.globalX > globalX + width) return false;
			if (object.globalX + object.width < globalX) return false;
			if (object.globalY > globalY + height) return false;
			if (object.globalY + object.height < globalY) return false;
			
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
			if (drag)
			{
				drag = false;
			}
		}
		
		/**
		 * Проверка на столкновение курсора с границами объекта..
		 * @return возвращает true - столкновение, false - отсутствие столкновения.
		 */
		public function hitTestBoundsWithMouse():Boolean
		{
			if (SkyMouse.x > globalX + (width - pivotX) * globalScaleX) return false;
			if (SkyMouse.x < globalX - pivotX * globalScaleX) return false;
			if (SkyMouse.y > globalY + (height - pivotY) * globalScaleY) return false;
			if (SkyMouse.y < globalY - pivotY * globalScaleY) return false;
			
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
			if (x > globalX + width - pivotX) return false;
			if (x < globalX - pivotX) return false;
			if (y > globalY + height - pivotY) return false;
			if (y < globalY - pivotY) return false;
			
			return true;
		}
		
		/**
		 * Посчитать глобальную видимость.
		 */
		public function calculateGlobalVisible():void
		{
			var isVisible:Boolean = mVisible && parent.mVisible && isAdded && parent.isAdded;
			globalVisible = isVisible ? 1 * parent.globalVisible : 0 * parent.globalVisible;
			isTransformed = true;
		}
		
		public var isTransformed:Boolean = false;
		public var globalTransformation:Boolean = false;
		public var lm:SkyMatrix = new SkyMatrix();
		public var wm:SkyMatrix = new SkyMatrix();
		private var oldx:Number = 0;
		private var oldy:Number = 0;
		
		public function setPos(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
			lm.translate(x, y);
			isTransformed = true;
		}
		
		public function get x():Number
		{
			return mX;
		}
		
		public function set x(value:Number):void
		{
			if (mX != value)
			{
				mX = value;
				isTransformed = true;
			}
		}
		
		public function get y():Number
		{
			return mY;
		}
		
		public function set y(value:Number):void
		{
			if (mY != value)
			{
				mY = value;
				isTransformed = true;
			}
		}
		
		public function get width():Number
		{
			return mWidth;
		}
		
		public function set width(value:Number):void
		{
			if (mWidth != value)
			{
				mWidth = value;
				isTransformed = true;
			}
		}
		
		public function get height():Number
		{
			return mHeight;
		}
		
		public function set height(value:Number):void
		{
			if (mHeight != value)
			{
				mHeight = value;
				isTransformed = true;
			}
		}
		
		public function get rotation():Number
		{
			return mRotation;
		}
		
		public function set rotation(value:Number):void
		{
			if (mRotation != value)
			{
				mRotation = value;
				isTransformed = true;
			}
		}
		public var gt:int = 1;
		public var lt:int = 1;
		
		public function get color():uint
		{
			return mColor;
		}
		
		public function set color(value:uint):void
		{
			mColor = value;
		}
		
		public function get depth():int
		{
			return mDepth;
		}
		
		public function set depth(value:int):void
		{
			mDepth = value;
		}
		
		public function get alpha():Number
		{
			return mAlpha;
		}
		
		public function set alpha(value:Number):void
		{
			mAlpha = value;
		}
		
		public function updateTransformation():void
		{
			if (oldRotation != mRotation)
				{
					lm.rotate(mRotation * Math.PI / 180, scaleX, scaleY);
					
					oldRotation = mRotation;
				}
				
				if (oldx != mX || oldy != mY)
				{
					lm.translate(mX, mY);
					
					oldy = mY;
					oldx = mX;
				}
			//lm.Transformation(scaleX, scaleY, x, y, rotation * Math.PI / 180);
			wm.multiply(lm, parent.wm);
			
			globalX = wm.tx;
			globalY = wm.ty;
		}
		
		/**
		 * Обновить данные объекта.
		 */
		public function updateData(deltaTime:Number):void
		{
			if (drag)
			{
				x = isLockAxisX ? x : SkyMouse.x - offsetDragPoint.x;
				y = isLockAxisY ? y : SkyMouse.y - offsetDragPoint.y;
				
				if (border)
				{
					//if(isLockAxisX)
						x = x >= rightBorder ? rightBorder : x <= leftBorder ? leftBorder : x;
					//if(isLockAxisY)
						y = y >= downBorder ? downBorder : y <= upBorder ? upBorder : y;
						
				}
			}
			/*	
				if (oldRotation != rotation)
				{
					lm.rotate(rotation * Math.PI / 180, scaleX, scaleY);
					isTransformed = true;
					oldRotation = rotation;
				}
				
				if (oldx != x || oldy != y)
				{
					lm.translate(x, y);
					isTransformed = true;
					oldy = y;
					oldx = x;
				}
				
				//globalTransformation = isTransformed || parent.globalTransformation;
				//;
				//gt = lt * parent.gt;
				//globalTransformation = isTransformed && parent.globalTransformation;
				//isTransformed = isTransformed && parent.isTransformed;
				//
				//if (!isTransformed)
				//{
					//lm.translate(x, y);
					
				//}
				/*globalX = parent.globalX + x;
				globalY = parent.globalY + y;
				globalScaleX = parent.globalScaleX * scaleX;
				globalScaleY = parent.globalScaleY * scaleY;
				globalRotation = parent.globalRotation + rotation;
				
				if (oldRotation != globalRotation)
				{
					var angle:Number = SkyMath.toRadian(parent.globalRotation);
					
					localR = SkyMath.rotatePoint(x, y, 0, 0, angle);
					globalR.x = localR.x + parent.globalR.x - x;
					globalR.y = localR.y + parent.globalR.y - y;
					
					oldRotation = globalRotation;
				}*/
				
				
			
		}
		
		public function updDrag():void
		{
			
		}
		
		/**
		 * Перетаскивается ли в данный момент объект.
		 */
		public function get isDrag():Boolean
		{
			return drag;
		}
	}
}