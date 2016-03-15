package skysand.physics.collision 
{
	import skysand.utils.f2Vec
	import src.physics.PolygonShape2D;
	import src.physics.DrawVector;
	import flash.display.Sprite;
	
	import flash.geom.Point;
	
	public class f2PolygonCollision
	{	
		private var collisionData:CollisionData;
		private var vectorOffset:f2Vec;
		
		public function f2PolygonCollision() 
		{
			collisionData = new CollisionData();
			vectorOffset = new f2Vec(0, 0);
		}
		
		public function check(polygon0:PolygonShape2D, polygon1:PolygonShape2D):CollisionData
		{
			//Точки начала и конца вектора проэкции
			var max0:Number;
			var min0:Number;
			var max1:Number;
			var min1:Number;
			//-------------------------------------
			//Кратчайшее расстояние нужноe для выведения полигонов из столкновения
			var shortDistance:Number = Number.MAX_VALUE;
			//------------------------------------------------------------------------------
			//Вектор расстояния между центрами полигонов
			vectorOffset.Set(polygon0.x - polygon1.x, polygon0.y - polygon1.y);
			var offset:Number;
			//-----------------------------------------------------------------------------------
			//Ось проэкции
			var axis:f2Vec;
			//-------------
			//Вершины первого и второго полигона
			var vertices1:Vector.<f2Vec> = polygon0.vertices;
			var vertices2:Vector.<f2Vec> = polygon1.vertices;
			//------------------------------------------------
			
			//Начало поиска столкновения
			
			for (var i:int = 0; i < vertices1.length + vertices2.length; ++i)
			{
				if (i < vertices1.length)
				{
					axis = getAxis(polygon0, i);
				}
				else
				{
					axis = getAxis(polygon1, i - vertices1.length);
				}
				
				min0 = axis.dotProduct(vertices1[0]);
				max0 = min0;
				
				for (var j:int = 1; j < vertices1.length; ++j) 
				{
					var temp:Number = axis.dotProduct(vertices1[j]);
					
					if (temp < min0) min0 = temp;
					if (temp > max0) max0 = temp;
				}
				
				min1 = axis.dotProduct(vertices2[0]);
				max1 = min1;
				
				for (j = 1; j < vertices2.length; ++j) 
				{
					temp = axis.dotProduct(vertices2[j]);
					
					if (temp < min1) min1 = temp;
					if (temp > max1) max1 = temp;
				}
				
				offset = axis.dotProduct(vectorOffset);
				
				min0 += offset;
				max0 += offset;
				
				if (min0 - max1 > 0 || min1 - max0 > 0)
				{
					collisionData.reset();
					
					return collisionData;
				}
				
				var distance:Number = (min0 > min1) ? -(min0 - max1) : min1 - max0;
				
				if (Math.abs(distance) < shortDistance)
				{
					shortDistance = Math.abs(distance);
					collisionData.normalVector = axis;
					collisionData.overlap = distance;
				}
			}
			
			collisionData.collide = true;
			
			return collisionData;
		}
		
		/**
		 * Находит оси проэкции полигона. 
		 * @param	rect полигон, оси которого нужно найти.
		 * @param	index номер стороны полигона.
		 * @return возвращает нормаль к стороне полигона, с помощью вектора.
		 */
		private function getAxis(rect:PolygonShape2D, index:int):f2Vec
		{
			if (index < rect.vertices.length - 1)
			{
				var vector:f2Vec = rect.vertices[index + 1].trancate(rect.vertices[index]);
			}
			else
			{
				vector = rect.vertices[0].trancate(rect.vertices[rect.vertices.length - 1]);
			}
			
			vector = vector.normalL();
			vector.normalize();
			
			return vector;
		}
	}
}