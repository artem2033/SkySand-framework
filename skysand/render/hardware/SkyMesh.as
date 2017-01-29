package skysand.render.hardware 
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import skysand.utils.SkyMath;
	import skysand.utils.SkyVector2D;
	import skysand.render.hardware.SkyPolygon;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyMesh 
	{
		private var polygons:Vector.<SkyPolygon>;
		private var position:SkyVector2D;
		private var angle:Number;
		private var origin:SkyVector2D;
		
		public function SkyMesh() 
		{
			polygons = new Vector.<SkyPolygon>();
			origin = new SkyVector2D();
			position = new SkyVector2D();
			
			angle = 0;
		}
		
		public function addPolygon(polygon:SkyPolygon):void
		{
			polygons.push(polygon);
			
			origin.x = 0;
			origin.y = 0;
			
			for (var i:int = 0; i < polygons.length; i++) 
			{
				origin.x += polygons[i].x;
				origin.y += polygons[i].y;
			}
			
			origin.x /= polygons.length;
			origin.y /= polygons.length;
		}
		
		public function set x(value:Number):void
		{
			for (var i:int = 0; i < polygons.length; i++) 
			{
				polygons[i].x = value;
			}
			
			position.x = value;
		}
		
		public function get x():Number
		{
			return position.x;
		}
		
		public function set y(value:Number):void
		{
			for (var i:int = 0; i < polygons.length; i++) 
			{
				polygons[i].y = value;
			}
			
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
			/*value = SkyMath.toRadian(value);
			
			var cos:Number = Math.cos(value);
			var sin:Number = Math.sin(value);
			
			var point:Point = SkyMath.rotatePointWithConst(point0.x, point0.y, origin.x, origin.y, cos, sin);
			this.point0.setTo(point.x, point.y);
			
			point = SkyMath.rotatePointWithConst(point1.x, point1.y, origin.x, origin.y, cos, sin);
			this.point1.setTo(point.x, point.y);
			
			point = SkyMath.rotatePointWithConst(point2.x, point2.y, origin.x, origin.y, cos, sin);
			this.point2.setTo(point.x, point.y);
			
			angle = value;*/
		}
		
		public function get rotation():Number
		{
			return angle;
		}
		
		public function draw(graphics:Graphics):void
		{
			graphics.drawCircle(position.x, position.y, 5);
			
			for (var i:int = 0; i < polygons.length; i++) 
			{
				polygons[i].draw(graphics);
			}
		}
	}
}