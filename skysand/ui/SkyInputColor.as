package skysand.ui 
{
	import skysand.display.SkyShape;
	import skysand.text.SkyTextField;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyInputColor extends SkyShape
	{
		/**
		 * Ссылка на цветовую схему.
		 */
		public static var colorPicker:SkyColorPicker;
		
		/**
		 * Ссылка на предыдущий компонент у которого выбирался цвет.
		 */
		private static var prev:SkyInputColor;
		
		/**
		 * Кнопка для выбора цвета.
		 */
		private var square:SkyButton;
		
		/**
		 * Поле ввода цвета.
		 */
		private var textField:SkyTextField;
		
		/**
		 * Ссылка на палитру.
		 */
		private var palette:SkyPalette;
		
		/**
		 * Выбирается ли цвет для текущего компонента.
		 */
		private var focusOn:Boolean;
		
		public function SkyInputColor() 
		{
			
		}
		
		/**
		 * Создать поле ввода цвета.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	textColor цвет текста.
		 * @param	backgroundColor цвет фона.
		 * @param	font шрифт.
		 * @param	size размер шрифта.
		 */
		public function create(width:Number, height:Number, textColor:uint, backgroundColor:uint, font:String, size:Number = 16):void
		{
			textField = new SkyTextField();
			textField.embedFonts = true;
			textField.font = font;
			textField.size = size;
			textField.width = width;
			textField.height = height;
			textField.textColor = textColor;
			textField.background = true;
			textField.backgroundColor = backgroundColor;
			textField.text = "0x" + textColor.toString(16).toUpperCase();
			textField.type = "input";
			textField.restrict = "01234456789xABCDEF";
			textField.maxChars = 8;
			addChild(textField);
			
			square = new SkyButton();
			square.create(SkyUI.RECTANGLE, height, height, textColor, onButtonListener);
			square.x = width + 2;
			addChild(square);
			
			color = textColor;
			width = width;
			height = height;
			
			focusOn = false;
		}
		
		/**
		 * Изменить размер.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function setSize(width:Number, height:Number):void
		{
			//var color:uint = textField.textColor;
			
			textField.width = width;
			textField.height = height;
			//textField.textColor = color;
			
			square.recreate(1, height, height);
			square.x = width + 2;
			
			width = width;
			height = height;
		}
		
		/**
		 * Получить текущий цвет.
		 * @return
		 */
		public function getColor():uint
		{
			return color;
		}
		
		/**
		 * Задать текущий цвет.
		 * @param	value цвет.
		 */
		public function setColor(value:uint):void
		{
			color = value;
			textField.text = "0x" + value.toString(16).toUpperCase();
			square.setColor(value);
		}
		
		/**
		 * Задать ссылку на палитру для выбора цвета из неё.
		 * @param	palette ссылка на палитру.
		 */
		public function setPalette(palette:SkyPalette):void
		{
			this.palette = palette;
		}
		
		/**
		 * Изменить цвета.
		 * @param	backgroundColor цвет фона.
		 * @param	textColor цвет текста.
		 */
		public function setColors(backgroundColor:uint, textColor:uint):void
		{
			textField.backgroundColor = backgroundColor;
			textField.textColor = textColor;
		}
		
		/**
		 * Прозрачность.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			textField.alpha = value;
			square.setAlpha(value);
			alpha = value;
		}
		
		/**
		 * Изменить шрифт.
		 * @param	font шрифт.
		 * @param	size размер шрифта.
		 */
		public function setFont(font:String, size:Number = 14):void
		{
			textField.font = font;
			textField.size = size;
			textField.text = "";
			textField.text = "0x" + color.toString(16).toUpperCase();
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(square);
			square.free();
			square = null;
			
			removeChild(textField);
			textField.free();
			textField = null;
			
			palette = null;
			
			super.free();
		}
		
		/**
		 * Обновить данные
		 * @param	deltaTime промежуток времени между кадрами.
		 */
		override public function updateData(deltaTime:Number):void 
		{
			if (colorPicker != null && colorPicker.visible && focusOn)
			{
				textField.text = "0x" + color.toString(16).toUpperCase();
				color = colorPicker.rgb;
				square.setColor(color);
			}
			else if (color != uint(textField.text))
			{
				color = uint(textField.text);
				square.setColor(color);
			}
			
			if (!colorPicker.visible)
			{
				focusOn = false;
			}
			
			super.updateData(deltaTime);
		}
		
		/**
		 * Слушатель на нажатие кнопки.
		 */
		private function onButtonListener():void
		{
			if (colorPicker == null) return;
			
			colorPicker.visible = true;
			colorPicker.rgb = color;
			
			colorPicker.x = globalX;
			colorPicker.x += globalX >= SkySand.SCREEN_WIDTH / 2 ? square.x + square.width - colorPicker.width - 4 : 0;
			
			colorPicker.y = globalY;
			colorPicker.y += globalY <= SkySand.SCREEN_HEIGHT / 2 ? square.height + 2 : -(colorPicker.height + 2);
			
			if (prev != null) prev.focusOn = false;
			prev = this;
			
			focusOn = true;
		}
	}
}