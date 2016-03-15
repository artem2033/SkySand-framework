package skysand.animation
{	
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	
	public class SkyAnimation extends Object
	{
		protected static const INDENT_FOR_FILTER:int = 64;
		protected static const INDENT_FOR_FILTER_DOUBLED:int = 128;
		protected static const DEST_POINT:Point = new Point();
		
		/**
		 * Имя анимации.
		 */
		public var name:String;
		
		/**
		 * Растеризованные кадры.
		 */
		public var frames:Vector.<SkyFrameData>;
		
		public function SkyAnimation()
		{
			super();
			frames = new Vector.<SkyFrameData>();
		}
		
		/**
		 * Растрировать анимацию из Sprite.
		 * @param	sprite ссылка на спрайт.
		 */
		public function makeFrameFromSprite(sprite:Sprite):void
		{
			var rect:Rectangle = sprite.getBounds(sprite);
			
			rect.width = Math.ceil(rect.width);
			rect.height = Math.ceil(rect.height);
			
			var matrix:Matrix = new Matrix();
			matrix.tx = -rect.x;
			matrix.ty = -rect.y;
			matrix.scale(sprite.scaleX, sprite.scaleY);
			matrix.rotate(sprite.rotation);
			
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0xFFFFFF);
			bitmapData.draw(sprite, matrix);
			
			var data:SkyFrameData = new SkyFrameData();
			data.x = rect.x;
			data.y = rect.y;
			data.bitmapData = bitmapData;
			frames.push(data);
		}
		
		/**
		 * Растрировать анимацию из MovieClip.
		 * @param	_class название класса.
		 */
		public function makeAnimationFromMovieClip(_class:Class):void
		{
			var clip:MovieClip = new _class();
			var data:SkyFrameData;
			var rectangle:Rectangle;
			var matrix:Matrix = new Matrix();
			var scratchBitmapData:BitmapData = null;
			var flooredX:Number = 0;
			var flooredY:Number = 0;
			var maxFrames:int = clip.totalFrames;
			var i:int = 1;
			
			while (i <= maxFrames)
			{
				clip.gotoAndStop(i);
				
				rectangle = clip.getBounds(clip);
				
				rectangle.width = Math.ceil(rectangle.width) + INDENT_FOR_FILTER_DOUBLED;
				rectangle.height = Math.ceil(rectangle.height) + INDENT_FOR_FILTER_DOUBLED;
				
				flooredX = rectangle.x - INDENT_FOR_FILTER;
				flooredY = rectangle.y - INDENT_FOR_FILTER;
				
				matrix.tx = -flooredX;
				matrix.ty = -flooredY;
				
				scratchBitmapData = new BitmapData(rectangle.width, rectangle.height, true, 0);
				scratchBitmapData.draw(clip, matrix);
				
				var trimBounds:Rectangle = scratchBitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
				trimBounds.x -= 1;
				trimBounds.y -= 1;
				trimBounds.width += 2;
				trimBounds.height += 2;
				
				var bitmapData:BitmapData = new BitmapData(trimBounds.width, trimBounds.height, true, 0);
				bitmapData.copyPixels(scratchBitmapData, trimBounds, DEST_POINT);
				
				flooredX += trimBounds.x;
				flooredY += trimBounds.y;
				
				data = new SkyFrameData();
				data.x = flooredX;
				data.y = flooredY;
				data.bitmapData = bitmapData;
				frames.push(data);
				
				scratchBitmapData.dispose();
				i++;
			}
		}
	}
}
