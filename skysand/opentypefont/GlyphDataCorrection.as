package skysand.opentypefont 
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	import skysand.debug.Console;
	import skysand.debug.SkyDebugDraw;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.utils.SkyMath;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class GlyphDataCorrection
	{
		public static const CLOCKWISE:uint = 0;
		public static const COUNTER_CLOCKWISE:uint = 1;
		
		private var table:Vector.<GlyphData>;
		private var debugDraw:SkyDebugDraw;
		private var numGlyph:int;
		
		public function GlyphDataCorrection() 
		{
			
		}
		
		public function init(table:Vector.<GlyphData>):void
		{
			this.table = table;
			numGlyph = table.length;
			var start:int = getTimer()
			correct();
			Console.log("correction: " + (getTimer() - start));
		}
		
		public function correct():int
		{
			
			for (var i:int = 0; i < numGlyph; i++) 
			{
				var glyph:GlyphData = table[i];
				if (glyph.xCoordinates == null) continue;
				
				removeDoublePoints(glyph);
				addCurves(glyph);
				
				//checkDirection(glyph, i);
			}
			var start:uint = getTimer();
			
			for (i = 0; i < numGlyph; i++) 
			{
				glyph = table[i];
				if (glyph.xCoordinates == null) continue;
				if (glyph.numberOfContours <= 1) continue;
				//trace(i);
				countContourIntersections(glyph, i);
				//pointCount += glyph.endPtsOfContours[glyph.numberOfContours - 1];
				
			}
			
			Console.log("countIntersectinsTime: " + (getTimer() - start));
			Console.log("pointCount: " + pointCount);
			//addCurves(table[12]);
			return 0;
		}
		
		public function tessellateGlyph(data:GlyphData, level:int = 2):void
		{
			var curveSmoothing:Number = level / 100;
		}
		
		private var pointCount:int = 0;
		private var c:Vector.<int> = new Vector.<int>(64, true);
		
		private function countContourIntersections(data:GlyphData, index:int):void
		{
			var test:int = 0;
			var length:int = data.numberOfContours
			var start:int = 0;
			//trace(length);
			//c.length = length;
			/*var s:Vector.<int> = new Vector.<int>(length * length, true);
			
			for (var i:int = 0; i < length*length; i++)
			{
				s[i] = -1;
			}
			var count:int = 0;
			*/
			var pairs:Vector.<Vector.<uint>> = data.pairs;
			
			for (var i:int = 0; i < length; i++) 
			{
				c[i] = 0;
				
				for (var j:int = 0; j < length; j++)
				{
					var x:Number = data.xCoordinates[test];
					var y:Number = data.yCoordinates[test];
					
					if (i != j && SkyMath.containsPoint(x, y, data.xCoordinates, data.yCoordinates, start, data.endPtsOfContours[j] + 1))
					{
						if (pairs[j] == null) pairs[j] = new Vector.<uint>();
						pairs[j].push(i);
						//s[j * length + count] = i;
						//count++;
						c[i]++;
					}
					
					start = data.endPtsOfContours[j] + 1;
				}
				
				data.directions[i] = c[i] & 1;
				
				//s.push(-1);
				start = 0;
				//count++;
				test = data.endPtsOfContours[i] + 1;
			}
			var str:String = "";
			for (i = 0; i < length; i++) 
			{
				if (pairs[i] == null || c[i] & 1) continue;
				var inners:Vector.<uint> = pairs[i];
				var count:int = inners.length;
				
				for (var k:int = 0; k < count; k++)
				{
					if (c[i] != c[inners[k]] - 1)
					{
						inners.removeAt(k);
						count--;
						k--;
					}
					//str += pairs[i][k] + ", ";
				}
			}
			/*
			for (i = 0; i < length; i++) 
			{
				if (pairs[i] == null || data.directions == 1) continue;
				
				str += "\n" + i + ": ";
				var inners:Vector.<uint> = pairs[i];
				var count:int = inners.length;
				
				for (var k:int = 0; k < count; k++) 
				{
					str += inners[k] + ", ";
				}
			}
			
			Console.log(index + ": " + str);
			
			
			/*
			var indices:Vector.<uint> = new Vector.<uint>();
			test = 0;
			for (i = 0; i < length; i++) 
			{
				if (c[i] != test) continue;
				indices.push(i);
				
				for (j = 0; j < length; j++) 
				{
					if (j == i) continue;
					
				}
			}
			
			Console.log("indices: " + indices.toString());
			
			/*
			var str:String = "";
			count = 0;
			for (i = 0; i < length; i++) 
			{
				str += i + "<-";
				
				for (j = 0; j < length; j++)
				{
					if (s[j + i * length] != -1)
					{
						str += s[j + i * length] + ", ";
					}
				}
				str += "\n";
			}
			/*
			var str:String = "";
			start = 0;
			
			for (i = 0; i < length; i++) 
			{
				for (j = start; j < s.length; j++) 
				{
					if (s[j] == -1)
					{
						start = j;
						break;
					}
					str += i + "<-" + s[j] + ", ";
				}
				str += "\n";
			}
			*/
			//Console.log("index: " + index + ": " + c.toString());
			//Console.log("index: " + index + ": " + str);//s.toString());
		}
		
		private function addCurves(data:GlyphData):void
		{
			var curveSmoothing:Number = 0.01;
			var segCount:int = 2;
			var length:int = data.numberOfContours;
			var start:int = 0;
			var end:int = 0;
			var xpoints:Vector.<Number> = new Vector.<Number>();
			var ypoints:Vector.<Number> = new Vector.<Number>();
			var endPts:Vector.<uint> = new Vector.<uint>();
			var ex:Number = 0;
			var ey:Number = 0;
			var t:Number = 0;
			
			for (var i:int = 0; i < length; i++)
			{
				start = end;
				end = data.endPtsOfContours[i] + 1;
				if (start - end == 0) continue;
				if (!data.onCurve(end - 1))
				{
					ex = (data.xCoordinates[start] + data.xCoordinates[end - 1]) / 2;
					ey = (data.yCoordinates[start] + data.yCoordinates[end - 1]) / 2;
				}
				else
				{
					ex = data.xCoordinates[end - 1];
					ey = data.yCoordinates[end - 1];
				}
				
				for (var j:int = start; j < end; j++) 
				{
					var a:int = j + 1 == end ? start : j + 1;
					var e:int = a + 1 == end ? start : a + 1;
					var isS:Boolean = data.onCurve(j);
					var isA:Boolean = data.onCurve(a);
					var isE:Boolean = data.onCurve(e);
					
					if (isS)
					{
						ex = data.xCoordinates[j];
						ey = data.yCoordinates[j];
						xpoints.push(ex);
						ypoints.push(ey);
						pointCount++;
						
						if (isA) continue;
						
						if (isE)
						{
							var dx:Number = data.xCoordinates[j] - data.xCoordinates[a];
							var dy:Number = data.yCoordinates[j] - data.yCoordinates[a];
							var len:Number = Math.sqrt(dx * dx + dy * dy);
							dx = data.xCoordinates[a] - data.xCoordinates[e];
							dy = data.yCoordinates[a] - data.yCoordinates[e];
							len += Math.sqrt(dx * dx + dy * dy);
							var count:int = len * curveSmoothing;
							
							for (var k:int = 1; k < count; k++)
							{
								pointCount++;
								t = k / count;
								var x:Number = (1 - t) * (1 - t) * data.xCoordinates[j] + 2 * t * (1 - t) * data.xCoordinates[a] + t * t * data.xCoordinates[e];
								var y:Number = (1 - t) * (1 - t) * data.yCoordinates[j] + 2 * t * (1 - t) * data.yCoordinates[a] + t * t * data.yCoordinates[e];
								xpoints.push(x);
								ypoints.push(y);
							}
						}
					}
					
					if (!isS && !isA)
					{
						var mx:Number = (data.xCoordinates[j] + data.xCoordinates[a]) / 2;
						var my:Number = (data.yCoordinates[j] + data.yCoordinates[a]) / 2;
						
						dx = ex - data.xCoordinates[j];
						dy = ey - data.yCoordinates[j];
						len = Math.sqrt(dx * dx + dy * dy);
						dx = data.xCoordinates[j] - mx;
						dy = data.yCoordinates[j] - my;
						len += Math.sqrt(dx * dx + dy * dy);
						count = len * curveSmoothing;
						
						for (k = 1; k < count; k++)
						{
							t = k / count;
							x = (1 - t) * (1 - t) * ex + 2 * t * (1 - t) * data.xCoordinates[j] + t * t * mx;
							y = (1 - t) * (1 - t) * ey + 2 * t * (1 - t) * data.yCoordinates[j] + t * t * my;
							xpoints.push(x);
							ypoints.push(y);
							pointCount++;
						}
						
						xpoints.push(mx);
						ypoints.push(my);
						pointCount++;
						ex = mx;
						ey = my;
						
						if (isE)
						{
							dx = mx - data.xCoordinates[a];
							dy = my - data.yCoordinates[a];
							len = Math.sqrt(dx * dx + dy * dy);
							dx = data.xCoordinates[a] - data.xCoordinates[e];
							dy = data.yCoordinates[a] - data.yCoordinates[e];
							len += Math.sqrt(dx * dx + dy * dy);
							count = len * curveSmoothing;
							
							for (k = 1; k < count; k++)
							{
								t = k / count;
								x = (1 - t) * (1 - t) * mx + 2 * t * (1 - t) * data.xCoordinates[a] + t * t * data.xCoordinates[e];
								y = (1 - t) * (1 - t) * my + 2 * t * (1 - t) * data.yCoordinates[a] + t * t * data.yCoordinates[e];
								xpoints.push(x);
								ypoints.push(y);
								pointCount++;
							}
						}
					}
				}
				
				endPts.push(xpoints.length - 1);
			}
			
			data.xCoordinates = xpoints;
			data.yCoordinates = ypoints;
			data.endPtsOfContours = endPts;
		}
		
		private function removeDoublePoints(data:GlyphData):void
		{
			var length:int = data.numberOfContours;
			var start:int = 0;
			var end:int = -1;
			
			for (var i:int = 0; i < length; i++) 
			{
				start = end + 1;
				end = data.endPtsOfContours[i];
				
				if (data.xCoordinates[start] != data.xCoordinates[end]) continue;
				if (data.yCoordinates[start] != data.yCoordinates[end]) continue;
				
				data.flags.fixed = false;
				data.xCoordinates.removeAt(end);
				data.yCoordinates.removeAt(end);
				data.flags.removeAt(end);
				
				for (var j:int = i; j < length; j++)
				{
					data.endPtsOfContours[j]--;
				}
				
				end--;
			}
		}
		
		private function checkDirection(data:GlyphData, index:int):void
		{
			if (data.numberOfContours == 1)
				Console.log("index: " + index + " is " + (data.directions[0] == CLOCKWISE ? "clockwise" : "counter clockwise"));
		}
		
		public function setDebugDraw(container:SkyRenderObjectContainer):void
		{
			debugDraw = new SkyDebugDraw();
			debugDraw.scaleY = -1;
			debugDraw.y += 500;
			debugDraw.x = 200;
			container.addChild(debugDraw);
			
			/*var data:GlyphData = table[352];
			var xpoints:Vector.<Number> = Vector.<Number>(data.xCoordinates);
			var ypoints:Vector.<Number> = Vector.<Number>(data.yCoordinates);
			var start:int = 0;
			var end:int = 0;
			//var xsrt:String = "contour0x.push(";
			//var ysrt:String = "contour0y.push(";
			
			for (var i:int = 0; i < data.numberOfContours; i++) 
			{
				start = end;
				end = data.endPtsOfContours[i] + 1;
				debugDraw.drawContourB(xpoints.slice(start, end), ypoints.slice(start, end), 0xFFF, 2, 0.5);
				for (var j:int = start; j < end; j++) 
				{
					debugDraw.drawPoint(data.xCoordinates[j], data.yCoordinates[j], 0xFFF, 4, 0.5);
					//xsrt += data.xCoordinates[j] + ", ";
					//ysrt += data.yCoordinates[j] + ", ";
				}
			}*/
			//trace(xsrt);
			//trace(ysrt);
		}
	}
}