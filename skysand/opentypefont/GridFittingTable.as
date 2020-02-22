package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class GridFittingTable 
	{
		public static const GASP_GRIDFIT:uint = 0x0001;
		public static const GASP_DOGRAY:uint = 0x0002;
		public static const GASP_SYMMETRIC_GRIDFIT:uint = 0x0004;
		public static const GASP_SYMMETRIC_SMOOTHING:uint = 0x0008;
		
		public var version:uint;
		public var numRanges:uint;
		public var rangeMaxPPEM:Vector.<uint>;
		public var rangeGaspBehavior:Vector.<uint>;
		
		public function GridFittingTable() 
		{
			
		}
		
		public function readBytes(bytes:ByteArray):void
		{
			rangeMaxPPEM = new Vector.<uint>();
			rangeGaspBehavior = new Vector.<uint>();
			
			version = bytes.readUnsignedShort();
			numRanges = bytes.readUnsignedShort();
			
			for (var i:int = 0; i < numRanges; i++) 
			{
				rangeMaxPPEM[i] = bytes.readUnsignedShort();
				rangeGaspBehavior[i] = bytes.readUnsignedShort();
			}
		}
		
		public function log():void
		{
			Console.log(toString());
		}
		
		public function toString():String
		{
			var string:String = "";
			string += "\nversion: " + version;
			string += "\nnumRanges: " + numRanges;
			
			for (var i:int = 0; i < numRanges; i++) 
			{
				string += "\nrangeMaxPPEM: " + rangeMaxPPEM[i];
				string += "\nrangeGaspBehavior: " + rangeGaspBehavior[i];
			}
			
			return string;
		}
	}
}