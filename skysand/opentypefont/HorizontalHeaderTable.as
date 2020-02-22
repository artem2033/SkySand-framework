package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class HorizontalHeaderTable 
	{
		public var majorVersion:uint;
		public var minorVersion:uint;
		public var ascender:int;
		public var descender:int;
		public var lineGap:int;
		public var advanceWidthMax:uint;
		public var minLeftSideBearing:int;
		public var minRightSideBearing:int;
		public var xMaxExtent:int;
		public var caretSlopeRise:int;
		public var caretSlopeRun:int;
		public var caretOffset:int;
		//int16	(reserved)	set to 0
		//int16	(reserved)	set to 0
		//int16	(reserved)	set to 0
		//int16	(reserved)	set to 0
		public var metricDataFormat:int;
		public var numberOfHMetrics:uint;
		
		public function HorizontalHeaderTable() 
		{
			
		}
		
		public function readBytes(bytes:ByteArray):void
		{
			majorVersion = bytes.readUnsignedShort();
			minorVersion = bytes.readUnsignedShort();
			ascender = bytes.readShort();
			descender = bytes.readShort();
			lineGap = bytes.readShort();
			advanceWidthMax = bytes.readUnsignedShort();
			minLeftSideBearing = bytes.readShort();
			minRightSideBearing = bytes.readShort();
			xMaxExtent = bytes.readUnsignedShort();
			caretSlopeRise = bytes.readShort();
			caretSlopeRun = bytes.readShort();
			caretOffset = bytes.readShort();
			bytes.readShort();
			bytes.readShort();
			bytes.readShort();
			bytes.readShort();
			metricDataFormat = bytes.readShort();
			numberOfHMetrics = bytes.readUnsignedShort();
		}
		
		public function log():void
		{
			Console.log(toString());
		}
		
		public function toString():String
		{
			var string:String = "";
			string += "\nmajorVersion: " + majorVersion;
			string += "\nminorVersion: " + minorVersion;
			string += "\nascender: " + ascender;
			string += "\ndescender: " + descender;
			string += "\nlineGap: " + lineGap;
			string += "\nadvanceWidthMax: " + advanceWidthMax;
			string += "\nminLeftSideBearing: " + minLeftSideBearing;
			string += "\nminRightSideBearing: " + minRightSideBearing;
			string += "\nxMaxExtent: " + xMaxExtent;
			string += "\ncaretSlopeRise: " + caretSlopeRise;
			string += "\ncaretSlopeRun: " + caretSlopeRun;
			string += "\ncaretOffset: " + caretOffset;
			string += "\nmetricDataFormat: " + metricDataFormat;
			string += "\nnumberOfHMetrics: " + numberOfHMetrics;
			
			return string;
		}
	}
}