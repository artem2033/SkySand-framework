package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class HorizontalMetricsTable 
	{
		public var advanceWidth:Vector.<uint>;
		public var lsb:Vector.<int>;
		public var leftSideBearings:Vector.<int>;
		
		public function HorizontalMetricsTable() 
		{
			
		}
		
		public function readBytes(bytes:ByteArray, numberOfHMetrics:uint, numGlyphs:uint):void
		{
			advanceWidth = new Vector.<uint>(numberOfHMetrics, true);
			lsb = new Vector.<int>(numberOfHMetrics, true);
			
			for (var i:int = 0; i < numberOfHMetrics; i++) 
			{
				advanceWidth[i] = bytes.readUnsignedShort();
				lsb[i] = bytes.readShort();
			}
			
			var length:int = numGlyphs - numberOfHMetrics;
			if (length > 0) 
			{
				leftSideBearings = new Vector.<int>(length, true);
				
				for (i = 0; i < length; i++) 
				{
					leftSideBearings[i] = bytes.readShort();
				}
			}
		}
		
		public function log():void
		{
			Console.log(toString());
		}
		
		public function toString():String
		{
			var string:String = "";
			var length:int = lsb.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				string += "\nadvanceWidth: " + advanceWidth[i];
				string += "\nlsb: " + lsb[i];
			}
			
			if (leftSideBearings != null)
			{
				length = leftSideBearings.length;
				
				for (i = 0; i < length; i++) 
				{
					string += "\nleftSideBearings: " + leftSideBearings[i];
				}
			}
			
			return string;
		}
	}
}