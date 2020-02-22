package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class FontHeader 
	{
		public var majorVersion:uint;
		public var minorVersion:uint;
		public var fontRevision:Number;
		public var checkSumAdjustment:uint;
		public var magicNumber:uint = 0x5F0F3CF5;
		public var flags:uint;
		public var unitsPerEm:uint;
		public var created:Number;
		public var modified:Number;
		public var xMin:int;
		public var yMin:int;
		public var xMax:int;
		public var yMax:int;
		public var macStyle:uint;
		public var lowestRecPPEM:uint;
		public var fontDirectionHint:int;
		public var indexToLocFormat:int;
		public var glyphDataFormat:int;
		
		public function FontHeader() 
		{
			
		}
		
		public function readData(bytes:ByteArray):void
		{
			majorVersion = bytes.readUnsignedShort();
			minorVersion = bytes.readUnsignedShort();
			fontRevision = BytesUtils.readFixed(bytes);
			checkSumAdjustment = bytes.readUnsignedInt();
			magicNumber = bytes.readUnsignedInt();
			flags = bytes.readUnsignedShort();
			unitsPerEm = bytes.readUnsignedShort();
			created = BytesUtils.readLong64(bytes);
			modified = BytesUtils.readLong64(bytes);
			xMin = bytes.readShort();
			yMin = bytes.readShort();
			xMax = bytes.readShort();
			yMax = bytes.readShort();
			macStyle = bytes.readUnsignedShort();
			lowestRecPPEM = bytes.readUnsignedShort();
			fontDirectionHint = bytes.readShort();
			indexToLocFormat = bytes.readShort();
			glyphDataFormat = bytes.readShort();
		}
		
		public function print():void
		{
			trace("header");
			trace(majorVersion);
			trace(minorVersion);
			trace(fontRevision);
			trace(checkSumAdjustment);
			trace(magicNumber);
			trace(flags);
			trace(unitsPerEm);
			trace(created);
			trace(modified);
			trace(xMin);
			trace(yMin);
			trace(xMax);
			trace(yMax);
			trace(macStyle);
			trace(lowestRecPPEM);
			trace(fontDirectionHint);
			trace(indexToLocFormat);
			trace(glyphDataFormat);
			trace("---------------");
		}
	}
}