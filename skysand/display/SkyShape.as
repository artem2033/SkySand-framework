package skysand.display
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	import skysand.render.SkyShapeBatch;
	import skysand.render.SkyHardwareRender;
	import skysand.input.SkyMouse;
	import skysand.utils.SkyUtils;
	import skysand.utils.SkyMath;
	
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
		 * Матрица трансформации.
		 */
		private var matrix:Matrix
		
		/**
		 * Старые данные для оптимизации рендера.
		 */
		private var oldData:SkyOldData;
		
		/**
		 * Начальная ширина объекта.
		 */
		private var standartWidth:Number;
		
		/**
		 * Начальная высота объекта.
		 */
		private var standartHeight:Number;
		
		/**
		 * Массив для хранения временных данных о трансформированных вершин.
		 */
		public var v:Vector.<Number>;
		
		/**
		 * Ссылка на вершины.
		 */
		public var batchVerteces:Vector.<Number>;
		
		/**
		 * Изначально заданные вершины многоугольника.
		 */
		public var verteces:Vector.<Number>;
		
		/**
		 * Имя пакета для отрисовки фигуры.
		 */
		public var batchName:String;
		
		/**
		 * Ссылка на мышь.
		 */
		private var mouse:SkyMouse;
		
		/**
		 * Левый верхний угол ограничевающего прямоугольника.
		 */
		private var leftUpPoint:Point;
		
		public function SkyShape()
		{
			oldData = new SkyOldData();
			oldData.width = width + 1;
			oldData.height = height + 1;
			oldData.rotation = rotation + 1;
			oldData.depth = 2;
			oldData.color = color + 1;
			
			batchName = "shape";
			standartHeight = 1;
			standartWidth = 1;
			
			mouse = SkyMouse.instance;
			matrix = new Matrix();
			
			leftUpPoint = new Point();
			
			v = new Vector.<Number>();
			verteces = new Vector.<Number>();
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			super.free();
			
			leftUpPoint = null;
			oldData = null;
			matrix = null;
			mouse = null;
			
			if (v != null)
			{
				v.length = 0
				v = null;
			}
			
			if (verteces != null)
			{
				verteces.length = 0;
				verteces = null;
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
				verteces.push(x + topLeftRadius, y + topLeftRadius);
			}
			else
			{
				for (var i:int = 0; i < numSides; i++)
				{
					var px:Number = Math.cos(angle + offset * 2) * topLeftRadius + x + topLeftRadius;
					var py:Number = Math.sin(angle + offset * 2) * topLeftRadius + y + topLeftRadius;
					
					verteces.push(px, py);
					
					angle += angleDelta;
				}
			}
			
			angle = 0;
			
			if (topRightRadius == 0)
			{
				verteces.push(x + width - topRightRadius, y + topRightRadius);
			}
			else
			{
				for (i = 0; i < numSides; i++)
				{
					px = Math.cos(angle - offset) * topRightRadius + x + width - topRightRadius;
					py = Math.sin(angle - offset) * topRightRadius + y + topRightRadius;
					
					verteces.push(px, py);
					
					angle += angleDelta;
				}
			}
			
			angle = 0;
			
			if (downRightRadius == 0)
			{
				verteces.push(x + width - downRightRadius, y + height - downRightRadius);
			}
			else
			{
				for (i = 0; i < numSides; i++)
				{
					px = Math.cos(angle) * downRightRadius + x + width - downRightRadius;
					py = Math.sin(angle) * downRightRadius + y + height - downRightRadius;
					
					verteces.push(px, py);
					
					angle += angleDelta;
				}
			}
			
			angle = 0;
			
			if (downLeftRadius == 0)
			{
				verteces.push(x + downLeftRadius, y + height - downLeftRadius);
			}
			else
			{
				for (i = 0; i < numSides; i++)
				{
					px = Math.cos(angle + offset) * downLeftRadius + x + downLeftRadius;
					py = Math.sin(angle + offset) * downLeftRadius + y + height - downLeftRadius;
					
					verteces.push(px, py);
					
					angle += angleDelta;
				}
			}
			
			calcBounds();
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
			//pivotX -= radius;
			//pivotY -= radius;
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
				
				verteces.push(dx, dy);
				
				angle += angleDelta;
			}
			
			dx = Math.cos(angle) * outRadius + x;
			dy = Math.sin(angle) * outRadius + y;
			
			verteces.push(dx, dy);
			
			angle = 0;
			
			for (i = 0; i < numSides; i++)
			{
				dx = Math.cos(angle) * inRadius + x;
				dy = Math.sin(angle) * inRadius + y;
				
				verteces.push(dx, dy);
				
				angle -= angleDelta;
			}
			
			dx = Math.cos(angle) * inRadius + x;
			dy = Math.sin(angle) * inRadius + y;
			
			verteces.push(dx, dy);
			
			calcBounds();
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
			addVertex(x + width + thickness, y);
			addVertex(x + width + thickness, y + height + thickness);
			addVertex(x, y + height + thickness);
			addVertex(x, y);
			addVertex(x + thickness, y + thickness);
			addVertex(x + thickness, y + height);
			addVertex(x + width, y + height);
			addVertex(x + width, y + thickness);
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
				
				verteces.push(dx, dy);
				
				angle += angleDelta;
			}
			
			calcBounds();
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
			verteces.push(x, y);
			verteces.push(width + x, y);
			verteces.push(width + x, height + y);
			verteces.push(x, height + y);
			
			this.width = width;
			this.height = height;
			standartWidth = width;
			standartHeight = height;
		}
		
		/**
		 * Добавить вершину.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function addVertex(x:Number, y:Number):void
		{
			verteces.push(x, y);
			
			calcBounds();
		}
		
		/**
		 * Функция для обновления вершин.
		 */
		public function updateVertices():void
		{
			oldData.width--;
		}
		
		/**
		 * Получить вершины в виде точек.
		 */
		public function getVertices():Vector.<Number>
		{
			return verteces;
		}
		
		/**
		 * Получить число вершин.
		 */
		public function get vertecesCount():int
		{
			return verteces.length / 2;
		}
		
		/**
		 * Проверка столкновения мыши с ограничивающим прямоугольником.
		 * @return
		 */
		override public function hitTestBoundsWithMouse():Boolean
		{
			var x:Number = SkySand.STAGE.mouseX;
			var y:Number = SkySand.STAGE.mouseY;
			
			if (x > globalX + width + pivotX + leftUpPoint.x) return false;
			if (x < globalX + pivotX + leftUpPoint.x) return false;
			if (y > globalY + height + pivotY + leftUpPoint.y) return false;
			if (y < globalY + pivotY + leftUpPoint.y) return false;
			
			return true;
        }
		
		/**
		 * Проверка столкновения с курсором мыши.
		 * @return возвращает true, если столкнулся, иначе false.
		 */
		override public function hitTestMouse():Boolean
		{
			if (!batchVerteces) return false;
			
			var x:Number = SkySand.STAGE.mouseX;
			var y:Number = SkySand.STAGE.mouseY;
			var i:int, j:int = verteces.length / 2 - 1;
			var oddNodes:uint = 0;
			var length:int = verteces.length / 2;
			
			for (i = 0; i < length; ++i)
			{
				if (batchVerteces.length <= (i * SkyShapeBatch.DATA_PER_VERTEX + indexID) || indexID < 0) break;
				
				var ix:Number = batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID];
				var iy:Number = batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1];
				var jx:Number = batchVerteces[j * SkyShapeBatch.DATA_PER_VERTEX + indexID];
				var jy:Number = batchVerteces[j * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1];
				
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
			var i:int, j:int = verteces.length / 2 - 1;
			var oddNodes:uint = 0;
			var length:int = verteces.length / 2;
			
			for (i = 0; i < length; ++i)
			{
				if (batchVerteces.length <= (i * SkyShapeBatch.DATA_PER_VERTEX + indexID) || indexID < 0) break;
				
				var ix:Number = batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID];
				var iy:Number = batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1];
				var jx:Number = batchVerteces[j * SkyShapeBatch.DATA_PER_VERTEX + indexID];
				var jy:Number = batchVerteces[j * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1];
				
				if ((iy < y && jy >= y || jy < y && iy >= y) && (ix <= x || jx <= x))
					oddNodes ^= uint(ix + (y - iy) / (jy - iy) * (jx - ix) < x);
				
				j = i;
			}
			
			return oddNodes != 0;
		}
		
		/**
		 * Инициализировать объект и добавить в список отображения.
		 */
		override public function init():void
		{
			if (vertecesCount > 2)
			{
				batch = SkySand.render.getBatch(batchName) as SkyShapeBatch;
				
				if (batch == null)
				{
					batch = new SkyShapeBatch();
					SkySand.render.addBatch(batch, batchName); 
				}
				
				batchVerteces = batch.verteces;
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
		 * Функция обновления координат и других данных.
		 */
		override public function updateData(deltaTime:Number):void
		{
			super.updateData(deltaTime);
			
			if (batchVerteces == null) return;
			
			if (globalVisible == 1)
			{
				var length:int = verteces.length / 2;
			
				//var px:Number = pivotX * globalScaleX;
				//var py:Number = pivotY * globalScaleY;
				
				if (oldData.rotation != globalRotation || oldData.width != width || oldData.height != height || oldData.scaleX != globalScaleX || oldData.scaleY != globalScaleY)
				{
					var angle:Number = SkyMath.toRadian(globalRotation);
					matrix.scale(width * globalScaleX / standartWidth, height * globalScaleY / standartHeight);
					matrix.rotate(angle);
					
					for (var i:int = 0; i < length; i++)
					{
						var dx:Number = verteces[i * 2] - pivotX;
						var dy:Number = verteces[i * 2 + 1] - pivotY;
						
						v[i * 2] = -globalR.x - dx * matrix.a - dy * matrix.c;
						v[i * 2 + 1] = -globalR.y - dx * matrix.b - dy * matrix.d;
						
						batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID] = globalX - v[i * 2];
						batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1] = globalY - v[i * 2 + 1];
					}
					
					matrix.identity();
					
					oldData.rotation = globalRotation;
					oldData.x = globalX;
					oldData.y = globalY;
					oldData.width = width;
					oldData.height = height;
					oldData.scaleX = globalScaleX;
					oldData.scaleY = globalScaleY;
				}
				
				if (oldData.x != globalX)
				{
					for (i = 0; i < length; i++)
					{
						batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID] = globalX - v[i * 2];// + px;
					}
					
					oldData.x = globalX;
				}
				
				if (oldData.y != globalY)
				{
					for (i = 0; i < length; i++)
					{
						batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 1] = globalY - v[i * 2 + 1];// + py;
					}
					
					oldData.y = globalY;
				}
				
				if (oldData.color != color || oldData.alpha != alpha)
				{
					for (i = 0; i < length; i++)
					{
						batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 3] = SkyUtils.getRed(color) / 255;
						batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 4] = SkyUtils.getGreen(color) / 255;
						batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 5] = SkyUtils.getBlue(color) / 255;
						batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 6] = alpha;
					}
					
					oldData.color = color;
					oldData.alpha = alpha;
				}
				
				if (oldData.depth != depth)
				{
					for (i = 0; i < length; i++)
					{
						batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 2] = depth / SkyHardwareRender.MAX_DEPTH;
					}
					
					oldData.depth = depth;
				}
			}
			else if (batchVerteces[indexID + 2] != -1)
			{
				length = verteces.length / 2;
				
				for (i = 0; i < length; i++)
					batchVerteces[i * SkyShapeBatch.DATA_PER_VERTEX + indexID + 2] = -1;
				
				oldData.depth = 2;
			}
		}
		
		/**
		 * Посчитать размеры фигуры.
		 */
		public function calcBounds():void
		{
			if (verteces.length < 6) return;
			
			var length:int = verteces.length / 2;
			
			var minX:Number = verteces[0];
			var maxX:Number = verteces[0];
			var minY:Number = verteces[1];
			var maxY:Number = verteces[1];
			
			for (var i:int = 1; i < length; i++)
			{
				minX = verteces[i * 2] < minX ? verteces[i * 2] : minX;
				maxX = verteces[i * 2] > maxX ? verteces[i * 2] : maxX;
				minY = verteces[i * 2 + 1] < minY ? verteces[i * 2 + 1] : minY;
				maxY = verteces[i * 2 + 1] > maxY ? verteces[i * 2 + 1] : maxY;
			}
			
			leftUpPoint.x = minX;
			leftUpPoint.y = minY;
			
			width = maxX - minX;
			height = maxY - minY;
			
			standartWidth = width;
			standartHeight = height;
		}
	}
}