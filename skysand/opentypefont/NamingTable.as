package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class NamingTable 
	{
		public static const COPYRIGHT:uint = 0;
		public static const FONT_FAMILY:uint = 1;
		public static const FONT_SUBFAMILY:uint = 2;
		public static const UNIQUE_ID:uint = 3;
		public static const FULL_NAME:uint = 4;
		public static const VERSION:uint = 5;
		public static const POSTSCRIPT:uint = 6;
		public static const TRADEMARK:uint = 7;
		public static const MANUFACTURER:uint = 8;
		public static const DESIGNER:uint = 9;
		public static const DESCRIPTION:uint = 10;
		public static const URL_VENDOR:uint = 11;
		public static const URL_DESIGNER:uint = 12;
		public static const LICENSE_DESCRIPTION:uint = 13;
		public static const LICENSE_INFO_URL:uint = 14;
		public static const TYPOGRAPHIC_FAMILY:uint = 16;
		public static const TYPOGRAPHIC_SUBFAMILY:uint = 17;
		public static const COMPATIBLE_FULL:uint = 18;
		public static const SAMPLE_TEXT:uint = 19;
		public static const POSTSCRIPT_CID:uint = 20;
		public static const WWS_FAMILY:uint = 21;
		public static const WWS_SUBFAMILY:uint = 22;
		public static const LIGHT_BACKGROUND_PALETTE:uint = 23;
		public static const DARK_BACKGROUND_PALETTE:uint = 24;
		public static const VARIATIONS_POSTSCRIPT_PREFIX:uint = 25;
		
		public var format:uint;
		public var count:uint;
		public var stringOffset:uint;
		public var records:Vector.<NameRecord>;
		
		public var langTagCount:uint;
		public var langTagOffset:Vector.<uint>
		public var langTagLength:Vector.<uint>
		private var fontInfo:Vector.<String>;
		
		public function NamingTable() 
		{
			
		}
		
		/**
		 * Прочитать данные для текущей таблицы.
		 * @param	bytes ссылка на массив байт.
		 */
		public function readBytes(bytes:ByteArray):void
		{
			var offset:uint = bytes.position;
			
			records = new Vector.<NameRecord>();
			format = bytes.readUnsignedShort();
			count = bytes.readUnsignedShort();
			stringOffset = bytes.readUnsignedShort();
			
			for (var i:int = 0; i < count; i++) 
			{
				var record:NameRecord = new NameRecord();
				record.platformID = bytes.readUnsignedShort();
				record.encodingID = bytes.readUnsignedShort();
				record.languageID = bytes.readUnsignedShort();
				record.nameID = bytes.readUnsignedShort();
				record.length = bytes.readUnsignedShort();
				record.offset = bytes.readUnsignedShort();
				records[i] = record;
			}
			
			if (format == 1)
			{
				langTagCount = bytes.readUnsignedShort();
				langTagLength = new Vector.<uint>();
				langTagOffset = new Vector.<uint>();
				
				for (i = 0; i < langTagCount; i++) 
				{
					langTagLength[i] = bytes.readUnsignedShort();
					langTagOffset[i] = bytes.readUnsignedShort();
				}
			}
			
			fillFontInfo();
			
			for (i = 0; i < count; i++) 
			{
				record = records[i];
				bytes.position = offset + stringOffset + record.offset;
				
				var length:int = record.length;
				var string:String = fontInfo[record.nameID];
				string = string.substr(0, string.length - 4);
				
				for (var j:int = 0; j < length; j++) 
				{
					string += bytes.readUTFBytes(1);
				}
				
				fontInfo[record.nameID] = string;
			}
		}
		
		/**
		 * Получить информацию о шрифте по уникальному идентификатору.
		 * @return возвращает строку.
		 */
		public function getFontInfo(id:uint):String
		{
			return fontInfo[id];
		}
		
		/**
		 * Вывести данные в консоль.
		 */
		public function log():void
		{
			Console.log(toString());
		}
		
		/**
		 * Вывести всю информацию о шрифте в консоль.
		 */
		public function logFullInfo():void
		{
			for (var i:int = 0; i < count; i++) 
			{
				Console.log(getFontInfo(records[i].nameID));
			}
		}
		
		/**
		 * Преобразовать данные таблицы в строку.
		 */
		public function toString():String
		{
			var string:String = "";
			string += "\nformat: " + format;
			string += "\ncount: " + count;
			string += "\nstringOffset: " + stringOffset;
			
			for (var i:int = 0; i < count; i++) 
			{
				var record:NameRecord = records[i];
				string += "\nname record: " + i;
				string += "\nplatformID: " + record.platformID;
				string += "\nencodingID: " + record.encodingID;
				string += "\nlanguageID: " + record.languageID;
				string += "\n: nameID" + record.nameID;
				string += "\nlength: " + record.length;
				string += "\noffset: " + record.offset;
			}
			
			if (format == 1)
			{
				for (i = 0; i < langTagCount; i++) 
				{
					string += "\nlangTagLength: " + langTagLength[i];
					string += "\nlangTagOffset: " + langTagOffset[i];
				}
			}
			
			return string;
		}
		
		/**
		 * Заполнить массив с данными о шрифте.
		 */
		private function fillFontInfo():void
		{
			fontInfo = new Vector.<String>(26, true);
			
			fontInfo[COPYRIGHT] 					= "Copyright: none";
			fontInfo[FONT_FAMILY] 					= "Font family: none";
			fontInfo[FONT_SUBFAMILY] 				= "Font subfamily: none";
			fontInfo[UNIQUE_ID] 					= "Unique identifier: none";
			fontInfo[FULL_NAME] 					= "Full name: none";
			fontInfo[VERSION] 						= "Version: none";
			fontInfo[POSTSCRIPT] 					= "Postscript: none";
			fontInfo[TRADEMARK] 					= "Trademark: none";
			fontInfo[MANUFACTURER] 					= "Manufacturer: none";
			fontInfo[DESIGNER] 						= "Designer: none";
			fontInfo[DESCRIPTION] 					= "Description: none";
			fontInfo[URL_VENDOR] 					= "URL vendor: none";
			fontInfo[URL_DESIGNER] 					= "URL designer: none";
			fontInfo[LICENSE_DESCRIPTION] 			= "License description: none";
			fontInfo[LICENSE_INFO_URL] 				= "License info URL: none";
			fontInfo[TYPOGRAPHIC_FAMILY] 			= "Typographic family: none";
			fontInfo[TYPOGRAPHIC_SUBFAMILY] 		= "Typographic subfamily: none";
			fontInfo[COMPATIBLE_FULL] 				= "Compatible full: none";
			fontInfo[SAMPLE_TEXT] 					= "Sample text: none";
			fontInfo[POSTSCRIPT_CID] 				= "Postscript CID: none";
			fontInfo[WWS_FAMILY] 					= "WWS family: none";
			fontInfo[WWS_SUBFAMILY] 				= "WWS subfamily: none";
			fontInfo[LIGHT_BACKGROUND_PALETTE] 		= "Light background palette: none";
			fontInfo[DARK_BACKGROUND_PALETTE] 		= "Dark background palette: none";
			fontInfo[VARIATIONS_POSTSCRIPT_PREFIX]	= "Variations postscript prefix: none";
		}
	}
}