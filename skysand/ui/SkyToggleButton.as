package skysand.ui 
{
	import skysand.text.SkyFont;
	import skysand.text.SkyTextField;
	import skysand.display.SkyShape;
	import skysand.input.SkyMouse;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyToggleButton extends SkyShape
	{
		/**
		 * Активна ли кнопка.
		 */
		public var isActive:Boolean;
		
		/**
		 * Максимальная скорость.
		 */
		private const MAX_SPEED:Number = 350;
		
		/**
		 * Правая граница.
		 */
		private var rightBorder:Number;
		
		/**
		 * Кнопка.
		 */
		private var button:SkyButton;
		
		/**
		 * Фон.
		 */
		private var background:SkyShape;
		
		/**
		 * Зелёный прямоугольник.
		 */
		private var greenRect:SkyShape;
		
		/**
		 * Красный прямоугольник.
		 */
		private var redRect:SkyShape;
		
		/**
		 * Контейнер для всего, что движется.
		 */
		private var container:SkyShape;
		
		/**
		 * Ионка галочки.
		 */
		private var check:SkyShape;
		
		/**
		 * Иконка крестика.
		 */
		private var cross:SkyShape;
		
		/**
		 * Текстовое поле.
		 */
		private var textField:SkyTextField;
		
		/**
		 * Функция, которая выполняется при активации кнопки.
		 */
		private var mFunction:Function;
		
		/**
		 * Текущая форма кнопки.
		 */
		private var kind:uint;
		
		/**
		 * Цвет при активации кнопки.
		 */
		private var onColor:uint;
		
		/**
		 * Цвет при диактивации кнопки.
		 */
		private var offColor:uint;
		
		/**
		 * Двигать кнопку в одну или в другую сторону.
		 */
		private var move:Boolean;
		
		/**
		 * Текущая скорость движения кнопки.
		 */
		private var speed:Number;
		
		/**
		 * Ссылка на мышку.
		 */
		private var mouse:SkyMouse;
		
		/**
		 * Цвет фона.
		 */
		private var backgroundColor:uint;
		
		public function SkyToggleButton() 
		{
			
		}
		
		/**
		 * Создать кнопку-переключатель.
		 * @param	kind вид кнопки, CIRCLE, RECTANGLE, LOW_ROUND_RECTANGLE.
		 * @param	backgroundColor цвет фона.
		 * @param	buttonColor цвет кнопки.
		 * @param	icon добавить иконку или текст.
		 * @param	mFunction функция.
		 */
		public function create(kind:uint, backgroundColor:uint, buttonColor:uint, icon:Boolean = true, mFunction:Function = null):void
		{
			speed = 0;
			move = false;
			isActive = false;
			rightBorder = 27;
			
			this.kind = kind;
			this.mFunction = mFunction;
			this.backgroundColor = backgroundColor;
			color = buttonColor;
			
			onColor = SkyColor.GREEN_SEA;
			offColor = SkyColor.RED_KRAYOLA;
			
			mouse = SkyMouse.instance;
			button = new SkyButton();
			
			if (kind == SkyUI.CIRCLE)
			{
				background = SkyUI.getForm(SkyUI.FULL_ROUND_RECTANGLE, backgroundColor, 50, 25);
				
				button.create(SkyUI.CIRCLE, 10.5, 21, buttonColor, action);
				button.x = 10.5;
				button.y = 12.5;
			}
			else if (kind == SkyUI.RECTANGLE)
			{
				background = SkyUI.getForm(SkyUI.RECTANGLE, backgroundColor, 50, 25);
				
				button.create(SkyUI.RECTANGLE, 21, 21, buttonColor, action);
				button.y = 2;
			}
			else if (kind == SkyUI.LOW_ROUND_RECTANGLE)
			{
				background = SkyUI.getForm(SkyUI.LOW_ROUND_RECTANGLE, backgroundColor, 50, 25);
				
				button.create(SkyUI.LOW_ROUND_RECTANGLE, 21, 21, buttonColor, action);
				button.y = 2;
			}
			
			addChild(background);
			
			container = new SkyShape();
			container.x = 2;
			addChildAt(container, 1);
			
			container.addChild(button);
			
			if (icon)
			{
				check = SkyUI.getForm(SkyUI.CHECK_ICON, SkyColor.GREEN_SEA, 0, 0);
				check.scaleX = 3;
				check.scaleY = 3;
				check.x = 6.5;
				check.y = 11;
				check.visible = false;
				container.addChild(check);
				
				cross = SkyUI.getForm(SkyUI.CROSS_ICON, SkyColor.RED_KRAYOLA, 0, 0);
				cross.scaleX = 2;
				cross.scaleY = 2;
				cross.x = 6.5;
				cross.y = 9;
				container.addChild(cross);
			}
			else
			{
				textField = new SkyTextField();
				textField.autoSize = "left";
				textField.embedFonts = true;
				textField.font = SkyFont.AKROBAT_BLACK;
				textField.size = 9;
				textField.textColor = SkyColor.RED_KRAYOLA;
				textField.text = "off";
				textField.x = (button.width - textField.width) / 2;
				textField.y = (button.height - textField.height) / 2;
				textField.mouseEnabled = false;
				button.addChild(textField);
			}
		}
		
		public function setSize(size:Number):void
		{
			if (background != null)
			{
				background.width = size;
				background.height = size / 2;
			}
			
			rightBorder = size / 2 + 2; 
			button.recreate(kind, size / 2 - 4, size / 2 - 4);
			
			if (check != null)
			{
				//check.scaleX = 3;
				//check.scaleY = 3;
				check.x = size / 4 - 6;
				check.y = size / 4 - 2;
				
				//cross.scaleX = 2;
				//cross.scaleY = 2;
				cross.x = size / 4 - 5.5;
				cross.y = size / 4 - 3.5;
			}
			
			if (textField != null)
			{
				textField.x = (button.width - textField.width) / 2;
				textField.y = (button.height - textField.height) / 2;
			}
		}
		
		public function setIcon(value:Boolean):void
		{
			if (value)
			{
				if (textField != null)
				{
					button.removeChild(textField);
					textField.free();
					textField = null;
				}
				
				if (check != null) return;
				
				check = SkyUI.getForm(SkyUI.CHECK_ICON, SkyColor.GREEN_SEA, 0, 0);
				check.scaleX = 3;
				check.scaleY = 3;
				check.x = 6.5;
				check.y = 11;
				check.visible = false;
				container.addChild(check);
				
				cross = SkyUI.getForm(SkyUI.CROSS_ICON, SkyColor.RED_KRAYOLA, 0, 0);
				cross.scaleX = 2;
				cross.scaleY = 2;
				cross.x = 6.5;
				cross.y = 9;
				container.addChild(cross);
			}
			else
			{
				if (check != null)
				{
					container.removeChild(check);
					check.free();
					check = null;
					
					container.removeChild(cross);
					cross.free();
					cross = null;
				}
				
				if (textField != null) return;
				
				textField = new SkyTextField();
				textField.autoSize = "left";
				textField.embedFonts = true;
				textField.font = SkyFont.AKROBAT_BLACK;
				textField.size = 9;
				textField.textColor = SkyColor.RED_KRAYOLA;
				textField.text = "off";
				textField.x = (button.width - textField.width) / 2;
				textField.y = (button.height - textField.height) / 2;
				textField.mouseEnabled = false;
				button.addChild(textField);
			}
		}
		
		/**
		 * Заполнить сплошным цветом.
		 * @param	onColor цвет при включенной кнопке.
		 * @param	offColor цвет при выключенной кнопке.
		 */
		public function addFill(onColor:uint = SkyColor.GREEN_SEA, offColor:uint = SkyColor.RED_KRAYOLA):void
		{
			if (cross != null) cross.color = offColor;
			if (check != null) check.color = onColor;
			
			this.onColor = onColor;
			this.offColor = offColor;
			
			var left:SkyShape = new SkyShape();
			left.color = SkyColor.CLOUDS;
			left.drawRect(0, 0, 27, 21);
			left.x = 48;
			left.y = 2;
			left.alpha = 0;
			addChild(left);
			
			var right:SkyShape = new SkyShape();
			right.color = SkyColor.CLOUDS;
			right.drawRect(0, 0, 30, 21);
			right.x = -28;
			right.y = 2;
			right.alpha = 0;
			addChild(right);
			
			if (kind != SkyUI.RECTANGLE)
			{
				var radius:Number = (kind == SkyUI.CIRCLE) ? 20 : 8;
				
				var leftDown:SkyShape = SkyUI.getForm(SkyUI.IN_ROUND_RECTANGLE, SkyColor.CLOUDS, radius, 12);
				leftDown.alpha = 0;
				leftDown.y = 23;
				leftDown.x = 2;
				addChild(leftDown);
				
				var leftUp:SkyShape = SkyUI.getForm(SkyUI.IN_ROUND_RECTANGLE, SkyColor.CLOUDS, radius, 30);
				leftUp.rotation = 90;
				leftUp.alpha = 0;
				leftUp.y = 2;
				leftUp.x = 2;
				addChild(leftUp);
				
				var rightUp:SkyShape = SkyUI.getForm(SkyUI.IN_ROUND_RECTANGLE, SkyColor.CLOUDS, radius, 30);
				rightUp.rotation = 180;
				rightUp.x = 48;
				rightUp.y = 2;
				rightUp.alpha = 0;
				addChild(rightUp);
				
				var rightDown:SkyShape = SkyUI.getForm(SkyUI.IN_ROUND_RECTANGLE, SkyColor.CLOUDS, radius, 30);
				rightDown.rotation = 270;
				rightDown.y = 23;
				rightDown.x = 48;
				rightDown.alpha = 0;
				addChild(rightDown);
			}
			
			redRect = new SkyShape();
			redRect.color = SkyColor.RED_KRAYOLA;
			redRect.drawRect(0, 0, 37, 21);
			redRect.x = 11;
			redRect.y = 2;
			container.addChildAt(redRect, 0);
			
			greenRect = new SkyShape();
			greenRect.color = SkyColor.GREEN_SEA;
			greenRect.drawRect(0, 0, 37, 21);
			greenRect.x = -30;
			greenRect.y = 2;
			container.addChildAt(greenRect, 0);
		}
		
		/**
		 * Прозрачность.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			if (greenRect != null) greenRect.alpha = value;
			if (redRect != null) redRect.alpha = value;
			if (cross != null) cross.alpha = value;
			if (check != null) check.alpha = value;
			
			background.alpha = value;
			button.setAlpha(value);
			
			alpha = value;
		}
		
		/**
		 * Изменить цвета переключателя.
		 * @param	buttonColor цвет кнопки.
		 * @param	backgroundColor цвет фона.
		 * @param	onColor Цвет при активации кнопки.
		 * @param	offColor Цвет при диактивации кнопки.
		 */
		public function setColors(buttonColor:uint, backgroundColor:uint, onColor:uint, offColor:uint):void
		{
			if (greenRect != null) greenRect.color = onColor;
			if (redRect != null) redRect.color = offColor;
			if (cross != null) cross.color = offColor;
			if (check != null) check.color = onColor;
			
			background.color = backgroundColor;
			button.setColor(buttonColor);
			
			this.offColor = offColor;
			this.onColor = onColor;
		}
		
		/**
		 * Настроить шрифт текста.
		 * @param	font шрифт.
		 * @param	size размер.
		 */
		public function setFont(font:String, size:Number = 9):void
		{
			if (textField == null) return;
			textField.font = font;
			textField.size = size;
			
			var text:String = textField.text;
			textField.text = "";
			textField.text = text;
			textField.x = (button.width - textField.width) / 2;
			textField.y = (button.height - textField.height) / 2;
		}
		
		/**
		 * Переключить кнопку.
		 * @param	value true - включить, false - выключить.
		 */
		public function setActive(value:Boolean):void
		{
			isActive = value;
			
			container.x = 2;
			
			if (!isActive)
			{
				if (textField != null)
				{
					textField.text = "off";
					textField.textColor = offColor;
				}
				else
				{
					cross.visible = true;
					check.visible = false;
				}
				
				container.x = 2;
				move = false;
				isActive = false;
				speed = 0;
			}
			else
			{
				if (textField != null)
				{
					textField.text = "on";
					textField.textColor = onColor;
				}
				else
				{
					cross.visible = false;
					check.visible = true;
				}
				
				container.x = rightBorder;
				move = true;
				isActive = true;
				speed = 0;
			}
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			if (greenRect != null)
			{
				container.removeChild(greenRect);
				greenRect.free();
				greenRect = null;
			}
			
			if (redRect != null)
			{
				container.removeChild(redRect);
				redRect.free();
				redRect = null;
			}
			
			if (check != null)
			{
				container.removeChild(check);
				check.free();
				check = null;
			}
			
			if (cross != null)
			{
				container.removeChild(cross);
				cross.free();
				cross = null;
			}
			
			if (textField != null)
			{
				button.removeChild(textField);
				textField.free();
				textField = null;
			}
			
			container.removeChild(button);
			button.free();
			button = null;
			
			removeChild(container);
			container.free();
			container = null;
			
			removeChild(background);
			background.free();
			background = null;
			
			mFunction = null;
			mouse = null;
			
			if (numChildren > 0)
			{
				for (var i:int = 0; i < numChildren; i++) 
				{
					var child:SkyShape = SkyShape(getChildAt(0));
					removeChild(child);
					child.free();
					child = null;
				}
			}
			
			super.free();
		}
		
		/**
		 * Обновить данные.
		 * @param	deltaTime время прошедшее с последнего кадра.
		 */
		override public function updateData(deltaTime:Number):void 
		{
			if (move)
			{
				container.x += speed * deltaTime;
			}
			else
			{
				container.x -= speed * deltaTime;
			}
			
			if (mouse.isDown(SkyMouse.LEFT) && button.isClosestToMouse())
			{
				container.startDrag(false, true, 0, 0, 2, rightBorder);
			}
			else
			{
				container.stopDrag();
			}
			
			if (container.x <= 2)
			{
				if (isActive)
				{
					if (textField != null)
					{
						textField.textColor = offColor;
						textField.text = "off";
					}
					else
					{
						cross.visible = true;
						check.visible = false;
					}
					
					container.x = 2;
					
					move = false;
					isActive = false;
				}
				
				speed = 0;
			}
			
			if (container.x >= rightBorder)
			{
				if (!isActive)
				{
					if (textField != null)
					{
						textField.textColor = onColor;
						textField.text = "on";
					}
					else
					{
						cross.visible = false;
						check.visible = true;
					}
					
					container.x = rightBorder;
					move = true;
					isActive = true;
				}
				
				speed = 0;
				
				if (mFunction != null) mFunction.apply();
			}
			
			super.updateData(deltaTime);
		}
		
		/**
		 * Действия выполняемые при нажатии кнопки.
		 */
		private function action():void
		{
			move = !move;
			speed = MAX_SPEED;
		}
	}
}