package skysand.render
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Vector3D;
	import skysand.debug.Console;
	import skysand.display.SkyCamera;
	import skysand.input.SkyKey;
	import skysand.input.SkyKeyboard;
	import skysand.input.SkyMouse;
	import skysand.text.SkyTextField;
	import skysand.ui.SkyButton;
	import skysand.utils.SkyUtils;
	
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkySprite;
	import skysand.display.SkyShape;
	
	public class SkyHardwareRender extends Object
	{
		public static const MAX_DEPTH:uint = 100000;
		
		public static var shaderVersion:uint = 4;
		
		/**
		 * Пересчитать глубину объектов.
		 */
		public var updateDepth:Boolean;
		
		/**
		 * Сглаживание.
		 */
		public var antialiasing:Number = 4;
		
		/**
		 * Число неотрисованных пакетов.
		 */
		internal var notRenderedBatchesCount:int = 0;
		
		/**
		 * Ширина отрисовываемого изображения.
		 */
		private var resolutionWidth:Number;
		
		/**
		 * Высота отрисовываемого изображения.
		 */
		private var resolutionHeight:Number;
		
		/**
		 * Режим растяжения изображения под размеры экрана.
		 */
		private var isScaleMode:Boolean;
		
		/**
		 * Ссылка на контекст.
		 */
		private var context3D:Context3D;
		
		/**
		 * Матрица проекции.
		 */
		public var modelViewMatrix:Matrix3D;//
		
		/**
		 * Матрица трансформации камеры.
		 */
		private var cameraView:Matrix3D;
		
		/**
		 * Камера.
		 */
		private var camera:SkyCamera;
		
		/**
		 * Матрица со смещением мировых координат.
		 */
		private var worldView:Matrix3D;
		
		/**
		 * Массив пакетов для отрисовки.
		 */
		private var batches:Vector.<SkyBatchBase>;
		
		/**
		 * Стак для смены пакета в который нужно добавлять графику.
		 */
		private var batchStack:Vector.<SkyBatchBase>;
		
		/**
		 * Количество пакетов для отрисовки.
		 */
		private var nBatches:int;
		
		/**
		 * Массив отрисовываемых объектов.
		 */
		public var objects:Vector.<SkyRenderObjectContainer>;
		
		/**
		 * Число отрисовываемых объектов.
		 */
		private var nObjects:uint;
		
		/**
		 * Число для подсчёта глубины объектов.
		 */
		private var depthCount:uint;
		
		/**
		 * Для сортировки объектов по их глубине.
		 */
		private var min:int = MAX_DEPTH;
		
		/**
		 * Количество отрисовываемых текстовых полей.
		 */
		private var textFieldsCount:int;
		
		/**
		 * Количество отрисовываемых графических объектов.
		 */
		private var graphicsCount:int;
		
		/**
		 * Количество отрисовываемых спрайтов.
		 */
		private var spriteCount:int;
		
		/**
		 * Корневой объект.
		 */
		public var root:SkyRenderObjectContainer;//
		
		/**
		 * Текстура для пост эффектов.
		 */
		private var renderTarget:RectangleTexture;
		
		/**
		 * Буффер текстурных координат для отрисовки текстуры.
		 */
		private var uvBuffer:VertexBuffer3D;
		
		/**
		 * Буффер индексов для отрисовки треугольников.
		 */
		private var indexBuffer:IndexBuffer3D;
		
		/**
		 * Буффер вершин для отрисовки текстуры с пост эффектами.
		 */
		private var vertexBuffer:VertexBuffer3D;
		
		/**
		 * Шейдеры для пост эффектов.
		 */
		private var shader:Program3D;
		
		/**
		 * Вершины для отрисовки в текстуру.
		 */
		private var verteces:Vector.<Number>;
		
		/**
		 * Текстурные координаты для отрисовки текстуры.
		 */
		private var uv:Vector.<Number>;
		
		/**
		 * Отрисовывать сначала в текстуру.
		 */
		private var isRenderToTarget:Boolean;
		
		/**
		 * Ассемблер для шейдеров.
		 */
		private var assembler:AGALMiniAssembler;
		
		/**
		 * Ссылка класса на самого себя.
		 */
		private static var _instance:SkyHardwareRender;
		
		/**
		 * Конструктор.
		 */
		public function SkyHardwareRender()
		{
			if (_instance != null)
			{
				throw new Error("Используйте instance для доступа к экземпляру класса SkyHardwareRender");
			}
			_instance = this;
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():SkyHardwareRender
		{
			return _instance == null ? new SkyHardwareRender() : _instance;
		}
		
		/**
		 * Инициализировать рендер.
		 */
		public function initialize():void
		{
			context3D = SkySand.CONTEXT_3D;
			context3D.configureBackBuffer(SkySand.SCREEN_WIDTH, SkySand.SCREEN_HEIGHT, 3);
			
			worldView = new Matrix3D();
			worldView.appendTranslation(-SkySand.SCREEN_WIDTH / 2, -SkySand.SCREEN_HEIGHT / 2, 0);
			worldView.appendScale(2 / SkySand.SCREEN_WIDTH, -2 / SkySand.SCREEN_HEIGHT, 1);
			
			modelViewMatrix = new Matrix3D();
			modelViewMatrix.append(worldView);
			
			verteces = new Vector.<Number>();
			verteces.push(0, 0, 0);
			verteces.push(SkySand.SCREEN_WIDTH, 0, 0);
			verteces.push(0, SkySand.SCREEN_HEIGHT, 0);
			verteces.push(SkySand.SCREEN_WIDTH, SkySand.SCREEN_HEIGHT, 0);
			
			uv = new Vector.<Number>();
			uv.push(0, 0);
			uv.push(1, 0);
			uv.push(0, 1);
			uv.push(1, 1);
			
			var indeces:Vector.<uint> = new Vector.<uint>();
			indeces.push(0, 1, 2);
			indeces.push(1, 3, 2);
			
			var vertexShader:String = "";
			vertexShader += "m44 op, va0, vc0 \n";
			vertexShader += "mov v0, va1";
			
			var pixelShader:String = "";
			pixelShader += "tex oc, v0.xy, fs0 <2d, clamp, nearest, mipnone>";
			
			renderTarget = context3D.createRectangleTexture(SkySand.SCREEN_WIDTH, SkySand.SCREEN_HEIGHT, Context3DTextureFormat.BGRA, true);
			renderTarget.uploadFromBitmapData(new BitmapData(1, 1));
			
			indexBuffer = context3D.createIndexBuffer(6);
			indexBuffer.uploadFromVector(indeces, 0, 6);
			
			uvBuffer = context3D.createVertexBuffer(4, 2);
			uvBuffer.uploadFromVector(uv, 0, 4);
			
			vertexBuffer = context3D.createVertexBuffer(4, 3);
			vertexBuffer.uploadFromVector(verteces, 0, 4);
			
			assembler = new AGALMiniAssembler();
			shader = assembler.assemble2(context3D, shaderVersion, vertexShader, pixelShader);
			context3D.setProgram(shader);
			
			batchStack = new Vector.<SkyBatchBase>();
			batches = new Vector.<SkyBatchBase>();
			nBatches = 0;
			
			objects = new Vector.<SkyRenderObjectContainer>();
			nObjects = 0;
			
			isRenderToTarget = false; //баг с порядком отображения текстовых полей.
			isScaleMode = false;
			updateDepth = false;
			
			resolutionWidth = SkySand.SCREEN_WIDTH;
			resolutionHeight = SkySand.SCREEN_HEIGHT;
			textFieldsCount = 0;
			graphicsCount = 0;
			spriteCount = 0;
			
			SkySand.STAGE.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, onResizeListener);
		}
		
		/**
		 * Задать размеры отрисовываемого изображения.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function setResolution(width:Number, height:Number):void
		{
			resolutionWidth = width;
			resolutionHeight = height;
			
			isScaleMode = (width < SkySand.SCREEN_WIDTH || width > SkySand.SCREEN_WIDTH || height < SkySand.SCREEN_HEIGHT || height > SkySand.SCREEN_HEIGHT) ? true : false;
			
			context3D.configureBackBuffer(SkySand.SCREEN_WIDTH, SkySand.SCREEN_HEIGHT, antialiasing, true);
			
			if (!isScaleMode)
			{
				worldView.identity();
				worldView.appendTranslation(-SkySand.SCREEN_WIDTH / 2, -SkySand.SCREEN_HEIGHT / 2, 0);
				worldView.appendScale(2 / SkySand.SCREEN_WIDTH, -2 / SkySand.SCREEN_HEIGHT, 1);
				
				verteces[3] = SkySand.SCREEN_WIDTH;
				verteces[7] = SkySand.SCREEN_HEIGHT;
				verteces[9] = SkySand.SCREEN_WIDTH;
				verteces[10] = SkySand.SCREEN_HEIGHT;
				
				vertexBuffer.uploadFromVector(verteces, 0, 4);
				
				renderTarget.dispose();
				renderTarget = context3D.createRectangleTexture(SkySand.SCREEN_WIDTH, SkySand.SCREEN_HEIGHT, Context3DTextureFormat.BGRA, true);
				renderTarget.uploadFromBitmapData(new BitmapData(1, 1));
			}
			else
			{
				if (SkySand.SCREEN_WIDTH / SkySand.SCREEN_HEIGHT < resolutionWidth / resolutionHeight)
				{
					var aspectRatio:Number = SkySand.SCREEN_WIDTH / SkySand.SCREEN_HEIGHT;
					
					var w:Number = resolutionWidth;
					var h:Number = w / aspectRatio;
				}
				else
				{
					aspectRatio = SkySand.SCREEN_HEIGHT / SkySand.SCREEN_WIDTH;
					
					h = resolutionHeight;
					w = h / aspectRatio;
				}
				
				worldView.identity();
				worldView.appendTranslation(-w / 2, -h / 2, 0);
				worldView.appendScale(2 / w, -2 / h, 1);
				
				if (isRenderToTarget)
				{
					verteces[3] = w;
					verteces[7] = h;
					verteces[9] = w;
					verteces[10] = h;
					
					vertexBuffer.uploadFromVector(verteces, 0, 4);
					
					renderTarget.dispose();
					renderTarget = context3D.createRectangleTexture(w, h, Context3DTextureFormat.BGRA, true);
					renderTarget.uploadFromBitmapData(new BitmapData(1, 1));
				}
			}
			
			modelViewMatrix.identity();
			modelViewMatrix.append(worldView);
			
			if (camera != null) camera.setScreenSize(width, height);
		}
		
		/**
		 * Удалить пакет отрисовки.
		 * @param	batch пакет.
		 */
		public function removeBatch(batch:SkyBatchBase):void
		{
			var index:int = batches.indexOf(batch);
			
			if (index < 0) return;
			
			batchStack.removeAt(batchStack.indexOf(batch));
			batches[index] = null;
			batches.removeAt(index);
			nBatches--;
		}
		
		/**
		 * Запросить пакет для отрисовки, если нету создаётся новый и возвращается.
		 * @param	name название.
		 * @return возращает пакет.
		 */
		public function getBatch(name:String):SkyBatchBase
		{
			var batch:SkyBatchBase;
			
			for (var i:int = nBatches - 1; i >= 0; i--)
			{
				batch = batchStack[i];
				
				if (batch.name == name && batch.verteces.length < 196596)
				{
					return batch;
				}
			}
			
			return null;
		}
		
		/**
		 * Сместить пакет в конец списка, в который добавляются объекты.
		 * @param	index позиция в списке отрисовки.
		 */
		public function pushUpBatch(index:int):void
		{
			var batch:SkyBatchBase = batches[index];
			var stackIndex:int = batchStack.indexOf(batch);
			
			batchStack.removeAt(stackIndex);
			batchStack.push(batch);
		}
		
		/**
		 * Добавить новый пакет отрисовки.
		 * @param	name название пакета.
		 */
		public function addBatch(batch:SkyBatchBase, name:String):void
		{
			batch.initialize(context3D, modelViewMatrix, name);
			batches[nBatches] = batch;
			batchStack[nBatches] = batch;
			nBatches++;
		}
		
		/**
		 * Поменять пакеты отрисовки местами.
		 * @param	index0 номер первого пакета.
		 * @param	index1 номер второго пакета.
		 */
		public function swapBatches(index0:int, index1:int):void
		{
			var batch0:SkyBatchBase = batches.removeAt(index0) as SkyBatchBase;
			var batch1:SkyBatchBase = batches.removeAt(index1) as SkyBatchBase;
			
			if (index0 > index1)
			{
				batches.insertAt(index1, batch0);
				batches.insertAt(index0, batch1);
			}
			else
			{
				batches.insertAt(index0, batch1);
				batches.insertAt(index1, batch0);
			}
		}
		
		/**
		 * Вывести в output информацию о списке пакетов.
		 */
		public function showBatchList():void
		{
			var string:String = "";
			
			for (var i:int = 0; i < nBatches; i++)
			{
				string += "name: " + batches[i].name + ", index: " + i.toString() + "\n";
			}
			
			trace(string);
		}
		
		/**
		 * Удалить отрисовываемый объект.
		 * @param	object объект.
		 */
		public function removeObjectFromRender(object:SkyRenderObjectContainer):void
		{
			var index:int = objects.indexOf(object);
			
			if (index == -1) return;
			
			objects.removeAt(index);
			nObjects--;
			
			if (object is SkyShape)
			{
				graphicsCount--;
			}
			else if (object is SkySprite)
			{
				spriteCount--;
			}
			else
			{
				textFieldsCount--;
			}
		}
		
		/**
		 * Добавить объект для отрисовки.
		 * @param	object объект.
		 */
		public function addObjectToRender(object:SkyRenderObjectContainer):void
		{
			objects.push(object);
			object.updateData(0);
			nObjects++;
			
			if (object is SkyShape)
			{
				graphicsCount++;
			}
			else if (object is SkySprite)
			{
				spriteCount++;
			}
			else if (object is SkyTextField)
			{
				textFieldsCount++;
			}
		}
		
		/**
		 * Пересчитать глубину отрисовываемых объектов.
		 * @param	child начальный объект.
		 */
		private function calculateDepth(child:SkyRenderObjectContainer):void
		{
			if (child == null) return;
			
			child.depth = MAX_DEPTH - depthCount;
			depthCount++;
			
			if (child.children)
			{
				for (var i:int = 0; i < child.numChildren; i++)
				{
					calculateDepth(child.children[i]);
				}
			}
		}
		
		/**
		 * Задать камеру.
		 * @param	camera ссылка на камеру.
		 */
		public function setCamera(camera:SkyCamera):void
		{
			this.camera = camera;
			cameraView = camera.transformMatrix;
		}
		
		/**
		 * Задать корневой объект.
		 * @param	root корневой объект.
		 */
		public function setRoot(root:SkyRenderObjectContainer):void
		{
			this.root = root;
		}
		
		private var angle:Number = 0;
		/**
		 * Обновить рендер.
		 * @param	deltaTime время прошедшее с прошлого кадра.
		 */
		public function update(deltaTime:Number):void
		{
			//context3D.clear();
			
			if (cameraView != null)
			{
				modelViewMatrix.identity();
				modelViewMatrix.append(worldView);
				modelViewMatrix.append(cameraView);
			}
			
			if (isRenderToTarget)
			{
				context3D.setRenderToTexture(renderTarget);//
				context3D.clear();
			}
			
			if (updateDepth)
			{
				depthCount = 0;
				calculateDepth(root);
				updateDepth = false;
				
				objects.sort(compare);
			}
			
			for (var i:int = 0; i < nObjects; i++)
			{
				objects[i].updateData(deltaTime);
			}
			
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewMatrix, true);
			context3D.setCulling(Context3DTriangleFace.BACK);
			context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			notRenderedBatchesCount = 0;
			
			for (i = 0; i < nBatches; i++)
			{
				batches[i].render();
			}
			
			if (isRenderToTarget)
			{
				context3D.setRenderToBackBuffer();
				context3D.setProgram(shader);
				context3D.setTextureAt(0, renderTarget);
				context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewMatrix, true);
				context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				context3D.drawTriangles(indexBuffer, 0, 2);
			}
			
			context3D.present();
		}
		
		/**
		 * Число вызовов отрисовки.
		 */
		public function get drawCallsCount():int
		{
			return isRenderToTarget ? batches.length + 1 - notRenderedBatchesCount : batches.length - notRenderedBatchesCount;
		}
		
		/**
		 * Число отрисовываемых объектов.
		 */
		public function get renderObjectsCount():int
		{
			return objects.length;
		}
		
		/**
		 * Число графических объектов.
		 */
		public function get graphicObjectsCount():int
		{
			return graphicsCount;
		}
		
		/**
		 * Число отрисовываемых спрайтов.
		 */
		public function get spriteObjectsCount():int
		{
			return spriteCount;
		}
		
		/**
		 * Число отрисовываемых текстовых полей.
		 */
		public function get textObjectsCount():int
		{
			return textFieldsCount;
		}
		
		/**
		 * Функция компоратор для сортировки.
		 * @param	a первый объект для сравнения.
		 * @param	b второй объект для сравнения.
		 * @return число от 1 до -1;
		 */
		private function compare(a:SkyRenderObject, b:SkyRenderObject):int
		{
			return a.depth < b.depth ? 1 : -1;
		}
		
		/**
		 * Слушатель события на изменение размеров окна.
		 * @param	event событие.
		 */
		private function onResizeListener(event:NativeWindowBoundsEvent):void
		{
			var width:Number = event.afterBounds.width;
			var height:Number = event.afterBounds.height;
			
			context3D.configureBackBuffer(width, height, antialiasing, true);
			
			SkySand.SCREEN_WIDTH = width;
			SkySand.SCREEN_HEIGHT = height;
			
			if (!isScaleMode)
			{
				worldView.identity();
				worldView.appendTranslation(-width / 2, -height / 2, 0);
				worldView.appendScale(2 / width, -2 / height, 1);
				
				verteces[3] = width;
				verteces[7] = height;
				verteces[9] = width;
				verteces[10] = height;
				
				vertexBuffer.uploadFromVector(verteces, 0, 4);
				
				renderTarget.dispose();
				renderTarget = context3D.createRectangleTexture(width, height, Context3DTextureFormat.BGRA, true);
				renderTarget.uploadFromBitmapData(new BitmapData(1, 1));
			}
			else
			{
				if (width / height < resolutionWidth / resolutionHeight)
				{
					var aspectRatio:Number = width / height;
					
					var w:Number = resolutionWidth;
					var h:Number = w / aspectRatio;
				}
				else
				{
					aspectRatio = height / width;
					
					h = resolutionHeight;
					w = h / aspectRatio;
				}
				
				worldView.identity();
				worldView.appendTranslation(-w / 2, -h / 2, 0);
				worldView.appendScale(2 / w, -2 / h, 1);
				
				if (isRenderToTarget)
				{
					verteces[3] = w;
					verteces[7] = h;
					verteces[9] = w;
					verteces[10] = h;
					
					vertexBuffer.uploadFromVector(verteces, 0, 4);
					
					renderTarget.dispose();
					renderTarget = context3D.createRectangleTexture(w, h, Context3DTextureFormat.BGRA, true);
					renderTarget.uploadFromBitmapData(new BitmapData(1, 1));
				}
			}
			
			modelViewMatrix.identity();
			modelViewMatrix.append(worldView);
			
			if (camera != null) camera.setScreenSize(width, height);
		}
	}
}