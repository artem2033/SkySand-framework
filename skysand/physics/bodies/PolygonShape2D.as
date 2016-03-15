package skysand.physics.bodies 
{
	import skysand.utils.f2Vec;
	
	public class PolygonShape2D extends Body2D
	{
		public var vertices:Vector.<f2Vec>;
		
		public function PolygonShape2D()
		{
			super();
			vertices = new Vector.<f2Vec>;
		}
		
		/**
		 * Добавить вершину в фигуру с помощью координат.
		 * @param	point координаты вершины.
		 */
		public function addVertex(point:f2Vec):void
		{
			vertices[vertices.length] = point;
		}
		
		public function create(_x:Number, _y:Number):void
		{
			init(_x, _y);
			
			calculateShapeCentr();
			
			if (type == DYNAMIC)
			{
				mass = getArea() * density;
				invMass = 1 / mass;
			}
			else if (type == STATIC)
			{
				mass = 0;
				invMass = 0;
			}
		}
		
		/**
		 * Создаёт прямоугольный четырёхугольник.
		 * @param	_x - координата х.
		 * @param	_y - координата у.
		 * @param	_width - ширина.
		 * @param	_height - высота.
		 */
		public function createRectangle(_x:Number, _y:Number, _width:Number, _height:Number):void
		{
			addVertex(new f2Vec(0, 0));
			addVertex(new f2Vec(_width, 0));
			addVertex(new f2Vec(_width, _height));
			addVertex(new f2Vec(0, _height));
			
			create(_x, _y);
		}
		
		/**
		 * Перемещает координаты вершин в положительную четверть декартовой плоскости.
		 */
		private function normalizeVertices():void
		{
			var minX:Number = Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE;
			
			for (var i:int = 0; i < vertices.length; i++) 
			{
				var vertix:f2Vec = vertices[i];
				
				if (minX > vertix.x) minX = vertix.x;
				if (minY > vertix.y) minY = vertix.y;
			}
			
			for (i = 0; i < vertices.length; i++)
			{
				vertices[i].x += Math.abs(minX);
				vertices[i].y += Math.abs(minY);
			}
		}
		
		private function calculateShapeCentr():void
		{
			normalizeVertices();
			
			var minX:Number = Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE;
			var maxX:Number = Number.MIN_VALUE;
			var maxY:Number = Number.MIN_VALUE;
			
			for (var i:int = 0; i < vertices.length; i++) 
			{
				var vertix:f2Vec = vertices[i];
				
				if (minX > vertix.x) minX = vertix.x;
				if (minY > vertix.y) minY = vertix.y;
				if (maxX < vertix.x) maxX = vertix.x;
				if (maxY < vertix.y) maxY = vertix.y;
			}
			
			var _x:Number = (maxX - minX) * 0.5;
			var _y:Number = (maxY - minY) * 0.5;
			
			aabb.half_width = (maxX - minX) * 0.5;
			aabb.half_height = (maxY - minY) * 0.5;
			
			for (i = 0; i < vertices.length; i++)
			{
				vertices[i].x -= _x;
				vertices[i].y -= _y;
			}
		}
		
		/**
		 * Создаёт правильный н-угольник.
		 * @param	_x координата х.
		 * @param	_y координата у.
		 * @param	sides число сторон полигона.
		 * @param	radius длина стороны полигона.
		 */
		public function createRightPoly(_x:Number, _y:Number, sides:int, radius:Number):void
		{
			var rotation:Number = (Math.PI * 2) / sides;
			var angle:Number;
			var vector:f2Vec;
			
			for (var i:int = 0; i < sides; i++) 
			{
				angle = (i * rotation) - Math.PI * 0.5;
				vector = new f2Vec(0, 0);
				vector.x = Math.cos(angle) * radius;
				vector.y = Math.sin(angle) * radius;
				addVertex (vector);
			}
			
			create(_x, _y);
		}
		
		/**
		 * Рассчитывает центр n - угольника.
		 * @return возвращяет вектор на который нужно отодвинуть каждую высоту n - угольника.
		 */
		private function calculateCentr():f2Vec
		{
			var _x:Number = 0;
			var _y:Number = 0;
			
			for (var i:int = 0; i < vertices.length; i++) 
			{
				var point:f2Vec = vertices[i];
				
				_x += point.x;
				_y += point.y;
			}
			
			return new f2Vec(_x / vertices.length, _y / vertices.length);
		}
		
		private function calculateAABB():void
		{
			var xMax:Number = Number.MIN_VALUE;
			var xMin:Number = Number.MAX_VALUE;
			var yMax:Number = Number.MIN_VALUE;
			var yMin:Number = Number.MAX_VALUE;
			
			for (var i:int = 0; i < vertices.length; i++) 
			{
				var vertex:f2Vec = vertices[i];
				
				if (vertex.x > xMax) xMax = vertex.x;
				if (vertex.x < xMin) xMin = vertex.x;
				if (vertex.y > yMax) yMax = vertex.y;
				if (vertex.y < yMin) yMin = vertex.y;
			}
			
			aabb.half_width = (xMax - xMin) * 0.5;
			aabb.half_height = (yMax - yMin) * 0.5;
		}
		
		/**
		 * Расчитывает площадь n - угольника.
		 * @return возвращает результат. 
		 */
		private function getArea():Number
		{
			var area:Number = 0;
			
			for (var i:int = 0; i < vertices.length; ++i) 
			{
				if (i < vertices.length - 1)
				{
					area += (vertices[i].x * vertices[i + 1].y - vertices[i + 1].x * vertices[i].y);
				}
			}
			area += (vertices[vertices.length - 1].x * vertices[0].y - vertices[vertices.length - 1].y * vertices[0].x);
			
			return area * 0.5;
		}
	}
}