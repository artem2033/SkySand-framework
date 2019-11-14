package skysand.file 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyFilePacker 
	{
		public static const FILENAME:String = "spk";
		public static const VERSION:Number = 1.0;
		
		public function SkyFilePacker() 
		{
			
		}
		
		
		
		public static function pack(files:Vector.<ByteArray>, names:Vector.<String>, compression:String = "none"):ByteArray
		{
			if (files.length < 2) throw new Error("Not enough files to pack!");
			
			var header:ByteArray = new ByteArray();
			var bytes:ByteArray = new ByteArray();
			var data:ByteArray = new ByteArray();
			var length:int = files.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var file:ByteArray = files[i];
				
				header.writeUTF(names[i]);
				header.writeUnsignedInt(data.position);
				header.writeUnsignedInt(file.length);
				data.writeBytes(file);
			}
			
			if (compression != "none")
			{
				header.compress(compression);
				data.compress(compression);
			}
			
			bytes.writeByte(0);
			bytes.writeUTFBytes(FILENAME);
			bytes.writeFloat(VERSION);
			bytes.writeUTF(compression);
			bytes.writeShort(length);
			bytes.writeUTFBytes("HED");
			bytes.writeUnsignedInt(header.length);
			bytes.writeBytes(header);
			bytes.writeUTFBytes("DAT");
			bytes.writeBytes(data);
			bytes.writeByte(0);
			
			return bytes;
		}
		
		public static function unpack():Vector.<ByteArray>
		{
			return null;
		}
	}
}