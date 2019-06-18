package skysand.ui
{
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyShape;
	import skysand.input.SkyMouse;
	
	public class SkySlider extends SkyRenderObjectContainer
	{
		/**
		 * Кнопка ползунка.
		 */
		private var button:SkyButton;
		
		/**
		 * Фон ползунка.
		 */
		private var background:SkyShape;
		
		/**
		 * Верхняя и нижняя граница.
		 */
		private var bound:Number;
		
		/**
		 * Ориентация ползунка.
		 */
		private var isVerticalOrientation:Boolean;
		
		/**
		 * Размер кнопки.
		 */
		private var sliderSize:Number;
		
		/**
		 * Форма.
		 */
		private var kind:uint;
		
		public function SkySlider()
		{
			
		}
		
		/**
		 * Создать ползунок.
		 * @param	verticalOrientation ориентация.
		 * @param	kind внешний вид, использовать константы из SkyButton.
		 * @param	height высота.
		 * @param	width ширина.
		 * @param	sliderSize размер кнопки.
		 */
		public function create(verticalOrientation:Boolean, kind:uint, height:Number, width:Number, sliderSize:Number, modification:uint = 0):void
		{
			isVerticalOrientation = verticalOrientation;
			this.sliderSize = sliderSize;
			this.kind = kind;
			this.width = width;
			this.height = height;
			
			background = SkyUI.getForm(kind, SkyColor.MINT_TURQUOISE, width, height, modification);
			addChild(background);
			
			button = new SkyButton();
			
			if (isVerticalOrientation)
			{
				button.create(kind, width, sliderSize, SkyColor.CLOUDS, null, false, modification);
				button.width = width;
				button.height = sliderSize;
			}
			else
			{
				button.create(kind, sliderSize, height, SkyColor.CLOUDS, null, false, modification);
				button.width = sliderSize;
				button.height = height;
			}
			
			addChild(button);
			
			bound = verticalOrientation ? background.height - sliderSize : background.width - sliderSize;
		}
		
		/**
		 * Задать размеры.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
			
			if (background != null)
			{
				background.width = width;
				background.height = height;
			}
			
			bound = isVerticalOrientation ? background.height - sliderSize : background.width - sliderSize;
		}
		
		/**
		 * Прозрачность.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			background.alpha = value;
			button.setAlpha(value);
			alpha = value;
		}
		
		/**
		 * Сменить цвета ползунка.
		 * @param	buttonColor цвет кнопки.
		 * @param	backgroundColor цвет фона.
		 */
		public function setColor(buttonColor:uint, backgroundColor:uint):void
		{
			background.color = backgroundColor;
			button.setColor(buttonColor);
		}
		
		/**
		 * Получить значение ползунка от 0 до 1.
		 */
		public function get position():Number
		{
			return isVerticalOrientation ? button.y / bound : button.x / bound;
		}
		
		/**
		 * Задать положение ползунка от 0 до 1.
		 */
		public function set position(value:Number):void
		{
			value = value <= 0 ? 0 : value >= 1 ? 1 : value;
			
			if (isVerticalOrientation) button.y = value * bound;
			else button.x = value * bound;
		}
		
		/**
		 * Получить размер кнопки.
		 */
		public function get buttonSize():Number
		{
			return isVerticalOrientation ? button.height : button.width;
		}
		
		/**
		 * задать размер кнопки.
		 */
		public function set buttonSize(value:Number):void
		{
			if (sliderSize != value)
			{
				if (isVerticalOrientation)
				{
					bound = background.height - value;
					button.recreate(kind, width, value);
				}
				else
				{
					bound = background.width - value;
					button.recreate(kind, value, height);
				}
				
				sliderSize = value;
			}
		}
		
		/**
		 * Сменить ориентацию.
		 * @param	value true - вертикальная, false - горизонтальная.
		 */
		public function setOrientation(value:Boolean):void
		{
			if (isVerticalOrientation != value)
			{
				position = 0;
				isVerticalOrientation = value;
				
				if (isVerticalOrientation) button.recreate(kind, width, sliderSize);
				else button.recreate(kind, sliderSize, height);
			}
		}
		
		override public function set mouseEnabled(value:Boolean):void 
		{
			button.mouseEnabled = value;
			super.mouseEnabled = value;
		}
		
		/**
		 * Обновить ползунок.
		 */
		override public function updateData(deltaTime:Number):void 
		{
			if (button.isClosestToMouse())
			{
				if (isVerticalOrientation) button.startDrag(true, false, bound);
				else button.startDrag(false, true, 0, 0, 0, bound);
			}
			else if (!SkyMouse.instance.isDown(SkyMouse.LEFT))
			{
				button.stopDrag();
			}
			
			super.updateData(deltaTime);
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			removeChild(button);
			button.free();
			button = null;
			
			removeChild(background);
			background.free();
			background = null;
			
			super.free();
		}
		
		/**
		 * Проверка на столкновение с курсором.
		 * @return true - столкновение, false - отсутствие столкновения.
		 */
		override public function hitTestMouse():Boolean 
		{
			return background.hitTestMouse();
		}
		
		/**
		 * Форма слайдера.
		 * @param	kind форма.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		private function setForm(kind:uint, width:Number, height:Number, modification:uint = 0):void
		{
			
		}
	}
}