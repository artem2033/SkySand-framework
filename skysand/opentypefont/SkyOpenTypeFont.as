package skysand.opentypefont 
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
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
			/*var tags:Vector.<String> = new Vector.<String>();
			var dir:File = File.desktopDirectory.resolvePath("SkySand-framework/skysand/text/fonts");
			var files:Array = dir.getDirectoryListing()
			Console.log("size " + files.length);
			var j:int = 28;
			//for (var j:int = 0; j < files.length; j++) 
			//{
				
				Console.log(File(files[j]).name);
				//Console.log(j);
				SkySand-framework/skysand/text/fonts/anonymous
				*/
			var bytes:ByteArray = SkyFilesCache.loadBytesFromFile(SkyFilesCache.getFile("10441.ttf", SkyFilesCache.DESKTOP_DIRECTORY));
			//iFlash Roboto-Regular
			//bariol anonymous ubuntu
			//cyrBit display segoe
			//droidSans lato
			//futura is "special" and lato
			
			var sfntVersion:int = bytes.readInt();
			var numTables:int = bytes.readUnsignedShort();
			var searchRange:int = bytes.readUnsignedShort(); 
			var entrySelector:int = bytes.readUnsignedShort();
			var rangeShift:int = bytes.readUnsignedShort();
			
			var tags:Dictionary = new Dictionary(true);
			var tables:Vector.<SkyTable> = new Vector.<SkyTable>(numTables, true);
			var index:int = 0;
			
			for (var i:int = 0; i < numTables; i++) 
			{
				var table:SkyTable = new SkyTable();
				table.tableTag = bytes.readUTFBytes(4);
				table.checkSum = bytes.readUnsignedInt();
				table.offset = bytes.readUnsignedInt();
				table.length = bytes.readUnsignedInt();
				
				tags[table.tableTag] = i;
				//trace(table.tableTag + ", " + i);
				//if(tags.indexOf(table.tableTag) < 0) tags.push(table.tableTag);
				
				//if (table.tableTag == "post") index = i;
				//Console.log(table.tableTag + ", " + i);
				tables[i] = table;
			}
			/*
			bytes.position = tables[index].offset;
			var postScriptTable:PostScriptTable = new PostScriptTable();
			postScriptTable.readBytes(bytes);//}
			postScriptTable.log();
			
			/*
			bytes.position = tables[index].offset;
			var namingTable:NamingTable = new NamingTable();
			namingTable.readBytes(bytes);//}
			namingTable.log();
			/*for (i = 0; i < tags.length; i++) 
			{
				Console.log(tags[i]);
			}
			/*
			bytes.position = tables[8].offset;//8
			var profile:MaximumProfile = new MaximumProfile();
			profile.readBytes(bytes);
			
			bytes.position = tables[5].offset;
			var hht:HorizontalHeaderTable = new HorizontalHeaderTable();
			hht.readBytes(bytes);
			
			bytes.position = tables[index].offset;
			var horizontalMetrics:HorizontalMetricsTable = new HorizontalMetricsTable();
			horizontalMetrics.readBytes(bytes, hht.numberOfHMetrics, profile.numGlyphs);
			horizontalMetrics.log();
			
			/*
			bytes.position = tables[index].offset;
			var gridFittingTable:GridFittingTable = new GridFittingTable();
			gridFittingTable.readBytes(bytes);
			gridFittingTable.log();
			
			/*
			bytes.position = tables[0].offset;
			var os2:OS2Table = new OS2Table();
			os2.readBytes(bytes);
			*/
			/*bytes.position = tables[index].offset;//5 3 1
			var indexMapping:CharacterIndexMappingTable = new CharacterIndexMappingTable();
			indexMapping.readBytes(bytes);
			indexMapping.log();//}
			*/
			bytes.position = tables[tags["head"]].offset;//4
			var header:FontHeader = new FontHeader();
			header.readData(bytes);
			//header.print();
			
			bytes.position = tables[tags["maxp"]].offset;//8
			var profile:MaximumProfile = new MaximumProfile();
			profile.readBytes(bytes);
			
			bytes.position = tables[tags["loca"]].offset;//7
			var indexPos:IndexLocation = new IndexLocation();
			indexPos.readBytes(bytes, header.indexToLocFormat, profile.numGlyphs);
			
			bytes.position = tables[tags["glyf"]].offset;//3
			glyphTable = new GlyphTable();
			glyphTable.readBytes(bytes, profile.numGlyphs, indexPos.offsets);
			glyphTable.container = container;
			
			//Console.log(bytes.position);
			
			
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
		
		public function getGlyphTable():GlyphTable
		{
			return glyphTable;
		}
		
		public function setCon(c:SkyRenderObjectContainer):void
		{
			glyphTable.container = c;
		}
	}
}