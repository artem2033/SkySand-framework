package skysand.render 
{
	/**
	 * ...
	 * @author Artem Andrienko
	 */
	public class ShapeRender 
	{
		
		public function ShapeRender() 
		{
			
		}
		
		public function drawLine(data:BitmapData, x0:int, y0:int, x1:int, y1:int, color:uint):void
		{
			var dx:int = x1 - x0;
			var dy:int = y1 - y0;
			var angle1:Number = dy / dx;
			var angle2:Number = dx / dy;
			var i:int = 0;
			var x:int = 0;
			var y:int = 0;
			var inc:int = dx > 0 ? -1 : 1;
			
			if (dx < dy)
			{
				for (i = 0; i < dy; i++) 
				{
					x = i * angle2 + x0;
					y = i + y0;
					
					data.setPixel(x + 1, y, color);
					data.setPixel(x, y, color);
				}
			}
			else
			{
				for (i = 0; i < dx; i++) 
				{
					x = i + x0;
					y = i * angle1 + y0;
					
					data.setPixel(x, y + 1, color);
					data.setPixel(x, y, color);
				}
			}
		}
	}

}