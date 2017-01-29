package skysand.utils 
{
	import flash.display.Bitmap;
	import flash.text.AntiAliasType;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.system.System;
	import skysand.components.ComponentColor;
	import skysand.components.SkyWindow;
	import skysand.display.SkyGraphics;
	import skysand.render.RenderObject;
	import skysand.text.SkyTextField;
	
	public class SkyProfiler extends SkyWindow
	{
		//Цвета для отрисовки.
		private const GREY:uint = 0x333333;
		private const BLUE:uint = 0x28AEFF;
		private const WHITE:uint = 0xCCCCCC;
		private const GREEN:uint = 0x91CC20;
		private const ORANGE:uint = 0xFF611B;
		private const YELLOW:uint = 0xFFA918;
		private const PURPLE:uint = 0xD44482;
		
		/**
		 * Максимальная частота кадров.
		 */
		public var maxFrameRate:int;
		
		/**
		 * Интервал в мс. с которым обновлять данные (по умолчанию 1 с.).
		 */
		public var timeInterval:int;
		
		/**
		 * Время которое ущло на отрисовку.
		 */
		public var renderTime:int;
		
		/**
		 * Время которое ушло на обновление приложения.
		 */
		public var applicationUpdateTime:int;
		
		/**
		 * Общее время ушедшее на обновление всего.
		 */
		public var totalUpdateTime:int;
		
		/**
		 * Время начала отсчёта для интервала.
		 */
		private var beginTime:Number;
		
		/**
		 * Время запуска приложения.
		 */
		private var startTime:int;
		
		/**
		 * Число кадров в интервале.
		 */
		private var nFrames:int;
		
		/**
		 * Максимальное число кадров в секунду.
		 */
		private var maxFps:Number;
		
		/**
		 * Минимальное число кадров в секунду.
		 */
		private var minFps:Number;
		
		/**
		 * Максимальное число занимаемой памяти.
		 */
		private var maxMemory:Number;
		
		/**
		 * Минимальное число занимаемой памяти.
		 */
		private var minMemory:Number;
		
		/**
		 * Среднее значение частоты кадров.
		 */
		private var averageFps:Number;
		
		/**
		 * Количество вызова функции updateFps для подсчёта среднего значения.
		 */
		private var updateFpsCount:int;
		
		/**
		 * Сумма частоты кадров за время работы проложения.
		 */
		private var totalFps:Number;
		
		/**
		 * Максимальное значение памяти для построения линий.
		 */
		private var maxMemoryLength:int;
		
		/**
		 * Матрица трансформации для отрисовки.
		 */
		private var matrix:Matrix;
		
		/**
		 * Номер линии.
		 */
		private var lineIndex:int;
		
		/**
		 * Текстовое поле для отображения текущего числа кадров в верху профайлера.
		 */
		private var fpsTextField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения максимального и минимального значения fps.
		 */
		private var minMaxFpsField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения среднего числа кадров.
		 */
		private var averageFpsField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения текущего числа кадров.
		 */
		private var currentFpsField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения времени, занявшем на обновление 1 кадра.
		 */
		private var frameTimeField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения времени, занявшем для отрисовки кадра.
		 */
		private var renderTimeField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения времени, занявшем для обновления приложения.
		 */
		private var applicationTimeField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения времени работы приложения.
		 */
		private var timeField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения текущего занимаемого объёма памяти.
		 */
		private var memoryField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения текущего занимаемого объёма памяти.
		 */
		private var currentMemoryField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения максимального и минимального значения занимаемой памяти.
		 */
		private var minMaxMemoryField:SkyTextField;
		
		/**
		 * Текстовое поле с заранее заданными настройками, для отрисовки в bitmapData.
		 */
		private var sourceTextField:SkyTextField;
		
		/**
		 * Массив с линиями показывающими текущее значение частоты кадров.
		 */
		private var fpsLines:Vector.<SkyGraphics>;
		
		/**
		 * Массив с линиями показывающими среднее значение частоты кадров.
		 */
		private var averageFpsLines:Vector.<SkyGraphics>;
		
		/**
		 * Массив с линиями показывающими текущую занимаемую оперативную память.
		 */
		private var memoryLines:Vector.<SkyGraphics>;
		
		private var gpuMemoryLines:Vector.<SkyGraphics>;
		
		/**
		 * Массив с линиями показывающими время отрисовки кадра.
		 */
		private var renderTimeLines:Vector.<SkyGraphics>;
		
		/**
		 * Массив с линиями показывающими время обновления цикла приложения.
		 */
		private var applicationTimeLines:Vector.<SkyGraphics>;
		
		/**
		 * Ссылка на класс.
		 */
		private static var _instance:SkyProfiler;
		
		public function SkyProfiler()
		{
			if(_instance != null)
			{
				throw new Error("use instance");
			}
			
			_instance = this;
			initialize();
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():SkyProfiler
		{
			return (_instance == null) ? new SkyProfiler() : _instance;
		}
		
		/**
		 * Скрыть или показать профайлер.
		 * @param	value true - показать, false - скрыть.
		 */
		public function show(value:Boolean):void
		{
			visible = value;
		}
		
		/**
		 * Обновление профайлера.
		 */
		public function update():void
		{
			var endTime:uint = getTimer();
			var deltaTime:uint = endTime - beginTime;
			
			nFrames++;
			
			if (deltaTime >= timeInterval)
			{
				var fps:Number = nFrames / deltaTime * 1000;
				
				for (var i:int = 0; i < 29; i++)
				{
					applicationTimeLines[i].x += 7;
					averageFpsLines[i].x += 7;
					renderTimeLines[i].x += 7;
					fpsLines[i].x += 7;
				}
				
				updateFps(fps);
				updateMemory();
				updateFrameTime();
				
				lineIndex = lineIndex - 1 < 0 ? 28 : lineIndex - 1;
				
				nFrames = 0;
				beginTime = endTime;
			}
		}
		
		/**
		 * Деструктор.
		 */
		override public function free():void
		{
			matrix = null;
			
			removeChild(fpsTextField);
			fpsTextField.free();
			fpsTextField = null;
			
			removeChild(minMaxFpsField);
			minMaxFpsField.free();
			minMaxFpsField = null;
			
			removeChild(averageFpsField);
			averageFpsField.free();
			averageFpsField = null;
			
			removeChild(currentFpsField);
			currentFpsField.free();
			currentFpsField = null;
			
			removeChild(frameTimeField);
			frameTimeField.free();
			frameTimeField = null;
			
			removeChild(renderTimeField);
			renderTimeField.free();
			renderTimeField = null;
			
			removeChild(applicationTimeField);
			applicationTimeField.free();
			applicationTimeField = null;
			
			removeChild(timeField);
			timeField.free();
			timeField = null;
			
			removeChild(memoryField);
			memoryField.free();
			memoryField = null;
			
			removeChild(currentMemoryField);
			currentMemoryField.free();
			currentMemoryField = null;
			
			removeChild(minMaxMemoryField);
			minMaxMemoryField.free();
			minMaxMemoryField = null;
			
			removeChild(sourceTextField);
			sourceTextField.free();
			sourceTextField = null;
			
			/*for (var i:int = 0; i < 29; i++) 
			{
				removeChild(applicationTimeLines[i]);
				removeChild(averageFpsLines[i]);
				removeChild(renderTimeLines[i]);
				removeChild(memoryLines[i]);
				removeChild(fpsLines[i]);
				
				applicationTimeLines[i].bitmapData.dispose();
				applicationTimeLines[i].bitmapData = null;
				
				averageFpsLines[i].bitmapData.dispose();
				averageFpsLines[i].bitmapData = null;
				
				renderTimeLines[i].bitmapData.dispose();
				renderTimeLines[i].bitmapData = null;
				
				memoryLines[i].bitmapData.dispose();
				memoryLines[i].bitmapData = null;
				
				fpsLines[i].bitmapData.dispose();
				fpsLines[i].bitmapData = null;
			}*/
			
			applicationTimeLines.length = 0;
			averageFpsLines.length = 0;
			renderTimeLines.length = 0;
			memoryLines.length = 0;
			fpsLines.length = 0;
			
			applicationTimeLines = null;
			averageFpsLines = null;
			renderTimeLines = null;
			memoryLines = null;
			fpsLines = null;
			
			super.free();
		}
		
		/**
		 * Обновить график и информацию о частоте кадров.
		 * @param	count число кадров.
		 */
		private function updateFps(count:Number):void
		{
			count = count > maxFrameRate ? maxFrameRate : count;
			
			var greenLine:SkyGraphics = fpsLines[lineIndex];
			greenLine.height = Math.ceil((count / maxFrameRate) * 78);
			greenLine.x = 13;
			greenLine.y = 319 - greenLine.height;
			
			updateFpsCount++;
			totalFps += count;
			averageFps = totalFps / updateFpsCount;
			
			var blueLine:SkyGraphics = averageFpsLines[lineIndex];
			blueLine.height = Math.ceil((averageFps / maxFrameRate) * 78);
			blueLine.x = 13;
			blueLine.y = 319 - blueLine.height;
			
			var index0:int = getChildIndex(greenLine);
			var index1:int = getChildIndex(blueLine);
			
			if (greenLine.height <= blueLine.height && index0 < index1) swapChildren(blueLine, greenLine);
			
			currentFpsField.text = "current\t\t\t             " + count.toFixed(1);
			averageFpsField.text = "average\t\t\t             " + averageFps.toFixed(1);
			
			fpsTextField.text = "frame rate\n" + count.toFixed(1) + " fps";
			fpsTextField.setLeading( -6);
			fpsTextField.setSize(15, 0, 11);
			trace(fpsTextField.getTextFormat().leading);
			
			maxFps = maxFps < count ? count : maxFps;
			minFps = minFps > count ? count : minFps;
			
			var minLength:int = minFps.toFixed(1).length;
			var maxLength:int = maxFps.toFixed(1).length;
			
			minMaxFpsField.text = maxFps.toFixed(1) + '\n' + minFps.toFixed(1);
			minMaxFpsField.setColor(GREEN, 0, minLength);
			minMaxFpsField.setColor(ORANGE, minLength + 1, minLength + maxLength + 1);
		}
		private var f:Boolean = false;
		/**
		 * Обновить график и данные о занимаемой памяти приложения.
		 */
		private function updateMemory():void
		{
			var memory:Number = System.totalMemory / 1024 / 1024;
			
			for (var i:int = 0; i < 29; i++) 
			{
				var line:SkyGraphics = memoryLines[i];
				line.x += 7;
				
				if (memory >= maxMemoryLength)
				{
					line.height = Math.ceil(line.height * 0.5);
					line.y = 319 - line.height;
				}
			}
			
			if (memory >= maxMemoryLength) maxMemoryLength *= 2;
			
			line = memoryLines.pop();
			line.x = memoryLines[0].x - 7;
			line.height = Math.ceil((memory / maxMemoryLength) * 78);
			line.y = 319 - line.height;
			memoryLines.unshift(line);
			
			memoryField.text = memory.toFixed(2) + " mb";
			currentMemoryField.text = "memory\t\t\t" + memory.toFixed(2);
			
			maxMemory = maxMemory < memory ? memory : maxMemory;
			minMemory = minMemory > memory ? memory : minMemory;
			
			var minLength:int = minMemory.toFixed(2).length;
			var maxLength:int = maxMemory.toFixed(2).length;
			
			minMaxMemoryField.text = maxMemory.toFixed(2) + '\n' + minMemory.toFixed(2);	
			minMaxMemoryField.setColor(ORANGE, 0, maxLength);
			minMaxMemoryField.setColor(GREEN, maxLength + 1, minLength + maxLength + 1);
		}
		
		/**
		 * Обновить график и данные о времени затраченном на 1 кадр.
		 */
		private function updateFrameTime():void
		{
			/*for (var i:int = 0; i < 29; i++)
			{
				applicationTimeLines[i].x += 7;
				renderTimeLines[i].x += 7;
			}*/
			
			var renderLine:SkyGraphics = renderTimeLines.pop();
			renderLine.x = renderTimeLines[0].x - 7;
			renderLine.height = Math.ceil((renderTime / totalUpdateTime) * 78);
			renderLine.y = 149 - renderLine.height;
			renderTimeLines.unshift(renderLine);
			
			var appLine:SkyGraphics = applicationTimeLines.pop();
			appLine.x = applicationTimeLines[0].x - 7;
			appLine.height = Math.ceil((applicationUpdateTime / totalUpdateTime) * 78);
			appLine.y = 149 - appLine.height - renderLine.height;
			applicationTimeLines.unshift(appLine);
			
			renderTimeField.text = "render\t\t\t\t" + String(renderTime);
			applicationTimeField.text = "application\t\t\t" + String(applicationUpdateTime);
			frameTimeField.text = String(totalUpdateTime) + " ms";
			
			var seconds:int = int((getTimer() - startTime) / 1000);
			var minutes:int = int(seconds / 60);
			var hours:int = int(minutes / 60);
			
			seconds -= minutes * 60;
			minutes -= hours * 60;
			
			var timeString:String = hours < 10 ? '0' + String(hours) + ':' : String(hours) + ':';
			timeString += minutes < 10 ? '0' + String(minutes) + ':' : String(minutes) + ':';
			timeString += seconds < 10 ? '0' + String(seconds) : String(seconds);
			
			timeField.text = timeString;
		}
		
		/**
		 * Инициализация.
		 */
		private function initialize():void
		{
			create(651, 376, ComponentColor.YELLOW_COLOR, "PROFILER", "verdana");
			
			applicationUpdateTime = 0;
			beginTime = getTimer();
			startTime = beginTime;
			maxMemoryLength = 20;
			timeInterval = 1000;
			totalUpdateTime = 0;
			minMemory = 1000000;
			updateFpsCount = 0;
			maxFrameRate = SkySand.FRAME_RATE;
			maxMemory = -1;
			averageFps = 0;
			renderTime = 0;
			minFps = 1000;
			totalFps = 0;
			nFrames = 0;
			maxFps = -1;
			lineIndex = 28;
			
			drawLabel(ORANGE, "render", 11, 160);
			drawLabel(GREEN, "application", 11, 180);
			drawLabel(GREEN, "current", 11, 330);
			drawLabel(BLUE, "average", 11, 350);
			drawLabel(YELLOW, "ram memory", 223, 330);
			drawLabel(PURPLE, "gpu memory", 435, 330);
			
			var line:SkyGraphics = new SkyGraphics();
			line.color = GREY;
			line.drawRect(0, 0, 629, 1);
			line.x = 11;
			line.y = 200;
			addChild(line);
			
			frameTimeField = createTextField();
			frameTimeField.x = 9;
			frameTimeField.y = 42;
			frameTimeField.size = 20;
			addChild(frameTimeField);
			
			timeField = createTextField();
			timeField.x = 128;
			timeField.y = 42;
			timeField.size = 20;
			addChild(timeField);
			
			renderTimeField = createTextField();
			renderTimeField.textColor = ORANGE;
			renderTimeField.x = 20;
			renderTimeField.y = 158;
			addChild(renderTimeField);
			
			applicationTimeField = createTextField();
			applicationTimeField.textColor = GREEN;
			applicationTimeField.x = 20;
			applicationTimeField.y = 178;
			addChild(applicationTimeField);
			
			fpsTextField = createTextField();
			fpsTextField.height = 80;
			fpsTextField.x = 9;
			fpsTextField.y = 200;//212;
			fpsTextField.size = 20;
			addChild(fpsTextField);
			
			minMaxFpsField = createTextField();
			minMaxFpsField.x = 160;
			minMaxFpsField.y = 201;
			minMaxFpsField.height = 40;
			addChild(minMaxFpsField);
			
			currentFpsField = createTextField();
			currentFpsField.textColor = GREEN;
			currentFpsField.x = 20;
			currentFpsField.y = 328;
			addChild(currentFpsField);
			
			averageFpsField = createTextField();
			averageFpsField.textColor = BLUE;
			averageFpsField.x = 20;
			averageFpsField.y = 348;
			addChild(averageFpsField);
			
			memoryField = createTextField();
			memoryField.x = 220;
			memoryField.y = 212;
			memoryField.size = 20;
			addChild(memoryField);
			
			minMaxMemoryField = createTextField();
			minMaxMemoryField.x = 380;
			minMaxMemoryField.y = 201;
			minMaxMemoryField.height = 40;
			addChild(minMaxMemoryField);
			
			currentMemoryField = createTextField();
			currentMemoryField.textColor = YELLOW;
			currentMemoryField.x = 232;//444
			currentMemoryField.y = 328;
			addChild(currentMemoryField);
			
			drawFrame(11, 69);
			drawFrame(11, 239);
			drawFrame(223, 239);
			drawFrame(435, 239);
			
			//drawStaticText("frame rate", 9, 200);
			drawStaticText("frame time", 9, 30);
			drawStaticText("active time", 128, 30);
			drawStaticText("ram memory", 221, 200);
			drawStaticText("gpu memory", 433, 200);
			
			drawTringle(GREEN, 150, 212, 270);
			drawTringle(ORANGE, 160, 227, 90);
			drawTringle(GREEN, 380, 227, 90);
			drawTringle(ORANGE, 370, 212, 270);
			drawTringle(GREEN, 560, 227, 90);
			drawTringle(ORANGE, 550, 212, 270);
			
			createLineArrays();
		}
		
		/**
		 * Нарисовать рамку.
		 * @param	x расположение рамки по оси х.
		 * @param	y расположение рамки по оси у.
		 */
		private function drawFrame(x:Number, y:Number):void
		{
			var frame:SkyGraphics = new SkyGraphics();
			frame.color = GREY;
			frame.addVertex(2, 2);
			frame.addVertex(0, 0);
			frame.addVertex(205, 0);
			frame.addVertex(205, 82);
			frame.addVertex(0, 82);
			frame.addVertex(0, 0);
			frame.addVertex(2, 2);
			frame.addVertex(2, 80);
			frame.addVertex(203, 80);
			frame.addVertex(203, 2);
			frame.x = x;
			frame.y = y;
			addChild(frame);
		}
		
		/**
		 * Создать текстовое поле, с заранее созданными настройками.
		 * @return возвращает текстовое поле.
		 */
		private function createTextField():SkyTextField
		{
			var textField:SkyTextField = new SkyTextField();
			textField.width = 200;
			textField.height = 20;
			textField.textColor = WHITE;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.embedFonts = true;
			textField.font = "hooge";
			textField.size = 15;
			
			return textField;
		}
		
		/**
		 * Создать массивы с линиями и заполнить их.
		 */
		private function createLineArrays():void
		{
			fpsLines = new Vector.<SkyGraphics>();
			memoryLines = new Vector.<SkyGraphics>();
			averageFpsLines = new Vector.<SkyGraphics>();
			renderTimeLines = new Vector.<SkyGraphics>();
			applicationTimeLines = new Vector.<SkyGraphics>();
			
			for (var i:int = 0; i < 29; i++)
			{
				var line = new SkyGraphics();
				line.color = ORANGE;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 71;
				line.x = 13 + i * 7;
				renderTimeLines[i] = line;
				addChild(line);
				
				line = new SkyGraphics();
				line.color = GREEN;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 71;
				line.x = 13 + i * 7;
				applicationTimeLines[i] = line;
				addChild(line);
				
				line = new SkyGraphics();
				line.color = GREEN;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 319;
				line.x = 13 + i * 7;
				fpsLines[i] = line;
				addChild(line);
				
				line = new SkyGraphics();
				line.color = BLUE;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 319;
				line.x = 13 + i * 7;
				line.visible = false;
				averageFpsLines[i] = line;
				addChild(line);
				
				line = new SkyGraphics();
				line.color = YELLOW;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 319;
				line.x = 225 + i * 7;//437 + i * 7;
				memoryLines[i] = line;
				addChild(line);
			}
		}
		
		/**
		 * Нарисовать определённый текст в определённом месте.
		 * @param	text текст, который нужно нарисовать.
		 * @param	x координата X.
		 * @param	y координата Y.
		 */
		private function drawStaticText(text:String, x:int, y:int):void
		{
			var textField:SkyTextField = createTextField();
			textField.text = text;
			textField.x = x;
			textField.y = y;
			addChild(textField);
		}
		
		/**
		 * Нарисовать блок, который поясняет какой цвет за что отвечает.
		 * @param	color цвет текста и блока.
		 * @param	text текст в блоке.
		 * @param	x координата X.
		 * @param	y координата Y.
		 */
		private function drawLabel(color:uint, text:String, x:int, y:int):void
		{
			var sprite:SkyGraphics = new SkyGraphics();
			sprite.color = GREY;
			sprite.drawRect(0, 0, 205, 16);
			sprite.x = x;
			sprite.y = y;
			addChild(sprite);
			
			sprite = new SkyGraphics();
			sprite.color = color;
			sprite.drawRect(0, 0, 5, 16);
			sprite.x = x;
			sprite.y = y;
			addChild(sprite);
		}
		
		/**
		 * Нарисовать треугольник.
		 * @param	color цвет треугольника.
		 * @param	x координата X.
		 * @param	y координата Y.
		 * @param	angle угол поворота.
		 */
		private function drawTringle(color:uint, x:int, y:int, angle:Number):void
		{
			var sprite:SkyGraphics = new SkyGraphics();
			sprite.color = color;
			sprite.addVertex(0, 0);
			sprite.addVertex(5, 5);
			sprite.addVertex(0, 10);
			sprite.rotation = angle;
			sprite.x = x;
			sprite.y = y;
			addChild(sprite);
		}
	}
}