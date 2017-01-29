package skysand.display 
{
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	import skysand.render.hardware.SkyGraphicsBatch;
	import skysand.render.hardware.SkyHardwareRender;
	import skysand.mouse.SkyMouse;
	import skysand.utils.SkyUtils;
	import skysand.utils.SkyMath;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyGraphics extends SkyRenderObjectContainer
	{
		/**
		 * Индекс с которого начинаются считываться вершины. 
		 */
		public var indexID:uint;
		
		/**
		 * Цвет.
		 */
		public var color:uint;
		
		/**
		 * Ссылка на пакет для отрисовки.
		 */
		private var batch:SkyGraphicsBatch;
		
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
		 * Массив для хранения временных данных трансформированных вершин.
		 */
		private var v:Vector.<Number>;
		
		/**
		 * Ссылка на вершины.
		 */
		private var batchVerteces:Vector.<Number>;
		
		/**
		 * Изначально заданные вершины многоугольника.
		 */
		private var verteces:Vector.<Number>;
		
		/**
		 * Точки для триангуляции вершин многоугольника. 
		 */
		private var points:Vector.<Point>
		
		/**
		 * Ссылка на мышь.
		 */
		private var mouse:SkyMouse;
		
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
		private static var isDrag:Boolean = false;
		
		public function SkyGraphics() 
		{
			offsetDragPoint = new Point();
			oldData = new SkyOldData();
			oldData.width = width + 1;
			oldData.height = height + 1;
			oldData.rotation = rotation + 1;
			oldData.depth = 2;
			oldData.color = color + 1;
			
			drag = false;
			indexID = 0;
			
			standartHeight = 1;
			standartWidth = 1;
			
			mouse = SkyMouse.instance;
			matrix = new Matrix();
			
			v = new Vector.<Number>();
			verteces = new Vector.<Number>();
			points = new Vector.<Point>();
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			offsetDragPoint = null;
			oldData = null;
			matrix = null;
			mouse = null;
			
			v.length = 0
			v = null;
			
			verteces.length = 0;
			verteces = null;
			
			points.length = 0;
			points = null;
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
			
			for (var i:int = 0; i < numSides; i++)
			{
				var px:Number = Math.cos(angle + offset * 2) * topLeftRadius + x + topLeftRadius;
				var py:Number = Math.sin(angle + offset * 2) * topLeftRadius + y + topLeftRadius;
				
				verteces.push(px, py);
				points.push(new Point(px, py));
				
				angle += angleDelta;
			}
			
			angle = 0;
			
			for (i = 0; i < numSides; i++)
			{
				px = Math.cos(angle - offset) * topRightRadius + x + width - topRightRadius;
				py = Math.sin(angle - offset) * topRightRadius + y + topRightRadius;
				
				verteces.push(px, py);
				points.push(new Point(px, py));
				
				angle += angleDelta;
			}
			
			angle = 0;
			
			for (i = 0; i < numSides; i++)
			{
				px = Math.cos(angle) * downRightRadius + x + width - downRightRadius;
				py = Math.sin(angle) * downRightRadius + y + height - downRightRadius;
				
				verteces.push(px, py);
				points.push(new Point(px, py));
				
				angle += angleDelta;
			}
			
			angle = 0;
			
			for (i = 0; i < numSides; i++)
			{
				px = Math.cos(angle + offset) * downLeftRadius + x + downLeftRadius;
				py = Math.sin(angle + offset) * downLeftRadius + y + height - downLeftRadius;
				
				verteces.push(px, py);
				points.push(new Point(px, py));
				
				angle += angleDelta;
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
				points.push(new Point(dx, dy));
				
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
			
			points.push(new Point(x, y));
			points.push(new Point(width + x, y));
			points.push(new Point(width + x, height + y));
			points.push(new Point(x, height + y));
			
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
			points.push(new Point(x, y));
			
			calcBounds();
		}
		
		/**
		 * Получить вершины в виде точек.
		 */
		public function get getVertices():Vector.<Point>
		{
			return points;
		}
		
		/**
		 * Получить число вершин.
		 */
		public function get vertecesCount():int
		{
			return verteces.length / 2;
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
		 * Проверка столкновения с курсором мыши.
		 * @return возвращает true, если столкнулся, иначе false.
		 */
		public function hitTestMouse():Boolean
		{
			if (!batchVerteces) return false;
			
			var x:Number = SkySand.STAGE.mouseX;
			var y:Number = SkySand.STAGE.mouseY;
			var i:int, j:int = verteces.length / 2 - 1;
            var oddNodes:uint = 0;
			var length:int = verteces.length / 2;
			
            for (i = 0; i < length; ++i)
            {
				if (batchVerteces.length <= (i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID) || indexID < 0) break;
				
                var ix:Number = batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID];
                var iy:Number = batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 1];
                var jx:Number = batchVerteces[j * SkyGraphicsBatch.DATA_PER_VERTEX + indexID];
                var jy:Number = batchVerteces[j * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 1];
				
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
			//if (!super.hitTestPoint(x, y)) return false;
			
            var i:int, j:int = verteces.length / 2 - 1;
            var oddNodes:uint = 0;
			var length:int = verteces.length / 2;
			
            for (i = 0; i < length; ++i)
            {
				if (batchVerteces.length <= (i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID) || indexID < 0) break;
				
                var ix:Number = batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID];
                var iy:Number = batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 1];
                var jx:Number = batchVerteces[j * SkyGraphicsBatch.DATA_PER_VERTEX + indexID];
                var jy:Number = batchVerteces[j * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 1];
				
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
				batch = SkyHardwareRender.instance.getBatch("vector") as SkyGraphicsBatch;
			}
			
			if (batch != null) 
			{
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
		override public function updateData():void 
		{
			globalVisible = visible ? 1 * parent.globalVisible : 0 * parent.globalVisible;
			
			if (globalVisible == 1 && isVisible)
			{
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
				
				var length:int = verteces.length / 2;
				
				var px:Number = pivotX * globalScaleX;
				var py:Number = pivotY * globalScaleY;
				
				if (batchVerteces == null) return;
				
				if (oldData.rotation != globalRotation || oldData.width != width || oldData.height != height)
				{
					var angle:Number = SkyMath.toRadian(parent.globalRotation);
					
					localR = SkyMath.rotatePoint(x, y, 0, 0, angle);
					globalR.x = localR.x + parent.globalR.x - x;
					globalR.y = localR.y + parent.globalR.y - y;
					
					angle = SkyMath.toRadian(globalRotation);
					matrix.scale(width * globalScaleX / standartWidth, height * globalScaleY / standartHeight);
					matrix.rotate(angle);
					
					for (var i:int = 0; i < length; i++) 
					{
						var dx:Number = verteces[i * 2]// + px;
						var dy:Number = verteces[i * 2 + 1]// + py;
						
						v[i * 2] = -globalR.x - dx * matrix.a - dy * matrix.c;
						v[i * 2 + 1] = -globalR.y - dx * matrix.b - dy * matrix.d;
						
						batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID] = globalX - v[i * 2]// - px;
						batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 1] = globalY - v[i * 2 + 1]// - py;
					}
					
					matrix.identity();
					
					oldData.rotation = globalRotation;
					oldData.x = globalX;
					oldData.y = globalY;
					oldData.width = width;
					oldData.height = height;
				}
				
				if (oldData.x != globalX)
				{
					for (i = 0; i < length; i++) 
					{
						batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID] = globalX - v[i * 2] + px;
					}
					
					oldData.x = globalX;
				}
				
				if (oldData.y != globalY)
				{
					for (i = 0; i < length; i++) 
					{
						batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 1] = globalY - v[i * 2 + 1] + py;
					}
					
					oldData.y = globalY;
				}
				
				if (oldData.color != color || oldData.alpha != alpha)
				{
					for (i = 0; i < length; i++) 
					{
						batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 3] = SkyUtils.getRed(color) / 255;
						batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 4] = SkyUtils.getGreen(color) / 255;
						batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 5] = SkyUtils.getBlue(color) / 255;
						batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 6] = alpha;
					}
					
					oldData.color = color;
					oldData.alpha = alpha;
				}
				
				if (oldData.depth != depth)
				{
					for (i = 0; i < length; i++) 
					{
						batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 2] = depth / SkyHardwareRender.MAX_DEPTH;
					}
					
					oldData.depth = depth;
				}
			}
			else
			{
				length = verteces.length / 2;
				
				for (i = 0; i < length; i++) 
				{
					batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID] = 0;
					batchVerteces[i * SkyGraphicsBatch.DATA_PER_VERTEX + indexID + 1] = 0;
				}
				
				oldData.x--;
				oldData.y--;
			}
		}
		
		/**
		 * Посчитать размеры фигуры.
		 */
		private function calcBounds():void
		{
			if (verteces.length / 2 < 3) return;
			
			var length:int = verteces.length / 2;
			
			var minX:Number = verteces[0];
			var maxX:Number = verteces[0];
			var minY:Number = verteces[1];
			var maxY:Number = verteces[1];
			
			for (var i:int = 0; i < length; i++) 
			{
				minX = verteces[i * 2] < minX ? verteces[i * 2] : minX;
				maxX = verteces[i * 2] > maxX ? verteces[i * 2] : maxX
				minY = verteces[i * 2 + 1] < minY ? verteces[i * 2 + 1] : minY
				maxY = verteces[i * 2 + 1] > maxY ? verteces[i * 2 + 1] : maxY
			}
			
			width = maxX - minX;
			height = maxY - minY;
			
			standartWidth = width;
			standartHeight = height;
		}
	}
}