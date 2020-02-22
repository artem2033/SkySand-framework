package skysand.opentypefont 
{
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class CharacterIndexMappingTable 
	{
		private const UNICODE_PLATFORM:uint = 0;
		private const MAC_OS_PLATFORM:uint = 1;
		private const ISO_PLATFORM:uint = 2;
		private const WINDOWS_PLATFORM:uint = 3;
		private const CUSTOM_PLATFORM:uint = 4;
		
		private var currentPlatform:uint;
		
		public var version:uint;
		public var numTables:uint;
		public var maps:Vector.<CharacterMap>;
		private var platformMap:CharacterMap;
		private var bytes:ByteArray;
		
		public function CharacterIndexMappingTable() 
		{
			var char:String = Capabilities.os.charAt(0);
			currentPlatform = char == "W" ? WINDOWS_PLATFORM : char == "M" ? MAC_OS_PLATFORM : 4;
		}
		
		public function readBytes(bytes:ByteArray):void
		{
			var start:uint = bytes.position;
			version = bytes.readUnsignedShort();
			numTables = bytes.readUnsignedShort();
			
			maps = new Vector.<CharacterMap>(numTables, true);
			this.bytes = bytes;
			
			for (var i:int = 0; i < numTables; i++) 
			{
				var map:CharacterMap = new CharacterMap();
				map.platformID = bytes.readUnsignedShort();
				map.encodingID = bytes.readUnsignedShort();
				map.offset = start + bytes.readUnsignedInt();
				maps[i] = map;
				
				if (map.platformID == currentPlatform) platformMap = map;
			}
			
			if (platformMap == null) throw new Error("Check your platform font reader!");
			platformMap.readBytes(bytes);
		}
		
		public function getMapByIndex(index:int):CharacterMap
		{
			maps[index].readBytes(bytes);
			return maps[index];
		}
		
		public function getPlatformMap():CharacterMap
		{
			return platformMap;
		}
		
		/**
		 * Вывести в консоль данные таблицы.
		 */
		public function log():void
		{
			Console.log(toString());
		}
		
		/**
		 * Преобразовать данные таблицы в строку.
		 * @return возвращает строку.
		 */
		public function toString():String
		{
			var string:String = "-------------";
			string += "\nversion: " + version;
			string += "\nnumTables: " + numTables;
			
			return string;
		}
	}
}