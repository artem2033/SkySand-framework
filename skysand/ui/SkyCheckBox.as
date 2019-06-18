package skysand.ui 
{
	import skysand.display.SkyShape;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyCheckBox extends SkyShape
	{
		/**
		 * Активна ли сейчас кнопка.
		 */
		public var isActive:Boolean;
		
		/**
		 * Кнопка.
		 */
		private var button:SkyButton;
		
		/**
		 * Иконка - галочка.
		 */
		private var checkIcon:SkyShape;
		
		/**
		 * Маска.
		 */
		private var mask:SkyShape;
		
		/**
		 * Цвет неактивной кнопки.
		 */
		private var backColor:uint;
		
		/**
		 * Цвет активной кнопки.
		 */
		private var checkColor:uint;
		
		/**
		 * Функция, выполняющаяся при активации кнопки.
		 */
		private var mFunction:Function;
		
		/**
		 * Функция вызываемая при нажантии на кнопку.
		 */
		private var switchFunction:Function;
		
		/**
		 * Форма.
		 */
		private var kind:uint;
		
		/**
		 * Форма в виде рамки.
		 */
		private var frameForm:Boolean;
		
		public function SkyCheckBox()
		{
			
		}
		
		/**
		 * Создать кнопку.
		 * @param	kind внешний вид.
		 * @param	color цвет кнопки.
		 * @param	checkIconColor цвет галочки.
		 * @param	mFunction функция, которая будет выполняться при активации.
		 * @param	frameType кнопка в виде рамки.
		 * @param	size размер кнопки.
		 */
		public function create(kind:uint, color:uint, checkIconColor:uint, mFunction:Function = null, frameForm:Boolean = false, size:Number = 20):void
		{
			this.kind = kind;
			this.frameForm = frameForm
			width = size;
			height = size;
			
			if (kind == SkyUI.CIRCLE)
			{
				size /= 2;
				
				mask = SkyUI.getForm(kind, color, size - 2, size * 2);
				mask.alpha = 0;
				mask.x = size;
				mask.y = size;
				mask.visible = frameForm;
				addChild(mask);
				
				button = new SkyButton();
				button.create(kind, size, size * 2, color, action);
				button.x = size;
				button.y = size;
				addChildAt(button, 0);
				
				checkIcon = SkyUI.getForm(SkyUI.CHECK_ICON, checkIconColor, 0, 0);
				checkIcon.visible = false;
				checkIcon.scaleX = 3;
				checkIcon.scaleY = 3;
				checkIcon.x = button.width - checkIcon.width;
				checkIcon.y = (button.height - checkIcon.height) / 2;
				addChild(checkIcon);
			}
			else
			{
				mask = SkyUI.getForm(kind, color, size - 4, size - 4);
				mask.alpha = 0;
				mask.x = 2;
				mask.y = 2;
				mask.visible = frameForm;
				addChild(mask);
				
				button = new SkyButton();
				button.create(kind, size, size, color, action);
				addChildAt(button, 0);
				
				checkIcon = SkyUI.getForm(SkyUI.CHECK_ICON, checkIconColor, 0, 0);
				checkIcon.visible = false;
				checkIcon.scaleX = 3;
				checkIcon.scaleY = 3;
				checkIcon.x = (button.width - checkIcon.width) / 2 - 2;
				checkIcon.y = (button.height - checkIcon.height) / 2;
				addChild(checkIcon);
			}
			
			width = size;
			height = size;
			isActive = false;
			backColor = color;
			checkColor = color;
			this.mFunction = mFunction;
		}
		
		/**
		 * Изменить размер.
		 * @param	size новый размер.
		 */
		public function setSize(size:Number):void
		{
			width = size;
			height = size;
			
			if (mask != null)
			{
				removeChild(mask);
				mask.free();
				mask = null;
			}
			
			if (kind == SkyUI.CIRCLE)
			{
				size /= 2;
				
				mask = SkyUI.getForm(kind, color, size - 2, size * 2);
				mask.alpha = 0;
				mask.x = size;
				mask.y = size;
				mask.visible = frameForm;
				addChild(mask);
				
				button.recreate(kind, size, size);
				button.x = size;
				button.y = size;
				
				checkIcon.x = button.width - checkIcon.width;
				checkIcon.y = (button.height - checkIcon.height) / 2;
			}
			else
			{
				mask = SkyUI.getForm(kind, color, size - 4, size - 4);
				mask.alpha = 0;
				mask.x = 2;
				mask.y = 2;
				mask.visible = frameForm;
				addChild(mask);
				
				button.recreate(kind, size, size);
				
				checkIcon.x = (button.width - checkIcon.width) / 2 - 2;
				checkIcon.y = (button.height - checkIcon.height) / 2;
			}
			
			width = size;
			height = size;
		}
		
		/**
		 * Показать рамку, либо скрыть.
		 */
		public function setFrameForm(value:Boolean):void
		{
			mask.visible = value;
		}
		
		/**
		 * Задать цвета.
		 * @param	backColor цвет неактивной кнопки.
		 * @param	checkColor цвет активной кнопки.
		 * @param	checkIconColor цвет галочки.
		 */
		public function setColors(backColor:uint, checkColor:uint, checkIconColor:uint):void
		{
			checkIcon.color = checkIconColor;
			this.checkColor = checkColor;
			this.backColor = backColor;
			button.setColor(backColor);
		}
		
		/**
		 * Назначить функцию, которая будет срабатывать при нажатии.
		 * @param	switchFunction функция.
		 */
		public function setSwitchFunction(switchFunction:Function):void
		{
			this.switchFunction = switchFunction;
		}
		
		/**
		 * Прозрачность.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			button.setAlpha(value);
			checkIcon.alpha = value;
			alpha = value;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(button);
			button.free();
			button = null;
			
			removeChild(checkIcon);
			checkIcon.free();
			checkIcon = null;
			
			if (mask != null)
			{
				removeChild(mask);
				mask.free();
				mask = null;
			}
			
			mFunction = null;
			
			super.free();
		}
		
		override public function set mouseEnabled(value:Boolean):void 
		{
			button.mouseEnabled = value;
			super.mouseEnabled = value;
		}
		
		/**
		 * Обновить данные.
		 * @param	deltaTime Время прошедшее с прошлого кадра.
		 */
		override public function updateData(deltaTime:Number):void 
		{
			if (isActive && mFunction != null)
			{
				mFunction.apply();
			}
			
			super.updateData(deltaTime);
		}
		
		/**
		 * Проврека на столкновение с мышкой.
		 * @return true - есть столкновение, false - нет.
		 */
		override public function hitTestMouse():Boolean 
		{
			return button.hitTestMouse();
		}
		
		/**
		 * Получить текущее состояние чекбокса.
		 */
		public function get active():Boolean
		{
			return isActive;
		}
		
		/**
		 * Включить или выключить чекбокс.
		 */
		public function set active(value:Boolean):void
		{
			isActive = value
			checkIcon.visible = value;
			button.setColor(isActive ? checkColor : backColor);
			
			if (switchFunction != null) switchFunction.apply();
		}
		
		/**
		 * Действия при нажатии на кнопку.
		 */
		private function action():void
		{
			isActive = !isActive
			checkIcon.visible = !checkIcon.visible;
			button.setColor(isActive ? checkColor : backColor);
			
			if (switchFunction != null) switchFunction.apply();
		}
	}
}