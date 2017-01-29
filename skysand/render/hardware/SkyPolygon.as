package skysand.render.hardware 
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import skysand.utils.SkyMath;
	import skysand.utils.SkyVector2D;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyPolygon 
	{
		private var point0:SkyVector2D;
		private var point1:SkyVector2D;
		private var point2:SkyVector2D;
		private var origin:SkyVector2D;
		private var position:SkyVector2D;
		private var angle:Number;
		
		public function SkyPolygon(x0:Number = 0, y0:Number = 0, x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0) 
		{
			point0 = new SkyVector2D(x0, y0);
			point1 = new SkyVector2D(x1, y1);
			point2 = new SkyVector2D(x2, y2);
			origin = new SkyVector2D();
			position = new SkyVector2D();
			
			origin.x = (x0 + x1 + x2) / 3;
			origin.y = (y0 + y1 + y2) / 3;
			
			angle = 0;
		}
		
		public function setVertices(point0:SkyVector2D, point1:SkyVector2D, point2:SkyVector2D):void
		{
			this.point0 = point0;
			this.point1 = point1;
			this.point2 = point2;
			
			origin.x = (point0.x + point1.x + point2.x) / 3;
			origin.y = (point0.y + point1.y + point2.y) / 3;
		}
		
		public function set x(value:Number):void
		{
			position.x = value;
		}
		
		public function get x():Number
		{
			return position.x;
		}
		
		public function set y(value:Number):void
		{
			position.y = value;
		}
		
		public function get y():Number
		{
			return position.y;
		}
		
		public function setOriginPoint(x:Number, y:Number):void
		{
			origin.x = x;
			origin.y = y;
		}
		
		public function set rotation(value:Number):void
		{
			value = SkyMath.toRadian(value);
			
			var cos:Number = Math.cos(value);
			var sin:Number = Math.sin(value);
			
			var point:Point = SkyMath.rotatePointWithConst(point0.x, point0.y, origin.x, origin.y, cos, sin);
			this.point0.setTo(point.x, point.y);
			
			point = SkyMath.rotatePointWithConst(point1.x, point1.y, origin.x, origin.y, cos, sin);
			this.point1.setTo(point.x, point.y);
			
			point = SkyMath.rotatePointWithConst(point2.x, point2.y, origin.x, origin.y, cos, sin);
			this.point2.setTo(point.x, point.y);
			
			angle = value;
		}
		
		public function get rotation():Number
		{
			return angle;
		}
		
		public function draw(graphics:Graphics):void
		{
			graphics.drawCircle(position.x, position.y, 5);
			graphics.moveTo(point0.x - origin.x + position.x, point0.y - origin.y + position.y);
			graphics.lineTo(point1.x - origin.x + position.x, point1.y - origin.y + position.y);
			graphics.lineTo(point2.x - origin.x + position.x, point2.y - origin.y + position.y);
			graphics.lineTo(point0.x - origin.x + position.x, point0.y - origin.y + position.y);
		}
	}
}