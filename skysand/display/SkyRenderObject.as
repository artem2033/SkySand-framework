package skysand.display
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import skysand.input.SkyMouse;
	
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
		 * Имя объекта.
		 */
		public var name:String;
		
		/**
		 * Цвет.
		 */
		public var color:uint;
		
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
		private static var isDrag:Boolean = false;
		
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
			alpha = 1;
			depth = 0;
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
					offsetDragPoint.x = SkySand.STAGE.mouseX - x;
					offsetDragPoint.y = SkySand.STAGE.mouseY - y;
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
				isDrag = false;
			}
		}
		
		/**
		 * Проверка на столкновение курсора с границами объекта..
		 * @return возвращает true - столкновение, false - отсутствие столкновения.
		 */
		public function hitTestBoundsWithMouse():Boolean
		{
			var x:Number = SkySand.STAGE.mouseX;
			var y:Number = SkySand.STAGE.mouseY;
			
			if (x > globalX + (width - pivotX) * globalScaleX) return false;
			if (x < globalX - pivotX * globalScaleX) return false;
			if (y > globalY + (height - pivotY) * globalScaleY) return false;
			if (y < globalY - pivotY * globalScaleY) return false;
			
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
		}
		
		/**
		 * Обновить данные объекта.
		 */
		public function updateData(deltaTime:Number):void
		{
			if (globalVisible == 1)
			{
				globalX = parent.globalX + x;
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
				}
				
				if (drag)
				{
					x = isLockAxisX ? x : SkySand.STAGE.mouseX - offsetDragPoint.x;
					y = isLockAxisY ? y : SkySand.STAGE.mouseY - offsetDragPoint.y;
					
					if (border)
					{
						//if(isLockAxisX)
							x = x >= rightBorder ? rightBorder : x <= leftBorder ? leftBorder : x;
						//if(isLockAxisY)
							y = y >= downBorder ? downBorder : y <= upBorder ? upBorder : y;
					}
				}
			}
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