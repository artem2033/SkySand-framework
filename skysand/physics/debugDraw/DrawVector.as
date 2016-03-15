package skysand.physics.debugDraw 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import src.helpers.FMath;
	
	public class DrawVector extends Sprite
	{
		private var line:Shape;
		private var arrow:Shape;
		
		public function DrawVector() 
		{
			line = new Shape();
			arrow = new Shape();
			addChild(line);
			addChild(arrow);
		}
		
		public function rotateArrow(_x2:Number, _y2:Number):void
		{
			arrow.rotation = FMath.toAngle(FMath.radian(new Point(0, 0), new Point(_x2, _y2))) + 90;
		}
		
		public function free():void
		{
			removeChild(line);
			removeChild(arrow);
			line = null;
			arrow = null;
		}
		
		public function draw(color:uint, thickness:Number, _x1:Number, _y1:Number, _x2:Number, _y2:Number):void
		{
			line.graphics.clear();
			arrow.graphics.clear();
			
			line.graphics.lineStyle(thickness, color, 0.5);
			line.graphics.moveTo(_x1, _y1);
			line.graphics.lineTo(_x2, _y2);
			
			arrow.graphics.lineStyle(thickness, color);
			arrow.graphics.moveTo(-5, -5);
			arrow.graphics.lineTo(0, 0);
			arrow.graphics.lineTo(5, -5);
			arrow.x = _x2;
			arrow.y = _y2;
			rotateArrow(_x2, _y2);
		}
	}
}