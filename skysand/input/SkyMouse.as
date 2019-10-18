package skysand.input
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import skysand.debug.Console;
	import skysand.display.SkyCamera;
	import skysand.display.SkyShape;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.render.SkyHardwareRender;
	import skysand.ui.SkyList;
	import skysand.utils.SkyUtils;
	
	public class SkyMouse extends Object
	{
		public static const NONE:uint = 0;
		//виды кнопок мыши: левая, правая и средняя.
		public static const LEFT:uint = 1;
		public static const RIGHT:uint = 2;
		public static const MIDDLE:uint = 3;
		
		public static var isDrag:Boolean = false;
		
		/**
		 * Координата мыши по оси х в координатах монитора.
		 */
		public static var x:Number;
		
		/**
		 * Координата мыши по оси у в координатах монитора.
		 */
		public static var y:Number;
		
		/**
		 * Координата мыши по оси х с учётом смещения камеры.
		 */
		public static var tx:Number;
		
		/**
		 * Координата мыши по оси у с учётом смещения камеры.
		 */
		public static var ty:Number;
		
		
		/**
		 * Верхний объект(ближайший к камере) с которым касается курсор. 
		 */
		public var upperIndex:int = 0;
		
		/**
		 * Ссылка на класс.
		 */
		private static var _instance:SkyMouse;
		
		/**
		 * Ссылка на сцену.
		 */
		private var mStage:Stage;
		
		/**
		 * Состояние нажатия левой кнопки мыши.
		 */
		private var isLeftDown:Boolean = false;
		
		/**
		 * Состояние нажатия правой кнопки мыши.
		 */
		private var isRightDown:Boolean = false;
		
		/**
		 * Состояние нажатия средней кнопки мыши.
		 */
		private var isMiddleDown:Boolean = false;
		
		/**
		 * Состояние клика левой кнопки мыши.
		 */
		private var isLeftClick:Boolean = false;
		
		/**
		 * Состояние клика правой кнопки мыши.
		 */
		private var isRightClick:Boolean = false;
		
		/**
		 * Состояние клика средней кнопки мыши.
		 */
		private var isMiddleClick:Boolean = false;
		
		/**
		 * Массив функций на собитие клика левой кнопки мыши.
		 */
		private var leftClickFunctions:Vector.<Function>;
		
		/**
		 * Массив функций на собитие клика правой кнопки мыши.
		 */
		private var rightClickFunctions:Vector.<Function>;
		
		/**
		 * Массив функций на собитие клика средней кнопки мыши.
		 */
		private var middleClickFunctions:Vector.<Function>;
		
		/**
		 * Число функций на левую кнопку мыши.
		 */
		private var leftClickFunctionCount:int = 0;
		
		public var isMouseMove:Boolean = false;
		
		/**
		 * Ближайший объект столкнувшийся с мышкой.
		 */
		public static var currentClosestObject:SkyRenderObject;
		
		/**
		 * Проверять столкновение точно или только по границам объекта.
		 */
		private var isExactHitTest:Boolean;
		
		/**
		 * Расчитывать ближайший объект при клике или нет.
		 */
		private var isCalculateClosestObject:Boolean;
		
		/**
		 * Массив объектов для проверки ближайшего к курсору.
		 */
		private var objects:Vector.<SkyRenderObject>;
		
		/**
		 * Отсортирован ли массив по глубине.
		 */
		private var isSorted:Boolean;
		
		/**
		 * Ссылка на камеру.
		 */
		private var camera:SkyCamera;
		
		public function SkyMouse():void
		{
			if (_instance != null)
			{
				throw("Ошибка! Используйте SkyMouse.instance");
			}
			
			_instance = this;
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():SkyMouse
		{
			return (_instance == null) ? new SkyMouse() : _instance;
		}
		
		/**
		 * Инициализация класса.
		 * @param	mStage ссылка на сцену.
		 */
		public function initialize(mStage:Stage):void
		{
			this.mStage = mStage;
			
			mStage.addEventListener(MouseEvent.MOUSE_DOWN, onLeftMouseDownHandler);
			mStage.addEventListener(MouseEvent.MOUSE_UP, onLeftMouseUpHandler);
			mStage.addEventListener(MouseEvent.CLICK, onLeftMouseClickHandler);
			
			mStage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDownHandler);
			mStage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUpHandler);
			mStage.addEventListener(MouseEvent.RIGHT_CLICK, onRightMouseClickHandler);
			
			mStage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleMouseDownHandler);
			mStage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMiddleMouseUpHandler);
			mStage.addEventListener(MouseEvent.MIDDLE_CLICK, onMiddleMouseClickHandler);
			mStage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelListener);
			
			//mStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveListener);
			
			
			leftClickFunctions = new Vector.<Function>();
			rightClickFunctions = new Vector.<Function>();
			middleClickFunctions = new Vector.<Function>();
			objects = new Vector.<SkyRenderObject>();
			
			currentClosestObject = null;
			isExactHitTest = false;
			isCalculateClosestObject = false;
			isSorted = false;
			
			x = mStage.mouseX;
			y = mStage.mouseY;
		}
		
		/**
		 * Нажата ли определённая кнопка мыши.
		 * @param	type вид кнопки.
		 * @return возвращает состояние кнопки.
		 */
		public function isDown(type:uint):Boolean
		{
			return type == LEFT ? isLeftDown : type == RIGHT ? isRightDown : isMiddleDown;
		}
		
		/**
		 * Сделан ли шелчёк кнопкой мыши.
		 * @param	type вид кнопки.
		 * @return возвращает состояния клика.
		 */
		public function isClick(type:uint):Boolean
		{
			if (type == LEFT) return isLeftClick;
			if (type == RIGHT) return isRightClick;
			if (type == MIDDLE) return isMiddleClick;
			
			return false;
		}
		
		public function reset():void
		{
			isRightClick = false;
			isMiddleClick = false;
			isLeftClick = false;
			scroll = 0;
		}
		
		public function setCamera(value:SkyCamera):void
		{
			camera = value;
		}
		
		public function update():void
		{
			x = mStage.mouseX;
			y = mStage.mouseY;
			tx = camera == null ? mStage.mouseX : mStage.mouseX + camera.x - camera.screenOffset.x;
			ty = camera == null ? mStage.mouseY : mStage.mouseY - camera.y - camera.screenOffset.y;
		}
		
		public var scroll:int = 0;
		
		private function onMouseWheelListener(mouseEvent:MouseEvent):void
		{
			scroll = mouseEvent.delta;//trace(mouseEvent.delta);
		}
		
		/**
		 * Добавить объект для проверки ближайшего к курсору.
		 * @param	object ссылка на объект.
		 */
		public function addObjectToClosestTest(object:SkyRenderObject):void
		{
			if (objects.indexOf(object) < 0 && object.mouseEnabled) objects.push(object);
			isSorted = false;
		}
		
		/**
		 * Функция компоратор для сортировки.
		 * @param	a первый объект для сравнения.
		 * @param	b второй объект для сравнения.
		 * @return число от 1 до -1;
		 */
		private function compare(a:SkyRenderObject, b:SkyRenderObject):int
		{
			return a.depth < b.depth ? 1 : -1;
		}
		
		/**
		 * Удалить объект из проверки ближайшего к курсору.
		 * @param	object ссылка на объект.
		 */
		public function removeObjectFromClosestTest(object:SkyRenderObject):void
		{
			var index:int = objects.indexOf(object);
			if (index >= 0) objects.removeAt(index);
		}
		
		/**
		 * Добавить функцию на событие клика мыши.
		 * @param	mFunction функция типа void.
		 * @param	button кнопка мыши.
		 */
		public function addFunctionOnClick(mFunction:Function, button:uint):void
		{
			if (button == LEFT) 
			{
				leftClickFunctions.push(mFunction);
				leftClickFunctionCount++;
			}
			else if (button == RIGHT)
			{
				rightClickFunctions.push(mFunction)
			}
			else 
			{
				middleClickFunctions.push(mFunction);
			}
		}
		
		/**
		 * Удалить функцию с события клика мыши.
		 * @param	mFunction функция типа void.
		 * @param	button кнопка мыши.
		 */
		public function removeFunctionOnClick(mFunction:Function, button:uint):void
		{
			if (button == LEFT) 
			{
				leftClickFunctions.removeAt(leftClickFunctions.indexOf(mFunction));
				leftClickFunctionCount--;
			}
			else if (button == RIGHT)
			{
				rightClickFunctions.removeAt(rightClickFunctions.indexOf(mFunction));
			}
			else 
			{
				middleClickFunctions.removeAt(middleClickFunctions.indexOf(mFunction));
			}
		}
		
		public function get numChildren():int
		{
			return objects.length;
		}
		
		/**
		 * TODO:: add changing graphics of cursor.
		 * @param	key
		 * @param	clip
		 * @param	point
		 */
		/*public function addCursor(key:String, clip:Class, point:Point):void
		{
			Anim = new FeatherAnimation();
			Anim.createAnimation(clip, 1, 1);
			var mouseCursorData:MouseCursorData = new MouseCursorData();
			//Anim.frames[0].applyFilter(Anim.frames[0], Anim.frames[0].rect, new Point(0, 0), new BlurFilter(4, 4, 1)); 
			mouseCursorData.data = Anim.frames;
			mouseCursorData.hotSpot = point;
			mouseCursorData.frameRate = 1;
			
			Mouse.registerCursor(key, mouseCursorData);
		}*/
		
		private function onMouseMoveListener(mouseEvent:MouseEvent):void
		{
			isMouseMove = true;
		}
		
		public function sortMouseChilds():void
		{
			objects.sort(compare);
		}
		
		/**
		 * Включить или выключить расчёт ближайшего объекта к курсору при клике.
		 * @param	isCalculate true - включить / false - выключить.
		 * @param	isExactHitTest проверять столкновение точно или только по границам объекта.
		 */
		public function calculateClosestObjectOnClick(isCalculate:Boolean, exactHitTest:Boolean = false):void
		{
			/*if (isCalculate)
			{
				for (var i:int = length - 1; i >= 0; i--) 
				{
					var object:SkyRenderObjectContainer = objects[i];
					
					if (object.globalVisible == 0 || !object.mouseEnabled) continue;
					
					if (object.hitTestBoundsWithMouse())
					{
						if (isExactHitTest)
						{
							if (object.hitTestMouse())
							{
								currentClosestObject = object;
								break;
							}
						}
						
						currentClosestObject = object;
						break;
					}
				}
			}*/
			
			isExactHitTest = exactHitTest;
			isCalculateClosestObject = isCalculate;
		}
		
		/**
		 * Событие нажатия левой кнопки мыши.
		 * @param	mouseEvent собитие мыши.
		 */
		private function onLeftMouseDownHandler(mouseEvent:MouseEvent):void
		{
			if (!isSorted)
			{
				Console.log("Mouse objects sorted: " + objects.length);
				objects.sort(compare);
				isSorted = true;
			}
			
			if (isCalculateClosestObject && currentClosestObject == null)
			{
				var length:int = objects.length - 1;
				
				for (var i:int = length; i >= 0; i--) 
				{
					var object:SkyRenderObject = objects[i];
					
					if (!object.isVisible) continue;
					
					if (object.hitTestBoundsWithMouse())
					{
						if (isExactHitTest)
						{
							if (object.hitTestMouse())
							{
								currentClosestObject = object;
								break;
							}
						}
						
						currentClosestObject = object;
						break;
					}
				}
			}
			
			isLeftDown = true;
		}
		
		/**
		 * Событие отжатия левой кнопки мыши.
		 * @param	mouseEvent собитие мыши.
		 */
		private function onLeftMouseUpHandler(mouseEvent:MouseEvent):void
		{
			isLeftDown = false;
			isDrag = false;
		}
		
		/**
		 * Событие клика левой кнопки мыши.
		 * @param	mouseEvent собитие мыши.
		 */
		private function onLeftMouseClickHandler(mouseEvent:MouseEvent):void
		{
			for (var i:int = 0; i < leftClickFunctionCount; i++) 
			{
				if(leftClickFunctions[i] != null) leftClickFunctions[i].apply();
			}
			
			isLeftClick = true;
			currentClosestObject = null;
		}
		
		/**
		 * Событие нажатия правой кнопки мыши.
		 * @param	mouseEvent собитие мыши.
		 */
		private function onRightMouseDownHandler(mouseEvent:MouseEvent):void
		{
			if (!isSorted)
			{
				Console.log("Mouse objects sorted: " + objects.length);
				objects.sort(compare);
				isSorted = true;
			}
			
			if (isCalculateClosestObject)
			{
				var length:int = objects.length - 1;
				
				for (var i:int = length; i >= 0; i--) 
				{
					var object:SkyRenderObject = objects[i];
					
					if (!object.isVisible) continue;
					
					if (object.hitTestBoundsWithMouse())
					{
						if (isExactHitTest)
						{
							if (object.hitTestMouse())
							{
								currentClosestObject = object;
								break;
							}
						}
						
						currentClosestObject = object;
						break;
					}
				}
			}
			
			isRightDown = true;
		}
		
		/**
		 * Событие отжатия правой кнопки мыши.
		 * @param	mouseEvent собитие мыши.
		 */
		private function onRightMouseUpHandler(mouseEvent:MouseEvent):void
		{
			isRightDown = false;
		}
		
		/**
		 * Событие клика правой кнопки мыши.
		 * @param	mouseEvent собитие мыши.
		 */
		private function onRightMouseClickHandler(mouseEvent:MouseEvent):void
		{
			var length:int = rightClickFunctions.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				rightClickFunctions[i].apply();
			}
			
			isRightClick = true;
			currentClosestObject = null;
		}
		
		/** 
		 * Событие нажатия средней кнопки мыши.
		 * @param	mouseEvent собитие мыши.
		 */
		private function onMiddleMouseDownHandler(mouseEvent:MouseEvent):void
		{
			isMiddleDown = true;
		}
		
		/**
		 * Событие отжатия средней кнопки мыши.
		 * @param	mouseEvent собитие мыши.
		 */
		private function onMiddleMouseUpHandler(mouseEvent:MouseEvent):void
		{
			isMiddleDown = false;
		}
		
		/**
		 * Событие клика средней кнопки мыши.
		 * @param	mouseEvent собитие мыши.
		 */
		private function onMiddleMouseClickHandler(mouseEvent:MouseEvent):void
		{
			var length:int = middleClickFunctions.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				middleClickFunctions[i].apply();
			}
			
			isMiddleClick = true;
		}
	}
}