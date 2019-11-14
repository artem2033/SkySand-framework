package skysand.display
{
	import skysand.render.SkyHardwareRender;
	import skysand.render.SkyShapeBatch;
	import skysand.input.SkyMouse;
	import skysand.utils.SkyUtils;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyShape extends SkyRenderObjectContainer
	{
		/**
		 * Ссылка на пакет для отрисовки.
		 */
		public var batch:SkyShapeBatch;
		
		/**
		 * Имя пакета для отрисовки фигуры.
		 */
		public var batchName:String;
		
		/**
		 * Ссылка на вершины.
		 */
		public var batchVertices:Vector.<Number>;
		
		/**
		 * Изначально заданные вершины многоугольника.
		 */
		protected var mVertices:Vector.<Number>;
		
		/**
		 * Ограничивающие координаты фигуры.
		 */
		private var maxX:Number;
		private var maxY:Number;
		private var minX:Number;
		private var minY:Number;
		
		public function SkyShape()
		{
			batchName = "shape";
			
			maxX = -1000000;
			maxY = -1000000;
			minX = 1000000;
			minY = 1000000;
			
			mVertices = new Vector.<Number>();
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			super.free();
			
			if (mVertices != null)
			{
				mVertices.length = 0;
				mVertices = null;
			}
		}
		
		/**
		 * Нарисовать скруглённый прямоугольник.
		 * @param	x смещение по оси х.
		 * @param	y смещение по оси у.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	radius радиус углов.
		 * @param	numSides количество сегментов на угол.
		 */
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, radius:Number, numSides:int):void
		{
			drawFullRoundRect(x, y, width, height, numSides, radius, radius, radius, radius);
		}
		
		/**
		 * Нарисовать скруглённый прямоугольник с заданием всех углов.
		 * @param	x смещение по оси х.
		 * @param	y смещение по оси у.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	numSides количество сегментов на угол.
		 * @param	topLeftRadius радиус левого верхнего угла.
		 * @param	topRightRadius радиус правого верхнего угла.
		 * @param	downLeftRadius радиус левого нижнего угла.
		 * @param	downRightRadius радиус правого нижнего угла.
		 */
		public function drawFullRoundRect(x:Number, y:Number, width:Number, height:Number, numSides:int, topLeftRadius:Number, topRightRadius:Number, downLeftRadius:Number, downRightRadius:Number):void
		{
			if (numSides < 6) numSides = 6;
			
			var offset:Number = Math.PI / 2;
			var angleDelta:Number = offset / numSides;
			var angle:Number = 0;
			
			if (topLeftRadius == 0)
			{
				addVertex(x + topLeftRadius, y + topLeftRadius);
			}
			else
			{
				for (var i:int = 0; i < numSides; i++)
				{
					var px:Number = Math.cos(angle + offset * 2) * topLeftRadius + x + topLeftRadius;
					var py:Number = Math.sin(angle + offset * 2) * topLeftRadius + y + topLeftRadius;
					
					addVertex(px, py);
					
					angle += angleDelta;
				}
			}
			
			angle = 0;
			
			if (topRightRadius == 0)
			{
				addVertex(x + width - topRightRadius, y + topRightRadius);
			}
			else
			{
				for (i = 0; i < numSides; i++)
				{
					px = Math.cos(angle - offset) * topRightRadius + x + width - topRightRadius;
					py = Math.sin(angle - offset) * topRightRadius + y + topRightRadius;
					
					addVertex(px, py);
					
					angle += angleDelta;
				}
			}
			
			angle = 0;
			
			if (downRightRadius == 0)
			{
				addVertex(x + width - downRightRadius, y + height - downRightRadius);
			}
			else
			{
				for (i = 0; i < numSides; i++)
				{
					px = Math.cos(angle) * downRightRadius + x + width - downRightRadius;
					py = Math.sin(angle) * downRightRadius + y + height - downRightRadius;
					
					addVertex(px, py);
					
					angle += angleDelta;
				}
			}
			
			angle = 0;
			
			if (downLeftRadius == 0)
			{
				addVertex(x + downLeftRadius, y + height - downLeftRadius);
			}
			else
			{
				for (i = 0; i < numSides; i++)
				{
					px = Math.cos(angle + offset) * downLeftRadius + x + downLeftRadius;
					py = Math.sin(angle + offset) * downLeftRadius + y + height - downLeftRadius;
					
					addVertex(px, py);
					
					angle += angleDelta;
				}
			}
		}
		
		/**
		 * Нарисовать многоугольник.
		 * @param	x смещение по оси х.
		 * @param	y смещение по оси у.
		 * @param	radius радиус.
		 * @param	numSides количество сторон.
		 */
		public function drawCircle(x:Number, y:Number, radius:Number, numSides:int):void
		{
			drawEllipse(x, y, radius, radius, numSides);
		}
		
		/**
		 * Нарисовать кольцо.
		 * @param	x центр по оси х.
		 * @param	y центр по оси у.
		 * @param	outRadius внешний радиус.
		 * @param	inRadius внутренний радиус, должен быть меньше внешнего.
		 * @param	numSides число сторон или то на сколько круглая будет окружность.
		 */
		public function drawRing(x:Number, y:Number, outRadius:Number, inRadius:Number, numSides:int):void
		{
			if (outRadius < inRadius) return;
			
			if (numSides < 6) numSides = 6;
			
			var angleDelta:Number = 2 * Math.PI / numSides;
			var angle:Number = 0;
			
			for (var i:int = 0; i < numSides; i++)
			{
				var dx:Number = Math.cos(angle) * outRadius + x;
				var dy:Number = Math.sin(angle) * outRadius + y;
				
				addVertex(dx, dy);
				
				angle += angleDelta;
			}
			
			dx = Math.cos(angle) * outRadius + x;
			dy = Math.sin(angle) * outRadius + y;
			
			addVertex(dx, dy);
			
			angle = 0;
			
			for (i = 0; i < numSides; i++)
			{
				dx = Math.cos(angle) * inRadius + x;
				dy = Math.sin(angle) * inRadius + y;
				
				addVertex(dx, dy);
				
				angle -= angleDelta;
			}
			
			dx = Math.cos(angle) * inRadius + x;
			dy = Math.sin(angle) * inRadius + y;
			
			addVertex(dx, dy);
		}
		
		/**
		 * Нарисовать рамку.
		 * @param	x центр рамки по оси х.
		 * @param	y центр рамки по оси у.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	thickness толщина стенок рамки.
		 */
		public function drawFrame(x:Number, y:Number, width:Number, height:Number, thickness:Number):void
		{
			addVertex(x + thickness, y + thickness);
			addVertex(x, y);
			addVertex(x + width, y);
			addVertex(x + width, y + height);
			addVertex(x, y + height);
			addVertex(x, y);
			addVertex(x + thickness, y + thickness);
			addVertex(x + thickness, y + height - thickness);
			addVertex(x + width - thickness, y + height - thickness);
			addVertex(x + width - thickness, y + thickness);
		}
		
		/**
		 * Нарисовать эллипс.
		 * @param	x смещение по оси х.
		 * @param	y смещение по оси у.
		 * @param	radiusX радиус по оси х.
		 * @param	radiusY радиус по оси у.
		 * @param	numSides количество сторон.
		 */
		public function drawEllipse(x:Number, y:Number, radiusX:Number, radiusY:Number, numSides:int):void
		{
			if (numSides < 6) numSides = 6;
			
			var angleDelta:Number = 2 * Math.PI / numSides;
			var angle:Number = 0;
			
			for (var i:int = 0; i < numSides; i++)
			{
				var dx:Number = Math.cos(angle) * radiusX + x;
				var dy:Number = Math.sin(angle) * radiusY + y;
				
				addVertex(dx, dy);
				
				angle += angleDelta;
			}
		}
		
		/**
		 * Нарисовать прямоугольник.
		 * @param	x смещение по оси х.
		 * @param	y смещение по оси у.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			addVertex(x, y);
			addVertex(width + x, y);
			addVertex(width + x, height + y);
			addVertex(x, height + y);
		}
		
		/**
		 * Добавить вершину.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function addVertex(x:Number, y:Number):void
		{
			mVertices.push(x, y);
			
			minX = x < minX ? x : minX;
			maxX = x > maxX ? x : maxX;
			minY = y < minY ? y : minY;
			maxY = y > maxY ? y : maxY;
			
			mWidth = maxX - minX;
			mHeight = maxY - minY;
		}
		
		/**
		 * Получить вершины в виде точек.
		 */
		public function get vertices():Vector.<Number>
		{
			return mVertices;
		}
		
		/**
		 * Получить число вершин.
		 */
		public function get verticesCount():int
		{
			return mVertices.length / 2;
		}
		
		/**
		 * Инициализировать объект и добавить в список отображения.
		 */
		override public function init():void
		{
			if (mVertices.length > 5)
			{
				batch = SkySand.render.getBatch(batchName) as SkyShapeBatch;
				
				if (batch == null)
				{
					batch = new SkyShapeBatch();
					SkySand.render.addBatch(batch, batchName); 
				}
				
				batchVertices = batch.verteces;
				batch.add(this);
			}
		}
		
		/**
		 * Удалить объект из списка отображения.
		 */
		override public function remove():void
		{
			if (batch != null)
			{
				batch.remove(this);
			}
		}
		
		/**
		 * Посчитать глобальную видимость.
		 */
		override public function calculateGlobalVisible():void 
		{
			super.calculateGlobalVisible();
			
			if (batchVertices == null) return;
			var length:int = mVertices.length / 2;
			var depth:Number = !isVisible ? -1 : mDepth / SkyHardwareRender.MAX_DEPTH;
			
			for (var i:int = 0; i < length; i++)
				batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 2] = depth;
			
			batch.isUploaded = false;
		}
		
		/**
		 * Посчитать трансформацию объекта.
		 */
		override public function updateTransformation():void 
		{
			super.updateTransformation();
			
			if (batchVertices == null) return;
			
			worldMatrix.transformShape(mVertices, batchVertices, indexID, mWidth / (maxX - minX), mHeight / (maxY - minY), mPivotX, mPivotY);
			batch.isUploaded = false;
		}
		
		/**
		 * Обновить вершины.
		 */
		public function updateVertices():void
		{
			if (batchVertices == null) return;
			
			worldMatrix.transformShape(mVertices, batchVertices, indexID, mWidth / (maxX - minX), mHeight / (maxY - minY), mPivotX, mPivotY);
			batch.isUploaded = false;
			boundsCalculated = false;
		}
		
		/**
		 * Проверка столкновения мыши с ограничивающим прямоугольником.
		 * @return
		 */
		override public function hitTestBoundsWithMouse():Boolean
		{
			var x:Number = !batch.allowCameraTransformation ? SkyMouse.x : SkyMouse.tx;
			var y:Number = !batch.allowCameraTransformation ? SkyMouse.y : SkyMouse.ty;
			
			if (!boundsCalculated) calculateBounds();
			if (x < bounds.x + globalX || x > bounds.width + globalX) return false;
			if (y < bounds.y + globalY || y > bounds.height + globalY) return false;
			
			return true;
        }
		
		/**
		 * Проверка столкновения с курсором мыши.
		 * @return возвращает true, если столкнулся, иначе false.
		 */
		override public function hitTestMouse():Boolean
		{
			if (batchVertices == null) return false;
			
			var x:Number = !batch.allowCameraTransformation ? SkyMouse.x : SkyMouse.tx;
			var y:Number = !batch.allowCameraTransformation ? SkyMouse.y : SkyMouse.ty;
			
			var length:int = mVertices.length / 2;
			var i:int, j:int = length - 1;
			var oddNodes:uint = 0;
			
			for (i = 0; i < length; i++)
			{
				var ix:Number = batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID];
				var iy:Number = batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1];
				var jx:Number = batchVertices[j * SkyShapeBatch.DATA_PER_VERTEX + indexID];
				var jy:Number = batchVertices[j * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1];
				
				if ((iy < y && jy >= y || jy < y && iy >= y) && (ix <= x || jx <= x))
					oddNodes ^= uint(ix + (y - iy) / (jy - iy) * (jx - ix) < x);
				
				j = i;
			}
			
			return oddNodes != 0;
		}
		
		/**
		 * Проверка столкновения с точкой.
		 * @param	x координата точки х.
		 * @param	y координата точки у.
		 * @return возвращает true, если столкнулся, иначе false.
		 */
		override public function hitTestPoint(x:Number, y:Number):Boolean
		{
			var length:int = mVertices.length / 2;
			var i:int, j:int = length - 1;
			var oddNodes:uint = 0;
			
			for (i = 0; i < length; ++i)
			{
				var ix:Number = batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID];
				var iy:Number = batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1];
				var jx:Number = batchVertices[j * SkyShapeBatch.DATA_PER_VERTEX + indexID];
				var jy:Number = batchVertices[j * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1];
				
				if ((iy < y && jy >= y || jy < y && iy >= y) && (ix <= x || jx <= x))
					oddNodes ^= uint(ix + (y - iy) / (jy - iy) * (jx - ix) < x);
				
				j = i;
			}
			
			return oddNodes != 0;
		}
		
		/**
		 * Рассчитать ограничивающий прямоугольник.
		 */
		override public function calculateBounds():void 
		{
			var length:int = mVertices.length / 2;
			if (batchVertices == null) return;
			
			bounds.x = batchVertices[indexID] - globalX;
			bounds.y = batchVertices[indexID + 1] - globalY;
			bounds.width = bounds.x;
			bounds.height = bounds.y;
			
			for (var i:int = 1; i < length; i++)
			{
				var x:Number = batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID] - globalX;
				var y:Number = batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1] - globalY;
				
				bounds.x = x < bounds.x ? x : bounds.x;
				bounds.width = x > bounds.width ? x : bounds.width;
				bounds.y = y < bounds.y ? y : bounds.y;
				bounds.height = y > bounds.height ? y : bounds.height;
			}
			
			boundsCalculated = true;
		}
		
		/**
		 * Цвет.
		 */
		override public function set color(value:uint):void 
		{
			if (mColor != value)
			{
				mColor = value;
				
				if (batchVertices == null) return;
				
				var length:int = mVertices.length / 2;
				var r:Number = SkyUtils.getRed(value) / 255;
				var g:Number = SkyUtils.getGreen(value) / 255;
				var b:Number = SkyUtils.getBlue(value) / 255;
				
				for (var i:int = 0; i < length; i++)
				{
					batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 3] = r;
					batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 4] = g;
					batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 5] = b;
				}
				
				batch.isUploaded = false;
			}
		}
		
		/**
		 * Прозрачность от 0 до 1.
		 */
		override public function set alpha(value:Number):void 
		{
			if (mAlpha != value)
			{
				mAlpha = value;
				
				if (batchVertices == null) return;
				var length:int = mVertices.length / 2;
				
				for (var i:int = 0; i < length; i++)
				{
					batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 6] = value;
				}
				
				batch.isUploaded = false;
			}
		}
		
		/**
		 * Глубина.
		 */
		override public function set depth(value:int):void 
		{
			if (mDepth != value)
			{
				mDepth = value;
				
				if (batchVertices == null || !isVisible) return;
				var length:int = mVertices.length / 2;
				
				for (var i:int = 0; i < length; i++)
				{
					batchVertices[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 2] = value / SkyHardwareRender.MAX_DEPTH;
				}
				
				batch.isUploaded = false;
			}
		}
	}
}