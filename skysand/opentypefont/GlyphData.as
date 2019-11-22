package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	import skysand.display.SkyLine;
	import skysand.display.SkyRenderObjectContainer;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class GlyphData 
	{
		//If the number of contours is greater than or equal to zero, this is a simple glyph. If negative,
		//this is a composite glyph — the value -1 should be used for composite glyphs.
		public var numberOfContours:int;
		public var xMin:int;
		public var yMin:int;
		public var xMax:int;
		public var yMax:int;
		public var endPtsOfContours:Vector.<uint>;// uint16	[numberOfContours]	Array of point indices for the last point of each contour, in increasing numeric order.
		public var instructionLength:uint;
		public var instructions:Vector.<int>;// [instructionLength]	Array of instruction byte code for the glyph.
		public var flags:Vector.<uint>;
		public var xCoordinates:Vector.<uint>;//	Contour point x-coordinates. See below for details regarding the number of coordinate array elements. Coordinate for the first point is relative to (0,0); others are relative to previous point.
		public var yCoordinates:Vector.<uint>;
		
		public function GlyphData() 
		{
			xMax = 0;
			xMin = 0;
			yMax = 0;
			yMin = 0;
			numberOfContours = 0;
		}
		
		public function readBytes(bytes:ByteArray):void
		{
			numberOfContours = bytes.readShort();
			if (numberOfContours < 0) return;
			xMin = bytes.readShort();
			yMin = bytes.readShort();
			xMax = bytes.readShort();
			yMax = bytes.readShort();
			
			endPtsOfContours = new Vector.<uint>(numberOfContours, true);
			//Console.log(numberOfContours);
			for (var i:int = 0; i < numberOfContours; i++) 
			{
				endPtsOfContours[i] = bytes.readUnsignedShort();
				//Console.log(endPtsOfContours[i]);
			}
			
			instructionLength = bytes.readUnsignedShort();
			//Console.log(instructionLength);
			instructions = new Vector.<int>()//instructionLength, true);
			//Console.log();
			var nPoints:int = endPtsOfContours[numberOfContours - 1] + 1;
			
			for (i = 0; i < instructionLength; i++) 
			{
				instructions[i] = bytes.readByte();
			}
			
			flags = new Vector.<uint>(nPoints, true);
			xCoordinates = new Vector.<uint>(nPoints, true);
			yCoordinates = new Vector.<uint>(nPoints, true);
			
			for (i = 0; i < nPoints; i++) 
			{
				flags[i] = bytes.readUnsignedByte();
				/*Console.log(flags[i] & 0x01);
				Console.log(flags[i] & 0x02);
				Console.log(flags[i] & 0x04);
				Console.log(flags[i] & 0x08);
				Console.log(flags[i] & 0x10);
				Console.log(flags[i] & 0x20);
				Console.log(flags[i] & 0x40);
				Console.log(flags[i].toString(2));
				Console.log("---------");*/
			}
			//OnCurve = 1,
            var XByte:uint = 1 << 1;
            var YByte:uint = 1 << 2;
            //Repeat = 1 << 3,
            var XSignOrSame:uint = 1 << 4;
            var YSignOrSame:uint = 1 << 5;
			//Console.log(0x01 0x02 0x04 0x08
			var n:int = 0;
			
			/*for (int i = 0; i < pointCount; i++)
            {
                int dx;
                if (HasFlag(flags[i], isByte))
                {
                    byte b = input.ReadByte();
                    dx = HasFlag(flags[i], signOrSame) ? b : -b;
                }
                else
                {
                    if (HasFlag(flags[i], signOrSame))
                    {
                        dx = 0;
                    }
                    else
                    {
                        dx = input.ReadInt16();
                    }
                }
                x += dx;
                xs[i] = (short)x; // TODO: overflow?
            }*/
			for (i = 0; i < nPoints; i++) 
			{
				var flag:uint = flags[i];
				var dx:int = 0;
				
				if (BytesUtils.hasFlag(flags[i], XByte))
				{
					var b:uint = bytes.readUnsignedByte();
					dx = BytesUtils.hasFlag(flags[i], XSignOrSame) ? b : -b;
				}
				else
				{
					if (BytesUtils.hasFlag(flags[i], XSignOrSame))
					{
						dx = 0;
					}
					else
					{
						dx = bytes.readUnsignedShort();
					}
				}
				n += dx;
				
				xCoordinates[i] = n % 65536;
			}
			n = 0;
			for (i = 0; i < nPoints; i++) 
			{
				var flag:uint = flags[i];
				var dx:int = 0;
				
				if (BytesUtils.hasFlag(flags[i], YByte))
				{
					var b:uint = bytes.readUnsignedByte();
					dx = BytesUtils.hasFlag(flags[i], YSignOrSame) ? b : -b;
				}
				else
				{
					if (BytesUtils.hasFlag(flags[i], YSignOrSame))
					{
						dx = 0;
					}
					else
					{
						dx = bytes.readUnsignedShort();
					}
				}
				n += dx;
				
				yCoordinates[i] = n % 65536;
			}
			
			/**/
			/*
			
			Console.log(xMin);
			Console.log(yMin);
			Console.log(xMax);
			Console.log(yMax);*/
		}
		
		public function print():void
		{
			if (xCoordinates == null)
			{
				Console.log("is null");
				return;
			}
			
			var nPoints:int = xCoordinates.length;
			var string:String = "\n";
			
			for (var i:int = 0; i < nPoints; i++) 
			{
				string += "x: " + xCoordinates[i] + ", y: " + yCoordinates[i] + "\n";
			}
			
			string += "-----------";
			Console.log(string);
		}
		
		public function draw(container:SkyRenderObjectContainer):Boolean
		{
			if (xCoordinates == null)
			{
				Console.log("is null");
				return true;
			}
			
			for (var i:int = 0; i < numberOfContours; i++) 
			{
				var nPoints:int = endPtsOfContours[i] + 1;
				var line:SkyLine = new SkyLine();
				line.create(nPoints);
				line.moveTo(xCoordinates[0], yCoordinates[0]);
				
				for (var j:int = 1; j < nPoints; j++) 
				{
					line.lineTo(xCoordinates[j], yCoordinates[j]);
				}
				
				line.y = 100;
				container.addChild(line);
			}
			
			return false;
		}
	}
}