package skysand.ui 
{
	import flash.geom.Point;
	import flash.text.GridFitType;
	import flash.text.TextFieldType;
	import skysand.display.SkyShape;
	import skysand.input.SkyMouse;
	import skysand.text.SkyFont;
	import skysand.text.SkyTextField;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyInputNumber extends SkyShape
	{
		/**
		 * Минимальный размер поля ввода.
		 */
		private const MIN_SIZE:Number = 20;
		
		/**
		 * Минимальное допустимое значение ввода.
		 */
		public var min:Number;
		
		/**
		 * Максимальное допустимое значение ввода.
		 */
		public var max:Number;
		
		/**
		 * Шаг с которым происходит изменение значения.
		 */
		private var mStep:Number;
		
		/**
		 * Количество знаков после запятой.
		 */
		private var signCount:int;
		
		/**
		 * Текущее значение.
		 */
		private var currentValue:Number;
		
		/**
		 * Для временных рассчётов.
		 */
		private var temp:Number;
		
		/**
		 * Обновить данные после нажатия.
		 */
		private var isUpdate:Boolean;
		
		/**
		 * Стартовое значение координат мыши при нажатии.
		 */
		private var offset:Number;
		
		/**
		 * Текстовое поле вывода информации.
		 */
		private var textField:SkyTextField;
		
		/**
		 * Кнопка нажатия вверх.
		 */
		private var upButton:SkyButton;
		
		/**
		 * Кнопка нажатия вниз.
		 */
		private var downButton:SkyButton;
		
		/**
		 * Стрелка вверх.
		 */
		private var upArrow:SkyShape;
		
		/**
		 * Стрелка вниз.
		 */
		private var downArrow:SkyShape;
		
		/**
		 * Ссылка на мышь.
		 */
		private var mouse:SkyMouse;
		
		public function SkyInputNumber() 
		{
			
		}
		
		/**
		 * Создать численное поле ввода.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function create(width:Number, height:Number):void
		{
			width = width < MIN_SIZE ? MIN_SIZE : width;
			height = height < MIN_SIZE ? MIN_SIZE : height;
			
			textField = new SkyTextField();
			textField.textColor = SkyColor.CLOUDS;
			textField.background = true;
			textField.backgroundColor = SkyColor.DARK_MAGENTA;
			textField.width = width;
			textField.height = height;
			textField.embedFonts = true;
			textField.font = SkyFont.AKROBAT_BLACK;
			textField.size = 16;
			textField.type = TextFieldType.INPUT;
			textField.restrict = "-0123456789.e";
			textField.text = "0";
			addChild(textField);
			
			upButton = new SkyButton();
			upButton.create(SkyUI.RECTANGLE, 20, height / 2, SkyColor.CARMINE_PINK, upAction);
			upButton.x = width;
			addChild(upButton);
			
			upArrow = new SkyShape();
			upArrow.color = SkyColor.CLOUDS;
			upArrow.addVertex(1, 0);
			upArrow.addVertex(4, 3);
			upArrow.addVertex(1, 6);
			upArrow.addVertex(0, 5);
			upArrow.addVertex(2, 3);
			upArrow.addVertex(0, 1);
			upArrow.rotation = -90;
			upArrow.scaleX = 2;
			upArrow.scaleY = 2;
			upArrow.y = (height / 2 + upArrow.height) / 2;
			upArrow.x = 4;
			upButton.addChild(upArrow);
			
			downButton = new SkyButton();
			downButton.create(SkyUI.RECTANGLE, 20, height / 2, SkyColor.CARMINE_PINK, downAction);
			downButton.x = width;
			downButton.y = height / 2;
			addChild(downButton);
			
			downArrow = new SkyShape();
			downArrow.color = SkyColor.CLOUDS;
			downArrow.addVertex(1, 0);
			downArrow.addVertex(4, 3);
			downArrow.addVertex(1, 6);
			downArrow.addVertex(0, 5);
			downArrow.addVertex(2, 3);
			downArrow.addVertex(0, 1);
			downArrow.rotation = 90;
			downArrow.scaleX = 2;
			downArrow.scaleY = 2;
			downArrow.y = (height / 2 - downArrow.height) / 2;
			downArrow.x = 16;
			downButton.addChild(downArrow);
			
			mouse = SkyMouse.instance;
			
			currentValue = 0;
			signCount = 0;
			offset = 0;
			mStep = 1;
			temp = 0;
			
			min = -Number.MAX_VALUE;
			max = Number.MAX_VALUE;
		}
		
		/**
		 * Задать цвета.
		 * @param	backgroundColor цвет фона текстового поля.
		 * @param	textColor цвет текста.
		 * @param	arrowColor цвет стрелочек.
		 * @param	buttonColor цвет кнопок.
		 */
		public function setColors(backgroundColor:uint, textColor:uint, arrowColor:uint, buttonColor:uint):void
		{
			downButton.setColor(buttonColor);
			upButton.setColor(buttonColor);
			
			downArrow.color = arrowColor;
			upArrow.color = arrowColor;
			
			textField.backgroundColor = backgroundColor;
			textField.textColor = textColor;
		}
		
		/**
		 * Изменить шрифт.
		 * @param	size размер.
		 * @param	font шрифт.
		 */
		public function setFont(size:Number, font:String):void
		{
			textField.size = size;
			textField.font = font;
			textField.text = "";
		}
		
		/**
		 * Прозрачность.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			downButton.setAlpha(value);
			upButton.setAlpha(value);
			textField.alpha = value;
			downArrow.alpha = value;
			upArrow.alpha = value;
			alpha = value;
		}
		
		/**
		 * Изменить размер.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
			
			width = width < MIN_SIZE ? MIN_SIZE : width;
			height = height < MIN_SIZE ? MIN_SIZE : height;
			
			textField.width = width;
			textField.height = height;
			
			upButton.recreate(SkyUI.RECTANGLE, 20, height / 2);
			upButton.x = width;
			
			downButton.recreate(SkyUI.RECTANGLE, 20, height / 2);
			downButton.x = width;
			downButton.y = height / 2;
		}
		
		/**
		 * Получить значение текстового поля.
		 */
		public function get value():Number
		{
			return currentValue;
		}
		
		/**
		 * Задать значение текстового поля.
		 */
		public function set value(value:Number):void
		{
			currentValue = value;
			textField.text = value.toFixed(signCount);
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(textField);
			textField.free();
			textField = null;
			
			upButton.removeChild(upArrow);
			upArrow.free();
			upArrow = null;
			
			downButton.removeChild(downArrow);
			downArrow.free();
			downArrow = null;
			
			removeChild(upButton);
			upButton.free();
			upButton = null;
			
			removeChild(downButton);
			downButton.free();
			downButton = null;
			
			mouse = null;
			
			super.free();
		}
		
		/**
		 * Обновить данные.
		 * @param	deltaTime промежуток времени прошедший с прошлого кадра.
		 */
		override public function updateData(deltaTime:Number):void 
		{
			if (upButton.isClosestToMouse() || downButton.isClosestToMouse())
			{
				var my:Number = SkySand.STAGE.mouseY;
				
				if (!isUpdate)
				{
					offset = my;
					isUpdate = true;
					temp = currentValue;
				}
				
				var value:Number = temp + (offset - my) * mStep;
				currentValue = value >= max ? max : value <= min ? min : value;
				textField.text = currentValue.toFixed(signCount);
			}
			else
			{
				isUpdate = false;
				upButton.isDown = false;
				downButton.isDown = false;
			}
			
			if (textField.focus)
			{
				value = Number(textField.text);
				currentValue = value >= max ? max : value <= min ? min : value;
			}
			else
			{
				textField.text = currentValue.toFixed(signCount);
			}
			
			super.updateData(deltaTime);
		}
		
		/**
		 * Шаг с которым происходит изменение значения.
		 */
		public function set step(value:Number):void
		{
			mStep = value;
			signCount = 0;
			
			if (value != 0)
			{
				while (value < 1)
				{
					signCount++;
					value *= 10;
				}
			}
		}
		
		/**
		 * Шаг с которым происходит изменение значения.
		 */
		public function get step():Number
		{
			return mStep;
		}
		
		/**
		 * Слушатель событий на нажатие кнопки вверх.
		 * Добавляет значение.
		 */
		private function upAction():void
		{
			currentValue = currentValue >= max ? max : currentValue + mStep;
			textField.text = currentValue.toFixed(signCount);
		}
		
		/**
		 * Слушатель событий на нажатие кнопки вниз.
		 * Убавляет значение.
		 */
		private function downAction():void
		{
			currentValue = currentValue <= min ? min : currentValue - mStep; 
			textField.text = currentValue.toFixed(signCount);
		}
	}
}