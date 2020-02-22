package skysand.ui
{
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import skysand.text.SkyFont;
	import skysand.text.SkyTextField;
	import skysand.text.SkyBitmapText;
	import skysand.display.SkyShape;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.input.SkyMouse;
	import skysand.utils.SkyUtils;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyButton extends SkyRenderObjectContainer
	{
		//Состояния кнопоки.
		private const UP:uint = 0;
		private const OVER:uint = 1;
		private const DOWN:uint = 2;
		
		/**
		 * Включить или отключить анимацию кнопки.
		 */
		public var isAnimated:Boolean;
		
		/**
		 * Цвет кнопки.
		 */
		public var сolor:uint;
		
		/**
		 * Проверка на нажатие кнопки.
		 */
		public var isDown:Boolean;
		
		/**
		 * Графика кнопки.
		 */
		public var button:SkyShape;
		
		/**
		 * Текстовое поле.
		 */
		private var textField:SkyTextField;
		
		/**
		 * Текстовое поле из текстуры.
		 */
		private var bitmapTextField:SkyBitmapText;
		
		/**
		 * Рамка.
		 */
		private var frame:SkyShape;
		
		/**
		 * Спрайт для создания объёма.
		 */
		private var volumeSprite:SkyShape;
		
		/**
		 * Тень для кнопки.
		 */
		private var shadow:SkyShape;
		
		/**
		 * Ссылка на мышку.
		 */
		private var mouse:SkyMouse;
		
		/**
		 * Функция выполняемая при нажатии кнопки.
		 */
		private var mFunction:Function;
		
		/**
		 * Цвет текста в нормальном состоянии.
		 */
		private var textNormalState:uint;
		
		/**
		 * Цвет текста в нажатом состоянии.
		 */
		private var textDownState:uint;
		
		/**
		 * Цвет текста, когда курсор находится над кнопкой.
		 */
		private var textOverState:uint;
		
		/**
		 * Яркость, используется для анимации.
		 */
		private var bright:Number;
		
		/**
		 * Вид кнопки.
		 */
		private var kind:uint;
		
		/**
		 * Проверка на нажатие кнопки за её границами.
		 */
		private var isOut:Boolean;
		
		/**
		 * Объём для кнопки.
		 */
		private var volume:Boolean;
		
		/**
		 * Активна кнопка или нет.
		 */
		private var active:Boolean;
		
		/**
		 * Возвращать в функцию название кнопки, если добавлен текст.
		 */
		private var returnName:Boolean;
		
		/**
		 * Отображать текст слева или по центру.
		 */
		private var isLeftPosition:Boolean;
		
		/**
		 * Имя пакета отрисовки.
		 */
		public var batchName:String;
		
		public function SkyButton()
		{
			mouse = SkyMouse.instance;
			
			mouseEnabled = true;
			mFunction = null;
			
			textNormalState = 0x000000;
			textDownState = 0x000000;
			textOverState = 0x000000;
			сolor = 0x000000;
			bright = 0;
			kind = 0;
			
			isLeftPosition = false;
			isAnimated = true;
			volume = false;
			active = true;
			isOut = false;
			isDown = false;
			returnName = false;
			batchName = "shape";
		}
		
		/**
		 * Создать кнопку.
		 * @param shape ссылка на форму кнопки.
		 * @param mFunction функция, которая сработает в случае нажатия.
		 */
		public function createFromShape(shape:SkyShape, mFunction:Function):void
		{
			this.color = shape.color;
			this.width = shape.width;
			this.height = shape.height;
			this.mFunction = mFunction;
			
			button = shape;
			addChild(button);
			
			mouse.addFunctionOnClick(applyAction, SkyMouse.LEFT);
		}
		
		/**
		 * Создать кнопку.
		 * @param	kind форма кнопки, все доступные в SkyUI.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	color цвет.
		 * @param	mFunction функция, которая сработает в случае нажатия.
		 * @param	volume добавить объём кнопке.
		 * @param	modification модификации формы, все доступные в SkyUI.
		 */
		public function create(kind:uint, width:Number, height:Number, color:uint, mFunction:Function, volume:Boolean = false, modification:uint = 0):void
		{
			this.kind = kind;
			this.width = width;
			this.height = height;
			this.volume = volume;
			this.mFunction = mFunction;
			this.color = color;
			
			if (kind != SkyUI.RING && kind != SkyUI.FRAME)
			{
				volumeSprite = SkyUI.getForm(kind, SkyColor.setBright(color, -30), width, height, modification);
				volumeSprite.y = 6;
				volumeSprite.visible = volume;
				volumeSprite.rendererName = batchName;
				addChild(volumeSprite);
			}
			
			if (kind == SkyUI.FRAME || kind == SkyUI.RING)
			{
				button = SkyUI.getForm(SkyUI.RECTANGLE, color, width, height);
				button.alpha = 0;
				button.rendererName = batchName;
				addChild(button);
				
				frame = SkyUI.getForm(kind, color, width, height);
				addChild(frame);
			}
			else
			{
				button = SkyUI.getForm(kind, color, width, height, modification);
				button.rendererName = batchName;
				addChild(button);
			}
			
			mouse.addFunctionOnClick(applyAction, SkyMouse.LEFT);
		}
		
		/**
		 * Добавить тень под кнопку.
		 * @param	density прозрачность тени.
		 * @param	offsetX смещение тени по оси х.
		 * @param	offsetY смещение тени по оси у.
		 * @param	scaleX увеличение тени по оси х.
		 * @param	scaleY увеличение тени по оси у.
		 * @param	color цвет тени.
		 */
		public function addShadow(density:Number, offsetX:Number = 0, offsetY:Number = 0, scaleX:Number = 1, scaleY:Number = 1, color:uint = 0x000000):void
		{
			shadow = SkyUI.getForm(kind, color, width, height);
			shadow.alpha = density;
			shadow.x = offsetX;
			shadow.y = offsetY;
			shadow.scaleX = scaleX;
			shadow.scaleY = scaleY;
			addChildAt(shadow, 0);
		}
		
		/**
		 * Добавить текст поверх кнопки.
		 * @param	text текст.
		 * @param	font шрифт.
		 * @param	color цвет текста.
		 * @param	size размер шрифта.
		 * @param	embedFonts внешний или встроенный шрифт.
		 * @param	offsetX смещение шрифта по оси х.
		 * @param	offsetY смещение шрифта по оси у.
		 */
		public function addText(text:String, font:String, color:uint, size:int = 16, embedFonts:Boolean = true, offsetX:Number = 0, offsetY:Number = 0):void
		{
			if (textField != null) return;
			
			if (bitmapTextField != null)
			{
				button.removeChild(bitmapTextField);
				bitmapTextField.free();
				bitmapTextField = null;
			}
			
			textField = new SkyTextField();
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.embedFonts = embedFonts;
			textField.textColor = color;
			textField.font = font;
			textField.size = size;
			textField.text = text;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.x = (width - textField.textWidth - 3) / 2 + offsetX;
			textField.y = (height - textField.textHeight - 3) / 2 + offsetY;
			textField.mouseEnabled = false;
			button.addChild(textField);
			
			textNormalState = color;
			textDownState = color;
			textOverState = color;
		}
		
		/**
		 * Добавить текстовое поле из текстуры.
		 * @param	filePath путь к текстуре.
		 * @param	directory директория файла.
		 * @param	text текст.
		 * @param	color цвет.
		 */
		public function addBitmapText(name:String, text:String, color:uint):void
		{
			if (bitmapTextField != null) return;
			
			if (textField != null)
			{
				button.removeChild(textField);
				textField.free();
				textField = null;
			}
			
			bitmapTextField = new SkyBitmapText();
			bitmapTextField.setAtlasFromCache(name);
			bitmapTextField.textColor = color;
			bitmapTextField.text = text;
			bitmapTextField.x = (width - bitmapTextField.textWidth - 3) / 2;
			bitmapTextField.y = (height - bitmapTextField.textHeight - 3) / 2;
			button.addChild(bitmapTextField);
			
			textNormalState = color;
			textDownState = color;
			textOverState = color;
		}
		
		/**
		 * Добавить объём или убрать.
		 */
		public function setVolume(value:Boolean):void
		{
			volumeSprite.visible = value;
			volume = value;
		}
		
		/**
		 * Есть объём или нет.
		 */
		public function getVolume():Boolean
		{
			return volume;
		}
		
		/**
		 * Пересоздать кнопку.
		 * @param	kind форма кнопки, все доступные в SkyUI.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	modification модификация.
		 */
		public function recreate(kind:uint, width:Number, height:Number, modification:uint = 0):void
		{
			this.kind = kind;
			this.width = width;
			this.height = height;
			
			if (textField != null)
			{
				button.removeChild(textField);
			}
			
			if (bitmapTextField != null)
			{
				button.removeChild(bitmapTextField);
			}
			
			if (button != null)
			{
				removeChild(button);
				button.free();
				button = null;
			}
			
			if (kind == SkyUI.FRAME || kind == SkyUI.RING)
			{
				button = SkyUI.getForm(SkyUI.RECTANGLE, color, width, height);
				button.alpha = 0;
				//button.mouseEnabled = true;
				addChild(button);
				
				frame = SkyUI.getForm(kind, color, width, height);
				addChild(frame);
			}
			else
			{
				if (volume)
				{
					removeChild(volumeSprite);
					volumeSprite.free();
					volumeSprite = SkyUI.getForm(kind, SkyColor.setBright(color, -30), width, height);
					volumeSprite.y = 6;
					addChild(volumeSprite);
				}
				
				button = SkyUI.getForm(kind, color, width, height, modification);
				//button.mouseEnabled = true;
				addChild(button);
			}
			
			if (textField != null)
			{
				button.addChild(textField);
				
				textField.x = (width - textField.textWidth - 3) / 2;
				textField.y = (height - textField.textHeight - 3) / 2;
				textField.textColor = textNormalState;
			}
			
			if (bitmapTextField != null)
			{
				button.addChild(bitmapTextField);
				bitmapTextField.x = (width - bitmapTextField.textWidth - 3) / 2;
				bitmapTextField.y = (height - bitmapTextField.textHeight - 3) / 2;
			}
		}
		
		/**
		 * Изменить цвет кнопки.
		 * @param	color новый цвет.
		 */
		public function setColor(color:uint):void
		{
			this.color = color;
			button.color = color;
		}
		
		/**
		 * Изменить цвет текста.
		 * @param	normalStateColor цвет при нормальном состоянии кнопки.
		 * @param	downStateColor цвет во время нажатия кнопки.
		 * @param	overStateColor цвет при наведении курсора на кнопку.
		 */
		public function setTextColors(normalStateColor:uint, downStateColor:uint = 0, overStateColor:uint = 0):void
		{
			if (textField) textField.textColor = normalStateColor;
			if (bitmapTextField) bitmapTextField.textColor = normalStateColor;
			
			textNormalState = normalStateColor;
			textDownState = downStateColor != 0 ? downStateColor : normalStateColor;
			textOverState = overStateColor != 0 ? overStateColor : normalStateColor;
		}
		
		/**
		 * Изменить прозрачность.
		 * @param	value значение.
		 */
		public function setAlpha(value:Number):void
		{
			if (textField) textField.alpha = value;
			if (bitmapTextField) bitmapTextField.alpha = value;
			
			button.alpha = value;
			alpha = value;
		}
		
		/**
		 * Изменить текст кнопки.
		 * @param	text новый текст.
		 */
		public function setText(text:String):void
		{
			if (textField != null)
			{
				textField.text = text;
				textField.x = (width - textField.textWidth - 3) / 2;
				textField.y = (height - textField.textHeight - 3) / 2;
			}
			else if (bitmapTextField != null)
			{
				bitmapTextField.text = text;
				bitmapTextField.x = (width - bitmapTextField.textWidth - 3) / 2;
				bitmapTextField.y = (height - bitmapTextField.textHeight - 3) / 2;
			}
			else
			{
				throw new Error("Add text before setting by function addText(...)");
			}
		}
		
		/**
		 * Получить текст в текстовом поле.
		 * @return возвращает строку с текстом.
		 */
		public function getText():String
		{
			return textField != null ? textField.text : bitmapTextField != null ? bitmapTextField.text : "";
		}
		
		/**
		 * Изменить шрифт кнопки.
		 * @param	font шрифт.
		 * @param	fontSize размер шрифта.
		 */
		public function setFont(font:String, fontSize:uint = 16):void
		{
			if (textField != null)
			{
				var temp:String = textField.text;
				
				textField.text = "";
				textField.size = fontSize;
				textField.font = font;
				textField.text = temp;
				textField.x = (width - textField.textWidth - 3) / 2;
				textField.y = (height - textField.textHeight - 3) / 2;
			}
		}
		
		/**
		 * Изменить координаты текста на кнопке.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function setTextPosition(x:Number, y:Number):void
		{
			if (textField != null)
			{
				textField.x = x;
				textField.y = y;
			}
			
			if (bitmapTextField != null)
			{
				bitmapTextField.x = x;
				bitmapTextField.y = y;
			}
		}
		
		/**
		 * Сменить шрифт у растрового текстового поля.
		 * @param	filePath путь к файлу.
		 * @param	directory директория с файлом.
		 */
		public function setBitmapFont(name:String):void
		{
			if (bitmapTextField == null) return;
			
			var text:String = bitmapTextField.text
			button.removeChild(bitmapTextField);
			bitmapTextField.free();
			bitmapTextField = new SkyBitmapText();
			bitmapTextField.setAtlasFromCache(name);
			bitmapTextField.textColor = color;
			bitmapTextField.text = text;
			bitmapTextField.x = (width - bitmapTextField.textWidth - 3) / 2;
			bitmapTextField.y = (height - bitmapTextField.textHeight - 3) / 2;
			button.addChild(bitmapTextField);
		}
		
		/**
		 * Показать текст.
		 */
		public function showText():void
		{
			if (textField != null)
				textField.visible = true;
			
			if (bitmapTextField != null)
				bitmapTextField.visible = true;
		}
		
		/**
		 * Скрыть текст.
		 */
		public function hideText():void
		{
			if (textField != null)
				textField.visible = false;
				
			if (bitmapTextField != null)
				bitmapTextField.visible = false;
		}
		
		/**
		 * Изменить настройки тени.
		 * @param	density прозрачность тени.
		 * @param	offsetX смещение тени по оси х.
		 * @param	offsetY смещение тени по оси у.
		 * @param	scaleX увеличение тени по оси х.
		 * @param	scaleY увеличение тени по оси у.
		 * @param	color цвет тени.
		 */
		public function setShadow(density:Number, offsetX:Number = 0, offsetY:Number = 0, scaleX:Number = 1, scaleY:Number = 1, color:uint = 0x000000):void
		{
			if (shadow != null)
			{
				shadow.alpha = density;
				shadow.x = offsetX;
				shadow.y = offsetY;
				shadow.scaleX = scaleX;
				shadow.scaleY = scaleY;
				shadow.color = color;
			}
		}
		
		/**
		 * Показать текст.
		 */
		public function showShadow():void
		{
			if (shadow != null)
				shadow.visible = true;
		}
		
		/**
		 * Скрыть текст.
		 */
		public function hideShadow():void
		{
			if (shadow != null)
				shadow.visible = false;
		}
		
		/**
		 * Сменить функцию.
		 * @param	mFunction новая функция.
		 * @param	returnName возвращать в функцию название кнопки, если добавлен текст.
		 */
		public function setFunction(mFunction:Function, returnName:Boolean = false):void
		{
			this.mFunction = mFunction;
			this.returnName = returnName;
		}
		
		/**
		 * Выключить кнопку.
		 * @param alpha прозрачность.
		 */
		public function disable(alpha:Number = 0.4, color:uint = 0x000000):void
		{
			button.alpha = alpha;
			button.color = color;
			
			if (textField != null)
				textField.alpha = alpha;
			
			if (frame != null)
				frame.alpha = alpha;
			
			if (volumeSprite != null)
				volumeSprite.alpha = alpha;
			
			active = false;
		}
		
		/**
		 * Включить кнопку.
		 */
		public function enable():void
		{
			button.alpha = 1;
			button.color = color;
			
			if (textField != null)
				textField.alpha = 1;
			
			if (frame != null)
				frame.alpha = 1;
			
			if (volumeSprite != null)
				volumeSprite.alpha = 1;
			
			active = true;
		}
		
		
		/**
		 * Является ли кнопка ближайшей к курсору мыши.
		 */
		public function isClosestToMouse():Boolean
		{
			return this == SkyMouse.currentClosestObject;
		}
		
		/**
		 * Проверка на столкновение с курсором.
		 * @return true - столкновение, false - отсутствие столкновения.
		 */
		override public function hitTestMouse():Boolean 
		{
			return button.hitTestMouse();
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			if (textField != null)
			{
				button.removeChild(textField);
				textField.free();
				textField = null;
			}
			
			if (bitmapTextField != null)
			{
				button.removeChild(bitmapTextField);
				bitmapTextField.free();
				bitmapTextField = null;
			}
			
			if (frame != null)
			{
				removeChild(frame);
				frame.free();
				frame = null;
			}
			
			if (volumeSprite != null)
			{
				removeChild(volumeSprite);
				volumeSprite.free();
				volumeSprite = null;
			}
			
			if (shadow != null)
			{
				removeChild(shadow);
				shadow.free();
				shadow = null;
			}
			
			removeChild(button);
			button.free();
			button = null;
			
			mFunction = null;
			mouse.removeFunctionOnClick(applyAction, SkyMouse.LEFT);
			mouse = null;
			
			super.free();
		}
		
		/**
		 * Обновить данные кнопки.
		 */
		override public function updateData(deltaTime:Number):void
		{
			super.updateData(deltaTime);
			
			if (active)
			{
				if (button.hitTestBoundsWithMouse() && !isOut)
				{
					if (mouse.isDown(SkyMouse.LEFT))
					{
						changeState(DOWN, deltaTime);
						isDown = true;
					}
					else
					{
						changeState(OVER, deltaTime);
						isDown = false;
					}
				}
				else
				{
					if (mouse.isDown(SkyMouse.LEFT)) isOut = true;
					
					isDown = false;
					changeState(UP, deltaTime);
				}
			}
		}
		
		/**
		 * Анимация кнопки.
		 * @param	state состояние на которое нужно сменить кнопку.
		 * @param	deltaTime промежуток времени для зависимости анимации от времени.
		 */
		private function changeState(state:uint, deltaTime:Number):void
		{
			const STEP:Number = isAnimated ? 3 : 30;
			var speed:Number = 50 * deltaTime;
			
			if (state == OVER && bright < 30)
			{
				bright += STEP;
				
				if (kind == SkyUI.RING || kind == SkyUI.FRAME)
				{
					frame.color = SkyColor.setBright(color, bright);
					button.alpha = 0;
				}
				else button.color = SkyColor.setBright(color, bright);
				
				if (textField != null)
				{
					textField.textColor = textOverState;
				}
				
				if (bitmapTextField != null)
				{
					bitmapTextField.textColor = textOverState;
				}
				
				if (volume && button.y > 0)
				{
					button.y -= speed;
				}
			}
			
			if (state == DOWN && this == SkyMouse.currentClosestObject)
			{
				if (bright > -30)
				{
					bright -= STEP * 10;
					bright = bright < -30 ? -30 : bright;
					
					if (kind == SkyUI.RING || kind == SkyUI.FRAME)
					{
						frame.color = color;
						button.alpha = 1;
					}
					else button.color = SkyColor.setBright(color, bright);
				}
				
				if (textField != null)
				{
					textField.textColor = textDownState;
				}
				
				if (bitmapTextField != null)
				{
					bitmapTextField.textColor = textDownState;
				}
				
				if (volume && button.y < 6 - speed)
				{
					button.y += speed;
				}
			}
			
			if (state == UP && bright != 0)
			{
				bright = bright < 0 ? bright + STEP : bright - STEP;
				
				if (kind == SkyUI.RING || kind == SkyUI.FRAME)
				{
					frame.color = SkyColor.setBright(color, bright);
					button.alpha = 0;
				}
				else button.color = SkyColor.setBright(color, bright);
				
				if (textField != null)
				{
					textField.textColor = textNormalState;
				}
				
				if (bitmapTextField != null)
				{
					bitmapTextField.textColor = textNormalState;
				}
				
				if (volume && button.y > 0)
				{
					button.y -= speed;
				}
			}
		}
		
		/**
		 * Выполнить действие прикреплённое на кнопку.
		 */
		private function applyAction():void
		{
			if (isOut || !active || mFunction == null)
			{
				isOut = false;
				return;
			}
			
			if (this == SkyMouse.currentClosestObject)
			{
				var text:String = textField != null ? textField.text : bitmapTextField != null ? bitmapTextField.text : "";
				mFunction.apply(null, returnName ? [text] : null);
			}
		}
	}
}