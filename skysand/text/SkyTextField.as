package skysand.text
{
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextLineMetrics;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyOldData;
	import skysand.render.hardware.SkyHardwareRender;
	import skysand.render.hardware.SkyTextBatch;
	import skysand.keyboard.SkyKeyboard;
	import skysand.mouse.SkyMouse;
	import skysand.utils.SkyMath;
	
	public class SkyTextField extends SkyRenderObjectContainer
	{
		/**
		 * Индекс с которого начинаются считываться вершины. 
		 */
		public var indexID:uint;
		
		/**
		 * Растровое представление текстового поля.
		 */
		private var bitmapData:BitmapData;
		
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
		
		/**
		 * Текст.
		 */
		private var _text:String = "";
		
		/**
		 * Пакет для отрисовки текстового поля.
		 */
		private var batch:SkyTextBatch;
		
		/**
		 * Старые данные для оптимизации рендера.
		 */
		private var old:SkyOldData;
		
		/**
		 * Ссылка на вершины.
		 */
		private var verteces:Vector.<Number>;
		
		/**
		 * Ссылка на текстурные координаты.
		 */
		private var uv:Vector.<Number>;
		
		/**
		 * Массив для хранения временных данных трансформированных вершин.
		 */
		private var v:Vector.<Number>;
		
		/**
		 * Ссылка на мышь.
		 */
		private var mouse:SkyMouse;
		
		/**
		 * Ссылка на клавиатуру.
		 */
		private var keyboard:SkyKeyboard;
		
		/**
		 * Перетаскивать или нет.
		 */
		private var drag:Boolean;
		
		/**
		 * Точка смещения перетаскивания объекта.
		 */
		private var offsetDragPoint:Point;
		
		/**
		 * Перетаскивается ли сейчас объект.
		 */
		private static var isDrag:Boolean;
		
		/**
		 * Стандартные размеры текстур.
		 */
		private var sizes:Vector.<uint>;
		
		/**
		 * Текущий размер текстуры.
		 */
		private var currentSizeOfTexture:uint;
		
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
			bitmapData = new BitmapData(2, 2, true, 0x00FFFFFF);
			textFormat = new TextFormat();
			matrix = new Matrix();
			
			textField = new TextField();
			textField.width = 10;
			textField.height = 1;
			textField.visible = false;
			SkySand.STAGE.addChild(textField);
			
			v = new Vector.<Number>(8, true);
			sizes = new Vector.<uint>(9, true);
			sizes[0] = 4;
			sizes[1] = 16;
			sizes[2] = 32;
			sizes[3] = 64;
			sizes[4] = 128;
			sizes[5] = 256;
			sizes[6] = 512;
			sizes[7] = 1024;
			sizes[8] = 2048;
			
			offsetDragPoint = new Point();
			old = new SkyOldData();
			
			focusOn = false;
			isDrag = false;
			drag = false;
			
			currentSizeOfTexture = 2;
			indexID = 0;
			height = 2;
			width = 2;
			
			mouse = SkyMouse.instance;
			keyboard = SkyKeyboard.instance;
		}
		
		/**
		 * Найходит ближайшмй размер для текстуры, исходя из размеров текстового поля.
		 * @return возвращает это значение.
		 */
		private function findClosestSize():int
		{
			var max:Number = width < height ? height : width;
			
			for (var i:int = 0; i < 9; i++) 
			{
				if (max < sizes[i]) return sizes[i];
			}
			
			return 2;
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
			
			if (batch) batch.texture.uploadFromBitmapData(bitmapData);
		}
		
		/**
		 * Удалить из пакета.
		 */
		override public function remove():void 
		{
			if (batch != null)
			{
				batch.remove(this);
			}
			
			SkyHardwareRender.instance.removeObjectFromRender(this);
		}
		
		/**
		 * Добавить в пакет для рендера.
		 */
		override public function init():void 
		{
			batch = SkyHardwareRender.instance.getBatch("textField") as SkyTextBatch;
			verteces = batch.verteces;
			uv = batch.uvs;
			batch.add(this);
		}
		
		/**
		 * Начать перетаскивание объекта за курсором мыши.
		 * @param	lockCentr перетаскивание без учёта смещения объекта от курсора.
		 */
		public function startDrag(lockCentr:Boolean = false):void
		{
			if (!drag && !isDrag)
			{
				if (!lockCentr)
				{
					offsetDragPoint.x = mouse.x - x;
					offsetDragPoint.y = mouse.y - y;
				}
				else
				{
					offsetDragPoint.x = 0;
					offsetDragPoint.y = 0;
				}
				
				drag = true;
				isDrag = true;
			}
		}
		
		/**
		 * Остановить перетаскивание объекта.
		 * Объект следует за мышью.
		 */
		public function stopDrag():void
		{
			if (drag)
			{
				drag = false;
				isDrag = false;
			}
		}
		
		/**
		 * Функция обновления координат и других данных.
		 */
		override public function updateData():void 
		{
			globalVisible = visible ? 1 * parent.globalVisible : 0 * parent.globalVisible;
			
			if (globalVisible == 1 && isVisible)
			{
				if (type == SkyTextConst.INPUT)
				{
					if (hitTestPoint(mouse.x, mouse.y) && mouse.LBMPressed)
					{
						focusOn = true;
						SkySand.STAGE.focus = textField;
						textField.setSelection(textField.length, textField.length);
						
						keyboard.isActive = false;
						mouse.LBMPressed = false;
					}
					
					if (mouse.LBMPressed && focusOn)
					{
						keyboard.isActive = true;
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
				
				if (drag)
				{
					x = mouse.x - offsetDragPoint.x;
					y = mouse.y - offsetDragPoint.y;
				}
				
				globalX = parent.globalX + x;
				globalY = parent.globalY + y;
				globalScaleX = parent.globalScaleX * scaleX;
				globalScaleY = parent.globalScaleY * scaleY;
				globalRotation = parent.globalRotation + rotation;
				
				var w:Number = globalScaleX * width;
				var h:Number = globalScaleY * height;
				
				var px:Number = pivotX * globalScaleX;
				var py:Number = pivotY * globalScaleY;
				
				if (verteces == null) return;
				
				if (old.rotation != globalRotation || old.width != width || old.height != height)
				{
					var angle:Number = SkyMath.toRadian(parent.globalRotation);
					
					localR = SkyMath.rotatePoint(x, y, 0, 0, angle);
					globalR.x = localR.x + parent.globalR.x - x;
					globalR.y = localR.y + parent.globalR.y - y;
					
					angle = SkyMath.toRadian(globalRotation);
					
					matrix.rotate(angle);
					
					v[0] = globalR.x - px * matrix.a - py * matrix.c;
					v[1] = globalR.x + (w - px) * matrix.a - py * matrix.c;
					v[2] = globalR.x - px * matrix.a + (h - py) * matrix.c;
					v[3] = globalR.x + (w - px) * matrix.a + (h - py) * matrix.c;
					v[4] = globalR.y - px * matrix.b - py * matrix.d;
					v[5] = globalR.y + (w - px) * matrix.b - py * matrix.d;
					v[6] = globalR.y - px * matrix.b + (h - py) * matrix.d;
					v[7] = globalR.y + (w - px) * matrix.b + (h - py) * matrix.d;
					
					matrix.rotate( -angle);
					matrix.identity();
					
					if (width > currentSizeOfTexture || height > currentSizeOfTexture)
					{
						currentSizeOfTexture = findClosestSize();
						
						batch.texture.dispose();
						batch.texture = SkySand.CONTEXT_3D.createTexture(currentSizeOfTexture, currentSizeOfTexture, Context3DTextureFormat.BGRA, false);
					}
					
					if (old.width != width)
					{
						uv[3] = width / currentSizeOfTexture;
						uv[9] = width / currentSizeOfTexture;
						
						bitmapData.dispose();
						bitmapData = new BitmapData(width, old.height, true, 0x000000);
						textField.width = width;
						
						drawText();
						
						old.width = width;
					}
					
					if (old.height != height)
					{
						uv[7] = height / currentSizeOfTexture;
						uv[10] = height / currentSizeOfTexture;
						
						bitmapData.dispose();
						bitmapData = new BitmapData(old.width, height, true, 0x000000);
						textField.height = height;
						
						drawText();
						
						old.height = height;
					}
					
					old.x--;
					old.y--;
					old.rotation = rotation;
				}
				
				if (old.x != globalX)
				{
					verteces[indexID] = globalX + v[0];
					verteces[indexID + 3] = globalX + v[1];
					verteces[indexID + 6] = globalX + v[2];
					verteces[indexID + 9] = globalX + v[3];
					
					old.x = globalX;
				}
				
				if (old.y != globalY)
				{
					verteces[indexID + 1] = globalY + v[4];
					verteces[indexID + 4] = globalY + v[5];
					verteces[indexID + 7] = globalY + v[6];
					verteces[indexID + 10] = globalY + v[7];
					
					old.y = globalY;
				}
				
				if (old.depth != depth)
				{
					verteces[indexID + 2] = depth / SkyHardwareRender.MAX_DEPTH;
					verteces[indexID + 5] = depth / SkyHardwareRender.MAX_DEPTH;
					verteces[indexID + 8] = depth / SkyHardwareRender.MAX_DEPTH;
					verteces[indexID + 11] = depth / SkyHardwareRender.MAX_DEPTH;
					
					old.depth = depth;
				}
			}
			else
			{
				verteces[indexID] = 0;
				verteces[indexID + 1] = 0;
				verteces[indexID + 3] = 0;
				verteces[indexID + 4] = 0;
				verteces[indexID + 6] = 0;
				verteces[indexID + 7] = 0;
				verteces[indexID + 9] = 0;
				verteces[indexID + 10] = 0;
				
				old.x--;
				old.y--;
			}
		}
		
		/**
		 * Деструктор.
		 */
		public function free():void
		{
			SkySand.STAGE.removeChild(textField);
			
			offsetDragPoint = null;
			bitmapData.dispose();
			bitmapData = null;
			textFormat = null;
			textField = null;
			verteces = null;
			keyboard = null;
			matrix = null;
			batch = null;
			mouse = null;
			old = null;	
			uv = null;
			
			v.fixed = false;
			v.length = 0;
			v = null;
			
			sizes.fixed = false;
			sizes.length = 0;
			sizes = null;
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
		
		public function setLeading(leading:int):void
		{
			textFormat.leading = leading;
			textField.setTextFormat(textFormat);
			drawText();
		}
		
		/**
		 * Сделать отдельные символы разного размера.
		 * @param	size размер.
		 * @param	beginIndex номер символа с которого нужно начать.
		 * @param	endIndex конечный символ.
		 */
		public function setSize(size:uint, beginIndex:int = -1, endIndex:int = -1):void
		{
			textFormat.size = size;
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
	}
}