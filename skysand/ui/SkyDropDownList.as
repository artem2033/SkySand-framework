package skysand.ui
{
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyShape;
	import skysand.input.SkyMouse;
	import skysand.text.SkyFont;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyDropDownList extends SkyRenderObjectContainer
	{
		/**
		 * Замедление стрелки.
		 */
		private const FRICTION:Number = 0.9;
		
		/**
		 * Максимальная скорость поворота стрелки.
		 */
		private const MAX_SPEED:Number = 600;
		
		/**
		 * Маленькая кнопка.
		 */
		private var smallButton:SkyButton;
		
		/**
		 * Большая кнопка.
		 */
		private var bigButton:SkyButton;
		
		/**
		 * Стрелка.
		 */
		private var arrow:SkyShape;
		
		/**
		 * Список.
		 */
		private var list:SkyList;
		
		/**
		 * Треугольник для списка.
		 */
		private var triangle:SkyShape;
		
		/**
		 * Повернуть стрелку в одну сторону или в другую.
		 */
		private var rotate:Boolean;
		
		/**
		 * Текущая скорость поворота стрелки.
		 */
		private var speed:Number;
		
		/**
		 * Разделён ли список с кнопкой.
		 */
		private var isListSplited:Boolean;
		
		/**
		 * Добавлена ли стрелка.
		 */
		private var isArrowAdded:Boolean;
		
		/**
		 * Показывать меню при нажатии или наведении курсором.
		 */
		private var showAfterPress:Boolean;
		
		/**
		 * Ссылка на мышку.
		 */
		private var mouse:SkyMouse;
		
		/**
		 * Текущий элемент.
		 */
		private var text:String;
		
		/**
		 * Проверка на нахождение курсора над кнопкой.
		 */
		private var underButton:Boolean;
		
		/**
		 * Менять ли имя кнопки при нажатии на элемент списка.
		 */
		private var changeButtonName:Boolean;
		
		/**
		 * Функция, которая срабатывает при выборе элемента из списка.
		 */
		private var onSelectFunction:Function;
		
		/**
		 * Форма.
		 */
		private var kind:uint;
		
		public function SkyDropDownList()
		{
			underButton = false;
			rotate = false;
			speed = 0;
			text = "";
		}
		
		/**
		 * Создать выпадющий список.
		 * @param	kind форма кнопки.
		 * @param	width ширина кнопки.
		 * @param	height высота кнопки.
		 * @param	color цвет кнопки.
		 * @param	showAfterPress автоматически показывать список при наведении на кнопку.
		 * @param	splitButton разделить кнопку.
		 * @param	splitList отступ списка от кнопки.
		 * @param	addArrow добавить анимированную стрелку.
		 */
		public function create(kind:uint, width:Number, height:Number, color:uint, showAfterPress:Boolean = false, splitButton:Boolean = false, splitList:Boolean = false, addArrow:Boolean = false, changeButtonName:Boolean = true):void
		{
			this.kind = kind;
			this.showAfterPress = showAfterPress;
			this.changeButtonName = changeButtonName;
			isListSplited = splitList;
			isArrowAdded = addArrow;
			
			if (splitList)
			{
				triangle = new SkyShape();
				triangle.color = SkyColor.CLOUDS;
				triangle.addVertex(6, 0);
				triangle.addVertex(12, 6);
				triangle.addVertex(0, 6);
				triangle.y = height + 9;
				triangle.x = width - height / 2 - 6;
				triangle.visible = false;
				addChild(triangle);
			}
			
			if (splitButton)
			{
				bigButton = new SkyButton();
				bigButton.create(kind, width - height, height, color, null, false, SkyUI.CUT_RIGHT);
				bigButton.disable(1);
				addChild(bigButton);
				
				smallButton = new SkyButton();
				smallButton.create(kind, height, height, SkyColor.setBright(color, -30), onButtonDown, false, SkyUI.CUT_LEFT);
				smallButton.x = width - height;
				addChild(smallButton);
			}
			else
			{
				bigButton = new SkyButton();
				bigButton.create(kind, width, height, color, onButtonDown);
				addChild(bigButton);
			}
			
			if (addArrow)
			{
				arrow = new SkyShape();
				arrow.color = SkyColor.CLOUDS;
				arrow.addVertex(5, 0);
				arrow.addVertex(20, 15);
				arrow.addVertex(5, 30);
				arrow.addVertex(0, 25);
				arrow.addVertex(10, 15);
				arrow.addVertex(0, 5);
				arrow.scaleX = 0.5;
				arrow.scaleY = 0.5;
				arrow.y = height / 2;
				arrow.x = width - arrow.y;
				arrow.pivotX = arrow.width / 2;
				arrow.pivotY = arrow.height / 2;
				addChild(arrow);
			}
			
			this.width = width;
			this.height = height;
			this.color = color;
			
			mouse = SkyMouse.instance;
			mouse.addFunctionOnClick(onMouseClick, SkyMouse.LEFT);
		}
		
		/**
		 * Изменить размеры.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function setSize(width:Number, height:Number):void
		{
			if (triangle != null)
			{
				triangle.y = height + 9;
				triangle.x = width - height / 2 - 6;
			}
			
			if (arrow != null)
			{
				arrow.y = height / 2;
				arrow.x = width - arrow.y;
			}
			
			if (smallButton != null)
			{
				bigButton.recreate(kind, width - height, height, SkyUI.CUT_RIGHT); 
				bigButton.disable(1);
				
				smallButton.recreate(kind, height, height, SkyUI.CUT_LEFT);
				smallButton.x = width - height;
			}
			else
			{
				bigButton.recreate(kind, width, height);
			}
		}
		
		/**
		 * Добавить список.
		 * @param	list список.
		 */
		public function addList(list:SkyList):void
		{
			if (this.list != null)
			{
				removeChild(this.list);
			}
			
			this.list = list;
			list.y = isListSplited ? height + 15 : height;
			list.visible = false;
			addChildAt(list, 0);
			
			if (changeButtonName)
			{
				var items:Vector.<SkyButton> = list.getItems();
				
				for (var i:int = 0; i < items.length; i++) 
				{
					items[i].setFunction(onElementChoose, true);
				}
			}
		}
		
		public function updateAddedList():void
		{
			//names = list.getNames();
			
			/*if (changeButtonName)
			{
				for (var i:int = 0; i < names.length; i++) 
				{
					list.getItems()[i].setFunction(onElementChoose);
				}
			}*/
		}
		
		/**
		 * Задать функцию, которая будет срабатывать при выборе элемента из списка.
		 * @param	mFunction функция.
		 */
		public function setOnSelectFunction(mFunction:Function):void
		{
			onSelectFunction = mFunction;
		}
		
		/**
		 * Добавить текст поверх кнопки.
		 * @param	text текст.
		 * @param	font шрифт.
		 * @param	color цвет текста.
		 * @param	size размер шрифта.
		 * @param	embedFonts внешний или встроенный шрифт.
		 * @param	offsetX смещение шрифта по оси х.
		 * @param	offsetY смещение шрифта по оси у.
		 */
		public function addText(text:String, font:String, color:uint, size:int = 16, embedFonts:Boolean = true, offsetX:Number = 0, offsetY:Number = 0):void
		{
			bigButton.addText(text, font, color, size, embedFonts, offsetX, offsetY);
		}
		
		/**
		 * Добавить текстовое поле из текстуры.
		 * @param	name название текстуры из кеша.
		 * @param	text текст.
		 * @param	color цвет.
		 */
		public function addBitmapText(name:String, text:String, color:uint):void
		{
			bigButton.addBitmapText(name, text, color);
		}
		
		/**
		 * Изменить шрифт кнопки.
		 * @param	font шрифт.
		 * @param	fontSize размер шрифта.
		 */
		public function setFont(font:String, size:Number = 14):void
		{
			bigButton.setText("");
			bigButton.setFont(font, size);
			bigButton.setText(text);
		}
		
		/**
		 * Поменять текст на кнопке.
		 * @param	text
		 */
		public function setText(value:String):void
		{
			bigButton.setText(value);
			text = value;
		}
		
		/**
		 * Поменять шрифт тектового поля.
		 * @param	name имя текстуры с шрифтом в кеше.
		 */
		public function setBitmapFont(name:String):void
		{
			if(bigButton != null)
				bigButton.setBitmapFont(name);
		}
		
		/**
		 * Текущий текст.
		 * @return строка.
		 */
		public function getText():String
		{
			return text;
		}
		
		/**
		 * Разделить кнопку на 2.
		 * @param	value true - разделить, false - объеденить.
		 */
		public function setSplitButton(value:Boolean):void
		{
			if (smallButton != null && smallButton.visible == value) return;
			
			if (smallButton == null)
			{
				smallButton = new SkyButton();
				smallButton.create(kind, height, height, SkyColor.setBright(color, -30), onButtonDown, false, SkyUI.CUT_LEFT);
				smallButton.x = width;
				smallButton.visible = value;
				addChild(smallButton);
				
				bigButton.disable(1);
			}
			else
			{
				if (value)
				{
					width += height;
					bigButton.disable(1);
				}
				else
				{
					width -= height;
					bigButton.enable();
				}
				
				if (arrow != null) arrow.x = width - arrow.y;
				
				smallButton.visible = value;
			}
		}
		
		/**
		 * Прозрачность.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			if (smallButton != null) smallButton.setAlpha(value);
			if (bigButton != null) bigButton.setAlpha(value);
			if (triangle != null) triangle.alpha = value;
			if (arrow != null) arrow.alpha = value;
			
			alpha = value;
		}
		
		/**
		 * Добавить стрелку.
		 * @param	value true - показать, false - скрыть.
		 */
		public function setArrow(value:Boolean):void
		{
			if (arrow == null)
			{
				arrow = new SkyShape();
				arrow.color = SkyColor.CLOUDS;
				arrow.addVertex(5, 0);
				arrow.addVertex(20, 15);
				arrow.addVertex(5, 30);
				arrow.addVertex(0, 25);
				arrow.addVertex(10, 15);
				arrow.addVertex(0, 5);
				arrow.scaleX = 0.5;
				arrow.scaleY = 0.5;
				arrow.y = height / 2;
				arrow.x = width - arrow.y;
				arrow.pivotX = arrow.width / 2;
				arrow.pivotY = arrow.height / 2;
				arrow.visible = value;
				addChild(arrow);
			}
			else 
			{
				isArrowAdded = value;
				arrow.visible = value;
			}
		}
		
		/**
		 * Активировать список.
		 */
		public function enable():void
		{
			bigButton.enable();
			if (smallButton != null) smallButton.enable();
		}
		
		/**
		 * Деактивировать.
		 */
		public function disable():void
		{
			bigButton.disable();
			if (smallButton != null) smallButton.disable();
		}
		
		/**
		 * Изменить цвета.
		 * @param	dark тёмный цвет.
		 * @param	bright светлый цвет.
		 */
		public function setColor(dark:uint, bright:uint, arrowColor:uint = 0xFFFFFF):void
		{
			bigButton.setColor(dark);
			bigButton.setTextColors(bright);
			
			if (arrow != null) arrow.color = arrowColor;
			if (triangle != null) triangle.color = bright;
			if (smallButton != null) smallButton.setColor(SkyColor.setBright(dark, -30));
		}
		
		/**
		 * Скрыть список.
		 */
		public function hideList():void
		{
			if(isListSplited) triangle.visible = false;
			
			list.visible = false;
			rotate = false;
			
			speed = MAX_SPEED;
		}
		
		/**
		 * Изменить цвета ползунка.
		 * @param	background цвет фона.
		 * @param	button цвет кнопки.
		 */
		public function setSliderColor(background:uint, button:uint):void
		{
			list.setSliderColors(button, background);
		}
		
		override public function set mouseEnabled(value:Boolean):void 
		{
			bigButton.mouseEnabled = value;
			if (smallButton != null) smallButton.mouseEnabled = value;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			if (smallButton != null)
			{
				removeChild(smallButton);
				smallButton.free();
				smallButton = null;
			}
			
			if (arrow != null)
			{
				removeChild(arrow);
				arrow.free();
				arrow = null;
			}
			
			if (triangle != null)
			{
				removeChild(triangle);
				triangle.free();
				triangle = null;
			}
			
			removeChild(bigButton)
			bigButton.free();
			bigButton = null;
			
			removeChild(list);
			list = null;
			mouse = null;
			onSelectFunction = null;
			
			super.free();
		}
		
		/**
		 * Обновить класс.
		 * @param	deltaTime промежуток времени прошедший с предыдущего кадра.
		 */
		override public function updateData(deltaTime:Number):void
		{
			if (visible && list != null)
			{
				if (!showAfterPress)
				{
					if (!list.visible && hitTestMouse() && !underButton)
					{
						if (isListSplited) triangle.visible = true;
						
						list.visible = true;
						rotate = true;
						
						speed = MAX_SPEED;
						
						underButton  = true;
					}
					
					if(!hitTestMouse() && !list.visible)
					{
						underButton = false;
					}
				}
				
				if (isArrowAdded)
				{			
					if (rotate)
					{
						speed *= FRICTION;
						arrow.rotation += speed * deltaTime;
						
						if (arrow.rotation >= 90)
						{
							arrow.rotation = 90;
						}
					}
					else
					{
						speed *= FRICTION;
						arrow.rotation -= speed * deltaTime;
						
						if (arrow.rotation <= 0)
						{
							arrow.rotation = 0;
						}
					}
				}
			}
			
			super.updateData(deltaTime);
		}
		
		/**
		 * Проверка на столкновение с мышью.
		 * @return true - есть столкновение, false - нет.
		 */
		override public function hitTestMouse():Boolean 
		{
			return (smallButton == null) ? bigButton.hitTestMouse() : smallButton.hitTestMouse();
		}
		
		/**
		 * Действия при клике.
		 */
		private function onMouseClick():void
		{
			if (list == null) return;
			
			if (!hitTestMouse() && !list.hitTestMouse())
			{
				if(isListSplited) triangle.visible = false;
				
				list.visible = false;
				rotate = false;
				
				speed = MAX_SPEED;
			}
		}
		
		/**
		 * Действия при нажатии на кнопку.
		 */
		public function onButtonDown():void
		{
			if (list == null) return;
			
			if (isListSplited) triangle.visible = !triangle.visible;
			
			list.visible = !list.visible;
			rotate = !rotate;
			speed = MAX_SPEED;
		}
		
		/**
		 * Событие при выборе элемента.
		 */
		private function onElementChoose(text:String = ""):void
		{
			if (onSelectFunction != null) onSelectFunction.apply();
			if (changeButtonName) bigButton.setText(text);
			
			this.text = text;
			hideList();
		}
	}
}