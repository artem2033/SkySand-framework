package skysand.text 
{
	import flash.geom.Rectangle;
	import flash.filesystem.File;
	
	import skysand.display.SkyFrame;
	import skysand.display.SkyShape;
	import skysand.display.SkySprite;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.render.SkyStandartQuadBatch;
	import skysand.file.SkyTextureAtlas;
	import skysand.file.SkyFilesCache;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyBitmapText extends SkyRenderObjectContainer
	{
		/**
		 * Массив символов для отображения текста.
		 */
		public var symbols:Vector.<SkySprite>;
		
		/**
		 * Текстурный атлас с символами.
		 */
		private var atlas:SkyTextureAtlas;
		
		/**
		 * Текст.
		 */
		private var mText:String;
		
		/**
		 * Цвет текстового поля.
		 */
		private var mTextColor:uint;
		
		/**
		 * Граница.
		 */
		private var mBorder:SkyFrame;
		
		/**
		 * Фон.
		 */
		private var mBackground:SkyShape;
		
		/**
		 * Расстояние между строк.
		 */
		private var mLeading:Number;
		
		/**
		 * Отображать текст как пароль.
		 */
		private var mDisplayAsPassword:Boolean;
		
		/**
		 * Максимальное количество символов для отображения.
		 */
		private var mMaxChars:int;
		
		/**
		 * Расстояние между символами.
		 */
		private var mLetterSpacing:int;
		
		/**
		 * Цвет границы.
		 */
		private var mBorderColor:uint;
		
		/**
		 * Цвет фона.
		 */
		private var mBackgroundColor:uint;
		
		/**
		 * Количество символов в 1 табуляции.
		 */
		private var mTabLength:int;
		
		/**
		 * Ширина текста.
		 */
		private var mTextWidth:Number;
		
		/**
		 * Высота текста.
		 */
		private var mTextHeight:Number;
		
		/**
		 * Счётчик количества табов.
		 */
		private var tabCount:int;
		
		/**
		 * Имя пакета по умолчанию.
		 */
		private var batchName:String;
		
		public function SkyBitmapText() 
		{
			
		}
		
		/**
		 * Задать атлас из глобального кеша.
		 * @param	name название атласа.
		 * @param	batchName если нужно добавить в пакет с другим именем.
		 */
		public function setAtlasFromCache(name:String, batchName:String = ""):void
		{
			this.batchName = batchName;
			atlas = SkySand.cache.getTextureAtlas(name);
			initialize();
		}
		
		/**
		 * Задать текстурный атлас.
		 * @param	atlas ссылка на текстурный атлас.
		 * @param	batchName если нужно добавить в пакет с другим именем.
		 */
		public function setAtlas(atlas:SkyTextureAtlas, batchName:String = ""):void
		{
			this.batchName = batchName;
			this.atlas = atlas;
			initialize();
		}
		
		/**
		 * Проверка на столкновение с мышкой.
		 * @return возвращает true - столновение, false - отсутствие.
		 */
		override public function hitTestMouse():Boolean 
		{
			return hitTestBoundsWithMouse();
		}
		
		/**
		 * Деструктор.
		 */
		override public function free():void
		{
			var length:int = symbols.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				removeChild(symbols[i]);
				symbols[i].free();
				symbols[i] = null;
			}
			
			symbols.length = 0;
			symbols = null;
			atlas = null;
			
			if (mBorder)
			{
				removeChild(mBorder);
				mBorder.free();
				mBorder = null;
			}
			
			if (mBackground)
			{
				removeChild(mBackground);
				mBackground.free();
				mBackground = null;
			}
			
			super.free();
		}
		
		/**
		 * Закрасить текст в промежутке.
		 * @param	color цвет.
		 * @param	beginIndex номер символа с которого нужно начать закрашивать.
		 * @param	endIndex номер символа до которого нужно закрашивать.
		 */
		public function setColor(color:uint, beginIndex:int = 0, endIndex:int = -1):void
		{
			var length:int = endIndex > 0 ? endIndex : symbols.length;
			
			for (var i:int = beginIndex; i < length; i++) 
			{
				symbols[i].color = color;
			}
		}
		
		/**
		 * Добавляет строку, указанную параметром newText, в конец текста в текстовом поле.
		 * @param	newText новая строка.
		 */
		public function appendText(newText:String):void
		{
			var length:int = mText.length + newText.length;
			var symbolsLength:int = symbols.length;
			var symbolCount:int = 0;
			
			newText = length > mMaxChars && mMaxChars > 0 ? newText.substr(0, length - mMaxChars) : newText;
			length = mText.length + newText.length;
			
			if (length > symbolsLength)
			{
				for (var i:int = 0; i < length - symbolsLength; i++) 
				{
					var char:SkySprite = new SkySprite();
					char.setAtlas(atlas, batchName);
					char.setSpriteByIndex(33);
					char.color = mTextColor;
					char.visible = false;
					addChild(char);
					
					symbols.push(char);
				}
			}
			
			symbolsLength = mText.length;
			length = newText.length;
			mTextWidth += mLetterSpacing;
			mTextHeight -= symbols[0].height;
			
			for (i = 0; i < length; i++) 
			{
				char = symbols[i + symbolsLength];
				
				if (newText.charAt(i) == " " && !mDisplayAsPassword)
				{
					symbolCount++;
					mTextWidth += atlas.getSpriteByIndex(0).width + mLetterSpacing;
					char.visible = false;
					
					continue;
				}
				
				if (newText.charAt(i) == "\t" && !mDisplayAsPassword)
				{
					tabCount++;
					tabCount += int(symbolCount / mTabLength);
					symbolCount = 0;
					
					mTextWidth = atlas.getSpriteByIndex(54).width * 4 * tabCount + mLetterSpacing;
					char.visible = false;
					
					continue;
				}
				
				if (newText.charAt(i) == "\n" && !mDisplayAsPassword)
				{
					tabCount = 0;
					mTextWidth = 0;
					mTextHeight += atlas.getSpriteByIndex(54).height + mLeading;
					char.visible = false;
					
					continue;
				}
				
				char.visible = true;
				char.setSpriteByIndex(mDisplayAsPassword ? 10 : getCharIndex(newText.charCodeAt(i)));
				char.x = mTextWidth;
				char.y = mTextHeight;
				
				mTextWidth += char.width + mLetterSpacing;
				symbolCount++;
			}
			
			mTextWidth -= mLetterSpacing;
			mTextHeight += symbols[0].height;
			
			if (mBorder != null && mBorder.isVisible)
			{
				mBorder.setSize(mWidth, mHeight);
			}
		}
		
		/**
		 * Возвращает прямоугольник, который является ограничительным блоком символа.
		 * @param	charIndex номер символа.
		 * @return тип Rectangle.
		 */
		public function getCharBoundaries(charIndex:int):Rectangle
		{
			return new Rectangle(0, 0, symbols[charIndex].width, symbols[charIndex].height);
		}
		
		/**
		 * Возвращает значение индекса, отсчитываемое от нуля, для символа в точке, определенной параметрами x и y.
		 * @param	x координата x.
		 * @param	y координата y.
		 * @return значение индекса.
		 */
		public function getCharIndexAtPoint(x:Number, y:Number):int
		{
			var length:int = symbols.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var char:SkySprite = symbols[i];
				
				if (!char.visible) continue;
				if (char.hitTestBounds(x, y)) return i;
			}
			
			return -1;
		}
		
		/**
		 * Заменяет диапазон символов, заданный параметрами beginIndex и endIndex, содержанием параметра newText.
		 * @param	beginIndex начальный номер.
		 * @param	endIndex конечный номер.
		 * @param	newText текст.
		 */
		public function replaceText(beginIndex:int, endIndex:int, newText:String):void
		{
			var temp:String = mText.substring(0, beginIndex);
			temp += newText + mText.substring(endIndex);
			text = temp;
		}
		
		/**
		 * Отключить взаимодействие с курсором.
		 * @param	value true - включить/false - выключить.
		 */
		public function setMouseEnabled(value:Boolean):void
		{
			for (var i:int = 0; i < symbols.length; i++) 
			{
				symbols[i].mouseEnabled = value;
			}
			
			mouseEnabled = value;
		}
		
		/**
		 * Задать размеры фона текстового поля.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function setBackgroundSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
			
			if (mBackground == null) return;
			
			mBackground.width = width;
			mBackground.height = height;
		}
		
		/**
		 * Прозрачность текстового поля.
		 */
		override public function set alpha(value:Number):void 
		{
			if (mAlpha != value)
			{
				mAlpha = value;
				var length:int = symbols.length;
				
				for (var i:int = 0; i < length; i++) 
				{
					symbols[i].alpha = value;
				}
				
				if (mBackground != null) mBackground.alpha = value;
			}
		}
		
		/**
		 * Инициализация текстового поля.
		 */
		private function initialize():void
		{
			symbols = new Vector.<SkySprite>();
			
			mText = "";
			tabCount = 0;
			mLeading = 0;
			mMaxChars = -1;
			mTabLength = 4;
			mTextWidth = 0;
			mTextHeight = 0;
			mLetterSpacing = -5;
			mTextColor = 0xFFFFFF;
			mBorderColor = 0x000000;
			mBackgroundColor = 0x000000;
			mDisplayAsPassword = false;
		}
		
		/**
		 * Получить индекс символа в атласе через его код.
		 * @param	code код символа.
		 * @return возвращает индекс символа в атласе.
		 */
		private function getCharIndex(code:int):int
		{
			return code == 1025 ? 95 : code == 1105 ? 160 : code < 127 ? code - 32 : code < 1104 ? code - 944 : 161;
		}
		
		/**
		 * Текст в текстовом поле.
		 */
		public function set text(value:String):void
		{
			if (mText != value)
			{
				mText = value.length > mMaxChars && mMaxChars > 0 ? value.substr(0, mMaxChars) : value;
				
				var length:int = mText.length;
				var symbolsLength:int = symbols.length;
				
				if (length > symbolsLength)
				{
					for (var i:int = 0; i < length - symbolsLength; i++) 
					{
						var char:SkySprite = new SkySprite();
						char.setAtlas(atlas, batchName);
						char.setSpriteByIndex(33);
						char.color = mTextColor;
						char.visible = false;
						addChild(char);
						
						symbols.push(char);
					}
				}
				
				mTextWidth = 0;
				mTextHeight = 0;
				symbolsLength = symbols.length;
				tabCount = 0;
				var symbolCount:int = 0;
				
				for (i = 0; i < symbolsLength; i++) 
				{
					char = symbols[i];
					
					if (i < length)
					{
						if (mText.charAt(i) == " " && !mDisplayAsPassword)
						{
							symbolCount++;
							mTextWidth += atlas.getSpriteByIndex(0).width + mLetterSpacing;
							char.visible = false;
							
							continue;
						}
						
						if (mText.charAt(i) == "\t" && !mDisplayAsPassword)
						{
							tabCount++;
							tabCount += int(symbolCount / mTabLength);
							symbolCount = 0;
							
							mTextWidth = atlas.getSpriteByIndex(54).width * 4 * tabCount + mLetterSpacing;
							char.visible = false;
							
							continue;
						}
						
						if (mText.charAt(i) == "\n" && !mDisplayAsPassword)
						{
							tabCount = 0;
							mTextWidth = 0;
							mTextHeight += atlas.getSpriteByIndex(54).height + mLeading;
							char.visible = false;
							
							continue;
						}
						
						char.visible = true;
						char.setSpriteByIndex(mDisplayAsPassword ? 10 : getCharIndex(mText.charCodeAt(i)));
						char.x = mTextWidth;
						char.y = mTextHeight;
						
						mTextWidth += char.width + mLetterSpacing;
						symbolCount++;
					}
					else char.visible = false;
				}
				
				mTextWidth -= mLetterSpacing;
				mTextHeight += symbols[0].height;
				
				if (mBorder != null && mBorder.isVisible)
				{
					mBorder.setSize(mWidth, mHeight);
				}
			}
		}
		
		/**
		 * Текст в текстовом поле.
		 */
		public function get text():String
		{
			return mText;
		}
		
		/**
		 * Цвет фона.
		 */
		public function set textColor(value:uint):void
		{
			if (mTextColor != value)
			{
				var length:int = symbols.length;
				
				for (var i:int = 0; i < length; i++) 
				{
					symbols[i].color = value;
				}
				
				mTextColor = value;
			}
		}
		
		/**
		 * Цвет фона.
		 */
		public function get textColor():uint
		{
			return mTextColor;
		}
		
		/**
		 * Скрыть/Показать фон.
		 */
		public function set background(value:Boolean):void
		{
			if (mBackground)
			{
				mBackground.width = width;
				mBackground.height = height;
				mBackground.visible = value;
				
				return;
			}
			
			if (mBackground == null && value)
			{
				mBackground = new SkyShape();
				mBackground.drawRect(0, 0, 2, 2);
				mBackground.color = mBackgroundColor;
				mBackground.width = width;
				mBackground.height = height;
				addChildAt(mBackground, 0);
			}
		}
		
		/**
		 * Скрыть/Показать фон.
		 */
		public function get background():Boolean
		{
			return mBackground ? mBackground.visible : false;
		}
		
		/**
		 * Цвет фона.
		 */
		public function get backgroundColor():uint
		{
			return mBackgroundColor;
		}
		
		/**
		 * Цвет фона.
		 */
		public function set backgroundColor(value:uint):void
		{
			mBackgroundColor = value;
			
			if (mBackground) mBackground.color = value;
		}
		
		/**
		 * Нарисовать границу текстового поля.
		 */
		public function get border():Boolean
		{
			return mBorder ? mBorder.visible : false;
		}
		
		/**
		 * Нарисовать границу текстового поля.
		 */
		public function set border(value:Boolean):void
		{
			if (mBorder)
			{
				mBorder.visible = value;
				mBorder.setSize(mWidth, mHeight);
				
				return;
			}
			
			if (!mBorder && value)
			{
				mBorder = new SkyFrame();
				mBorder.create(mWidth, mHeight);
				mBorder.color = mBorderColor;
				addChild(mBorder);
			}
		}
		
		/**
		 * Цвет границы.
		 */
		public function get borderColor():uint
		{
			return mBorderColor;
		}
		
		/**
		 * Цвет границы.
		 */
		public function set borderColor(value:uint):void
		{
			mBorderColor = value;
			
			if (mBorder) mBorder.color = value;
		}
		
		/**
		 * Показывает, является ли текстовое поле полем пароля.
		 */
		public function get displayAsPassword():Boolean
		{
			return mDisplayAsPassword;
		}
		
		/**
		 * Показывает, является ли текстовое поле полем пароля.
		 */
		public function set displayAsPassword(value:Boolean):void
		{
			if (value != mDisplayAsPassword)
			{
				var length:int = mText.length;
				
				width = 0;
				
				for (var i:int = 0; i < length; i++) 
				{
					var char:SkySprite = symbols[i]
					char.setSprite("*");
					char.x = width;
					
					width += char.width + mLetterSpacing;
				}
				
				if (mBackground && mBackground.visible)
				{
					mBackground.width = width;
					mBackground.height = height;
				}
				
				if (mBorder != null && mBorder.isVisible)
				{
					mBorder.setSize(mWidth, mHeight);
				}
				
				mDisplayAsPassword = value;
			}
		}
		
		/**
		 * Число символов в текстовом поле.
		 */
		public function get length():int
		{
			return mText.length;
		}
		
		/**
		 * Введенное пользователем максимальное число символов, которое может содержать текстовое поле.
		 */
		public function get maxChars():int
		{
			return mMaxChars;
		}
		
		/**
		 * Введенное пользователем максимальное число символов, которое может содержать текстовое поле.
		 */
		public function set maxChars(value:int):void
		{
			if (value < 0)
			{
				mMaxChars = value;
				return;
			}
			
			if (mMaxChars != value)
			{	
				mMaxChars = value;
				
				if (symbols.length < value) return;
				
				while (symbols.length > value)
				{
					var char:SkySprite = symbols.pop()
					mTextWidth -= char.width + mLetterSpacing;
					
					removeChild(char);
					char.free();
					char = null;
				}
				
				if (mBackground && mBackground.visible)
				{
					mBackground.width = width;
					mBackground.height = height;
				}
				
				if (mBorder != null && mBorder.isVisible)
				{
					mBorder.setSize(mWidth, mHeight);
				}
			}
		}
		
		/**
		 * Определяет число строк текста в многострочном текстовом поле.
		 */
		public function get numLines():int
		{
			return int(mTextHeight / atlas.getSpriteByIndex(82).height);
		}
		
		/**
		 * Высота текста в пикселях.
		 */
		public function get textHeight():Number
		{
			return mTextHeight
		}
		
		/**
		 * Ширина текста в пикселях.
		 */
		public function get textWidth():Number
		{
			return mTextWidth
		}
		
		/**
		 * Задать расстояние между строками.
		 */
		public function set leading(value:Number):void
		{
			if (mLeading != value)
			{
				mLeading = value;
				
				var temp:String = mText;
				text = "";
				text = temp;
			}
		}
		
		/**
		 * Задать расстояние между строками.
		 */
		public function get leading():Number
		{
			return mLeading;
		}
		
		/**
		 * Задать расстояние между строками.
		 */
		public function set tabLength(value:Number):void
		{
			if (mTabLength != value)
			{
				mTabLength = value;
				
				var temp:String = mText;
				text = "";
				text = temp;
			}
		}
		
		/**
		 * Задать расстояние между строками.
		 */
		public function get tabLength():Number
		{
			return mTabLength;
		}
		
		/**
		 * Задать расстояние между буквами.
		 */
		public function set letterSpacing(value:Number):void
		{
			if (mLetterSpacing != value)
			{
				mLetterSpacing = value;
				
				var temp:String = mText;
				text = "";
				text = temp;
			}
		}
		
		/**
		 * Задать расстояние между буквами.
		 */
		public function get letterSpacing():Number
		{
			return mLetterSpacing;
		}
		
		/**
		 * Шрифт.
		 */
		public function get font():String
		{
			return atlas.name.substring(0, atlas.name.length - 2);
		}
		
		/**
		 * Размер шрифта.
		 */
		public function get fontSize():Number
		{
			return Number(atlas.name.substring(atlas.name.length - 2));
		}
		
		/**
		 * Получить пакет отрисовки символов.
		 */
		public function get batch():SkyStandartQuadBatch
		{
			return symbols[0].batch;
		}
	}
}