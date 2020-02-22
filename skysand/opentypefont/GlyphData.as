package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	import skysand.display.SkyLine;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyShape;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class GlyphData 
	{
		public static const ON_CURVE:uint = 1;
		public static const X_BYTE:uint = 1 << 1;
		public static const Y_BYTE:uint = 1 << 2;
		public static const REPEAT:uint = 1 << 3;
		public static const X_SIGN_OR_SAME:uint = 1 << 4;
		public static const Y_SIGN_OR_SAME:uint = 1 << 5;
		
		public var numberOfContours:int;
		public var xMin:int;
		public var yMin:int;
		public var xMax:int;
		public var yMax:int;
		public var endPtsOfContours:Vector.<uint>;
		public var instructionLength:uint;
		public var instructions:Vector.<int>;
		public var flags:Vector.<uint>;
		public var xCoordinates:Vector.<Number>;
		public var yCoordinates:Vector.<Number>;
		public var directions:Vector.<int>;
		public var pairs:Vector.<Vector.<uint>>;
		
		public function GlyphData() 
		{
			xMax = 0;
			xMin = 0;
			yMax = 0;
			yMin = 0;
			numberOfContours = 0;
			ccwcount = 0;
			cwcount = 0;
		}
		
		public function readBytes(bytes:ByteArray):void
		{
			numberOfContours = bytes.readShort();
			if (numberOfContours < 0) return;
			
			xMin = bytes.readShort();
			yMin = bytes.readShort();
			xMax = bytes.readShort();
			yMax = bytes.readShort();
			
			pairs = new Vector.<Vector.<uint>>(numberOfContours, true);
			endPtsOfContours = new Vector.<uint>(numberOfContours, true);
			directions = new Vector.<int>(numberOfContours, true);
			
			for (var i:int = 0; i < numberOfContours; i++) 
			{
				endPtsOfContours[i] = bytes.readUnsignedShort();
			}
			
			instructionLength = bytes.readUnsignedShort();
			instructions = new Vector.<int>(instructionLength, true);
			
			for (i = 0; i < instructionLength; i++) 
			{
				instructions[i] = bytes.readByte();
			}
			
			var nPoints:int = endPtsOfContours[numberOfContours - 1] + 1;
			var repeatCount:int = 0;
			var flag:uint = 0;
			var n:int = 0;
			
			flags = new Vector.<uint>(nPoints, true);
			xCoordinates = new Vector.<Number>(nPoints);
			yCoordinates = new Vector.<Number>(nPoints);
			
			i = 0;
			
			while (i < nPoints)
			{
				if (repeatCount > 0)
				{
					repeatCount--;
				}
				else
				{
					flag = bytes.readUnsignedByte();
					if (BytesUtils.hasFlag(flag, REPEAT))
					{
						repeatCount = bytes.readUnsignedByte();
					}
				}
				
				flags[i++] = flag;
			}
			
			for (i = 0; i < nPoints; i++)
			{
				flag = flags[i];
				var dx:int = 0;
				
				if (BytesUtils.hasFlag(flags[i], X_BYTE))
				{
					var b:uint = bytes.readUnsignedByte();
					dx = BytesUtils.hasFlag(flags[i], X_SIGN_OR_SAME) ? b : -b;
				}
				else
				{
					if (BytesUtils.hasFlag(flags[i], X_SIGN_OR_SAME))
					{
						dx = 0;
					}
					else
					{
						dx = bytes.readShort();
					}
				}
				
				n += dx;
				xCoordinates[i] = n % 65536;
			}
			
			n = 0;
			
			for (i = 0; i < nPoints; i++) 
			{
				flag = flags[i];
				dx = 0;
				
				if (BytesUtils.hasFlag(flags[i], Y_BYTE))
				{
					b = bytes.readUnsignedByte();
					dx = BytesUtils.hasFlag(flags[i], Y_SIGN_OR_SAME) ? b : -b;
				}
				else
				{
					if (BytesUtils.hasFlag(flags[i], Y_SIGN_OR_SAME))
					{
						dx = 0;
					}
					else
					{
						dx = bytes.readShort();
					}
				}
				
				n += dx;
				yCoordinates[i] = n % 65536;
			}
		}
		
		public function onCurve(index:int):Boolean
		{
			return BytesUtils.hasFlag(flags[index], GlyphData.ON_CURVE);
		}
		
		public var ccwcount:int;
		public var cwcount:int;
		
		public function print():void
		{
			if (xCoordinates == null)
			{
				Console.log("is null");
				return;
			}
			
			var nPoints:int = xCoordinates.length;
			var string:String = "\n";
			var testx:String = "contour0x.push(";
			var testy:String = "contour0y.push(";
			for (var i:int = 0; i < nPoints; i++) 
			{
				string += "x: " + xCoordinates[i] + ", y: " + yCoordinates[i] + "\n";
				testx += xCoordinates[i] + ", ";
				testy += yCoordinates[i] + ", ";
			}
			trace(testx + "\n" + testy);
			trace(directions.toString());
			string += "-----------";
			Console.log(string);
		}
		
		public function draw(container:SkyRenderObjectContainer):SkyShape
		{
			if (xCoordinates == null)
			{
				Console.log("is null");
				return null;
			}
			var xpoints:Vector.<Number> = new Vector.<Number>();
			var ypoints:Vector.<Number> = new Vector.<Number>();
			var prev:int = 0;
			/*for (var i:int = 0; i < numberOfContours; i++) 
			{
				var nPoints:int = endPtsOfContours[i] + 1;
				//trace(nPoints, prev);
				for (var j:int = prev; j < nPoints; j++) 
				{
					
					xpoints.push(xCoordinates[j]);
					ypoints.push(yCoordinates[j]);
				}
				//trace(xpoints.toString());
				//trace(ypoints.toString());
				t.addContour(xpoints, ypoints, prev != 0);
				xpoints.length = 0;
				ypoints.length = 0;
				prev = nPoints;
			}
			
			t.makeMonotone();
			var shape:SkyShape = new SkyShape();
				shape.drawComplexShape(t.toV(), t.indices);
				shape.x = 400;
				shape.y = 300;
				container.addChild(shape);*/
			return null;
		}
	}
}