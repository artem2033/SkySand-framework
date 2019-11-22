package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class MaximumProfile 
	{
		//0x00010000
		public var version:Number;
		public var numGlyphs:uint;
		public var maxPoints:uint;
		public var maxContours:uint;
		public var maxCompositePoints:uint;
		public var maxCompositeContours:uint;
		public var maxZones:uint;
		public var maxTwilightPoints:uint;
		public var maxStorage:uint;
		public var maxFunctionDefs:uint;
		public var maxInstructionDefs:uint;
		public var maxStackElements:uint;
		public var maxSizeOfInstructions:uint;
		public var maxComponentElements:uint;
		public var maxComponentDepth:uint;
		
		public function MaximumProfile() 
		{
			
		}
		
		public function readBytes(bytes:ByteArray):void
		{
			version = BytesUtils.readFixed(bytes);
			numGlyphs = bytes.readUnsignedShort();
			maxPoints = bytes.readUnsignedShort();
			maxContours = bytes.readUnsignedShort();
			maxCompositePoints = bytes.readUnsignedShort();
			maxCompositeContours = bytes.readUnsignedShort();
			maxZones = bytes.readUnsignedShort();
			maxTwilightPoints = bytes.readUnsignedShort();
			maxStorage = bytes.readUnsignedShort();
			maxFunctionDefs = bytes.readUnsignedShort();
			maxInstructionDefs = bytes.readUnsignedShort();
			maxStackElements = bytes.readUnsignedShort();
			maxSizeOfInstructions = bytes.readUnsignedShort();
			maxComponentElements = bytes.readUnsignedShort();
			maxComponentDepth = bytes.readUnsignedShort();
		}
	}
}