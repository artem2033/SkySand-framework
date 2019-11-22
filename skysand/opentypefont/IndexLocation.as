package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class IndexLocation 
	{
		public var offsets:Vector.<uint>;
		
		public function IndexLocation() 
		{
			
		}
		
		public function readBytes(bytes:ByteArray, indexToLocFormat:int, numGlyphs:int):void
		{
			offsets = new Vector.<uint>();
			
			if (indexToLocFormat == 0)
			{
				for (var i:int = 0; i < numGlyphs + 1; i++) 
				{
					offsets[i] = bytes.readUnsignedShort() * 2;
				}
			}
			else
			{
				for (i = 0; i < numGlyphs + 1; i++) 
				{
					offsets[i] = bytes.readUnsignedInt();
				}
			}
		}
	}
}