package skysand.ui
{
	import flash.display3D.textures.Texture;
	import flash.text.AntiAliasType;
	import skysand.text.SkyBitmapText;
	import skysand.text.SkyFont;
	
	import skysand.display.SkyShape;
	import skysand.text.SkyTextField;
	import skysand.input.SkyMouse;
	import skysand.utils.SkyUtils;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyWindow extends SkyShape
	{
		/**
		 * Разрешить перетаскивание окна мышью.
		 */
		public var dragable:Boolean;
		
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
		
		private var bitmapTextField:SkyBitmapText;
		
		protected var head:SkyShape;
		
		protected var body:SkyShape;
		
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
		public function create(width:Number, height:Number, headColor:uint, bodyColor:uint):void
		{
			mouse = SkyMouse.instance;
			
			body = new SkyShape();
			body.color = bodyColor;
			body.drawRect(0, 0, width, height - 25);
			body.mouseEnabled = true;
			body.y = 25;
			addChild(body)
			
			head = new SkyShape();
			head.color = headColor;
			head.drawRect(0, 0, width, 25);
			head.mouseEnabled = true;
			addChild(head);
			
			closeButton = new SkyButton();
			closeButton.create(SkyUI.RECTANGLE, 23, 23, headColor, close);
			closeButton.x = width - 24;
			closeButton.y = 1;
			addChild(closeButton);
			
			var cross:SkyShape = new SkyShape();
			cross.color = bodyColor;
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
			cross.mouseEnabled = false;
			closeButton.addChild(cross);
			
			dragable = true;
			
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Добавить название окна.
		 * @param	text текст.
		 * @param	font шрифт.
		 * @param	color цвет текста.
		 * @param	size размер шрифта.
		 * @param	embedFonts внешний или встроенный шрифт.
		 */
		public function addText(text:String, font:String, color:uint, size:int = 16, embedFonts:Boolean = false):void
		{
			textField = new SkyTextField();
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.embedFonts = embedFonts;
			textField.textColor = color;
			textField.mouseEnabled = false;
			textField.width = width;
			textField.height = 25;
			textField.font = font;
			textField.size = size;
			textField.text = text;
			addChild(textField);
		}
		
		/**
		 * Добавить название окна используя растровый шрифт.
		 * @param	filePath путь к текстуре.
		 * @param	directory директория файла.
		 * @param	text текст.
		 * @param	color цвет.
		 */
		public function addBitmapText(name:String, text:String, color:uint):void
		{
			bitmapTextField = new SkyBitmapText();
			bitmapTextField.setAtlasFromCache(name);
			bitmapTextField.textColor = color;
			bitmapTextField.text = text;
			addChild(bitmapTextField);
		}
		
		public function setSize(width:Number, height:Number):void
		{
			var color:uint = head.color;
			
			removeChild(head);
			head.free();
			head = new SkyShape();
			head.color = color;
			head.drawRect(0, 0, width, 25);
			addChild(head);
			
			color = body.color;
			
			removeChild(body);
			body.free();
			body = new SkyShape();
			body.color = color;
			body.drawRect(0, 25, width, height - 25);
			body.mouseEnabled = false;
			addChild(body);
			
			textField.width = width;
			closeButton.x = width - 24;
		}
		
		public function setColor(headColor:uint, bodyColor:uint, textColor:uint = 0xFFFFFF):void
		{
			body.color = bodyColor;
			head.color = headColor;
			textField.textColor = textColor;
		}
		
		public function setCrossIconColor(value:uint):void
		{
			closeButton.children[closeButton.numChildren - 1].color = value;
		}
		
		public function hideWindow():void
		{
			getChildAt(0).visible = false;
			getChildAt(1).visible = false;
			textField.visible = false;
			closeButton.visible = false;
		}
		
		public function showWindow():void
		{
			getChildAt(0).visible = true;
			getChildAt(1).visible = true;
			textField.visible = true;
			closeButton.visible = true;
		}
		
		public function set headName(value:String):void
		{
			if (textField != null) textField.text = value;
			else 
				bitmapTextField.text = value;
		}
		
		public function get headName():String
		{
			return textField != null ? textField.text : bitmapTextField.text;
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
			
			mouse = null;
			
			super.free();
		}
		
		/**
		 * Обновить отрисовываемый объект (используется движком).
		 */
		override public function updateData(deltaTime:Number):void
		{
			if (dragable)
			{
				if (SkyMouse.currentClosestObject == head && mouse.isDown(SkyMouse.LEFT))
				{
					startDrag();
				}
				
				if (!mouse.isDown(SkyMouse.LEFT))
				{
					stopDrag();
				}
			}
			
			super.updateData(deltaTime);
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
		public function hitTest():Boolean
		{
			var mx:Number = SkySand.STAGE.mouseX;
			var my:Number = SkySand.STAGE.mouseY;
			
			if (mx < x || mx > width + x) return false;
			if (my < y || my > 25 + y) return false;
			
			return true;
		}
	}
}