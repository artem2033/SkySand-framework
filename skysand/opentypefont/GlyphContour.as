package skysand.opentypefont 
{
	import skysand.debug.SkyDebugDraw;
	import skysand.utils.SkyMath;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class GlyphContour 
	{
		private var xOriginalCoordinates:Vector.<Number>;
		private var yOriginalCoordinates:Vector.<Number>;
		public var direction:uint = 0;
		public var innerContours:Vector.<GlyphContour>;
		public var xCoordinates:Vector.<Number>;
		public var yCoordinates:Vector.<Number>;
		
		public function GlyphContour(xPoints:Vector.<int>, yPoints:Vector.<int>, startIndex:int, endIndex:int) 
		{
			xOriginalCoordinates = Vector.<Number>(xPoints.slice(startIndex, endIndex));
			yOriginalCoordinates = Vector.<Number>(yPoints.slice(startIndex, endIndex));
		}
		
		public function containsPoint(x:Number, y:Number):Boolean
		{
			return SkyMath.containsPoint(x, y, xCoordinates, yCoordinates);
		}
		
		public function swapDirection():void
		{
			var length:int = xCoordinates.length;
			var last:int = length - 1;
			
			for (var i:int = 0; i < length; i++) 
			{
				var temp:Number = xOriginalCoordinates[i];
				xOriginalCoordinates[i] = xOriginalCoordinates[last];
				xOriginalCoordinates[last] = temp;
				
				temp = yOriginalCoordinates[i];
				yOriginalCoordinates[i] = yOriginalCoordinates[last];
				yOriginalCoordinates[last] = temp;
				
				last--;
				
				if (last <= i) break;
			}
		}
		
		public function draw(debugDraw:SkyDebugDraw, scale:Number = 1, color:uint = 0xFFF):void
		{
			debugDraw.drawContourB(xCoordinates, yCoordinates, color, 2, scale);
		}
	}
}