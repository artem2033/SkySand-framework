package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class BytesUtils 
	{
		
		public function BytesUtils()
		{
			
		}
		
		public static function readFixed(bytes:ByteArray):Number  
		{ 
			var integerValue:int = bytes.readInt(); 
			var floatValue:Number = Number(integerValue) / Number(0x10000); 
			
			return floatValue; 
		}
		
		public static function readF2Dot14(bytes:ByteArray):Number 
		{ 
			var integerValue:int = bytes.readShort(); 
			var floatValue:Number = Number(integerValue) / Number(0x20000); 
			
			return floatValue; 
		}
		
		public static function readLong64(bytes:ByteArray):Number  
		{ 
			var value:Number = bytes.readUnsignedInt() << 32; 
			value += bytes.readUnsignedInt(); 
			
			return value; 
		}
		
		public static function readUint24(bytes:ByteArray):uint
		{ 
			var value:uint = bytes.readUnsignedShort() << 16; 
			value += bytes.readUnsignedByte(); 
			
			return value; 
		}
		
		/*public static function readLong16(bytes:ByteArray):uint  
		{ 
			var value:uint = bytes.readUnsignedByte() << 8; 
			value += bytes.readUnsignedByte(); 
			
			return value; 
		}*/
		
		public static function hasFlag(target:uint, flag:uint):Boolean
		{
			return (target & flag) == flag;
		}
	}
}