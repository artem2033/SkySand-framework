package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	import skysand.display.SkyRenderObjectContainer;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class GlyphTable
	{
		private var glyphs:Vector.<GlyphData>;
		private var tableOffset:uint = 0;
		public var container:SkyRenderObjectContainer;
		
		public function GlyphTable() 
		{
			
		}
		
		public function readBytes(bytes:ByteArray, numGlyphs:uint, offsets:Vector.<uint>):void
		{
			glyphs = new Vector.<GlyphData>(numGlyphs, true);
			tableOffset = bytes.position;
			
			//var compositeGlyphs:Vector.<uint> = new Vector.<uint>();
			
			for (var i:int = 0; i < numGlyphs; i++) 
			{
				bytes.position = tableOffset + offsets[i];
				var size:int = offsets[i + 1] - offsets[i];
				
				glyphs[i] = new GlyphData();
				if (size > 0) glyphs[i].readBytes(bytes);
			}
			
			Console.instance.registerCommand("print", printGlyph, []);
			Console.instance.registerCommand("draw", drawGlyph, []);
		}
		
		private function printGlyph(index:int):void
		{
			glyphs[index].print();
		}
		private var first:Boolean = true;
		
		private function drawGlyph(index:int):void
		{
			if (!first)
			{
				for (var i:int = 0; i < glyphs[index].numberOfContours; i++) 
				{
					container.children[container.numChildren - 1 - i].visible = false;
				}
			}
			else first = false;
			
			first = glyphs[index].draw(container);
		}
	}
}