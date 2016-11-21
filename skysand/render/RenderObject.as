package skysand.render
{
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import skysand.mouse.SkyMouse;
	import skysand.console.Console;
	
	use namespace framework;
	
	public class RenderObject extends Object
	{
		/**
		 * Родитель.
		 */
		public var parent:RenderObject;
		
		/**
		 * Локальная координата X.
		 */
		public var x:Number;
		
		/**
		 * Локальная коорлината Y.
		 */
		public var y:Number;
		
		/**
		 * Масштаб объекта по горизонтали.
		 */
		public var scaleX:Number;
		
		/**
		 * Масштаб объекта по вертикали.
		 */
		public var scaleY:Number;
		
		/**
		 * Локальный угол поворота объекта.
		 */
		public var angle:Number;
		
		/**
		 * Отрисовывать объект или нет.
		 */
		public var visible:Boolean;
		
		/**
		 * Графическое содержимое объекта.
		 */
		public var bitmapData:BitmapData;
		
		/**
		 * Пока в разработке...
		 */
		public var _graphics:SkyGraphics;
		
		/**
		 * Прозрачность объекта.
		 */
		private var _alpha:Number;
		
		/**
		 * Ширина.
		 */
		private var _width:Number;
		
		/**
		 * Высота.
		 */
		private var _height:Number;
		
		/**
		 * Флаг определяющий возможность перетаскивать объект.
		 */
		private var drag:Boolean;
		
		/**
		 * Точка для определения смещения от начала координат объекта.
		 */
		private var offsetDragPoint:Point;
		
		/**
		 * Первая точка для проверки на пересечение.
		 */
		private var firstHitPoint:Point;
		
		/**
		 * Вторая точка для проверки на пересечение.
		 */
		private var secondHitPoint:Point;
		
		/**
		 * Ссылка на спрайт, для использования некоторых методов.
		 */
		private var sprite:Sprite;
		
		/**
		 * Число дочерних объектов.
		 */
		private var _numChildren:int;
		
		/**
		 * Объект для отрисовки графики из graphics.
		 */
		private var graphicsObject:RenderObject;
		
		/**
		 * Глобальный угол поворота объекта.
		 */
		framework var globalAngle:Number;
		
		/**
		 * Осевая координата объекта по X.
		 */
		framework var originX:Number;
		
		/**
		 * Осевая координата объекта по Y.
		 */
		framework var originY:Number;
		
		/**
		 * Глобальная позиция по X.
		 */
		framework var globalX:Number;
		
		/**
		 * Глобальная позиция по Y.
		 */
		framework var globalY:Number;
		
		/**
		 * Массив дочерних объектов.
		 */
		framework var children:Vector.<RenderObject>;
		
		/**
		 * Порядок в очереди отрисовки.
		 */
		framework var renderID:uint = 0;
		
		/**
		 * Перетаскивается ли сейчас объект.
		 */
		private static var isDrag:Boolean = false;
		
		public function RenderObject()
		{
			super();
			init();
		}
		
		/**
		 * Добавить объект в конец списка отображения.
		 * @param	child объект для отрисовки(у объекта не обязательно должна bitmapData != null).
		 */
		public function addChild(child:RenderObject):void
		{
			if (!children) children = new Vector.<RenderObject>();
			
			if (children.indexOf(child) > -1) return;
			
			if (child.parent) child.parent.removeChild(child);
			
			calculateGlobalData(child);
			child.parent = this;
			
			children[_numChildren] = child;
			_numChildren++;
			SkySand.NUM_OF_RENDER_OBJECTS++;
		}
		
		/**
		 * Добавить объект в список отображения на определённую позицию.
		 * @param	child объект для отрисовки.
		 * @param	index позиция от 0 до numChildren.
		 */
		public function addChildAt(child:RenderObject, index:int):void
		{
			index = index < 0 ? 0 : index >= _numChildren ? _numChildren : index;
			
			if (!children) children = new Vector.<RenderObject>();
			
			if (children.indexOf(child) > -1) return;
			
			if (child.parent) child.parent.removeChild(child);
			
			calculateGlobalData(child);
			child.parent = this;
			children.splice(index, 0, child);
			_numChildren++;
			SkySand.NUM_OF_RENDER_OBJECTS++;
		}
		
		/**
		 * Получить номер дочернего объекта.
		 * @param	child дочерний объект.
		 * @return возвращает номер объекта.
		 */
		public function getChildIndex(child:RenderObject):int
		{
			if (children == null) return -1;
			
			return children.indexOf(child);
		}
		
		/**
		 * Получить массив всех объектов под определённой точкой.
		 * @param	point точка.
		 * @return возвращает массив дочерних объектов.
		 */
		public function getChildsUnderPoint(x:Number, y:Number):Vector.<RenderObject>
		{
			var childs:Vector.<RenderObject> = new Vector.<RenderObject>();
			
			getChilds(SkySand.root, childs, x, y);
			return childs;
		}
		
		/**
		 * Заполнить массив дочерними объектами под определённой точкой.
		 * @param	child объект с которого начинать поиск.
		 * @param	childs массив куда добавлять объекты попавшие под точку.
		 * @param	x координта точки X.
		 * @param	y координта точки Y.
		 */
		private function getChilds(child:RenderObject, childs:Vector.<RenderObject>, x:Number, y:Number):void
		{
			var length:int = child._numChildren;
			
			for (var i:int = 0; i < length; i++) 
			{
				var current:RenderObject = child.children[i];
				
				if (current.hitTestPoint(x, y))
				{
					childs.push(current);
				}
				
				if (child.children) getChilds(current, childs, x, y);
			}
		}
		
		/**
		 * Получить дочерний объект с определённым номером.
		 * @param	index номер объекта.
		 * @return возвращает объект, если он есть в массиве.
		 */
		public function getChildAt(index:int):RenderObject
		{
			if (children == null) return null;
			
			if (index < 0 || index >= _numChildren)
			{
				throw new Error("Ошибка, элемента с номером " + index + " нет в массиве!");
			}
			
			return children[index];
		}
		
		/**
		 * Получить ограничивающий прямоугольник.
		 * Нужно переделать.
		 * @param	child дочерний объект
		 * @return возвращает прямогульник(Rectangle).
		 */
		public function getBounds(child:RenderObject):Rectangle
		{
			return new Rectangle(globalX, globalY, width, height);
		}
		
		/**
		 * Содержит ли данный дочерний объект, другой дочерний объект.
		 * @param	child объект который нужно проверить.
		 * @return возращает true, если объект содержиться, false, если нет.
		 */
		public function contains(child:RenderObject):Boolean
		{
			if (children != null) return false;
			if (children.indexOf(child) < 0) return false;
			
			return true;
		}
		
		/**
		 * Удалить объект из списка отображения.
		 * @param	object удаляемый объект.
		 */
		public function removeChild(child:RenderObject):void
		{
			if (children == null) return;
			
			var index:int = children.indexOf(child);
			
			if (index == -1) return;
			
			children[index].parent = null;
			children[index] = null;
			children.splice(index, 1);
			_numChildren--;
		}
		
		/**
		 * Удалить дочерний объект через его номер.
		 * @param	index номер объекта в списке от 0 до numChildren.
		 */
		public function removeChildAt(index:int):void
		{
			if (children == null) return;
			
			if (index < 0 || index > _numChildren)
			{
				throw new Error("Ошибка, элемента с номером " + index + " нет в массиве!");
			}
			
			children[index].parent = null;
			children[index] = null;
			children.splice(index, 1);
			_numChildren--;
		}
		
		/**
		 * Удалить дочерние объекты в интервале от beginIndex до endIndex.
		 * @param	beginIndex начальный номер с которого начинать удалять дочерние объекты.
		 * @param	endIndex конечный номер до которого удалять дочерние объекты, не включая последний.
		 */
		public function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			if (children == null) return;
			
			beginIndex = beginIndex < 0 ? 0 : beginIndex > _numChildren ? _numChildren : beginIndex;
			endIndex = endIndex < beginIndex ? beginIndex : endIndex > _numChildren ? _numChildren : endIndex;
			
			for (var i:int = beginIndex; i < endIndex; i++) 
			{
				removeChildAt(i);
				i--;
				endIndex--;
			}
		}
		
		/**
		 * Поменять местами дочерние объекты в массиве.
		 * @param	child0 первый объект.
		 * @param	child1 второй объект.
		 */
		public function swapChildren(child0:RenderObject, child1:RenderObject):void
		{
			if (children == null) return;
			
			var index0:int = children.indexOf(child0);
			var index1:int = children.indexOf(child1);
			
			if (index0 < 0 || index1 < 0) return;
			
			var temp:RenderObject = children[index0];
			children[index0] = children[index1];
			children[index1] = temp;
		}
		
		/**
		 * Поменять местами дочерние объекты в массиве через их номера.
		 * @param	index0 номер первого объекта.
		 * @param	index1 номер второго объекта.
		 */
		public function swapChildrenAt(index0:int, index1:int):void
		{
			if (children == null) return;
			
			if ((index0 || index1) < 0 || (index0 || index1) > _numChildren) return;
			
			var temp:RenderObject = children[index0];
			children[index0] = children[index1];
			children[index1] = temp;
		}
		
		/**
		 * Начать перетаскивание объекта за курсором мыши.
		 * @param	lockCentr перетаскивание без учёта смещения объекта от курсора.
		 */
		public function startDrag(lockCentr:Boolean = false):void
		{
			if (!drag && !isDrag && isNearest)
			{
				if (!lockCentr)
				{
					offsetDragPoint.x = mouseX - x;
					offsetDragPoint.y = mouseY - y;
				}
				else
				{
					offsetDragPoint.x = 0;
					offsetDragPoint.y = 0;
				}
				
				drag = true;
				isDrag = true;
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
		 * Проверка пересечения объекта с точкой.
		 * @param	_x координата X.
		 * @param	_y координата Y.
		 * @return возвращает true, если произошло пересечение с точкой, false, если нет.
		 */
		public function hitTestPoint(x:Number, y:Number):Boolean
		{
			if (bitmapData == null) return false;
			
			firstHitPoint.setTo(globalX + originX, globalY + originY);
			secondHitPoint.setTo(x, y);
			
			return bitmapData.hitTest(firstHitPoint, 0, secondHitPoint);
		}
		
		/**
		 * Проверка пересечения объекта с курсором мыши.
		 * @return возвращает true, если произошло пересечение с курсором мыши, false, если нет.
		 */
		public function hitTestMouse():Boolean
		{
			if (bitmapData == null) return false;
			
			secondHitPoint.setTo(sprite.mouseX, sprite.mouseY);
			firstHitPoint.setTo(globalX + originX, globalY + originY);
			
			return bitmapData.hitTest(firstHitPoint, 0, secondHitPoint);
		}
		
		/**
		 * Проверка пересечения объекта с другим объектом.
		 * @param	child объект, с которым нужно проверить пересечение.
		 * @return возвращает true, если произошло пересечение с объектом, false, если нет.
		 */
		public function hitTestObject(child:RenderObject):Boolean
		{
			if (bitmapData == null || child.bitmapData == null) return false;
			
			firstHitPoint.setTo(globalX, globalY);
			secondHitPoint.setTo(child.globalX, child.globalY)
			
			return bitmapData.hitTest(firstHitPoint, 0, child.bitmapData, secondHitPoint);
		}
		
		/**
		 * Рассчитать глобальные координаты дочернего объекта на экране.
		 * @param	child объект.
		 */
		public function calculateGlobalData(child:RenderObject):void
		{
			child.globalX = child.x + globalX;
			child.globalY = child.y + globalY;
			child.globalAngle = child.angle + globalAngle;
		}
		
		//TODO: Events and Listenders and Dispatchers.
		public function addEventListener(type:uint, _function:Function):void
		{
			
		}
		
		public function watch(rest:String):void
		{
			rest;
		}
		
		/**
		 * Инициализация класса.
		 */
		private function init():void
		{
			offsetDragPoint = new Point();
			firstHitPoint = new Point();
			secondHitPoint = new Point();
			sprite = new Sprite();
			
			_numChildren = 0;
			globalAngle = 0;
			globalX = 0;
			globalY = 0;
			originX = 0;
			originY = 0;
			_height = 0;
			_width = 0;
			_alpha = 1;
			scaleX = 1;
			scaleY = 1;
			angle = 0;
			x = 0;
			y = 0;
			visible = true;
			drag = false;
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			parent = null;
			sprite = null;
			_graphics = null;
			firstHitPoint = null;
			secondHitPoint = null;
			offsetDragPoint = null;
			
			for (var i:int = 0; i < _numChildren; i++) 
			{
				children[i].parent = null;
				children[i] = null;
			}
			
			//children.length = 0;
			_numChildren = 0;
		}
		
		/**
		 * Обновить отрисовываемы объект (используется движком).
		 */
		public function updateByFramework():void
		{
			if (drag)
			{
				x = mouseX - offsetDragPoint.x;
				y = mouseY - offsetDragPoint.y;
			}
		}
		
		/**
		 * Прозрачность объекта.
		 */
		public function set alpha(value:Number):void
		{
			if (_alpha != value)
			{
				_alpha = value > 1 ? 1 : value < 0 ? 0 : value;
				var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, -255 + _alpha * 255);
				bitmapData.colorTransform(bitmapData.rect, colorTransform);
			}
		}
		
		/**
		 * Прозрачность объекта.
		 */
		public function get alpha():Number
		{
			return _alpha;
		}
		
		/**
		 * Ссылка на основную сцену.
		 */
		public function get stage():Stage
		{
			return SkySand.STAGE;
		}
		
		/**
		 * Координаты указателя мыши по оси X.
		 */
		public function get mouseX():Number
		{
			return SkySand.STAGE.mouseX;
		}
		
		/**
		 * Координаты указателя мыши по оси Y.
		 */
		public function get mouseY():Number
		{
			return SkySand.STAGE.mouseY;
		}
		
		/**
		 * Высота объекта.
		 */
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		/**
		 * Высота объекта.
		 */
		public function get height():Number
		{
			return _height;
		}
		
		/**
		 * Ширина объекта.
		 */
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		/**
		 * Ширина объекта.
		 */
		public function get width():Number
		{
			return _width;
		}
		
		public function get graphics():SkyGraphics
		{
			if (!graphicsObject)
			{
				graphicsObject = new RenderObject();
				graphicsObject.bitmapData = new BitmapData(800, 600, true, 0x000000);
				addChild(graphicsObject);
				
				_graphics = new SkyGraphics(graphicsObject);
			}
			
			return _graphics;
		}
		
		/**
		 * Получить количество дочерних объектов.
		 */
		public function get numChildren():int
		{
			return _numChildren;
		}
		
		/**
		 * Флаг для проверки ближайшего к курсору дочернего объекта по глубине.
		 */
		public function get isNearest():Boolean
		{
			var array:Vector.<RenderObject> = getChildsUnderPoint(sprite.mouseX, sprite.mouseY);
			var length:int = array.length;
			
			if (length <= 1) return true;
			
			var index:int = parent.children.indexOf(this);
			
			for (var i:int = 0; i < length; i++) 
			{
				var child:RenderObject = array[i];
				
				if (child == this) continue;
				
				if (array[i].renderID > renderID) return false;
			}
			
			return true;
		}
	}
}