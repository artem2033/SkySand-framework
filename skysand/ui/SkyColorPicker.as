package skysand.ui
{
	import flash.display.BitmapData;
	
	import skysand.utils.SkyUtils;
	import skysand.display.SkyShape;
	import skysand.display.SkySprite;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.file.SkyTextureAtlas;
	import skysand.input.SkyKeyboard;
	import skysand.input.SkyMouse;
	import skysand.input.SkyKey;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyColorPicker extends SkyRenderObjectContainer
	{
		/**
		 * Фон.
		 */
		private var background:SkyShape;
		
		/**
		 * Фон для палитры.
		 */
		private var paletteBackground:SkyShape;
		
		/**
		 * Линия отделяющая палитру от панели выбора цвета.
		 */
		private var line:SkyShape;
		
		/**
		 * Спрайт с текстурой цветового тона.
		 */
		private var hueRect:SkySprite;
		
		/**
		 * Битмапа для отрисовки данных для текстуры.
		 */
		private var bitmapData:BitmapData;
		
		/**
		 * Атлас с данными о спрайтах.
		 */
		private var atlas:SkyTextureAtlas;
		
		/**
		 * Спрайт для отображения градиента насыщенности и яркости.
		 */
		private var saturationValueSquare:SkySprite;
		
		/**
		 * Иконка для выбора насыщенности и яркости.
		 */
		private var colorPicker:SkyShape;
		
		/**
		 * Иконка для отображения текущего выбранного оттенка.
		 */
		private var arrow:SkyShape;
		
		/**
		 * Круг для отображения текущего выбранного цвета из палитры.
		 */
		private var underCircle:SkyShape;
		
		/**
		 * Ссылка на клавиатуру.
		 */
		private var keyboard:SkyKeyboard;
		
		/**
		 * Массив для вывода палитры.
		 */
		private var palette:Vector.<SkyShape>;
		
		/**
		 * Массив с цветами для палитры.
		 */
		private var colors:Vector.<uint>;
		
		/**
		 * Координата от которой начинать считается смещение курсора мыши.
		 */
		private var offsetX:Number;
		
		/**
		 * Итоговое смещение текущих отображаемых цветов.
		 */
		private var offsetIndex:int;
		
		/**
		 * Предыдущее смещение отображаемых цветов.
		 */
		private var prevOffset:int;
		
		/**
		 * Предыдущее значение координты х для стелки выбора цвета. 
		 */
		private var prevArrowX:Number;
		
		/**
		 * Перетаскивается ли цвета в палитре.
		 */
		private var isColorDrag:Boolean;
		
		/**
		 * Перетаскивается ли сейчас что-либо.
		 */
		private var isDragging:Boolean;
		
		/**
		 * Является ли объект активным для ввода с клавиатуры.
		 */
		private var focusOn:Boolean;
		
		/**
		 * Значение тона.
		 */
		private var mHue:Number;
		
		/**
		 * Значение насыщенности.
		 */
		private var mSaturation:Number;
		
		/**
		 * Значение яркости.
		 */
		private var mValue:Number;
		
		public function SkyColorPicker()
		{
			mHue = 0;
			mValue = 0;
			mSaturation = 0;
			offsetIndex = 0;
			prevOffset = 0;
			prevArrowX = 0;
			offsetX = 0;
			
			focusOn = false;
			isDragging = false;
			isColorDrag = false;
		}
		
		/**
		 * Создать окно выбора цвета.
		 * @param	colors палитра предустановленных цветов.
		 */
		public function create(colors:Vector.<uint>):void
		{
			this.colors = colors;
			
			width = 200;
			height = 270;
			
			background = new SkyShape();
			background.color = SkyColor.CLOUDS;
			background.drawRect(0, 0, width + 4, height - 36);
			addChild(background);
			
			paletteBackground = new SkyShape();
			paletteBackground.color = SkyUtils.changeColorBright(SkyColor.CLOUDS, -20);
			paletteBackground.drawRect(0, 0, width + 4, 36);
			paletteBackground.y = background.height;
			addChild(paletteBackground);
			
			line = new SkyShape();
			line.color = SkyUtils.changeColorBright(SkyColor.CLOUDS, -30);
			line.drawRect(0, 0, width, 1);
			line.x = 2;
			line.y = background.height;
			addChild(line);
			
			drawHSV(width, 20);
			
			atlas = new SkyTextureAtlas();
			atlas.loadFromBitmapData(bitmapData, "hsv");
			atlas.setSprite(0, 0, width, width, "satval");
			atlas.setSprite(0, width, width, 20, "hue");
			
			saturationValueSquare = new SkySprite();
			saturationValueSquare.setAtlas(atlas);
			saturationValueSquare.setSprite("satval");
			//saturationValueSquare.verticesColor.setRight(SkyColor.BRIGHT_ORANGE);
			saturationValueSquare.x = 2;
			saturationValueSquare.y = 2;
			saturationValueSquare.mouseEnabled = true;
			addChild(saturationValueSquare);
			
			hueRect = new SkySprite();
			hueRect.setAtlas(atlas);
			hueRect.setSprite("hue");
			hueRect.y = 2 + saturationValueSquare.height + saturationValueSquare.y;
			hueRect.x = 2;
			hueRect.mouseEnabled = true;
			addChild(hueRect);
			
			arrow = new SkyShape();
			arrow.color = 0x000000;
			arrow.addVertex(-4, 0);
			arrow.addVertex(4, 0);
			arrow.addVertex(0, 5);
			arrow.y = width + 2;
			arrow.x = 30;
			addChild(arrow);
			
			colorPicker = new SkyShape();
			colorPicker.color = SkyColor.CLOUDS;
			colorPicker.drawRing(0, 0, 8, 6, 20);
			colorPicker.x = 55;
			colorPicker.y = 55;
			colorPicker.mouseEnabled = true;
			addChild(colorPicker);
			
			palette = new Vector.<SkyShape>();
			palette.length = 7;
			palette.fixed = true;
			
			underCircle = new SkyShape();
			underCircle.drawCircle(0, 0, 15, 20);
			underCircle.visible = false;
			addChild(underCircle);
			
			var dx:Number = (width + 4 + 20) / 8;
			
			for (var i:int = 0; i < 7; i++) 
			{
				var circle:SkyShape = new SkyShape();
				circle.color = colors[i];
				circle.drawCircle(0, 0, 10, 20);
				circle.x = dx - 10 + i * dx;
				circle.y = paletteBackground.y + paletteBackground.height / 2;
				addChild(circle);
				
				palette[i] = circle;
			}
			
			SkyMouse.instance.addFunctionOnClick(onClickListener, SkyMouse.LEFT);
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(background);
			background.free();
			background = null;
			
			removeChild(paletteBackground);
			paletteBackground.free();
			paletteBackground = null;
			
			removeChild(line);
			line.free();
			line = null;
			
			removeChild(colorPicker);
			colorPicker.free();
			colorPicker = null;
			
			removeChild(arrow);
			arrow.free();
			arrow = null;
			
			removeChild(underCircle);
			underCircle.free();
			underCircle = null;
			
			removeChild(hueRect)
			hueRect.free();
			hueRect = null;
			
			removeChild(saturationValueSquare);
			saturationValueSquare.free();
			saturationValueSquare = null;
			
			atlas.free();
			atlas = null;
			
			bitmapData.dispose();
			bitmapData = null;
			
			SkyMouse.instance.removeFunctionOnClick(onClickListener, SkyMouse.LEFT);
			
			colors.length = 0;
			colors = null;
			
			for (var i:int = 0; i < 7; i++) 
			{
				removeChild(palette[i]);
				palette[i].free();
				palette[i] = null;
			}
			
			palette.length = 0;
			palette = null;
			
			super.free();
		}
		
		/**
		 * Обновить данные.
		 * @param	deltaTime промежуток времени между кадрами.
		 */
		override public function updateData(deltaTime:Number):void
		{
			super.updateData(deltaTime);
			
			if (SkyMouse.instance.isDown(SkyMouse.LEFT))
			{
				if (!isDragging)
				{
					if (SkyMouse.currentClosestObject == saturationValueSquare || SkyMouse.currentClosestObject == colorPicker)
					{
						colorPicker.x = SkySand.STAGE.mouseX - saturationValueSquare.globalX + saturationValueSquare.x;
						colorPicker.y = SkySand.STAGE.mouseY - saturationValueSquare.globalY + saturationValueSquare.y;
						colorPicker.startDrag(false, false, saturationValueSquare.y + saturationValueSquare.height, saturationValueSquare.y, saturationValueSquare.x, saturationValueSquare.x + saturationValueSquare.width);
						
						isDragging = true;
					}
					else if (SkyMouse.currentClosestObject == hueRect)
					{
						arrow.x = SkySand.STAGE.mouseX - line.globalX + line.x;
						arrow.startDrag(false, true, saturationValueSquare.height + 2, saturationValueSquare.height + 2, 2, hueRect.width + 2);
						
						isDragging = true;
					}
					
					if (paletteBackground.hitTestBoundsWithMouse())
					{
						offsetX = SkySand.STAGE.mouseX;
						
						isColorDrag = true;
						isDragging = true;
						focusOn = true;
					}
					
					if (background.hitTestBoundsWithMouse())
					{
						focusOn = true;
					}
				}
				
				if (isColorDrag)
				{
					var index:int = ((offsetX - SkySand.STAGE.mouseX) / 30) | 0;//~math.floor
					
					scrollPalette(index);
				}
			}
			else
			{
				arrow.stopDrag();
				colorPicker.stopDrag();
				prevOffset = offsetIndex;
			}
			
			if (focusOn) updateKeyboardInput();
			
			if (prevArrowX != arrow.x)
			{
				var left:Number = 2 + arrow.width / 2;
				var right:Number = 2 + width - arrow.width / 2;
				
				arrow.verteces[0] = arrow.x <= left ? 2 - arrow.x : 2 - left;
				arrow.verteces[2] = arrow.x >= right ? width + 2 - arrow.x : arrow.width / 2;
				
				arrow.updateVertices();
				prevArrowX = arrow.x;
			}
			
			mHue = (arrow.x - 2) / hueRect.width * 360;
			mValue = 1 - (colorPicker.y - 2) / saturationValueSquare.width;
			mSaturation = (colorPicker.x - 2) / saturationValueSquare.height;
			color = SkyUtils.HSVToRGB(mHue, mSaturation, mValue);
			
			//saturationValueSquare.verticesColor.setRight(SkyUtils.HSVToRGB(mHue, 1, 1));
		}
		
		/**
		 * Сменить цвета на палитре.
		 * @param	offset количество цветов.
		 */
		public function scrollPalette(offset:int):void
		{
			offsetIndex = prevOffset + offset;
			offsetIndex = offsetIndex < 0 ? 0 : offsetIndex > colors.length - 7 ? colors.length - 7 : offsetIndex;
			underCircle.visible = false;
			
			for (var i:int = 0; i < 7; i++) 
			{
				palette[i].color = colors[i + offsetIndex];
			}
		}
		
		/**
		 * Получить массив с цветами для палитры.
		 */
		public function get colorsPalette():Vector.<uint>
		{
			return colors;
		}
		
		/**
		 * Значение цвета в формате rgb.
		 */
		public function get rgb():uint
		{
			return color;
		}
		
		/**
		 * Значение цвета в формате rgb.
		 */
		public function set rgb(value:uint):void
		{
			SkyUtils.RGBToHSV(value);
			mHue = SkyUtils.hue;
			mValue = SkyUtils.value;
			mSaturation = SkyUtils.saturation;
			
			arrow.x = 2 + mHue / 360 * hueRect.width;
			colorPicker.x = 2 + mSaturation * saturationValueSquare.width;
			colorPicker.y = 2 + (1 - mValue) * saturationValueSquare.height;
			
			color = value;
		}
		
		/**
		 * Цветовой тон.
		 */
		public function get hue():Number
		{
			return mHue;
		}
		
		/**
		 * Насыщенность цвета.
		 */
		public function get saturation():Number
		{
			return mSaturation;
		}
		
		/**
		 * Яркость цвета.
		 */
		public function get value():Number
		{
			return mValue;
		}
		
		/**
		 * Цвет фона.
		 */
		public function set backgroundColor(value:uint):void
		{
			background.color = value;
			paletteBackground.color = SkyUtils.changeColorBright(value, -20);
			line.color = SkyUtils.changeColorBright(value, -30);
		}
		
		/**
		 * Цвет фона.
		 */
		public function get backgroundColor():uint
		{
			return background.color;
		}
		
		/**
		 * Обновить управление с клавиатуры.
		 */
		private function updateKeyboardInput():void
		{
			if (SkyKeyboard.isPressed(SkyKey.END))
			{
				scrollPalette(colors.length);
			}
			
			if (SkyKeyboard.isPressed(SkyKey.LEFT))
			{
				scrollPalette(-7);
			}
			
			if (SkyKeyboard.isPressed(SkyKey.RIGHT))
			{
				scrollPalette(7);
			}
			
			if (SkyKeyboard.isPressed(SkyKey.HOME))
			{
				scrollPalette(-colors.length);
			}
		}
		
		/**
		 * Событие на нажатие левой кнопки мыши.
		 */
		private function onClickListener():void
		{
			if (!isVisible) return;
			
			for (var i:int = 0; i < 7; i++) 
			{
				if (!isDrag && palette[i].hitTestMouse())
				{
					underCircle.color = palette[i].color;
					underCircle.x = palette[i].x;
					underCircle.y = palette[i].y;
					underCircle.visible = true;
					
					rgb = underCircle.color;
					
					break;
				}
			}
			
			if (!hitTestBoundsWithMouse() && !isColorDrag && !isDragging)
			{
				focusOn = false;
				visible = false;
			}
			
			isColorDrag = false;
			isDragging = false;
		}
		
		/**
		 * Нарисовать текстуру с квадратом насыщености/света и прямоугольник оттенков.
		 * @param	size размер квадрата.
		 * @param	hueHeight высота прямоугольника оттенков.
		 */
		private function drawHSV(size:Number, hueHeight:Number):void
		{
			bitmapData = new BitmapData(size, size + hueHeight);
			
			for (var i:int = 0; i <= size; i++)
			{
				for (var j:int = 0; j <= size; j++)
				{
					bitmapData.setPixel(i, size - j, SkyUtils.HSVToRGB(0, 0, j / size));
				}
			}
			
			for (i = 0; i <= hueHeight; i++)
			{
				for (j = 0; j <= size; j++)
				{
					bitmapData.setPixel(j, i + size, SkyUtils.HSVToRGB(j / size * 360, 1, 1));
				}
			}
		}
	}
}