package skysand.debug 
{
	import skysand.ui.SkySlider;
	import skysand.ui.SkyUI;
	import skysand.ui.SkyWindow;
	import skysand.text.SkyFont;
	import skysand.text.SkyTextField;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyOutput extends SkyWindow
	{
		/**
		 * Текстовое поле вывода информации.
		 */
		private var textField:SkyTextField;
		
		/**
		 * Строки с информацией.
		 */
		private var strings:Vector.<String>;
		
		/**
		 * Ползунок для прокрутки текстового поля.
		 */
		private var slider:SkySlider;
		
		/**
		 * Текущий свободный индекс для вывода значения.
		 */
		private var index:int;
		
		public function SkyOutput()
		{
			index = 0;
		}
		
		/**
		 * Отображать любую информацию в окне вывода.
		 * @param	string информация в виде строки.
		 * @param	index позиция в списке.
		 */
		public function watch(value:*):void
		{
			visible = true;
			strings[index] = String(value);
			index++;
		}
		
		/**
		 * Обновить информацию в текстовом поле.
		 */
		public function update():void
		{
			var length:int = strings.length;
			
			if (length > 0)
			{
				textField.text = strings[0];
				
				for (var i:int = 1; i < length; i++) 
				{
					textField.appendText("\n" + strings[i]);
				}
				
				textField.scrollV = slider.position * textField.maxScrollV;
				index = 0;
			}
		}
		
		/**
		 * Инициализировать окно вывода информации.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	headColor цвет верхней панели окна.
		 * @param	bodyColor цвет окна.
		 * @param	textColor цвет текста.
		 * @param	font шрифт.
		 * @param	fontSize размер шрифта.
		 */
		public function initialize(width:Number, height:Number, headColor:uint, bodyColor:uint, textColor:uint, font:String, fontSize:int):void
		{
			create(width, height, headColor, bodyColor);
			addText("OUTPUT", "verdana", bodyColor, 12);
			
			strings = new Vector.<String>();
			
			textField = new SkyTextField();
			textField.textColor = textColor;
			textField.font = font;
			textField.embedFonts = true;
			textField.size = fontSize;
			textField.width = width;
			textField.height = height - 24;
			textField.y = 24;
			textField.mouseEnabled = false;
			addChild(textField);
			
			slider = new SkySlider();
			slider.create(true, SkyUI.RECTANGLE, height - 27, 5, height / 10);
			slider.setColor(headColor, bodyColor);
			slider.x = width - 6;
			slider.y = 26;
			addChild(slider);
		}
		
		/**
		 * Настроить внешний вид окна вывода информации.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	headColor цвет верхней панели окна.
		 * @param	bodyColor цвет окна.
		 * @param	textColor цвет текста.
		 * @param	font шрифт.
		 * @param	fontSize размер шрифта.
		 */
		public function setOutputView(width:Number, height:Number, headColor:uint, bodyColor:uint, textColor:uint, font:String, fontSize:int):void
		{
			setSize(width, height);
			setColor(headColor, bodyColor, textColor);
			slider.setSize(5, height - 27);
			slider.setColor(headColor, bodyColor);
			
			textField.textColor = textColor;
			textField.font = font;
			textField.size = fontSize;
			textField.height = height - 24;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(textField);
			textField.free();
			textField = null;
			
			strings.length = 0;
			strings = null;
			
			super.free();
		}
	}
}