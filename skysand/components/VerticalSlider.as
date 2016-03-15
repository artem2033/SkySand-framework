package skysand.components;
import src.animationn;
package components 
{
	imsrc.animationn.featherEngine.animation.FeatherAnimationCache;
	imsrc.animationn.featherEngine.animation.FeatherClip;
	import flash.geom.Point;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	
	public class VerticalSlider extends Sprite
	{
		/**
		 * Кнопка ползунка.
		 */
		private var slider:SkyButton;
		
		/**
		 * Фон ползунка.
		 */
		private var background:FeatherClip;
		
		/**
		 * Координата нажатия мыши по слайдеру.
		 */
		private var offsetY:Number;
		
		/**
		 * Перетаскивается ли ползунок.
		 */
		private var drag:Boolean;
		
		/**
		 * Верхняя и нижняя граница.
		 */
		private var bound:Number;
		
		public function VerticalSlider() 
		{
			
		}
		
		/**
		 * Создать вертикальный ползунок.
		 * @param	_name название цветовой палитры.
		 * @param	_height высота ползунка.
		 * @param	_width ширина ползунка.
		 */
		public function create(_name:String, _height:Number = 30, _width:Number = 8, sliderHeight:Number = 10):void
		{
			cachingGraphics();
			
			background = new FeatherClip();
			background.setAnim("backgroundSliderLine_graphics");
			background.height = _height;
			background.width = _width;
			addChild(background);
			
			slider = new SkyButton();
			slider.create("sliderButton_graphics");
			slider.height = sliderHeight >= background.height ? background.height : sliderHeight;
			slider.width = _width;
			slider.y = (-background.height + slider.height) * 0.5;
			addChild(slider);
			
			bound = (background.height - slider.height) * 0.5;
			
			drag = false;
			offsetY = 0;
			changeColor(_name);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			removeChild(slider);
			slider.free();
			slider = null;
			
			removeChild(background);
			background = null;
			
			bound = 0;
			offsetY = 0;
			drag = false;
		}
		
		/**
		 * Задать размер ползунка в процентах.
		 * @param	value число от 0.1 до 1;
		 */
		public function setSliderHeight(value:Number):void
		{
			background.height = value;
			slider.y = (-background.height + slider.height) * 0.5;
			bound = (background.height - slider.height) * 0.5;
		}
		
		/**
		 * Получить значение ползунка.
		 * @return возвращает численное значение отношения координаты ползунка к допустимому перемещению для ползунка.
		 */
		public function get position():Number
		{
			return (slider.y / bound + 1) * 0.5;
		}
		
		/**
		 * Обновить ползунок.
		 */
		public function update():void
		{
			if (drag)
			{
				slider.y = mouseY - offsetY;
				slider.y = bound <= slider.y ? bound : -bound >= slider.y ? -bound : slider.y;
			}
		}
		
		/**
		 * Сменить цвета ползунка.
		 */
		public function changeColor(colorName:String):void
		{
			var color:ComponentColor = ColorStorage.instance.getColor(colorName);
			
			background.setColor(1, color.main);
			slider.button.setColor(0, color.dark);
			slider.button.setColor(1, color.bright);
		}
		
		/**
		 * Слушатель нажатия кнопки мыши.
		 * @param	me событие мыши
		 */
		private function mouseDown(me:MouseEvent):void
		{
			drag = true;
			offsetY = me.localY;
		}
		
		/**
		 * Слушатель отпускания кнопки мыши.
		 * @param	me событие мыши
		 */
		private function mouseUp(me:MouseEvent):void
		{
			drag = false;
		}
		
		/**
		 * Подготавливаем графику для ползунка.
		 */
		private function cachingGraphics():void
		{
			FeatherAnimationCache.instance.addAnimationToCache(BackgroundSliderLine_mc, "backgroundSliderLine_graphics");
			FeatherAnimationCache.instance.addAnimationToCache(Slider_btn_mc, "sliderButton_graphics");
		}
	}
}