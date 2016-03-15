package skysand.components
{
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.text.AntiAliasType;
	import skysand.mouse.SkyMouse;
	import skysand.text.SkyTextField;
	import skysand.render.RenderObject;
	import skysand.interfaces.IFrameworkUpdatable;
	
	use namespace framework;
	
	public class SkyWindow extends RenderObject implements IFrameworkUpdatable
	{
		/**
		 * Разрешить перетаскивание окна мышью.
		 */
		public var dragable:Boolean;
		
		/**
		 * Цветовая схема.
		 */
		private var color:ComponentColor;
		
		/**
		 * Кнопка закрытия консоли.
		 */
		private var closeButton:SkyButton;
		
		/**
		 * Ссылка на мышку.
		 */
		private var mouse:SkyMouse;
		
		public static var N:int = 0;
		
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
		 */
		public function create(width:Number, height:Number, _color:String, name:String = "", font:String = "system", embedFonts:Boolean = false):void
		{
			color = ColorStorage.instance.getColor(_color);
			mouse = SkyMouse.instance;
			
			draw(width, height, name, font, embedFonts);
			
			closeButton = new SkyButton();
			closeButton.create("skyCloseButton", close);
			closeButton.x = width - 15;
			closeButton.y = 5;
			addChild(closeButton);
			
			dragable = true;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(closeButton);
			closeButton.free();
			closeButton = null;
			color = null;
			mouse = null;
			
			bitmapData.dispose();
			bitmapData = null;
			
			super.free();
		}
		
		/**
		 * Обновить отрисовываемый объект (используется движком).
		 */
		override public function updateByFramework():void
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
			
			super.updateByFramework();
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
			if (mouseX < x || mouseX > width + x) return false;
			if (mouseY < y || mouseY > 25 + y) return false;
			
			return true;
		}
		
		/**
		 * Нарисовать окно.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	name загаловок окна.
		 * @param	font шрифт загаловка.
		 */
		private function draw(width:Number, height:Number, name:String, font:String, embedFonts:Boolean):void
		{
			var head:Sprite = new Sprite();
			head.graphics.beginFill(color.dark);
			head.graphics.drawRect(0, 0, width, 25);
			
			var body:Sprite = new Sprite();
			body.graphics.beginFill(color.main);
			body.graphics.drawRect(0, 0, width, height);
			body.addChild(head);
			
			var textField:SkyTextField = new SkyTextField();
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = color.bright;
			textField.embedFonts = embedFonts;
			textField.width = width;
			textField.height = 25;
			textField.font = font;
			textField.text = name;
			
			bitmapData = new BitmapData(width, height, true, 0xFFFFFF);
			bitmapData.draw(body, new Matrix());
			bitmapData.copyPixels(textField.bitmapData, new Rectangle(0, 0, width, 25), new Point(0, 2), null, null, true);
			
			textField.bitmapData.dispose();
			
			super.width = width;
			super.height = height;
		}
	}
}