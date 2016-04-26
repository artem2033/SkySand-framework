package skysand.text
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import skysand.mouse.SkyMouse;
	import skysand.console.Console;
	import skysand.render.RenderObject;
	import skysand.interfaces.IFrameworkUpdatable;
	
	public class SkyTextField extends RenderObject implements IFrameworkUpdatable
	{
		/**
		 * Проверка на фокуса на текстовом поле.
		 */
		private var focusOn:Boolean;
		
		/**
		 * Матрица трансформации для отрисовки тестового поля.
		 */
		private var matrix:Matrix;
		
		/**
		 * Текстовое поле с которого производится отрисовка.
		 */
		private var textField:TextField;
		
		/**
		 * Формат текстового поля.
		 */
		private var textFormat:TextFormat;
		
		private var _text:String = "";
		
		public function SkyTextField()
		{
			super();
			initialize();
		}
		
		/**
		 * Инициализация текстового поля.
		 */
		private function initialize():void
		{
			bitmapData = new BitmapData(1, 1, true, 0x00FFFFFF);
			textFormat = new TextFormat();
			matrix = new Matrix();
			
			textField = new TextField();
			textField.visible = false;
			stage.addChild(textField);
			
			focusOn = false;
			
			super.width = 1;
			super.height = 1;
			
			Console.instance.message("Framework: Создано новое текстовое поле, ID: " + textField.name.substring(8) + '.', Console.GREY);
		}
		
		/**
		 * Перерисовать текстовой поле.
		 */
		private function drawText():void
		{
			bitmapData.lock();
			bitmapData.fillRect(bitmapData.rect, textField.backgroundColor);
			bitmapData.draw(textField, matrix);
			bitmapData.unlock();
		}
		
		/**
		 * Деструктор.
		 */
		override public function free():void
		{
			Console.instance.message("Framework: Текстовое поле с номером ID: " + textField.name.substring(8) + " удалено.", Console.RED);
			
			stage.removeChild(textField);
			
			textField = null;
			textFormat = null;
			matrix = null;
			bitmapData.dispose();
			bitmapData = null;
			focusOn = false;
			
			super.free();
		}
		
		/**
		 * Закрасить текст определённым цветом.
		 * @param	color цвет.
		 * @param	beginIndex номер символа с которого нужно начать закрашивать.
		 * @param	endIndex номер символа до которого нужно закрашивать.
		 */
		public function setColor(color:uint, beginIndex:int = -1, endIndex:int = -1):void
		{
			textFormat.color = color;
			textField.setTextFormat(textFormat, beginIndex, endIndex);
			drawText();
		}
		
		/**
		 * Добавляет строку, указанную параметром newText, в конец текста в текстовом поле.
		 * @param	newText новая строка.
		 */
		public function appendText(newText:String):void
		{
			textField.appendText(newText);
			drawText();
			
			if (textField.autoSize != "none")
			{
				width = textField.width != width ? textField.width : width;
				height = textField.height != height ? textField.height : height;
			}
		}
		
		/**
		 * Возвращает прямоугольник, который является ограничительным блоком символа.
		 * @param	charIndex номер символа.
		 * @return тип Rectangle.
		 */
		public function getCharBoundaries(charIndex:int):Rectangle
		{
			return textField.getCharBoundaries(charIndex);
		}
		
		/**
		 * Возвращает значение индекса, отсчитываемое от нуля, для символа в точке, определенной параметрами x и y.
		 * @param	x координата x.
		 * @param	y координата y.
		 * @return значение индекса.
		 */
		public function getCharIndexAtPoint(x:Number, y:Number):int
		{
			return textField.getCharIndexAtPoint(x, y);
		}
		
		/**
		 * Получив индекс символа, возвращает индекс первого символа в том же абзаце.
		 * @param	charIndex номер символа.
		 * @return индекс первого символа в том же абзаце.
		 */
		public function getFirstCharInParagraph(charIndex:int):int
		{
			return textField.getFirstCharInParagraph(charIndex);
		}
		
		/**
		 * Возвращает ссылку DisplayObject для данного идентификатора, изображения или SWF-файла, добавленного в текстовое поле с форматированием HTML с помощью тега <img>.
		 * @param	id идентификатор.
		 * @return DisplayObject.
		 */
		public function getImageReference(id:String):DisplayObject
		{
			return textField.getImageReference(id);
		}
		
		/**
		 * Возвращает значение индекса, отсчитываемое от нуля, для строки в точке с координатами x и y.
		 * @param	x координата X.
		 * @param	y координата Y.
		 * @return значение индекса.
		 */
		public function getLineIndexAtPoint(x:Number, y:Number):int
		{
			return textField.getLineIndexAtPoint(x, y);
		}
		
		/**
		 * Отсчитываемое от нуля значение индекса для строки, которая содержит символ, заданный параметром charIndex.
		 * @param	charIndex индекс символа.
		 * @return значение индекса для строки.
		 */
		public function getLineIndexOfChar(charIndex:int):int
		{
			return textField.getLineIndexOfChar(charIndex);
		}
		
		/**
		 * Возвращает число символов в заданной строке текста.
		 * @param	lineIndex номер строки.
		 * @return число символов.
		 */
		public function getLineLength(lineIndex:int):int
		{
			return textField.getLineLength(lineIndex);
		}
		
		/**
		 * Возвращает данные метрик для заданной строки текста.
		 * @param	lineIndex номер строки.
		 * @return данные метрик.
		 */
		public function getLineMetrics(lineIndex:int):TextLineMetrics
		{
			return textField.getLineMetrics(lineIndex);
		}
		
		/**
		 * Возвращает индекс первого символа в строке, заданной параметром lineIndex.
		 * @param	lineIndex номер строки.
		 * @return номер первого символа в строке.
		 */
		public function getLineOffset(lineIndex:int):int
		{
			return textField.getLineOffset(lineIndex);
		}
		
		/**
		 * Возвращает текст строки, заданной параметром lineIndex.
		 * @param	lineIndex номер строки.
		 * @return текст строки.
		 */
		public function getLineText(lineIndex:int):String
		{
			return textField.getLineText(lineIndex);
		}
		
		/**
		 * Используя полученный индекс символа, возвращает длину абзаца, содержащего этот символ.
		 * @param	charIndex номер символа.
		 * @return длина абзаца.
		 */
		public function getParagraphLength(charIndex:int):int
		{
			return textField.getParagraphLength(charIndex);
		}
		
		/**
		 * Возвращает объект TextFormat, содержащий данные о форматировании для фрагмента текста, заданного параметрами beginIndex и endIndex.
		 * @param	beginIndex начальный номер.
		 * @param	endIndex конечный номер.
		 * @return TextFormat.
		 */
		public function getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat
		{
			return textField.getTextFormat(beginIndex, endIndex);
		}
		
		/**
		 * Возвращает значение true, если доступен встроенный шрифт с указанными свойствами fontName и fontStyle, где Font.fontType — это flash.text.FontType.EMBEDDED.
		 * @param	fontName имя шрифта.
		 * @param	fontStyle стиль шрифта.
		 * @return доступность шрифта.
		 */
		public static function isFontCompatible(fontName:String, fontStyle:String):Boolean
		{
			return TextField.isFontCompatible(fontName, fontStyle);
		}
		
		/**
		 * Заменяет текущий выделенный фрагмент содержимым параметра value.
		 * @param	value строка.
		 */
		public function replaceSelectedText(value:String):void
		{
			textField.replaceSelectedText(value);
			drawText();
		}
		
		/**
		 * Заменяет диапазон символов, заданный параметрами beginIndex и endIndex, содержанием параметра newText.
		 * @param	beginIndex начальный номер.
		 * @param	endIndex конечный номер.
		 * @param	newText текст.
		 */
		public function replaceText(beginIndex:int, endIndex:int, newText:String):void
		{
			textField.replaceText(beginIndex, endIndex, newText);
			drawText();
		}
		
		/**
		 * Задает способ разметки текста с помощью индексов первого и последнего символов, которые указываются параметрами beginIndex и endIndex
		 * @param	beginIndex начальный номер.
		 * @param	endIndex конечный номер.
		 */
		public function setSelection(beginIndex:int, endIndex:int):void
		{
			textField.setSelection(beginIndex, endIndex);
			drawText();
		}
		
		/**
		 * Применяет форматирование текста, заданное параметром format, к указанному содержимому текстового поля.
		 * @param	format TextFormat.
		 * @param	beginIndex начальный номер.
		 * @param	endIndex конечный номер.
		 */
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void
		{
			textField.setTextFormat(format, beginIndex, endIndex);
			drawText();
		}
		
		/**
		 * Обновить текстовое поле (используется движком).
		 */
		override public function updateByFramework():void 
		{
			if (type == SkyTextConst.INPUT)
			{
				if (hitTestMouse() && SkyMouse.instance.LBMPressed)
				{
					focusOn = true;
					stage.focus = textField;
					textField.setSelection(textField.length, textField.length);
					
					SkyMouse.instance.LBMPressed = false;
				}
				else
				{
					focusOn = false;
					drawText();
				}
				
				if (focusOn)
				{
					drawText();
				}
			}
			
			if (textField.autoSize != "none")
			{
				width = textField.width != width ? textField.width : width;
				height = textField.height != height ? textField.height : height;
			}
			
			super.updateByFramework();
		}
		
		/**
		 * Включить фон.
		 */
		public function set background(value:Boolean):void
		{
			textField.background = value;
			drawText();
		}
		
		/**
		 * Включить фон.
		 */
		public function get background():Boolean
		{
			return textField.background;
		}
		
		/**
		 * Цвет фона.
		 */
		public function set textColor(value:uint):void
		{
			textField.textColor = value;
			drawText();
		}
		
		/**
		 * Цвет фона.
		 */
		public function get textColor():uint
		{
			return textField.textColor;
		}
		
		/**
		 * Текст в текстовом поле.
		 */
		public function set text(value:String):void
		{
			if (textField.text != value)
			{
				textField.text = value;
				_text = value;
				drawText();
				
				if (textField.autoSize != "none")
				{
					width = textField.width != width ? textField.width : width;
					height = textField.height != height ? textField.height : height;
				}
			}
		}
		
		/**
		 * Текст в текстовом поле.
		 */
		public function get text():String
		{
			return textField.text;
		}
		
		/**
		 * При значении true и отсутствии фокуса на текстовом поле проигрыватель Flash Player выделяет фрагмент в текстовом поле серым цветом.
		 */
		public function get alwaysShowSelection():Boolean
		{
			return textField.alwaysShowSelection;
		}
		
		/**
		 * При значении true и отсутствии фокуса на текстовом поле проигрыватель Flash Player выделяет фрагмент в текстовом поле серым цветом.
		 */
		public function set alwaysShowSelection(value:Boolean):void
		{
			textField.alwaysShowSelection = value;
			drawText();
		}
		
		/**
		 * Тип сглаживания, применяемый для данного текстового поля.
		 */
		public function get antiAliasType():String
		{
			return textField.antiAliasType;
		}
		
		/**
		 * Тип сглаживания, применяемый для данного текстового поля.
		 */
		public function set antiAliasType(antiAliasType:String):void
		{
			textField.antiAliasType = antiAliasType;
			drawText();
		}
		
		/**
		 * Управляет автоматической настройкой размеров и выравниванием текстовых полей.
		 */
		public function get autoSize():String
		{
			return textField.autoSize;
		}
		
		/**
		 * Управляет автоматической настройкой размеров и выравниванием текстовых полей.
		 */
		public function set autoSize(value:String):void
		{
			textField.autoSize = value;
			drawText();
		}
		
		/**
		 * Цвет фона.
		 */
		public function get backgroundColor():uint
		{
			return textField.backgroundColor;
		}
		
		/**
		 * Цвет фона.
		 */
		public function set backgroundColor(value:uint):void
		{
			textField.backgroundColor = value;
			drawText();
		}
		
		/**
		 * Нарисовать границу текстового поля.
		 */
		public function get border():Boolean
		{
			return textField.border;
		}
		
		/**
		 * Нарисовать границу текстового поля.
		 */
		public function set border(value:Boolean):void
		{
			textField.border = value;
			drawText();
		}
		
		/**
		 * Цвет границы.
		 */
		public function get borderColor():uint
		{
			return textField.borderColor;
		}
		
		/**
		 * Цвет границы.
		 */
		public function set borderColor(value:uint):void
		{
			textField.borderColor = value;
			drawText();
		}
		
		/**
		 * Целое число (индекс, отсчитываемый от 1), соответствующее самой нижней строке, которую видно в заданном текстовом поле.
		 */
		public function get bottomScrollV():int
		{
			return textField.bottomScrollV;
		}
		
		/**
		 * Индекс каретки ввода.
		 */
		public function get caretIndex():int
		{
			return textField.caretIndex;
		}
		
		/**
		 * Логическое значение, определяющее, следует ли удалять лишние разделители (пробелы, разрывы строк и т.д.) в текстовом поле с текстом HTML.
		 */
		public function get condenseWhite():Boolean
		{
			return textField.condenseWhite;
		}
		
		/**
		 * Логическое значение, определяющее, следует ли удалять лишние разделители (пробелы, разрывы строк и т.д.) в текстовом поле с текстом HTML.
		 */
		public function set condenseWhite(value:Boolean):void
		{
			textField.condenseWhite = value;
			drawText();
		}
		
		/**
		 * Определяет формат, применяемый к новому вставленному тексту, такому как тексту, введенному пользователем, или тексту, вставленному с использованием метода replaceSelectedText().
		 */
		public function get defaultTextFormat():TextFormat
		{
			return textField.defaultTextFormat;
		}
		
		/**
		 * Определяет формат, применяемый к новому вставленному тексту, такому как тексту, введенному пользователем, или тексту, вставленному с использованием метода replaceSelectedText().
		 */
		public function set defaultTextFormat(format:TextFormat):void
		{
			textField.defaultTextFormat = format;
			drawText();
		}
		
		/**
		 * Показывает, является ли текстовое поле полем пароля.
		 */
		public function get displayAsPassword():Boolean
		{
			return textField.displayAsPassword;
		}
		
		/**
		 * Показывает, является ли текстовое поле полем пароля.
		 */
		public function set displayAsPassword(value:Boolean):void
		{
			textField.displayAsPassword = value;
			drawText();
		}
		
		/**
		 * Определяет, должна ли выполняться визуализация с использованием структур встроенных шрифтов.
		 */
		public function get embedFonts():Boolean
		{
			return textField.embedFonts;
		}
		
		/**
		 * Определяет, должна ли выполняться визуализация с использованием структур встроенных шрифтов.
		 */
		public function set embedFonts(value:Boolean):void
		{
			textField.embedFonts = value;
			drawText();
		}
		
		/**
		 * Тип подгонки к сетке, применяемый для этого текстового поля.
		 */
		public function get gridFitType():String
		{
			return textField.gridFitType;
		}
		
		/**
		 * Тип подгонки к сетке, применяемый для этого текстового поля.
		 */
		public function set gridFitType(gridFitType:String):void
		{
			textField.gridFitType = gridFitType;
			drawText();
		}
		
		/**
		 * Содержит HTML-представление содержимого текстового поля.
		 */
		public function get htmlText():String
		{
			return textField.htmlText;
		}
		
		/**
		 * Содержит HTML-представление содержимого текстового поля.
		 */
		public function set htmlText(value:String):void
		{
			textField.htmlText = value;
			drawText();
		}
		
		/**
		 * Число символов в текстовом поле.
		 */
		public function get length():int
		{
			return textField.length;
		}
		
		/**
		 * Введенное пользователем максимальное число символов, которое может содержать текстовое поле.
		 */
		public function get maxChars():int
		{
			return textField.maxChars;
		}
		
		/**
		 * Введенное пользователем максимальное число символов, которое может содержать текстовое поле.
		 */
		public function set maxChars(value:int):void
		{
			textField.maxChars = value;
			drawText();
		}
		
		/**
		 * Максимальное значение scrollH.
		 */
		public function get maxScrollH():int
		{
			return textField.maxScrollH;
		}
		
		/**
		 * Максимальное значение scrollV.
		 */
		public function get maxScrollV():int
		{
			return textField.maxScrollV;
		}
		
		/**
		 * Логическое значение, определяющее, выполняет ли проигрыватель Flash Player автоматическую прокрутку многострочных текстовых полей, когда пользователь щелкает текстовое поле и вращает колесико мыши.
		 */
		public function get mouseWheelEnabled():Boolean
		{
			return textField.mouseWheelEnabled;
		}
		
		/**
		 * Логическое значение, определяющее, выполняет ли проигрыватель Flash Player автоматическую прокрутку многострочных текстовых полей, когда пользователь щелкает текстовое поле и вращает колесико мыши.
		 */
		public function set mouseWheelEnabled(value:Boolean):void
		{
			textField.mouseWheelEnabled = value;
		}
		
		/**
		 * Показывает, является ли текстовое поле многострочным.
		 */
		public function get multiline () : Boolean
		{
			return textField.multiline;
		}
		
		/**
		 * Показывает, является ли текстовое поле многострочным.
		 */
		public function set multiline(value:Boolean):void
		{
			textField.multiline = value;
			drawText();
		}
		
		/**
		 * Определяет число строк текста в многострочном текстовом поле.
		 */
		public function get numLines():int
		{
			return textField.numLines;
		}
		
		/**
		 * Определяет набор символов, которые могут быть введены пользователем в текстовом поле.
		 */
		public function get restrict():String
		{
			return textField.restrict;
		}
		
		/**
		 * Определяет набор символов, которые могут быть введены пользователем в текстовом поле.
		 */
		public function set restrict(value:String):void
		{
			textField.restrict = value;
			drawText();
		}
		
		/**
		 * Текущее положение горизонтальной прокрутки.
		 */
		public function get scrollH():int
		{
			return textField.scrollH;
		}
		
		/**
		 * Текущее положение горизонтальной прокрутки.
		 */
		public function set scrollH(value:int):void
		{
			textField.scrollH = value;
			drawText();
		}
		
		/**
		 * Вертикальное положение текста в текстовом поле.
		 */
		public function get scrollV():int
		{
			return textField.scrollV;
		}
		
		/**
		 * Вертикальное положение текста в текстовом поле.
		 */
		public function set scrollV(value:int):void
		{
			textField.scrollV = value;
			drawText();
		}
		
		/**
		 * Логическое значение, определяющее, можно ли выбрать текстовое поле.
		 */
		public function get selectable():Boolean
		{
			return textField.selectable;
		}
		
		/**
		 * Логическое значение, определяющее, можно ли выбрать текстовое поле.
		 */
		public function set selectable(value:Boolean):void
		{
			textField.selectable = value;
			drawText();
		}
		
		/**
		 * Получить выделенный текст.
		 */
		public function get selectedText():String
		{
			return textField.selectedText;
		}
		
		/**
		 * Отсчитываемое от нуля значение индекса для первого символа в текущем выделенном фрагменте.
		 */
		public function get selectionBeginIndex():int
		{
			return textField.selectionBeginIndex;
		}
		
		/**
		 * Отсчитываемое от нуля значение индекса для последнего символа в текущем выделенном фрагменте.
		 */
		public function get selectionEndIndex():int
		{
			return textField.selectionEndIndex;
		}
		
		/**
		 * Четкость контуров символов в этом текстовом поле.
		 */
		public function get sharpness():Number
		{
			return textField.sharpness;
		}
		
		/**
		 * Четкость контуров символов в этом текстовом поле.
		 */
		public function set sharpness(value:Number):void
		{
			textField.sharpness = value;
			drawText();
		}
		
		/**
		 * Присоединяет таблицу стилей к текстовому полю.
		 */
		public function get styleSheet():StyleSheet
		{
			return textField.styleSheet;
		}
		
		/**
		 * Присоединяет таблицу стилей к текстовому полю.
		 */
		public function set styleSheet(value:StyleSheet):void
		{
			textField.styleSheet = value;
			drawText();
		}
		
		/**
		 * Высота текста в пикселях.
		 */
		public function get textHeight():Number
		{
			return textField.textHeight;
		}
		
		/**
		 * Свойства режима взаимодействия, Значение по умолчанию - TextInteractionMode. НОРМАЛЬНЫЙ.
		 */
		public function get textInteractionMode():String
		{
			return textField.textInteractionMode;
		}
		
		/**
		 * Ширина текста в пикселях.
		 */
		public function get textWidth():Number
		{
			return textField.textWidth;
		}
		
		/**
		 * Толщина контуров символов в данном текстовом поле.
		 */
		public function get thickness():Number
		{
			return textField.thickness;
		}
		
		/**
		 * Толщина контуров символов в данном текстовом поле.
		 */
		public function set thickness(value:Number):void
		{
			textField.thickness = value;
			drawText();
		}
		
		/**
		 * Тип текстового поля.
		 */
		public function get type():String
		{	
			return textField.type;
		}
		
		/**
		 * Тип текстового поля.
		 */
		public function set type(value:String):void
		{
			textField.type = value;
			drawText();
		}
		
		/**
		 * Определяет, будет ли форматирование текста копироваться и вставляться вместе с самим текстом.
		 */
		public function get useRichTextClipboard():Boolean
		{
			return textField.useRichTextClipboard;
		}
		
		/**
		 * Определяет, будет ли форматирование текста копироваться и вставляться вместе с самим текстом.
		 */
		public function set useRichTextClipboard(value:Boolean):void
		{
			textField.useRichTextClipboard = value;
			drawText();
		}
		
		/**
		 * Логическое значение, определяющее применение переноса по словам к текстовому полю.
		 */
		public function get wordWrap():Boolean
		{
			return textField.wordWrap;
		}
		
		/**
		 * Логическое значение, определяющее применение переноса по словам к текстовому полю.
		 */
		public function set wordWrap(value:Boolean):void
		{
			textField.wordWrap = value;
			drawText();
		}
		
		/**
		 * Шрифт.
		 */
		public function get font():String
		{
			return textField.defaultTextFormat.font;
		}
		
		/**
		 * Шрифт.
		 */
		public function set font(value:String):void
		{
			textFormat.font = value;
			textField.defaultTextFormat = textFormat;
			drawText();
		}
		
		/**
		 * Размер шрифта.
		 */
		public function set size(value:Object):void
		{
			textFormat.size = value;
			textField.defaultTextFormat = textFormat;
			drawText();
		}
		
		/**
		 * Размер шрифта.
		 */
		public function get size():Object
		{
			return textField.defaultTextFormat.size;
		}
		
		/**
		 * Высота текстового поля.
		 */
		override public function set height(value:Number):void 
		{
			bitmapData.dispose();
			bitmapData = new BitmapData(width, value, true, 0x000000);
			textField.height = value;
			drawText();
			
			super.height = value;
		}
		
		/**
		 * Ширина тестового поля.
		 */
		override public function set width(value:Number):void 
		{
			bitmapData.dispose();
			bitmapData = new BitmapData(value, height, true, 0x000000);
			textField.width = value;
			drawText();
			
			super.width = value;
		}
	}
}