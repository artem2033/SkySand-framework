package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyShape;
	import skysand.utils.SkyUtils;
	
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
			SkyUtils.setTime();
			
			for (var i:int = 0; i < numGlyphs; i++) 
			{
				bytes.position = tableOffset + offsets[i];
				var size:int = offsets[i + 1] - offsets[i];
				
				glyphs[i] = new GlyphData();
				if (size > 0)
				{
					//Console.log(i);
					glyphs[i].readBytes(bytes);
					//Console.log("---");
				}
			}
			/*Console.log("glyph num: " + numGlyphs);
			Console.log("total: " + (GlyphData.contourCount1 + GlyphData.contourCount2 + GlyphData.contourCountMore));
			Console.log("1 contour count: " + GlyphData.contourCount1);
			Console.log("2 contour count: " + GlyphData.contourCount2);
			Console.log("more contour count: " + GlyphData.contourCountMore);
			
			GlyphData.contourCount1 = 0;
			GlyphData.contourCount2 = 0;
			GlyphData.contourCountMore = 0;
			*/
			Console.log("Glyphs read time: " + SkyUtils.getTime())
			Console.instance.registerCommand("print", printGlyph, []);
			Console.instance.registerCommand("d", drawGlyph, []);
		}
		
		public function getGlyphs():Vector.<GlyphData>
		{
			return glyphs;
		}
		
		private function printGlyph(index:int):void
		{
			glyphs[index].print();
		}
		private var first:Boolean = true;
		private var shape:SkyShape;
		private function drawGlyph(index:int):void
		{
			if (shape) shape.visible = false;
			shape = glyphs[index].draw(container);
		}
	}
}