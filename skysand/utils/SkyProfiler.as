package skysand.utils 
{
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
		private var fpsLines:Vector.<RenderObject>;
		
		/**
		 * Массив с линиями показывающими среднее значение частоты кадров.
		 */
		private var averageFpsLines:Vector.<RenderObject>;
		
		/**
		 * Массив с линиями показывающими текущую занимаемую оперативную память.
		 */
		private var memoryLines:Vector.<RenderObject>;
		
		/**
		 * Массив с линиями показывающими время отрисовки кадра.
		 */
		private var renderTimeLines:Vector.<RenderObject>;
		
		/**
		 * Массив с линиями показывающими время обновления цикла приложения.
		 */
		private var applicationTimeLines:Vector.<RenderObject>;
		
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
				
				updateFps(fps);
				updateMemory();
				updateFrameTime();
				
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
			
			for (var i:int = 0; i < 29; i++) 
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
			}
			
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
			count = count > 60 ? 60 : count;
			
			for (var i:int = 0; i < 29; i++)
			{
				averageFpsLines[i].x += 7;
				fpsLines[i].x += 7;
			}
			
			var greenLine:RenderObject = fpsLines.pop();
			greenLine.x = fpsLines[0].x - 7;
			greenLine.height = Math.ceil((count / maxFrameRate) * 78);
			greenLine.y = 149 - greenLine.height;
			fpsLines.unshift(greenLine);
			
			updateFpsCount++;
			totalFps += count;
			averageFps = totalFps / updateFpsCount;
			
			var blueLine:RenderObject = averageFpsLines.pop();
			blueLine.x = averageFpsLines[0].x - 7;
			blueLine.height = Math.ceil((averageFps / maxFrameRate) * 78);
			blueLine.y = 149 - blueLine.height;
			averageFpsLines.unshift(blueLine);
			
			var index0:int = getChildIndex(greenLine);
			var index1:int = getChildIndex(blueLine);
			
			if (greenLine.height <= blueLine.height && index0 < index1) swapChildren(greenLine, blueLine);
			
			currentFpsField.text = count.toFixed(1);
			averageFpsField.text = averageFps.toFixed(1);
			fpsTextField.text = count.toFixed(1) + " fps";
			
			maxFps = maxFps < count ? count : maxFps;
			minFps = minFps > count ? count : minFps;
			
			var minLength:int = minFps.toFixed(1).length;
			var maxLength:int = maxFps.toFixed(1).length;
			
			minMaxFpsField.text = maxFps.toFixed(1) + '\n' + minFps.toFixed(1);	
			minMaxFpsField.setColor(GREEN, 0, minLength);
			minMaxFpsField.setColor(ORANGE, minLength + 1, minLength + maxLength + 1);
		}
		
		/**
		 * Обновить график и данные о занимаемой памяти приложения.
		 */
		private function updateMemory():void
		{
			var memory:Number = System.totalMemory / 1024 / 1024;
			
			for (var i:int = 0; i < 29; i++)
			{
				var line:RenderObject = memoryLines[i];
				line.x += 7;
				
				if (memory >= maxMemoryLength)
				{
					line.height = Math.ceil(line.height * 0.5);
					line.y = 149 - line.height;
				}
			}
			
			if (memory >= maxMemoryLength) maxMemoryLength *= 2;
			
			line = memoryLines.pop();
			line.x = memoryLines[0].x - 7;
			line.height = Math.ceil((memory / maxMemoryLength) * 78);
			line.y = 149 - line.height;
			memoryLines.unshift(line);
			
			memoryField.text = memory.toFixed(2) + " mb";
			currentMemoryField.text = memory.toFixed(2);
			
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
			for (var i:int = 0; i < 29; i++)
			{
				applicationTimeLines[i].x += 7;
				renderTimeLines[i].x += 7;
			}
			
			var renderLine:RenderObject = renderTimeLines.pop();
			renderLine.x = renderTimeLines[0].x - 7;
			renderLine.height = Math.ceil((renderTime / totalUpdateTime) * 78);
			renderLine.y = 149 - renderLine.height;
			renderTimeLines.unshift(renderLine);
			
			var appLine:RenderObject = applicationTimeLines.pop();
			appLine.x = applicationTimeLines[0].x - 7;
			appLine.height = Math.ceil((applicationUpdateTime / totalUpdateTime) * 78);
			appLine.y = 149 - appLine.height - renderLine.height;
			applicationTimeLines.unshift(appLine);
			
			renderTimeField.text = String(renderTime);
			applicationTimeField.text = String(applicationUpdateTime);
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
			create(651, 207, ComponentColor.YELLOW_COLOR, "PROFILER", "verdana");
			
			applicationUpdateTime = 0;
			beginTime = getTimer();
			startTime = beginTime;
			maxMemoryLength = 20;
			timeInterval = 1000;
			totalUpdateTime = 0;
			minMemory = 1000000;
			updateFpsCount = 0;
			maxFrameRate = 60;
			maxMemory = -1;
			averageFps = 0;
			renderTime = 0;
			minFps = 1000;
			totalFps = 0;
			nFrames = 0;
			maxFps = -1;
			
			sourceTextField = createTextField();
			
			fpsTextField = createTextField();
			fpsTextField.x = 9;
			fpsTextField.y = 42;
			fpsTextField.size = 20;
			addChild(fpsTextField);
			
			minMaxFpsField = createTextField();
			minMaxFpsField.x = 160;
			minMaxFpsField.y = 30;
			minMaxFpsField.height = 40;
			addChild(minMaxFpsField);
			
			currentFpsField = createTextField();
			currentFpsField.textColor = GREEN;
			currentFpsField.x = 179;
			currentFpsField.y = 158;
			addChild(currentFpsField);
			
			averageFpsField = createTextField();
			averageFpsField.textColor = BLUE;
			averageFpsField.x = 179;
			averageFpsField.y = 178;
			addChild(averageFpsField);
			
			frameTimeField = createTextField();
			frameTimeField.x = 221;
			frameTimeField.y = 42;
			frameTimeField.size = 20;
			addChild(frameTimeField);
			
			renderTimeField = createTextField();
			renderTimeField.textColor = ORANGE;
			renderTimeField.x = 394;
			renderTimeField.y = 158;
			addChild(renderTimeField);
			
			applicationTimeField = createTextField();
			applicationTimeField.textColor = GREEN;
			applicationTimeField.x = 394;
			applicationTimeField.y = 178;
			addChild(applicationTimeField);
			
			timeField = createTextField();
			timeField.x = 340;
			timeField.y = 42;
			timeField.size = 20;
			addChild(timeField);
			
			memoryField = createTextField();
			memoryField.x = 433;
			memoryField.y = 42;
			memoryField.size = 20;
			addChild(memoryField);
			
			minMaxMemoryField = createTextField();
			minMaxMemoryField.x = 560;
			minMaxMemoryField.y = 30;
			minMaxMemoryField.height = 40;
			addChild(minMaxMemoryField);
			
			currentMemoryField = createTextField();
			currentMemoryField.textColor = YELLOW;
			currentMemoryField.x = 579;
			currentMemoryField.y = 158;
			addChild(currentMemoryField);
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.lineStyle(2, GREY);
			sprite.graphics.drawRect(0, 0, 203, 80);
			
			matrix = new Matrix();
			matrix.translate(12, 70);
			bitmapData.draw(sprite, matrix);
			matrix.translate(212, 0);
			bitmapData.draw(sprite, matrix);
			matrix.translate(212, 0);
			bitmapData.draw(sprite, matrix);
			matrix.identity();
			
			drawStaticText("frame rate", 9, 30);
			drawStaticText("frame time", 221, 30);
			drawStaticText("active time", 340, 30);
			drawStaticText("memory", 433, 30);
			
			drawLabel(GREEN, "current", 11, 160);
			drawLabel(BLUE, "average", 11, 180);
			drawLabel(ORANGE, "render", 223, 160);
			drawLabel(GREEN, "application", 223, 180);
			drawLabel(YELLOW, "memory", 435, 160);
			
			drawTringle(GREEN, 150, 40, 270);
			drawTringle(ORANGE, 160, 55, 90);
			drawTringle(GREEN, 560, 55, 90);
			drawTringle(ORANGE, 550, 40, 270);
			
			createLineArrays();
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
			fpsLines = new Vector.<RenderObject>();
			memoryLines = new Vector.<RenderObject>();
			averageFpsLines = new Vector.<RenderObject>();
			renderTimeLines = new Vector.<RenderObject>();
			applicationTimeLines = new Vector.<RenderObject>();
			
			var sourceBlueLine:BitmapData = new BitmapData(5, 78, false, BLUE);
			sourceBlueLine.fillRect(new Rectangle(0, 0, 5, 2), 0x151E27);
			
			var sourceGreenLine:BitmapData = new BitmapData(5, 78, false, GREEN);
			sourceGreenLine.fillRect(new Rectangle(0, 0, 5, 2), 0x151E27);
			
			var sourceYellowLine:BitmapData = new BitmapData(5, 78, false, YELLOW);
			sourceYellowLine.fillRect(new Rectangle(0, 0, 5, 2), 0x151E27);
			
			var sourceOrangeLine:BitmapData = new BitmapData(5, 78, false, ORANGE);
			sourceOrangeLine.fillRect(new Rectangle(0, 0, 5, 2), 0x151E27);
			
			for (var i:int = 0; i < 29; i++)
			{
				var line:RenderObject = new RenderObject();
				line.bitmapData = sourceGreenLine;
				line.width = 5;
				line.height = 0;
				line.y = 71;
				line.x = 13 + i * 7;
				fpsLines[i] = line;
				addChild(line);
				
				line = new RenderObject();
				line.bitmapData = sourceBlueLine;
				line.width = 5;
				line.height = 0;
				line.y = 71;
				line.x = 13 + i * 7;
				averageFpsLines[i] = line;
				addChild(line);
				
				line = new RenderObject();
				line.bitmapData = sourceOrangeLine;
				line.width = 5;
				line.height = 0;
				line.y = 71;
				line.x = 225 + i * 7;
				renderTimeLines[i] = line;
				addChild(line);
				
				line = new RenderObject();
				line.bitmapData = sourceGreenLine;
				line.width = 5;
				line.height = 0;
				line.y = 71;
				line.x = 225 + i * 7;
				applicationTimeLines[i] = line;
				addChild(line);
				
				line = new RenderObject();
				line.bitmapData = sourceYellowLine;
				line.width = 5;
				line.height = 0;
				line.y = 71;
				line.x = 437 + i * 7;
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
			sourceTextField.text = text;
			bitmapData.copyPixels(sourceTextField.bitmapData, sourceTextField.bitmapData.rect, new Point(x, y), null, null, true);
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
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(GREY);
			sprite.graphics.drawRect(0, 0, 205, 16);
			sprite.graphics.beginFill(color);
			sprite.graphics.drawRect(0, 0, 5, 16);
			
			matrix.translate(x, y);
			bitmapData.draw(sprite, matrix);
			matrix.identity();
			
			sourceTextField.textColor = color;
			drawStaticText(text, x + 9, y - 2);
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
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(color);
			sprite.graphics.lineTo(5, 5);
			sprite.graphics.lineTo(0, 10);
			
			matrix.identity();
			angle = SkyMath.toRadian(angle);
			matrix.rotate(angle);
			matrix.translate(x, y);
			
			bitmapData.draw(sprite, matrix);
		}
	}
}