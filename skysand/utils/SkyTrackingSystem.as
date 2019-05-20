package skysand.utils 
{
	import flash.geom.Point;
	
	import skysand.display.SkyRenderObject;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyTrackingSystem extends Object
	{
		/**
		 * Массив отслеживаемых точек.
		 */
		private var points:Vector.<Vector.<Point>>;
		
		/**
		 * Массив объектов двигающихся за точками.
		 */
		private var objects:Vector.<SkyRenderObject>;
		
		public function SkyTrackingSystem() 
		{
			objects = new Vector.<SkyRenderObject>();
			points = new Vector.<Vector.<Point>>();
		}
		
		/**
		 * Добавить отслеживаемую точку.
		 * @param	points массив точек с координатами для каждого кадра.
		 */
		public function addPoint(points:Vector.<Point>):void
		{
			this.points.push(points);
		}
		
		/**
		 * Добавить отслеживаемую точку.
		 * @param	points массив точек с координатами для каждого кадра.
		 * @param	index индекс точки.
		 */
		public function addPointAt(points:Vector.<Point>, index:int):void
		{
			this.points.splice(index, 0, points);
		}
		
		/**
		 * Удалить отслеживаемую точку.
		 * @param	index индекс точки.
		 */
		public function removePoint(index:int):void
		{
			points.removeAt(index);
		}
		
		/**
		 * Добавить объект, следующий за точкой.
		 * @param	object отрисовываемый объект.
		 */
		public function addFollowingRenderObject(object:SkyRenderObject):void
		{
			objects.push(object);
		}
		
		/**
		 * Добавить объект, следующий за точкой.
		 * @param	object отрисовываемый объект.
		 * @param	index индекс объекта.
		 */
		public function addFollowingRenderObjectAt(object:SkyRenderObject, index:int):void
		{
			objects.splice(index, 0, object);
		}
		
		/**
		 * Удалить объект, следующий за точкой.
		 * @param	object отрисовываемый объект.
		 */
		public function removeFollowingRenderObject(object:SkyRenderObject):void
		{
			objects.removeAt(objects.indexOf(object));
		}
		
		/**
		 * Удалить объект, следующий за точкой.
		 * @param	index индекс объекта.
		 */
		public function removeFollowingRenderObjectAt(index:int):void
		{
			objects.removeAt(index);
		}
		
		/**
		 * Обновить координаты точек.
		 * @param	frame кадр с новыми координатами.
		 */
		public function update(frame:int):void
		{
			var length:int = objects.length;
			
			if (length < 1) return;
			
			for (var i:int = 0; i < length; i++) 
			{
				objects[i].x = points[i][frame - 1].x;
				objects[i].y = points[i][frame - 1].y;
			}
		}
	}
}