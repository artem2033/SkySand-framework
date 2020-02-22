package skysand.debug 
{
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyShape;
	import skysand.utils.SkyMath;
	import skysand.utils.SkyVector2D;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyDebugDraw extends SkyRenderObjectContainer
	{
		/**
		 * Список фигур.
		 */
		private var shapes:Vector.<SkyShape>;
		
		/**
		 * Название пакета отрисоки.
		 */
		private const RENDERER_NAME:String = "debugDrawShapes";
		
		public function SkyDebugDraw() 
		{
			shapes = new Vector.<SkyShape>();
		}
		
		/**
		 * Нарисовать точку.
		 * @param	x координата точки.
		 * @param	y координата точки.
		 * @param	color цвет.
		 * @return
		 */
		public function drawPoint(x:Number, y:Number, color:uint, size:Number = 5, scale:Number = 1):SkyShape
		{
			var point:SkyShape = new SkyShape();
			point.rendererName = RENDERER_NAME;
			point.drawCircle(0, 0, size, size * 2);
			point.color = color;
			point.x = x * scale;
			point.y = y * scale;
			addChild(point);
			
			shapes.push(point);
			
			return point;
		}
		
		/**
		 * Нарисовать линию.
		 * @param	sx начальная координата х.
		 * @param	sy начальная координата у.
		 * @param	ex конечная коорлината х.
		 * @param	ey конечная коорлината у.
		 * @param	color цвет.
		 * @param	thickness толщина.
		 * @return
		 */
		public function drawLine(sx:Number, sy:Number, ex:Number, ey:Number, color:uint, thickness:Number):SkyShape
		{
			var dx:Number = ex - sx;
			var dy:Number = ey - sy;
			var length:Number = Math.sqrt(dx * dx + dy * dy);
			if (length == 0)
			{
				Console.log("line has zero length!");
				return null;
			}
			
			var ndx:Number = dx / length;
			var ndy:Number = dy / length;
			var lx:Number = ndy * thickness * 0.5;
			var ly:Number = -ndx * thickness * 0.5;
			var rx:Number = -ndy * thickness * 0.5;
			var ry:Number = ndx * thickness * 0.5;
			
			var line:SkyShape = new SkyShape();
			line.rendererName = RENDERER_NAME;
			line.color = color;
			line.addVertex(sx + lx, sy + ly);
			line.addVertex(ex + lx, ey + ly);
			line.addVertex(ex + rx, ey + ry);
			line.addVertex(sx + rx, sy + ry);
			//line.x = sx;
			//line.y = sy;
			addChild(line);
			
			shapes.push(line);
			
			return line;
		}
		
		public function drawContourA(vertices:Vector.<Number>, color:uint, thickness:Number = 2, scale:Number = 1):void
		{
			var length:int = vertices.length;
			
			drawLine(vertices[length - 3], vertices[length - 2], vertices[0], vertices[1], color, thickness);
			
			for (var i:int = 0; i < length - 2; i += 2) 
			{
				drawLine(vertices[i], vertices[i + 1], vertices[i + 2], vertices[i + 3], color, thickness);
			}
		}
		
		/**
		 * Нарисовать контур полигона.
		 * @param	xCoordinates координаты по оси х.
		 * @param	yCoordinates координаты по оси у.
		 * @param	color цвет линий.
		 * @param	thickness толщина линий.
		 * @param	scale масштаб контура.
		 */
		public function drawContourB(xCoordinates:Vector.<Number>, yCoordinates:Vector.<Number>, color:uint, thickness:Number = 2, scale:Number = 1):void
		{
			var length:int = xCoordinates.length;
			var sx:Number = xCoordinates[length - 1] * scale;
			var sy:Number = yCoordinates[length - 1] * scale;
			var ex:Number = xCoordinates[0] * scale;
			var ey:Number = yCoordinates[0] * scale;
			
			drawLine(sx, sy, ex, ey, color, thickness);
			
			for (var i:int = 0; i < length - 1; i++) 
			{
				sx = xCoordinates[i] * scale;
				sy = yCoordinates[i] * scale;
				ex = xCoordinates[i + 1] * scale;
				ey = yCoordinates[i + 1] * scale;
				
				drawLine(sx, sy, ex, ey, color, thickness);
			}
		}
	}
}