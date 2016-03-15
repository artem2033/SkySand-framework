package skysand.text 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import skysand.utils.SkyMath;
	import skysand.keyboard.SkyKey;
	import skysand.keyboard.SkyKeyboard;
	import skysand.mouse.SkyMouse;
	import skysand.render.RenderObject;
	
	use namespace framework;
	//TODO: refactoring.
	//TODO: add another text field options.
	//Version 18th of november 2015 - 0.84;
	
	public class TextArea extends RenderObject
	{
		/**
		 * Динамическое текстовое поле.
		 */
		public static const DYNAMIC:uint = 1;
		
		/**
		 * Текcтовое поле ввода.
		 */
		public static const INPUT:uint = 2;
		
		/**
		 * Тип текстового поля.
		 */
		public var type:uint;
		
		/**
		 * Правый отступ от края текстового поля.
		 */
		public var rightMargin:Number;
		
		/**
		 * Левый отступ от края текстового поля.
		 */
		public var leftMargin:Number;
		
		/**
		 * Расстояние между строками.
		 */
		public var leading:Number;
		
		/**
		 * Абзац.
		 */
		public var indent:Number;
		
		public var autoSize:Boolean = false;
		
		/**
		 * При нажатии ентер переходить на новую строку.
		 */
		public var multiline:Boolean;
		
		/**
		 * Логическое значение, определяющее, можно ли выбрать текстовое поле.
		 */
		public var selectable:Boolean;
		
		/**
		 * Индекс каретки.
		 */
		private var _caretIndex:int;
		
		/**
		 * Расстояние между буквами.
		 */
		public var letterSpacing:Number;
		
		/**
		 * Перенос на новый строку.
		 */
		public var wordWrap:Boolean;
		
		/**
		 * Отображать звёздочки вместо символов.
		 */
		public var displayAsPassword:Boolean;
		
		/**
		 * Максимум символов в поле.
		 */
		public var maxChars:int;
		
		/**
		 * Доступные символы ввода.
		 */
		public var restrict:String;
		
		/**
		 * Фокус на текстовое поле.
		 */
		private var focusOn:Boolean;
		
		/**
		 * Массив с данными о каждом символе.
		 */
		private var charsData:Vector.<CharData>;
		
		/**
		 * Число букв в текстовом поле.
		 */
		private var numChars:int;
		
		/**
		 * Таблица с символами.
		 */
		private var charTable:CharTable;
		
		/**
		 * Позиция последнего введёного символа.
		 */
		public var position:Point;
		
		/**
		 * Координата смещения текта.
		 */
		private var positionScroll:Point;
		
		/**
		 * Ссылка на клавиатуру.
		 */
		private var keyboard:SkyKeyboard;
		
		/**
		 * Прямоугольник для очистки текстового поля.
		 */
		private var rectangle:Rectangle;
		
		/**
		 * Символ ввода текста.
		 */
		private var caret:RenderObject;
		
		/**
		 * Счётчик для мигания сивола ввода текста.
		 */
		private var caretCountTimer:uint;
		
		/**
		 * Первый символ на новой строке.
		 */
		private var firstSymbol:Boolean;
		/**
		 * Введёный текст.
		 */
		protected var _text:String;
		
		/**
		 * Текущий цвет текста.
		 */
		protected var _textColor:uint;
		
		/**
		 * Текущий цвет фона.
		 */
		protected var _backgroundColor:uint;
		
		/**
		 * Рисовать ли фон для текстового поля.
		 */
		protected var _background:Boolean;
		
		/**
		 * Размер текста.
		 */
		protected var _size:Number;
		
		/**
		 * Число строк.
		 */
		protected var _numLines:int;
		
		/**
		 * Максимальное смещение по вертикали.
		 */
		protected var _maxScrollV:int;
		
		/**
		 * Максимальное смещение по горизонтали.
		 */
		protected var _maxScrollH:int;
		
		/**
		 * Текущее смещение по вертикали.
		 */
		protected var _scrollV:int;
		
		/**
		 * Текущее смещение по горизонтали.
		 */
		protected var _scrollH:int;
		
		/**
		 * 
		 */
		private var lastWidth:Number = 0;
		
		public function TextArea() 
		{
			super();
			initialize();
		}
		
		/**
		 * Добавить текст в конец текстового поля.
		 * @param value добавляемый текст.
		 */
		public function appendText(value:String):void
		{
			var length:int = value.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				if (maxChars > 0 && numChars < maxChars)
				{
					drawChar(value.charAt(i));
					_text += value;
				}
				else if (maxChars == -1)
				{
					drawChar(value.charAt(i));
					_text += value;
				}
			}
			
			autoSizer();
		}
		
		/**
		 * Получить индекс первого символа в строке, заданной параметром lineIndex.
		 * @param	lineIndex номер строки.
		 * @return возвращает номер символа.
		 */
		public function getLineOffset(lineIndex:int):int
		{
			for (var i:int = 0; i < numChars; i++) 
			{
				var char:CharData = charsData[i];
				
				if (char.y == (_size + leading) * lineIndex)
				{
					return i;
				}
			}
			
			return 0;
		}
		
		/**
		 * Получтиь длину строки в текстовом поле по индексу.
		 * @param	lineIndex номер строки.
		 * @return возвращает длину строки.
		 */
		public function getLineLength (lineIndex:int):int
		{
			var beginIndex:int = getLineOffset(lineIndex);
			var endIndex:int = getLineOffset(lineIndex + 1);
			
			return endIndex == 0 ? numChars - beginIndex : endIndex - beginIndex;
		}
		
		/**
		 * Получтиь строку в текстовом поле по индексу.
		 * @param	lineIndex номер строки.
		 * @return возвращает строку.
		 */
		public function getLineText(lineIndex:int):String
		{
			var string:String = "";
			var beginIndex:int = getLineOffset(lineIndex);
			var endIndex:int = getLineOffset(lineIndex + 1);
			
			endIndex = endIndex == 0 ? numChars : endIndex;
			
			for (var i:int = beginIndex; i < endIndex; i++)
			{
				string += _text.charAt(i);
			}
			
			return string;
		}
		
		/**
		 * Получить номер линии в точке.
		 * @param	x координата.
		 * @param	y координата.
		 * @return возвращает номер линии.
		 */
		public function getLineIndexAtPoint (x:Number, y:Number):int
		{
			if (numChars == 0) return -1;
			
			for (var i:int = 0; i < _numLines + 1; i++) 
			{
				var char:CharData = charsData[i + getLineOffset(i)];
				
				if (char.y + _size / 2 > y - _size - globalY)
				{
					return i;
				}
			}
			
			return -1;
		}
		
		/**
		 * Получить номер символа в точке.
		 * @param	x координата.
		 * @param	y координата.
		 * @return возвращает номер символа.
		 */
		public function getCharIndexAtPoint(x:Number, y:Number):int
		{
			if (numChars == 0)
			{
				caret.x = -2;
				caret.y = 0;
				return -1;
			}
			
			if (charsData[numChars - 1].x + charsData[numChars - 1].width < x - globalX)
			{
				return numChars;
			}
			
			for (var i:int = 0; i < numChars; i++) 
			{
				var symbol:CharData = charsData[i];
				
				if (symbol.x + symbol.width / 2 > x - globalX)
				{
					if (symbol.y + _size / 2 > y - _size - globalY)
					{
						return i;
					}
				}
			}
			
			return 0;
		}
		
		/**
		 * Отсчитываемое от нуля значение индекса для строки, которая содержит символ, заданный параметром charIndex.
		 * @param	charIndex номер символа.
		 * @return возвращает номер строки, содержащей символ.
		 */
		public function getLineIndexOfChar(charIndex:int):int
		{
			return getLineIndexAtPoint(charsData[charIndex].x, charsData[charIndex].y);
		}
		
		/**
		 * Получить ограничивающий прямоугольник символа.
		 * @param	charIndex номер символа.
		 * @return возвращает ограничивающий прямоугольник.
		 */
		public function getCharBoundaries(charIndex:int):Rectangle
		{
			return charsData[charIndex].bitmapData.rect;
		}
		
		/**
		 * Ширина текста в текстовом поле.
		 * @return возвращает ширину.
		 */
		public function textWidth():int
		{
			var value:int = int.MIN_VALUE;
			
			for (var i:int = 0; i < numChars; i++) 
			{
				var char:CharData = charsData[i];
				
				value = char.x + char.width > value ? char.x + char.width : value;
			}
			
			return value;
		}
		
		/**
		 * Высота текста в текстовом поле.
		 * @return возвращает высоту.
		 */
		public function textHeight():int
		{
			return _size * _numLines + _size;
		}
		
		/**
		 * Заменить текст в текстовом поле
		 * @param	startIndex начальный индекс.
		 * @param	endIndex конечный индекс.
		 * @param	string текст на который заменяем.
		 */
		public function replaceText(startIndex:int, endIndex:int, string:String):void
		{
			var temp:String = _text.slice(0, startIndex);
			
			temp += string;
			temp += _text.slice(endIndex, numChars);
			text = temp;
		}
		
		override public function free():void
		{
			
		}
		
		private function autoSizer():void
		{
			if (!autoSize) return;
			if (numChars <= 0) return;
			/*
			var maxLineLenght:Number = 0;
			
			for (var i:int = 0; i < _numLines; i++)
			{
				maxLineLenght = getLineLength(i) > maxLineLenght ? getLineLength(i) : maxLineLenght;
			}
			
			width = maxLineLenght;
			//height = (_size + indent) * _numLines;*/
		}
		
		/**
		 * Обновление текстового поля.
		 */
		public function localUpdate():void
		{
			if (type == TextArea.INPUT)
			{
				if (hitTestMouse()) Mouse.cursor = MouseCursor.IBEAM;
				else Mouse.cursor = MouseCursor.ARROW;
				
				if (SkyMouse.instance.LBMPressed)
				{
					if (hitTestMouse() && selectable)
					{
						controlKeys();
						setCaretInMousePosition();
						caret.visible = true;
						focusOn = true;
					}
					else
					{
						focusOn = false;
						caret.visible = false;
						caretCountTimer = 0;
					}
				}
				
				if (focusOn)
				{
					if (_caretIndex > numChars - 1)
					{
						if (numChars > 0)
						{
							caret.x = charsData[numChars - 1].x + charsData[numChars - 1].width - 2;
							caret.y = charsData[numChars - 1].y;
						}
					}
					else if (_caretIndex == 0)
					{
						caret.x = -2;
						caret.y = 0;
					}
					else
					{
						caret.x = charsData[_caretIndex].x - 2;
						caret.y = charsData[_caretIndex].y;
					}
					
					caretCountTimer++;
					
					if (caretCountTimer == 30) //To normal time.
					{
						caret.visible = !caret.visible;
						caretCountTimer = 0;
					}
					
					if (keyboard.anyCharKeyDown)
					{
						if (numChars > 0)
						{
							if (_caretIndex < numChars)
							{
								replaceText(_caretIndex, _caretIndex, keyboard.char);
							}
							else
							{
								appendText(keyboard.char);
							}
							
							//transferWords();
						}
						else
						{
							appendText(keyboard.char);
						}
						
						_caretIndex++;
						
						keyboard.anyCharKeyDown = false;
					}		
				}
			}
		}
		
		private function transferWords():void
		{
			if (_text.indexOf('\n') == -1) return;
			
			var index:int = _text.indexOf('\n');
			//charsData.splice(index, 1);
			//numChars--;
			
			if (_text.charAt(index + 1) != ' ')
			{
				var index2:int = _text.lastIndexOf(' ', index);
				replaceText(index2 + 1, index2 + 1, '\n');
			}
		}
		
		private function keySpace():void
		{
			flag = true;
		}
		
		private function keyLeft():void
		{
			if (!focusOn) return;
			
			if (_caretIndex > 0) _caretIndex--;
			else _caretIndex = 0;
		}
		
		private function keyRight():void
		{
			if (!focusOn) return;
			
			if (_caretIndex < numChars) _caretIndex++;
			else _caretIndex = numChars;
		}
		
		private function keyUp():void
		{
			if (!focusOn) return;
		}
		
		private function keyDown():void
		{
			if (!focusOn) return;
			
			//_caretIndex = 
		}
		
		private function keyEnter():void
		{
			if (!focusOn) return;
			
			if (multiline)
			{
				replaceText(_caretIndex, _caretIndex, '\n');
				_caretIndex = numChars;
				caret.y += _size + leading;
			}
		}
		
		private function keyBackspace():void
		{
			if (!focusOn) return;
			
			if (numChars == 1) caret.x = -2;
			
			if (_caretIndex > 0)
			{
				replaceText(_caretIndex - 1, _caretIndex, "");
				_caretIndex--;
			}
			else _caretIndex = 0;
		}
		
		private function controlKeys():void
		{
			keyboard.addFunctionToKey(SkyKey.BACKSPACE, keyBackspace, true);
			keyboard.addFunctionToKey(SkyKey.ENTER, keyEnter, true);
			keyboard.addFunctionToKey(SkyKey.LEFT, keyLeft, true);
			keyboard.addFunctionToKey(SkyKey.RIGHT, keyRight, true);
			keyboard.addFunctionToKey(SkyKey.DOWN, keyDown, true);
			keyboard.addFunctionToKey(SkyKey.SPACE, keySpace, true);
		}
		
		//???
		private function alwaysShowSelection():Boolean
		{
			return false;//При значении true и отсутствии фокуса на текстовом поле проигрыватель Flash Player выделяет фрагмент в текстовом поле серым цветом.
		}
		
		public function set align(value:uint):void
		{
			
		}
		
		public function set bold(value:int):void
		{
			charTable.bold = value;
		}
		
		public function set font(value:String):void
		{
			charTable.font = value;
		}
		
		public function set kerning(value:uint):void
		{
			
		}
		
		public function set italic(value:Boolean):void
		{
			charTable.italic = value;
		}
		
		public function set size(value:uint):void
		{
			charTable.size = value;
			caret.bitmapData.dispose();
			caret.bitmapData = charTable.getChar(124).clone();
			_size = value;
		}
		
		public function get size():uint
		{
			return _size;
		}
		
		/**
		 * Инициализация класса.
		 */
		private function initialize():void
		{
			bitmapData = new BitmapData(1, 1, true, 0x000000);
			charsData = new Vector.<CharData>();
			charTable = new CharTable();
			positionScroll = new Point();
			position = new Point();
			keyboard = SkyKeyboard.instance;
			rectangle = new Rectangle();
			caret = new RenderObject();
			caret.bitmapData = charTable.getChar(124).clone();
			caret.visible = false;
			caret.width = caret.bitmapData.width;
			caret.height = caret.bitmapData.height;
			caret.x = 0;
			caret.y = 0;
			addChild(caret);
			
			focusOn = false;
			wordWrap = false;
			firstSymbol = true;
			multiline = false;
			selectable = true;
			_background = false;
			displayAsPassword = false;
			
			caretCountTimer = 0;
			letterSpacing = 0;
			rightMargin = 4;
			type = DYNAMIC;
			leftMargin = 0;
			_caretIndex = 0;
			numChars = 0;
			leading = 1;
			indent = 0;
			maxChars = -1;
			_scrollH = 0;
			_scrollV = 0;
			_maxScrollH = 0;
			_maxScrollV = 0;
			_numLines = 0;
			_backgroundColor = 0x000000;
			_textColor = 0x000000;
			_text = "";
			restrict = "";
			
			super.width = 1;
			super.height = 1;
			
			_size = charTable.getChar(99).height - 3;
		}
		
		/**
		 * Отрисовать текст.
		 * @param	text текст.
		 */
		public function drawText(text:String):void
		{
			position.x = 0;
			position.y = 0;
			rectangle.width = width;
			rectangle.height = height;
			
			bitmapData.fillRect(rectangle, _backgroundColor);
			
			var length:int = text.length;
			
			for (var i:int = 0; i < length; i++)
			{
				drawChar(_text.charAt(i));
			}
		}
		
		private var flag:Boolean = false;
		
		private function calculateCharPosition(char:BitmapData):void
		{
			if (!wordWrap && position.x > width - rightMargin)
			{
				_maxScrollH++;
				
				rectangle.width = width;
				rectangle.height = height;
				
				bitmapData.fillRect(rectangle, _backgroundColor);
				
				for (var i:int = 0; i < numChars; i++) 
				{
					var chars:CharData = charsData[i];
					if (!chars.bitmapData) continue;
					
					chars.x -= char.width - letterSpacing;
					positionScroll.y = chars.y;
					positionScroll.x = chars.x;
					bitmapData.copyPixels(chars.bitmapData, chars.bitmapData.rect, positionScroll);
				}
				
				position.x -= char.width - letterSpacing;
			}
			
			if (!firstSymbol && numChars > 0)
			{
				var lastChar:CharData = charsData[numChars - 1];
				position.x = lastChar.x + lastChar.width + letterSpacing;
			}
			else
			{
				firstSymbol = false;
				position.x = leftMargin + indent;
			}
			
			if (!wordWrap && position.x > width - rightMargin)
			{
				_maxScrollH++;
				
				rectangle.width = width;
				rectangle.height = height;
				
				bitmapData.fillRect(rectangle, _backgroundColor);
				
				for (i = 0; i < numChars; i++)
				{
					chars = charsData[i];
					if (!chars.bitmapData) continue;
					
					chars.x -= char.width - letterSpacing;
					positionScroll.y = chars.y;
					positionScroll.x = chars.x;
					bitmapData.copyPixels(chars.bitmapData, chars.bitmapData.rect, positionScroll);
				}
				
				position.x -= char.width - letterSpacing;
				
			}
			else if (wordWrap && position.x > width - rightMargin - char.width)
			{
				position.y += _size + leading;
				position.x = leftMargin + indent;
				
				_numLines++
				
				if (position.y >= height - _size)
				{
					if (type == TextArea.INPUT)
					{
						position.y = charsData[numChars - 1].y;
						position.x = indent + leftMargin
						rectangle.width = width;
						rectangle.height = height;
						
						bitmapData.fillRect(rectangle, _backgroundColor);
						
						for (i = 0; i < numChars; i++) 
						{
							chars = charsData[i];
							if (!chars.bitmapData) continue;
							
							chars.y -= (_size + leading);
							positionScroll.y = chars.y;
							positionScroll.x = chars.x;
							bitmapData.copyPixels(chars.bitmapData, chars.bitmapData.rect, positionScroll);
						}
					}
					
					_maxScrollV++;
				}
			}
		}
		
		/**
		 * Нарисовать символ.
		 * @param	_char символ.
		 */
		private function drawChar(_char:String):void
		{
			if (specialSymbol(_char))
			{
				var charData:CharData = new CharData();
				charData.x = 0;
				charData.y = position.y;
				charsData.push(charData);
				
				numChars++;
				return;
			}
			
			var char:BitmapData = displayAsPassword ? charTable.getChar(42) : charTable.getChar(_char.charCodeAt(0));
			
			if (restrict != "")
			{
				var length:int = restrict.length;
				
				for (var i:int = 0; i < length; i++) 
				{
					if (_char == restrict.charAt(i)) break;
					else if (i == length - 1 && _char != restrict.charAt(i)) return;
				}
			}
			
			calculateCharPosition(char);
			
			bitmapData.copyPixels(char, char.rect, position);
			
			charData = new CharData();
			charData.width = char.width;
			charData.height = char.height;
			charData.x = position.x;
			charData.y = position.y;
			charData.bitmapData = char;
			charsData.push(charData);
			
			numChars++;
		}
		
		/**
		 * Специальные символы (\n)(\t).
		 * @param	_char символ.
		 * @return присутствует ли данный символ.
		 */
		private function specialSymbol(_char:String):Boolean
		{
			if (_char == '\w')
			{
				//var index:int = _text.indexOf('\w');
				
				/*var string:String = "";
				
				for (i = index; i < numChars; i++)
				{
					string += _text.charAt(i);
				}
				
				replaceText(index, numChars, "");
				
				position.y += _size + leading;
				position.x = leftMargin + indent;
				firstSymbol = true;
				_numLines++;*/
			}
			
			if (_char == '\n')
			{
				position.y += _size + leading;
				position.x = leftMargin + indent;
				_numLines++
				firstSymbol = true;
				
				if (position.y >= height) _maxScrollV++;
				
				return true;
			}
			
			if (_char == '\t')
			{
				drawChar(' ');
				drawChar(' ');
				drawChar(' ');
				drawChar(' ');
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Поместить каретку в место указанное курсором.
		 */
		private function setCaretInMousePosition():void
		{
			if (numChars == 0)
			{
				caret.x = -2;
				caret.y = 0;
				return;
			}
			
			if (charsData[numChars - 1].x + charsData[numChars - 1].width < mouseX - globalX)
			{
				_caretIndex = numChars;
			}
			
			for (var i:int = 0; i < numChars; i++) 
			{
				var symbol:CharData = charsData[i];
				
				if (symbol.x + symbol.width / 2 > mouseX - globalX)
				{
					if (symbol.y + _size / 2 > mouseY - _size - globalY)
					{
						_caretIndex = i;
						break;
					}
				}
			}
		}
		
		/**
		 * Сместить текст по горизонтали.
		 */
		public function set scrollH(value:int):void
		{
			_scrollH = value < 0 ? 0 : value > _maxScrollH ? _maxScrollH : value;
			
			positionScroll.y = -_scrollH * width;
			rectangle.width = width;
			rectangle.height = height;
			
			bitmapData.fillRect(rectangle, _backgroundColor);
			
			for (var i:int = 0; i < numChars; i++) 
			{
				var char:CharData = charsData[i];
				if (!char.bitmapData) continue;
				
				positionScroll.y = char.y;
				positionScroll.x += char.x;
				bitmapData.copyPixels(char.bitmapData, char.bitmapData.rect, positionScroll);
				positionScroll.x -= char.x;
			}
		}
		
		/**
		 * Получить смещение по горизонтали.
		 */
		public function get scrollH():int
		{
			return _scrollH;
		}
		
		/**
		 * Сместить текст по вертикали.
		 */
		public function set scrollV(value:int):void
		{
			_scrollV = value < 0 ? 0 : value > _maxScrollV ? _maxScrollV : value;
			
			positionScroll.y = -_scrollV * (_size + leading);
			
			rectangle.width = width;
			rectangle.height = height;
			
			bitmapData.fillRect(rectangle, _backgroundColor);
			
			for (var i:int = 0; i < numChars; i++) 
			{
				var char:CharData = charsData[i];
				if (!char.bitmapData) continue;
				
				positionScroll.y += char.y;
				positionScroll.x = char.x;
				bitmapData.copyPixels(char.bitmapData, char.bitmapData.rect, positionScroll);
				positionScroll.y -= char.y;
			}
		}
		
		/**
		 * Получить смещение по вертикали.
		 */
		public function get scrollV():int
		{
			return _scrollV;
		}
		
		/**
		 * Максимальное смещение по горизонтали.
		 */
		public function get maxScrollH():int
		{
			return _backgroundColor;
		}
		
		/**
		 * Максимальное смещение по вертикали.
		 */
		public function get maxScrollV():int
		{
			return _maxScrollV;
		}
		
		/**
		 * Получить количество строк.
		 */
		public function get numLines():int
		{
			return _numLines;
		}
		
		/**
		 * Назначить текст.
		 */
		public function set text(value:String):void
		{
			if (_text != value) 
			{
				numChars = 0;
				charsData.length = 0;
				
				if (maxChars > 0 && numChars < maxChars)
				{
					_text = value;
					drawText(value);
				}
				else if (maxChars == -1)
				{
					_text = value;
					drawText(value);
				}
				
				autoSizer();
			}
		}
		
		/**
		 * Получить текст.
		 */
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * Измениить цвет текста.
		 */
		public function set textColor(value:uint):void
		{
			if (_textColor != value)
			{
				charTable.transformColor(value);
				_textColor = value;
				text = _text;
			}
		}
		
		/**
		 * Получить цвет текста.
		 */
		public function get textColor():uint
		{
			return _textColor;
		}
		
		/**
		 * Назначить цвет фона текстового поля.
		 */
		public function set backgroundColor(value:uint):void
		{
			if (value != _backgroundColor)
			{
				bitmapData.dispose();
				bitmapData = new BitmapData(width, height, !_background, value);
				text = _text;
				_backgroundColor = value;
				
				if (value == 0xFFFFFF)
				{
					var color:ColorTransform = new ColorTransform();
					color.color = 0x000000;
					caret.bitmapData.colorTransform(caret.bitmapData.rect, color);
				}
			}
		}
		
		/**
		 * Получить цвет фона текстового поля.
		 */
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		/**
		 * Отображать фон текстового поля.
		 */
		public function set background(value:Boolean):void
		{
			if (value != _background)
			{
				bitmapData.dispose();
				bitmapData = new BitmapData(width, height, !value, _backgroundColor);
				text = _text;
				_background = value;
			}
		}
		
		/**
		 * Получить значение: отображается ли цвет фона текстового поля.
		 */
		public function get background():Boolean
		{
			return _background;
		}
		
		/**
		 * Получить текущий индекс каретки.
		 */
		public function get caretIndex():int
		{
			return _caretIndex;
		}
		
		/**
		 * Ширина тектового поля.
		 */
		override public function set width(value:Number):void
		{
			if (super.width != value)
			{
				bitmapData.dispose();
				bitmapData = new BitmapData(value, height, !_background, _textColor);
				drawText(_text);
				
				super.width = value;
			}
		}
		
		/**
		 * Высота тектового поля.
		 */
		override public function set height(value:Number):void
		{
			if (super.height != value)
			{
				bitmapData.dispose();
				bitmapData = new BitmapData(width, value, !_background, _textColor);
				drawText(_text);
				
				super.height = value;
			}
		}
	}
}