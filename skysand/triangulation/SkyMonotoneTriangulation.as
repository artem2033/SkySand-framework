package skysand.triangulation 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyMonotoneTriangulation
	{
		/**
		 * Константы описывающие типы вершин.
		 */
		public static const START:uint = 0;
		public static const END:uint = 1;
		public static const REGULAR:uint = 2;
		public static const MERGE:uint = 3;
		public static const SPLIT:uint = 4;
		
		/**
		 * Массив вершин для обработки.
		 */
		private var verticesQueue:Vector.<SkyPolygonPoint>;
		
		/**
		 * Список диагоналей.
		 */
		private var diagonals:Vector.<SkyDiagonal>;
		
		/**
		 * Список граней триангулируемого многоугольника.
		 */
		private var edges:Vector.<SkyEdge>;
		
		/**
		 * Временная таблица для хранения граней.
		 */
		private var hash:Dictionary;
		
		/**
		 * Массив координат вершин.
		 */
		private var mVertices:Vector.<Number>;
		
		/**
		 * Массив индексов вершин.
		 */
		private var mIndices:Vector.<uint>;
		
		//public var indices:Vector.<uint>;
		
		/**
		 * Счётчик количества вершин.
		 */
		private var queueCount:int;
		
		public function SkyMonotoneTriangulation()
		{
			verticesQueue = new Vector.<SkyPolygonPoint>();
			diagonals = new Vector.<SkyDiagonal>();
			mVertices = new Vector.<Number>();
			mIndices = new Vector.<uint>();
			edges = new Vector.<SkyEdge>();
			hash = new Dictionary();
			queueCount = 0;
		}
		
		/**
		 * Добавить контур для триангуляции.
		 * @param	xPoints координаты контура по оси х.
		 * @param	yPoints координаты контура по оси у.
		 * @param	isHole является ли контур отверстием внутри другого контура.
		 * @param	firstIndex начальный элемент с которого считывать вершины.
		 * @param	endIndex конечный элемент до которого считывать вершины.
		 */
		public function addContour(xPoints:Vector.<Number>, yPoints:Vector.<Number>, isHole:Boolean = false, firstIndex:uint = 0, endIndex:uint = 0):void
		{
			endIndex = endIndex == 0 ? xPoints.length : endIndex;
			
			var length:uint = endIndex - firstIndex;
			var iMin:int = firstIndex;
			var min:Number = xPoints[firstIndex];
			var offset:int = mVertices.length / 2;
			
			for (var i:int = firstIndex + 1; i < endIndex; i++) 
			{
				if (min > xPoints[i] || min == xPoints[i] && yPoints[iMin] > yPoints[i])
				{
					min = xPoints[i];
					iMin = i;
				}
			}
			
			var x:Number = xPoints[iMin];
			var y:Number = yPoints[iMin];
			var xnext:Number = xPoints[iMin == endIndex - 1 ? firstIndex : iMin + 1];
			var ynext:Number = yPoints[iMin == endIndex - 1 ? firstIndex : iMin + 1];
			var xprev:Number = xPoints[iMin == firstIndex ? endIndex - 1 : iMin - 1];
			var yprev:Number = yPoints[iMin == firstIndex ? endIndex - 1 : iMin - 1];
			
			var isClockwise:Boolean = (xnext - x) * (yprev - y) - (ynext - y) * (xprev - x) > 0;
			
			var point:SkyPolygonPoint = new SkyPolygonPoint();
			point.x = xPoints[firstIndex];
			point.y = yPoints[firstIndex];
			point.index = offset;
			
			mVertices.push(xPoints[firstIndex], yPoints[firstIndex]);
			addToQueue(point);
			
			var first:SkyPolygonPoint = point;
			var last:SkyPolygonPoint = point;
			
			if (isClockwise && !isHole || !isClockwise && isHole)
			{
				for (i = length - 1; i > 0; i--)
				{
					point = new SkyPolygonPoint();
					point.x = xPoints[i + firstIndex];
					point.y = yPoints[i + firstIndex];
					point.index = offset + length - i;
					point.prev = last;
					last.next = point;
					last = point;
					
					mVertices.push(point.x, point.y);
					addToQueue(point);
				}
			}
			else
			{
				for (i = 1; i < length; i++) 
				{
					point = new SkyPolygonPoint();
					point.x = xPoints[i + firstIndex];
					point.y = yPoints[i + firstIndex];
					point.index = offset + i;
					point.prev = last;
					last.next = point;
					last = point;
					
					mVertices.push(point.x, point.y);
					addToQueue(point);
				}
			}
			
			first.prev = last;
			last.next = first;
			length = offset + length - 1;
			
			for (i = offset; i < length; i++)
			{
				var edge:SkyEdge = new SkyEdge();
				edge.sx = mVertices[i * 2];
				edge.sy = mVertices[i * 2 + 1];
				edge.ex = mVertices[i * 2 + 2];
				edge.ey = mVertices[i * 2 + 3];
				edges.push(edge);
			}
			
			i--;
			edge = new SkyEdge();
			edge.sx = mVertices[i * 2 + 2];
			edge.sy = mVertices[i * 2 + 3];
			edge.ex = mVertices[offset * 2];
			edge.ey = mVertices[offset * 2 + 1];
			edges.push(edge);
		}
		
		/**
		 * Запустить триангуляцию многоугольника.
		 */
		public function makeMonotone():void
		{
			for (var i:int = 0; i < queueCount; i++) 
			{
				var point:SkyPolygonPoint = verticesQueue[i];
				var xprev:Number = point.prev.x;
				var yprev:Number = point.prev.y;
				var xnext:Number = point.next.x;
				var ynext:Number = point.next.y;
				var x:Number = point.x;
				var y:Number = point.y;
				
				var clockwise:Number = (xnext - x) * (yprev - y) - (ynext - y) * (xprev - x);
				var higherThanPrev:Boolean = (y < yprev) || (y == yprev && x < xprev);
				var higherThanNext:Boolean = (y < ynext) || (y == ynext && x < xnext);
				
				if (higherThanPrev && higherThanNext)
				{
					if (clockwise < 0)
					{
						point.type = START;
						handleStartVertex(point);
					}
					else
					{
						point.type = SPLIT;
						handleSplitVertex(point);
					}
				}
				else if (!higherThanPrev && !higherThanNext)
				{
					if (clockwise < 0)
					{
						point.type = END;
						handleEndVertex(point);
					}
					else
					{
						point.type = MERGE;
						handleMergeVertex(point);
					}
				}
				else
				{
					point.type = REGULAR;
					handleRegularVertex(point);
				}
			}
			
			if (diagonals.length > 0) splitPolygon();
			else
			{
				point = verticesQueue[0];
				
				for (i = 0; i < queueCount; i++) 
				{
					verticesQueue[i] = point;
					point = point.next;
				}
				
				triangulate();
			}
		}
		
		/**
		 * Частично сбросить данные для формирования одного массива вершин и индексов.
		 */
		public function partReset():void
		{
			verticesQueue.length = 0;
			queueCount = 0;
		}
		
		/**
		 * Сбросить данные для подготовки к новой триангуляции.
		 */
		public function fullReset():void
		{
			verticesQueue.length = 0;
			mVertices.length = 0;
			mIndices.length = 0;
			edges.length = 0;
			queueCount = 0;
		}
		
		/**
		 * Получить массив вершин после триангуляции.
		 */
		public function get vertices():Vector.<Number>
		{
			return mVertices;
		}
		
		/**
		 * Получить массив индексов вершин после триангуляции.
		 */
		public function get indices():Vector.<uint>
		{
			return mIndices;
		}
		
		/**
		 * Разбить полигон по диагоналям на монотонные полигоны.
		 */
		private function splitPolygon():void
		{
			var length:int = diagonals.length;
			var	startDiagonal:SkyDiagonal = diagonals[0];
			var nextDiagonal:SkyDiagonal = startDiagonal;
			var current:SkyPolygonPoint = startDiagonal.startPoint;
			var endPoint:SkyPolygonPoint = current;
			var next:SkyPolygonPoint = startDiagonal.endPoint;
			var prev:SkyPolygonPoint = current;
			var diagonalCount:int = 0;
			
			queueCount = 0;
			verticesQueue[queueCount++] = current;
			current = next;
			
			while (length >= 0)
			{
				if (endPoint == current)
				{
					triangulate();
					
					if (nextDiagonal != null)
					{
						nextDiagonal.isEdge = true;
						nextDiagonal.startPoint = nextDiagonal.endPoint;
						nextDiagonal.endPoint = prev;
					}
					
					if (length == 0) break;
					
					queueCount = 0;
					startDiagonal = diagonals[0];
					
					current = startDiagonal.startPoint;
					endPoint = current;
					nextDiagonal = startDiagonal;
					
					prev = current;
					next = startDiagonal.endPoint;
				}
				else if (diagonalCount == 1)
				{
					if (nextDiagonal != null)
					{
						next = current.next;
					}
					else
					{
						nextDiagonal = current.diagonals[0];
						next = nextDiagonal.getOppositePoint(current);
					}
				}
				else if (diagonalCount > 1)
				{
					var a:Number = current.x - prev.x;
					var b:Number = current.y - prev.y;
					
					var point:SkyPolygonPoint = current.next;
					var min:Number = Math.atan2((point.x - current.x) * b - (point.y - current.y) * a, a * (point.x - current.x) + b * (point.y - current.y));
					next = point;
					var d:SkyDiagonal = null;
					
					for (var i:int = 0; i < diagonalCount; i++)
					{
						var diagonal:SkyDiagonal = current.diagonals[i];
						if (diagonal == nextDiagonal) continue;
						
						point = diagonal.getOppositePoint(current);
						var angle:Number = Math.atan2((point.x - current.x) * b - (point.y - current.y) * a, a * (point.x - current.x) + b * (point.y - current.y));
						
						if (angle > min)
						{
							min = angle;
							next = point;
							d = diagonal;
						}
					}
					
					if (nextDiagonal != null && prev == nextDiagonal.getOppositePoint(current))
					{
						if (!nextDiagonal.isEdge)
						{
							nextDiagonal.isEdge = true;
							
							if (prev == nextDiagonal.startPoint)
							{
								nextDiagonal.startPoint = nextDiagonal.endPoint;
								nextDiagonal.endPoint = prev;
							}
						}
						else
						{
							var index:int = diagonals.indexOf(nextDiagonal);
							if (index != -1)
							{
								diagonals.removeAt(index);
								length--;
							}
						}
					}
					
					nextDiagonal = d;
				}
				else next = current.next;
				
				if (nextDiagonal != null && prev == nextDiagonal.getOppositePoint(current))
				{
					if (!nextDiagonal.isEdge)
					{
						nextDiagonal.isEdge = true;
						
						if (prev == nextDiagonal.startPoint)
						{
							nextDiagonal.startPoint = nextDiagonal.endPoint;
							nextDiagonal.endPoint = prev;
						}
					}
					else
					{
						index = diagonals.indexOf(nextDiagonal);
						if (index != -1)
						{
							diagonals.removeAt(index);
							length--;
						}
					}
					
					nextDiagonal = null;
				}
				
				verticesQueue[queueCount++] = current;
				
				prev = current;
				current = next;
				diagonalCount = current.diagonals.length;
			}
		}
		
		/**
		 * Триангулировать полигон.
		 */
		private function triangulate():void
		{
			if (queueCount < 3) return;
			if (queueCount == 3)
			{
				mIndices.push(verticesQueue[0].index, verticesQueue[1].index, verticesQueue[2].index);
				return;
			}
			
			var i:int = 0;
			
			while (queueCount > 3)
			{
				var ax:Number = verticesQueue[i].x;
				var ay:Number = verticesQueue[i].y;
				var bx:Number = verticesQueue[(i + 1) % queueCount].x;
				var by:Number = verticesQueue[(i + 1) % queueCount].y;
				var cx:Number = verticesQueue[(i + 2) % queueCount].x;
				var cy:Number = verticesQueue[(i + 2) % queueCount].y;
				var ccw:Number = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)
				
				if (ccw < 0)
				{
					var isEmpty:Boolean = true;
					
					for (var j:int = 0; j < queueCount; j++)
					{
						var x:Number = verticesQueue[j].x;
						var y:Number = verticesQueue[j].y;
						
						if ((x == ax && y == ay) || (x == bx && y == by) || (x == cx && y == cy)) continue;
						
						var n1:Number = (by - ay) * (x - ax) - (bx - ax) * (y - ay);
						var n2:Number = (cy - by) * (x - bx) - (cx - bx) * (y - by);
						var n3:Number = (ay - cy) * (x - cx) - (ax - cx) * (y - cy);
						
						if ((n1 >= 0 && n2 >= 0 && n3 >= 0) || (n1 <= 0 && n2 <= 0 && n3 <= 0))
						{
							isEmpty = false;
							break;
						}
					}
					
					if (isEmpty)
					{
						mIndices.push(verticesQueue[i].index, verticesQueue[(i + 1) % queueCount].index, verticesQueue[(i + 2) % queueCount].index);
						
						verticesQueue.removeAt((i + 1) % queueCount);
						
						i--;
						queueCount--;
					}
				}
				else if (ccw == 0)
				{
					verticesQueue.removeAt((i + 1) % queueCount);
					
					i--;
					queueCount--;
				}
				
				i = i + 1 == queueCount ? 0 : i + 1;
			}
			
			mIndices.push(verticesQueue[0].index, verticesQueue[1].index, verticesQueue[2].index);
		}
		
		/**
		 * Обработать start вершину.
		 * @param	point ссылка на вершину.
		 */
		private function handleStartVertex(point:SkyPolygonPoint):void
		{
			var edge:SkyEdge = edges[point.index];
			edge.helper = point;
			hash[edge] = edge;
		}
		
		/**
		 * Обработать end вершину.
		 * @param	point ссылка на вершину.
		 */
		private function handleEndVertex(point:SkyPolygonPoint):void
		{
			var edge:SkyEdge = edges[point.prev.index]
			
			if (edge.helper != null && edge.helper.type == MERGE)
			{
				var diagonal:SkyDiagonal = new SkyDiagonal(point, edge.helper);
				diagonals.push(diagonal);
			}
			
			delete hash[edge];
		}
		
		/**
		 * Обработать split вершину.
		 * @param	point ссылка на вершину.
		 */
		private function handleSplitVertex(point:SkyPolygonPoint):void
		{
			var edge:SkyEdge = getEdge(point.x, point.y);
			
			var diagonal:SkyDiagonal = new SkyDiagonal(point, edge.helper);
			diagonals.push(diagonal);
			
			edge.helper = point;
			edge = edges[point.index];
			edge.helper = point;
			hash[edge] = edge;
		}
		
		/**
		 * Обработать merge вершину.
		 * @param	point ссылка на вершину.
		 */
		private function handleMergeVertex(point:SkyPolygonPoint):void
		{
			var edge:SkyEdge = edges[point.prev.index];
			
			if (edge.helper != null && edge.helper.type == MERGE)
			{
				var diagonal:SkyDiagonal = new SkyDiagonal(point, edge.helper);
				diagonals.push(diagonal);
			}
			
			delete hash[edge];
			edge = getEdge(point.x, point.y);
			
			if (edge != null)
			{			
				if (edge.helper != null && edge.helper.type == MERGE)
				{
					diagonal = new SkyDiagonal(point, edge.helper);
					diagonals.push(diagonal);
				}
				
				edge.helper = point;
			}
		}
		
		/**
		 * Обработать regular вершину.
		 * @param	point ссылка на вершину.
		 */
		private function handleRegularVertex(point:SkyPolygonPoint):void
		{
			var prev:SkyPolygonPoint = point.prev;
			var next:SkyPolygonPoint = point.next;
			var lowerThanPrev:Boolean = (point.y > prev.y) || (point.y == prev.y && point.x > prev.x);
			var higherThanNext:Boolean = (point.y < next.y) || (point.y == next.y && point.x < next.x);
			
			if (lowerThanPrev && higherThanNext)
			{
				var edge:SkyEdge = edges[point.prev.index]
				
				if (edge.helper != null && edge.helper.type == MERGE)
				{
					var diagonal:SkyDiagonal = new SkyDiagonal(point, edge.helper);
					diagonals.push(diagonal);
				}
				
				delete hash[edge];
				
				edge = edges[point.index];
				edge.helper = point;
				hash[edge] = edge;
			}
			else
			{
				edge = getEdge(point.x, point.y);
				
				if (edge != null)
				{
					if (edge.helper != null && edge.helper.type == MERGE)
					{
						diagonal = new SkyDiagonal(point, edge.helper);
						diagonals.push(diagonal);
					}
					
					edge.helper = point;
				}
			}
		}
		
		/**
		 * Получить ближайшую грань, которую пересекает прямая, к текущей вершине.
		 * @param	px координата вершины.
		 * @param	py координата вершины.
		 * @return возвращает грань.
		 */
		private function getEdge(px:Number, py:Number):SkyEdge
		{
			var closest:SkyEdge;
			var dist:Number = 1000000;
			
			for each (var edge:SkyEdge in hash)
			{
				var a:Number = edge.sy - edge.ey;
				if (a == 0) continue;
				
				var b:Number = edge.ex - edge.sx;
				var c:Number = edge.sx * edge.ey - edge.ex * edge.sy;
				var x:Number = -(c + py * b) / a;
				
				if (x < px && px - x < dist)
				{
					closest = edge;
					dist = px - x;
				}
			}
			
			return closest;
		}
		
		/**
		 * Добавить вершину в очередь для обработки в порядке по возрастанию координаты у.
		 * @param	point ссылка но вершину.
		 */
		private function addToQueue(point:SkyPolygonPoint):void
		{
			var low:int = 0;
			var high:int = queueCount - 1;
			var mid:int = 0;
			
			while (low <= high)
			{
				mid = int((low + high) * 0.5);
				var x:Number = verticesQueue[mid].x;
				var y:Number = verticesQueue[mid].y;
				
				if (y < point.y || y == point.y && x < point.x)
				{
					low = mid + 1;
				}
				else if (y > point.y || y == point.y && x > point.x)
				{
					high = mid - 1;
				}
				else break;
			}
			
			queueCount++;
			verticesQueue.insertAt(y < point.y || y == point.y && x < point.x ? mid + 1 : mid, point);
		}
	}
}