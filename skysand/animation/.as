package skysand.animation
{	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class d extends Object
	{
		protected static const INDENT_FOR_FILTER:int = 64;
		protected static const INDENT_FOR_FILTER_DOUBLED:int = 128;
		protected static const DEST_POINT:Point = new Point();
		
		/**
		 * Кадры растеризованные.
		 */
		public var frames:Vector.<BitmapData>;
		
		/**
		 * Положение кадра по оси х.
		 */
		public var framesX:Vector.<Number>;
		
		/**
		 * Положение кадра по оси у.
		 */
		public var framesY:Vector.<Number>;
		
		public function d()
		{
			frames = new Vector.<BitmapData>();
			framesX = new Vector.<Number>();
			framesY = new Vector.<Number>();
		}
		
		public function spriteToBitmapData(sprite:Sprite):void
		{
			var rect:Rectangle = sprite.getRect(sprite);
			
			rect.width = Math.ceil(rect.width);
			rect.height = Math.ceil(rect.height);
			
			var matrix:Matrix = new Matrix();
			matrix.tx = -rect.x;
			matrix.ty = -rect.y;
			matrix.scale(sprite.scaleX, sprite.scaleY);
			matrix.rotate(sprite.rotation);
			
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0xFFFFFF);
			bitmapData.draw(sprite, matrix);
			
			frames[0] = bitmapData;
			framesX[0] = 0;
			framesY[0] = 0;
		}
		
		/**
		 * Растрировать анимацию.
		 * @param	clipName название класса.
		 */
		public function createAnimation(clipName:Class):void
		{
			var clipToCache:MovieClip = new clipName();
			var rectangle:Rectangle;
			var matrix:Matrix = new Matrix();
			var scratchBitmapData:BitmapData = null;
			var flooredX:Number = 0;
			var flooredY:Number = 0;
			var maxFrames:int = clipToCache.totalFrames;
			var i:int = 1;
			
			while (i <= maxFrames)
			{
				clipToCache.gotoAndStop(i);
				
				rectangle = clipToCache.getBounds(clipToCache);
				
				rectangle.width = Math.ceil(rectangle.width) + INDENT_FOR_FILTER_DOUBLED;
				rectangle.height = Math.ceil(rectangle.height) + INDENT_FOR_FILTER_DOUBLED;
				
				flooredX = rectangle.x - INDENT_FOR_FILTER;
				flooredY = rectangle.y - INDENT_FOR_FILTER;
				
				matrix.tx = -flooredX;
				matrix.ty = -flooredY;
				
				scratchBitmapData = new BitmapData(rectangle.width, rectangle.height, true, 0);
				scratchBitmapData.draw(clipToCache, matrix);
				
				var trimBounds:Rectangle = scratchBitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
				trimBounds.x -= 1;
				trimBounds.y -= 1;
				trimBounds.width += 2;
				trimBounds.height += 2;
				
				var bitmap_data:BitmapData = new BitmapData(trimBounds.width, trimBounds.height, true, 0);
				bitmap_data.copyPixels(scratchBitmapData, trimBounds, DEST_POINT);
				
				flooredX += trimBounds.x;
				flooredY += trimBounds.y;
				
				framesX.push(flooredX);
				framesY.push(flooredY);
				frames.push(bitmap_data);
				
				scratchBitmapData.dispose();
				i++;
			}
		}
	}
}
