package skysand.debug 
{
	import flash.text.AntiAliasType;
	import flash.utils.getTimer;
	import flash.system.System;
	import skysand.ui.SkyUI;
	
	import skysand.render.SkyHardwareRender;
	import skysand.display.SkyShape;
	import skysand.text.SkyTextField;
	import skysand.text.SkyFont;
	import skysand.ui.SkyButton;
	import skysand.ui.SkyWindow;
	import skysand.ui.SkyColor;
	
	public class SkyProfiler extends SkyWindow
	{
		public static const MB:int = 1048576;
		public static const KB:int = 1024;
		
		//Цвета для отрисовки.
		private const GREY:uint = 0x333333;
		private const BLUE:uint = 0x28AEFF;//0xBE0066
		private const WHITE:uint = 0xCCCCCC;
		private const GREEN:uint = 0x91CC20;
		private const ORANGE:uint = 0xFF611B;
		private const YELLOW:uint = 0xFFA918;
		private const PURPLE:uint = 0xDF7DFF//PINK 0xFF0079;
		
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
		 * Номер линии.
		 */
		private var lineIndex:int;
		
		/**
		 * Коэфициент регулирующий длинну линий времени на кадр.
		 */
		private var renderLineMultiplier:int;
		
		/**
		 * Максимальное значение видео памяти для построения линий.
		 */
		private var maxGPUMemorySize:Number;
		
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
		 * Текстовое поле для отображения текущего занимаемого объёма видеопамяти.
		 */
		private var currentGPUMemoryField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения максимального и минимального значения занимаемой видеопамяти.
		 */
		private var minMaxGPUMemoryField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения текущего занимаемого объёма видеопамяти.
		 */
		private var gpuMemoryField:SkyTextField;
		
		/**
		 * Основная информация в для вывода в левый или правый верхний угол.
		 */
		private var basicInfoField:SkyTextField;
		
		/**
		 * Максимальное значение занимаемой видеопамяти.
		 */
		private var maxGpuMemory:Number;
		
		/**
		 * Минимальное значение занимаемой видеопамяти.
		 */
		private var minGpuMemory:Number;
		
		/**
		 * Проверка на текущий режим отображения профайлера.
		 */
		private var isBasic:Boolean;
		
		/**
		 * Текстовое поле для отображения числа вызовов отрисовки.
		 */
		private var drawCallsField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения числа графических объектов.
		 */
		private var graphicsCountField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения числа спрайтов.
		 */
		private var spriteCountField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения числа текстовых полей.
		 */
		private var textCountField:SkyTextField;
		
		/**
		 * Текстовое поле для отображения числа отрисовываемых объектов.
		 */
		private var renderObjectsCountField:SkyTextField;
		
		/**
		 * Кнопка переключения вида профайлера.
		 */
		private var switchButton:SkyButton;
		
		/**
		 * Массив с линиями показывающими текущее значение частоты кадров.
		 */
		private var fpsLines:Vector.<SkyShape>;
		
		/**
		 * Массив с линиями показывающими среднее значение частоты кадров.
		 */
		private var averageFpsLines:Vector.<SkyShape>;
		
		/**
		 * Массив с линиями показывающими текущую занимаемую оперативную память.
		 */
		private var memoryLines:Vector.<SkyShape>;
		
		/**
		 * Массив с линиями показывающими текущую занимаемую память видеокарты.
		 */
		private var gpuMemoryLines:Vector.<SkyShape>;
		
		/**
		 * Массив с линиями показывающими время отрисовки кадра.
		 */
		private var renderTimeLines:Vector.<SkyShape>;
		
		/**
		 * Массив с линиями показывающими время обновления цикла приложения.
		 */
		private var applicationTimeLines:Vector.<SkyShape>;
		
		/**
		 * Ссылка на класс рендера.
		 */
		private var render:SkyHardwareRender;
		
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
		 * Переключатель профайлера в сокращёный или полный режим.
		 */
		public function switchProfiler():void
		{
			isBasic = !isBasic;
			
			for (var i:int = 0; i < 232; i++) 
			{
				getChildAt(i).visible = !isBasic;
			}
			
			basicInfoField.visible = isBasic;
			
			if (isBasic)
			{
				switchButton.x = 140;
				switchButton.y = 3;
				
				x = 0;
				y = 0;
				
				hideWindow();
			}
			else
			{
				switchButton.x = 640;
				switchButton.y = 365;
				
				showWindow();
			}
			
			visible = true;
		}
		
		/**
		 * Показать профайлер.
		 */
		public function show():void
		{
			visible = true;
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
					gpuMemoryLines[i].x += 7;
					memoryLines[i].x += 7;
					fpsLines[i].x += 7;
				}
				
				updateFps(fps);
				updateMemory();
				updateFrameTime();
				updateGPUMemory();
				
				lineIndex = lineIndex - 1 < 0 ? 28 : lineIndex - 1;
				
				drawCallsField.text = "draw calls\t\t\t" + render.drawCallsCount.toString();
				graphicsCountField.text = "Graphics objects\t" + render.graphicObjectsCount.toString();
				spriteCountField.text = "Sprites\t\t\t\t" + render.spriteObjectsCount.toString();
				textCountField.text = "TextFields\t\t\t" + render.textObjectsCount.toString();
				renderObjectsCountField.text = "Render objects\t\t" + render.renderObjectsCount.toString();
				
				if (isBasic)
				{
					basicInfoField.text = "FPS\t\t" + fps.toFixed(1);
					basicInfoField.appendText("\nDC\t\t" + render.drawCallsCount.toString());
					basicInfoField.appendText("\nFRAME\t" + totalUpdateTime.toString());
					basicInfoField.appendText("\nGPU\t\t" + (SkySand.CONTEXT_3D.totalGPUMemory / MB).toFixed(2));
					basicInfoField.appendText("\nRAM\t\t" + (System.totalMemory / MB).toFixed(2));
					basicInfoField.appendText("\nOBJECTS\t" + render.renderObjectsCount.toString());
				}
				
				nFrames = 0;
				beginTime = endTime;
			}
		}
		
		/**
		 * Деструктор.
		 */
		override public function free():void
		{
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
			
			removeChild(renderTimeField)
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
			
			removeChild(currentGPUMemoryField);
			currentGPUMemoryField.free();
			currentGPUMemoryField = null;
			
			removeChild(minMaxGPUMemoryField);
			minMaxGPUMemoryField.free();
			minMaxGPUMemoryField = null;
			
			removeChild(gpuMemoryField);
			gpuMemoryField.free();
			gpuMemoryField = null;
			
			removeChild(drawCallsField);
			drawCallsField.free();
			drawCallsField = null;
			
			removeChild(graphicsCountField);
			graphicsCountField.free();
			graphicsCountField = null;
			
			removeChild(spriteCountField);
			spriteCountField.free();
			spriteCountField = null;
			
			removeChild(textCountField);
			textCountField.free();
			textCountField = null;
			
			removeChild(renderObjectsCountField);
			renderObjectsCountField.free();
			renderObjectsCountField = null;
			
			removeChild(basicInfoField);
			basicInfoField.free();
			basicInfoField = null;
			
			removeChild(switchButton);
			switchButton.free();
			switchButton = null;
			
			for (var i:int = 0; i < 29; i++) 
			{
				removeChild(fpsLines[0]);
				fpsLines[0].free();
				fpsLines.removeAt(0);
				
				removeChild(averageFpsLines[0]);
				averageFpsLines[0].free();
				averageFpsLines.removeAt(0);
				
				removeChild(memoryLines[0]);
				memoryLines[0].free();
				memoryLines.removeAt(0);
				
				removeChild(gpuMemoryLines[0]);
				gpuMemoryLines[0].free();
				gpuMemoryLines.removeAt(0);
				
				removeChild(renderTimeLines[0]);
				renderTimeLines[0].free();
				renderTimeLines.removeAt(0);
				
				removeChild(applicationTimeLines[0]);
				applicationTimeLines[0].free();
				applicationTimeLines.removeAt(0);
			}
			
			applicationTimeLines = null;
			renderTimeLines = null;
			averageFpsLines = null;
			gpuMemoryLines = null;
			memoryLines = null;
			fpsLines = null;
			_instance = null;
			render = null;
			
			for (i = 0; i < numChildren; i++) 
			{
				if (getChildAt(i) is SkyTextField)
				{
					var text:SkyTextField = getChildAt(i) as SkyTextField;
					removeChild(text);
					text.free();
					text = null;
				}
				
				if (getChildAt(i) is SkyShape)
				{
					var graphic:SkyShape = getChildAt(i) as SkyShape;
					removeChild(graphic);
					graphic.free();
					graphic = null;
				}
				
				i = i - 1 < 0 ? 0 : i - 1;
			}
			
			super.free();
		}
		
		/**
		 * Обновить график и информацию о частоте кадров.
		 * @param	count число кадров.
		 */
		private function updateFps(count:Number):void
		{
			count = count > maxFrameRate ? maxFrameRate : count;
			
			var greenLine:SkyShape = fpsLines[lineIndex];
			greenLine.height = Math.ceil((count / maxFrameRate) * 78);
			greenLine.x = 13;
			greenLine.y = 319 - greenLine.height;
			
			updateFpsCount++;
			totalFps += count;
			averageFps = totalFps / updateFpsCount;
			
			var blueLine:SkyShape = averageFpsLines[lineIndex];
			blueLine.x = 13;
			blueLine.y = 319 - Math.ceil((averageFps / maxFrameRate) * 78);
			
			currentFpsField.text = "current\t\t             " + count.toFixed(1);
			averageFpsField.text = "average\t\t             " + averageFps.toFixed(1);
			
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
			var memory:Number = System.totalMemory / MB;
			
			if (memory >= maxMemoryLength)
			{			
				for (var i:int = 0; i < 29; i++) 
				{
					var line:SkyShape = memoryLines[i];
					line.height = line.height * 0.5
					line.y = 319 - line.height;
				}
				
				maxMemoryLength *= 2;
			}
			
			line = memoryLines[lineIndex];
			line.height = Math.ceil((memory / maxMemoryLength) * 78);
			line.x = 225;
			line.y = 319 - line.height;
			
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
		 * Обновить график и данные о занимаемой видеопамяти приложения.
		 */
		private function updateGPUMemory():void
		{
			var memory:Number = SkySand.CONTEXT_3D.totalGPUMemory / MB;
			
			if (memory >= maxGPUMemorySize)
			{
				for (var i:int = 0; i < 29; i++) 
				{
					var line:SkyShape = memoryLines[i];
					line.height = line.height * 0.5;
					line.y = 319 - line.height;
				}
				
				maxGPUMemorySize *= 2;
			}
			
			line = gpuMemoryLines[lineIndex];
			line.height = Math.ceil((memory / maxGPUMemorySize) * 78);
			line.x = 437;
			line.y = 319 - line.height;
			
			gpuMemoryField.text = memory.toFixed(2) + " mb";
			currentGPUMemoryField.text = "memory\t\t\t" + memory.toFixed(2);
			
			maxGpuMemory = maxGpuMemory < memory ? memory : maxGpuMemory;
			minGpuMemory = minGpuMemory > memory ? memory : minGpuMemory;
			
			var minLength:int = minGpuMemory.toFixed(2).length;
			var maxLength:int = maxGpuMemory.toFixed(2).length;
			
			minMaxGPUMemoryField.text = maxGpuMemory.toFixed(2) + '\n' + minGpuMemory.toFixed(2);	
			minMaxGPUMemoryField.setColor(ORANGE, 0, maxLength);
			minMaxGPUMemoryField.setColor(GREEN, maxLength + 1, minLength + maxLength + 1);
		}
		
		/**
		 * Обновить график и данные о времени затраченном на 1 кадр.
		 */
		private function updateFrameTime():void
		{
			var maxRenderTime:Number = 1000 / maxFrameRate * renderLineMultiplier;
			var totalTime:Number = renderTime + applicationUpdateTime;
			
			if (totalTime > maxRenderTime)
			{
				for (var i:int = 0; i < 29; i++) 
				{
					var line:SkyShape = renderTimeLines[i];
					line.height *= 0.5;
					line.y = 149 - line.height;
					
					line = applicationTimeLines[i];
					line.height *= 0.5;
					line.y = 149 - line.height - renderTimeLines[i].height;
				}
				
				renderLineMultiplier *= 2;
				maxRenderTime = 1000 / maxFrameRate * renderLineMultiplier;
			}
			
			var renderLine:SkyShape = renderTimeLines[lineIndex];
			renderLine.height = Math.ceil((renderTime / maxRenderTime) * 78);
			renderLine.x = 13;
			renderLine.y = 149 - renderLine.height;
			
			var appLine:SkyShape = applicationTimeLines[lineIndex];
			appLine.height = Math.ceil((applicationUpdateTime / maxRenderTime) * 78);
			appLine.x = 13;
			appLine.y = 149 - appLine.height - renderLine.height;
			
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
			create(651, 376, 0xDBB71E, 0x151E27);
			addText("PROFILER", "verdana", 0x151E27, 12);
			
			render = SkySand.render;
			
			applicationUpdateTime = 0;
			renderLineMultiplier = 1;
			beginTime = getTimer();
			startTime = beginTime;
			maxMemoryLength = 20;
			timeInterval = 1000;
			totalUpdateTime = 0;
			minMemory = 1000000;
			maxGPUMemorySize = 20;
			updateFpsCount = 0;
			maxGpuMemory = 0;
			minGpuMemory = 1000000;
			maxFrameRate = SkySand.FRAME_RATE;
			maxMemory = -1;
			averageFps = 0;
			renderTime = 0;
			minFps = 1000;
			totalFps = 0;
			nFrames = 0;
			maxFps = -1;
			lineIndex = 28;
			isBasic = false;
			
			drawLabel(ORANGE, "render", 11, 160);
			drawLabel(GREEN, "application", 11, 180);
			drawLabel(GREEN, "current", 11, 330);
			drawLabel(BLUE, "average", 11, 350);
			drawLabel(PURPLE, "ram memory", 223, 330);
			drawLabel(YELLOW, "gpu memory", 435, 330);
			
			var line:SkyShape = new SkyShape();
			line.color = GREY;
			line.drawRect(0, 0, 629, 1);
			line.x = 11;
			line.y = 200;
			line.mouseEnabled = false;
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
			fpsTextField.y = 212;
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
			currentMemoryField.textColor = PURPLE;
			currentMemoryField.x = 232;
			currentMemoryField.y = 328;
			addChild(currentMemoryField);
			
			currentGPUMemoryField = createTextField();
			currentGPUMemoryField.textColor = YELLOW;
			currentGPUMemoryField.x = 444;
			currentGPUMemoryField.y = 328;
			addChild(currentGPUMemoryField);
			
			gpuMemoryField = createTextField();
			gpuMemoryField.size = 20;
			gpuMemoryField.x = 432;
			gpuMemoryField.y = 212;
			addChild(gpuMemoryField);
			
			minMaxGPUMemoryField = createTextField();
			minMaxGPUMemoryField.height = 40;
			minMaxGPUMemoryField.width = 60;
			minMaxGPUMemoryField.x = 590;
			minMaxGPUMemoryField.y = 201;
			addChild(minMaxGPUMemoryField);
			
			drawCallsField = createTextField();
			drawCallsField.width = 220;
			drawCallsField.x = 232;
			drawCallsField.y = 68;
			addChild(drawCallsField);
			
			renderObjectsCountField = createTextField();
			renderObjectsCountField.width = 220;
			renderObjectsCountField.x = 232;
			renderObjectsCountField.y = 81;
			addChild(renderObjectsCountField);
			
			graphicsCountField = createTextField();
			graphicsCountField.width = 220
			graphicsCountField.x = 232;
			graphicsCountField.y = 94;
			addChild(graphicsCountField);
			
			textCountField = createTextField();
			textCountField.width = 220;
			textCountField.x = 232;
			textCountField.y = 107;
			addChild(textCountField);
			
			spriteCountField = createTextField();
			spriteCountField.width = 220;
			spriteCountField.x = 232;
			spriteCountField.y = 120;
			addChild(spriteCountField);
			
			addFrame(11, 69, 203, 80);
			addFrame(11, 239, 203, 80);
			addFrame(223, 239, 203, 80);
			addFrame(435, 239, 203, 80);
			addFrame(223, 69, 415, 125);
			
			drawStaticText("frame rate", 9, 200);
			drawStaticText("frame time", 9, 30);
			drawStaticText("active time", 128, 30);
			drawStaticText("ram memory", 221, 200);
			drawStaticText("gpu memory", 433, 200);
			drawStaticText("render information", 221, 47);
			
			drawTringle(GREEN, 150, 212, 270);
			drawTringle(ORANGE, 160, 227, 90);
			drawTringle(GREEN, 380, 227, 90);
			drawTringle(ORANGE, 370, 212, 270);
			drawTringle(GREEN, 590, 227, 90);
			drawTringle(ORANGE, 580, 212, 270);
			
			drawTringle(GREEN, 227, 73, 0);
			drawTringle(GREEN, 227, 86, 0);
			drawTringle(GREEN, 227, 99, 0);
			drawTringle(GREEN, 227, 112, 0);
			drawTringle(GREEN, 227, 125, 0);
			
			createLineArrays();
			
			basicInfoField = createTextField();
			basicInfoField.width = 150;
			basicInfoField.height = 110;
			basicInfoField.textColor = 0xFFFFFF;
			basicInfoField.visible = false;
			addChild(basicInfoField);
			
			switchButton = new SkyButton();
			switchButton.create(SkyUI.TRIANGLE, 10, 10, 0xFFFFFF, switchProfiler);
			switchButton.x = 640;
			switchButton.y = 365;
			addChild(switchButton);
		}
		
		/**
		 * Добавить рамку.
		 * @param	x расположение рамки по оси х.
		 * @param	y расположение рамки по оси у.
		 */
		private function addFrame(x:Number, y:Number, width:Number, height:Number):void
		{
			var frame:SkyShape = new SkyShape();
			frame.color = GREY;
			frame.drawFrame(0, 0, width, height, 2);
			frame.x = x;
			frame.y = y;
			frame.mouseEnabled = false;
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
			fpsLines = new Vector.<SkyShape>();
			memoryLines = new Vector.<SkyShape>();
			gpuMemoryLines = new Vector.<SkyShape>();
			averageFpsLines = new Vector.<SkyShape>();
			renderTimeLines = new Vector.<SkyShape>();
			applicationTimeLines = new Vector.<SkyShape>();
			
			for (var i:int = 0; i < 29; i++)
			{
				var line:SkyShape = new SkyShape();
				line.mouseEnabled = false;
				line.color = ORANGE;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 71;
				line.x = 13 + i * 7;
				renderTimeLines[i] = line;
				addChild(line);
				
				line = new SkyShape();
				line.mouseEnabled = false;
				line.color = GREEN;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 71;
				line.x = 13 + i * 7;
				applicationTimeLines[i] = line;
				addChild(line);
				
				line = new SkyShape();
				line.mouseEnabled = false;
				line.color = GREEN;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 319;
				line.x = 13 + i * 7;
				fpsLines[i] = line;
				addChild(line);
				
				line = new SkyShape();
				line.mouseEnabled = false;
				line.color = 0x151E27;
				line.drawRect(0, 0, 5, 2);
				line.y = 319;
				line.x = 13 + i * 7;
				averageFpsLines[i] = line;
				addChild(line);
				
				line = new SkyShape();
				line.mouseEnabled = false;
				line.color = PURPLE;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 319;
				line.x = 225 + i * 7;
				memoryLines[i] = line;
				addChild(line);
				
				line = new SkyShape();
				line.mouseEnabled = false;
				line.color = YELLOW;
				line.drawRect(0, 0, 5, 78);
				line.height = 0;
				line.y = 319;
				line.x = 437 + i * 7;
				gpuMemoryLines[i] = line;
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
			var sprite:SkyShape = new SkyShape();
			sprite.color = GREY;
			sprite.drawRect(0, 0, 205, 16);
			sprite.x = x;
			sprite.y = y;
			addChild(sprite);
			
			sprite = new SkyShape();
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
			var sprite:SkyShape = new SkyShape();
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