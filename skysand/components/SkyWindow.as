package skysand.components
{
	import flash.text.AntiAliasType;
	
	import skysand.display.SkyGraphics;
	import skysand.text.SkyTextField;
	import skysand.mouse.SkyMouse;
	import skysand.utils.SkyUtils;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyWindow extends SkyGraphics
	{
		/**
		 * Разрешить перетаскивание окна мышью.
		 */
		public var dragable:Boolean;
		
		/**
		 * Цветовая схема.
		 */
		private var colorScheme:ComponentColor;
		
		/**
		 * Кнопка закрытия консоли.
		 */
		private var closeButton:SkyButton;
		
		/**
		 * Ссылка на мышку.
		 */
		private var mouse:SkyMouse;
		
		/**
		 * Заголовок окна.
		 */
		private var textField:SkyTextField;
		
		public function SkyWindow() 
		{
			
		}
		
		/**
		 * Создать окно.
		 * @param	width ширина окна.
		 * @param	height высота окна.
		 * @param	_color цветовая схема.
		 * @param	name название окна.
		 * @param	font шрифт для названия.
		 * @param	size размер шрифта для названия.
		 * @param	embedFonts импортируемый шрифт для названия.
		 */
		public function create(width:Number, height:Number, _color:String, name:String = "", font:String = "system", size:int = 12, embedFonts:Boolean = false):void
		{
			colorScheme = ColorStorage.instance.getColor(_color);
			mouse = SkyMouse.instance;
			
			var head:SkyGraphics = new SkyGraphics();
			head.color = colorScheme.dark;
			head.drawRect(0, 0, width, 25);
			addChild(head);
			
			var body:SkyGraphics = new SkyGraphics();
			body.color = colorScheme.main;
			body.drawRect(0, 25, width, height - 25);
			addChild(body)
			
			textField = new SkyTextField();
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = colorScheme.bright;
			textField.embedFonts = embedFonts;
			textField.width = width;
			textField.height = 25;
			textField.font = font;
			textField.size = size;
			textField.text = name;
			addChild(textField);
			
			var buttonSprite:SkyGraphics = new SkyGraphics();
			buttonSprite.color = colorScheme.bright;
			buttonSprite.drawRect(0, 0, 23, 23);
			
			var cross:SkyGraphics = new SkyGraphics();
			cross.color = colorScheme.bright;
			cross.addVertex(2, 12);
			cross.addVertex(0, 10);
			cross.addVertex(4, 6);
			cross.addVertex(0, 2);
			cross.addVertex(2, 0);
			cross.addVertex(6, 4);
			cross.addVertex(10, 0);
			cross.addVertex(12, 2);
			cross.addVertex(8, 6);
			cross.addVertex(12, 10);
			cross.addVertex(10, 12);
			cross.addVertex(6, 8.1);
			cross.x = 11.5 - cross.width * 0.5;
			cross.y = 11.5 - cross.height * 0.5;
			buttonSprite.addChild(cross);
			
			closeButton = new SkyButton();
			closeButton.createSimpleButtonWithPreset(buttonSprite, colorScheme.dark, SkyUtils.changeColorBright(colorScheme.bright, 40), colorScheme.bright, close);
			closeButton.x = width - 24;
			closeButton.y = 1;
			addChild(closeButton);
			
			dragable = true;
			
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChildAt(0);
			removeChildAt(1);
			
			removeChild(textField);
			textField.free();
			textField = null;
			
			removeChild(closeButton);
			closeButton.free();
			closeButton = null;
			
			colorScheme = null;
			mouse = null;
			
			super.free();
		}
		
		/**
		 * Обновить отрисовываемый объект (используется движком).
		 */
		override public function updateData():void 
		{
			if (dragable)
			{
				if (hitTest() && mouse.LBMPressed)
				{
					startDrag();
				}
				
				if (!mouse.LBMPressed)
				{
					stopDrag();
				}
			}
			
			super.updateData();
		}
		
		/**
		 * Закрыть окно(сделать не видимым).
		 */
		private function close():void
		{
			visible = false;
		}
		
		/**
		 * Проверка на столкновение с верхней линией окна.
		 * @return возвращает true, если произошло пересечение с курсором мыши, false, если нет.
		 */
		private function hitTest():Boolean
		{
			var mx:Number = SkySand.STAGE.mouseX;
			var my:Number = SkySand.STAGE.mouseY;
			
			if (mx < x || mx > width + x) return false;
			if (my < y || my > 25 + y) return false;
			
			return true;
		}
	}
}