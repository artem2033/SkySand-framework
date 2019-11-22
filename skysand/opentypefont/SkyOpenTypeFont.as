package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.opentypefont.SkyTable;
	import skysand.file.SkyFilesCache;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyOpenTypeFont 
	{
		public var container:SkyRenderObjectContainer;
		private var glyphTable:GlyphTable;
		
		public function SkyOpenTypeFont() 
		{
			var bytes:ByteArray = SkyFilesCache.loadBytesFromFile(SkyFilesCache.getFile("iFlash.ttf", SkyFilesCache.DESKTOP_DIRECTORY));
			
			var sfntVersion:int = bytes.readInt();
			var numTables:int = bytes.readUnsignedShort();
			var searchRange:int = bytes.readUnsignedShort(); 
			var entrySelector:int = bytes.readUnsignedShort();
			var rangeShift:int = bytes.readUnsignedShort();
			
			var tables:Vector.<SkyTable> = new Vector.<SkyTable>(numTables, true);
			
			for (var i:int = 0; i < numTables; i++) 
			{
				var table:SkyTable = new SkyTable();
				table.tableTag = bytes.readUTFBytes(4);
				table.checkSum = bytes.readUnsignedInt();
				table.offset = bytes.readUnsignedInt();
				table.length = bytes.readUnsignedInt();
				//Console.log(table.tableTag + ", " + i);
				tables[i] = table;
			}
			trace(bytes.endian);
			bytes.position = tables[4].offset;
			var header:FontHeader = new FontHeader();
			header.readData(bytes);
			
			bytes.position = tables[8].offset;
			var profile:MaximumProfile = new MaximumProfile();
			profile.readBytes(bytes);
			
			bytes.position = tables[7].offset;
			var indexPos:IndexLocation = new IndexLocation();
			indexPos.readBytes(bytes, header.indexToLocFormat, profile.numGlyphs);
			
			bytes.position = tables[3].offset;
			glyphTable = new GlyphTable();
			glyphTable.readBytes(bytes, profile.numGlyphs, indexPos.offsets);
			glyphTable.container = container;
			
			//Console.log(bytes.position);
			
			
			/*var hht:HorizontalHeaderTable = new HorizontalHeaderTable();
			hht.readBytes(bytes);
			
			/**/
			
			//Tag			tableTag	Table identifier.
			//uint32		checkSum	CheckSum for this table.
			//Offset32		offset		Offset from beginning of TrueType font file.
			//uint32		length		Length of this table.
			
			
			/*
			Console.log(sfntVersion);
			Console.log(numTables);
			Console.log(searchRange);
			Console.log(entrySelector);
			Console.log(rangeShift);*/
		}
		
		public function setCon(c:SkyRenderObjectContainer):void
		{
			glyphTable.container = c;
		}
	}
}