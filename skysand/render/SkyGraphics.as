package skysand.render 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	use namespace framework;
	
	public class SkyGraphics extends Object
	{
		/**
		 * Ссылка на класс в который рисовать.
		 */
		private var object:RenderObject;
		
		/**
		 * Цвет которым закрашивать.
		 */
		private var fillColor:uint;
		
		/**
		 * Цвет линии.
		 */
		private var lineColor:uint;
		
		/**
		 * Начальная координата X для рисования линии.
		 */
		private var beginX:Number;
		
		/**
		 * Начальная координата Y для рисования линии.
		 */
		private var beginY:Number;
		
		private var lineSmoothing:Boolean;
		
		private var rectangle:Rectangle = new Rectangle();
		
		private var bitmapData:BitmapData;
		
		private var tinkness:int;
		
		public function SkyGraphics(bitmapData:RenderObject)
		{
			object = bitmapData;
			fillColor = 0;
			lineColor = 0;
			beginX = 0;
			beginY = 0;
			lineSmoothing = false;
		}
		
		/**
		 * Настроить цвет заполнения графики.
		 * @param	color цвет.
		 * @param	alpha прозрачность от 0 до 1.
		 */
		public function beginFill(color:uint, alpha:Number = 1):void
		{
			fillColor = ((alpha * 0xFF) << 24) | color;
		}
		
		/**
		 * Настройки для рисования линии.
		 * @param	tinkness толщина линии.
		 * @param	color цвет.
		 * @param	alpha прозрачность от 0 до 1.
		 * @param	smoothing сглаживание линии.
		 */
		public function lineStyle(tinkness:int, color:uint, alpha:Number = 1, smoothing:Boolean = false):void
		{
			lineColor = ((alpha * 0xFF) << 24) | color;
			lineSmoothing = smoothing;
			this.tinkness = tinkness;
		}
		
		/**
		 * Задать начальную точку для рисования линии.
		 * @param	x координата X.
		 * @param	y координата Y.
		 */
		public function moveTo(x:Number, y:Number):void
		{
			beginX = x;
			beginY = y;
		}
		
		/**
		 * Задать конечную точку для рисования линии.
		 * @param	x координата X.
		 * @param	y координата Y.
		 */
		public function lineTo(x:Number, y:Number):void
		{
			object.bitmapData.lock();
			//if (lineSmoothing) antiAliasedLine(x, y);
			/*else*/ notAntiAliasedLine(x, y);
			object.bitmapData.unlock();
			
			beginX = x;
			beginY = y;
			
			object.width = object.width < x ? x + 1 : object.width;
			object.height = object.height < y ? y + 1 : object.height;
			
			//target.originX = x;
			//target.originY = y;
		}
		
		private function notAntiAliasedLine(x:int, y:int):void
		{
			var dx:int;
			var dy:int;
			var i:int;
			var xinc:int;
			var yinc:int;
			var cumul:int;
			var targetX:int;
			var targetY:int;
			targetX = beginX;
			targetY = beginY;
			dx = x - beginX;
			dy = y - beginY;
			xinc = ( dx > 0 ) ? 1 : -1;
			yinc = ( dy > 0 ) ? 1 : -1;
			dx = dx < 0 ? -dx : dx;
			dy = dy < 0 ? -dy : dy;
			object.bitmapData.setPixel32(targetX, targetY, lineColor);
			
			if ( dx > dy )
			{
				cumul = dx >> 1;
		  		
				for ( i = 1 ; i <= dx; ++i )
				{
					targetX += xinc;
					cumul += dy;
					
					if (cumul >= dx)
					{
			  			cumul -= dx;
			  			targetY += yinc;
					}
					
					object.bitmapData.setPixel32(targetX, targetY, lineColor);
				}
			}
			else
			{
		  		cumul = dy >> 1;
		  		
				for ( i = 1 ; i <= dy; ++i )
				{
					targetY += yinc;
					cumul += dx;
					
					if ( cumul >= dy )
					{
			  			cumul -= dy;
			  			targetX += xinc ;
					}
					
					object.bitmapData.setPixel32(targetX, targetY, lineColor);
				}
			}
		}
		/*
		private function antiAliasedLine(x:int, y:int):void
		{
			var steep:Boolean = Boolean((y - oldy) < 0 ? -(y - oldy) : (y - oldy) > (x - oldx) < 0 ? -(x - oldx) : (x - oldx));
			var swap:int;
			
			if (steep)
			{
				swap = oldx; oldx = oldy; oldy = swap;
				swap = x; x = y; y = swap;
			}
			
			if (oldx > x)
			{
				swap = oldx; oldx = x; x = swap;
				swap = oldy; oldy = y; y = swap;
			}
			
			var dx:int = x - oldx;
			var dy:int = y - oldy
			
			var gradient:Number = dy / dx;
			
			var xend:int = oldx;
			var yend:Number = oldy + gradient * (xend - oldx);
			var xgap:Number = 1 - ((oldx + 0.5) % 1);
			var xpx1:int = xend;
			var ypx1:int = yend;
			var alpha:Number;
			
			alpha = ((yend) % 1 ) * xgap;
			
			var intery:Number = yend + gradient;
			
			xend = x;
			yend = y + gradient * (xend - x)
			xgap = (x + 0.5) % 1;
			
			var xpx2:int = xend; 
			var ypx2:int = yend;
			
			alpha = (1 - ((yend) % 1)) * xgap;
			
			if (steep)
				drawAlphaPixel(ypx2, xpx2, alpha, _lineColor);
			else drawAlphaPixel(xpx2, ypx2, alpha, _lineColor);
			
			alpha = ((yend) % 1) * xgap;
			
			if (steep)
				drawAlphaPixel(ypx2 + 1, xpx2, alpha, _lineColor);
			else drawAlphaPixel(xpx2, ypx2 + 1, alpha, _lineColor);
			 
			var tx:int = xpx1;
			
			while (tx++ < xpx2)
			{
				alpha = 1 - ((intery) % 1);
				
				if (steep)
					drawAlphaPixel(intery, tx, alpha, _lineColor);
				else drawAlphaPixel(tx, intery, alpha, _lineColor);
				
				alpha = intery % 1;
				
				if (steep)
					drawAlphaPixel(intery + 1, tx, alpha, _lineColor);
				else drawAlphaPixel(tx, intery + 1, alpha, _lineColor);
				
				intery = intery + gradient
			}
		}
		*/
		
		/**
		 * Нарисовать прямоугольник.
		 * @param	x точка центра прямоугольника X.
		 * @param	y точка центра прямоугольника Y.
		 * @param	width ширина прямоугольника.
		 * @param	height высота прямоугольника.
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			rectangle.width = width;
			rectangle.height = height;
			
			object.bitmapData.fillRect(rectangle, fillColor);
			object.width = width;
			object.height = height;
			object.x = x;
			object.y = y;
		}
		
		public function clear():void
		{/*
			rectangle.width = target.width;
			rectangle.height = target.height;
			target.bitmapData.fillRect(rectangle, 0x000000);
			target.originX = 0;
			target.originY = 0;
			target.width = 0;
			target.height = 0;*/
		}
		
		/*
		private function drawAlphaPixel ( x:int, y:int, a:Number, c:Number ):void
		{	
			var g:uint = target.getPixel32(x,y);
			
			var r0:uint = ((g & 0x00FF0000) >> 16);
			var g0:uint = ((g & 0x0000FF00) >> 8);
			var b0:uint = ((g & 0x000000FF));
			
			var r1:uint = ((c & 0x00FF0000) >> 16);
			var g1:uint = ((c & 0x0000FF00) >> 8);
			var b1:uint = ((c & 0x000000FF));
			
			var ac:Number = 0xFF;
			var rc:Number = r1 * a + r0 * (1 - a);
			var gc:Number = g1 * a + g0 * (1 - a);
			var bc:Number = b1 * a + b0 * (1 - a);
			
			var n:uint = (ac << 24) + (rc << 16) + (gc << 8) + bc;
			target.setPixel32(x, y, n);
		}*/
	}
}