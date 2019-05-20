package skysand.utils 
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyPNGDecoder extends Object
	{
		private var stream:FileStream;
		private var file:File;
		private var fileFilter:FileFilter;
		private var pixels:Vector.<uint>;
		private var width:int;
		private var height:int;
		private var bitDepth:int;
		private var colorType:int;
		private var compressionMethod:int;
		private var filterMethod:int;
		private var interlaceMethod:int;
		private var chunk:ByteArray;
		private var byteWidth:int;
		
		public function SkyPNGDecoder() 
		{
			fileFilter = new FileFilter("image", "*.png");
			pixels = new Vector.<uint>();
		}
		
		public function browseForOpen():void
		{
			file = new File();
			file.browseForOpen("", [fileFilter]);
			file.addEventListener(Event.SELECT, onSelect);
		}
		
		private function onSelect(event:Event):void
		{
			file.removeEventListener(Event.SELECT, onSelect);
			
			var data:ByteArray = new ByteArray();
			
			stream = new FileStream();
			stream.open(file, "read");
			stream.readBytes(data);
			stream.close();
			
			data.position = 16;
			width = data.readInt();
			height = data.readInt();
			bitDepth = data.readUnsignedByte();
			colorType = data.readUnsignedByte();
			compressionMethod = data.readUnsignedByte();
			filterMethod = data.readUnsignedByte();
			interlaceMethod = data.readUnsignedByte();
			
			var offset:int = search(data, "IDAT")[0] + 6;
			var length:int = search(data, "IEND")[0] - offset - 1;
			//trace(search(data, "IDAT").length);
			chunk = new ByteArray();
			chunk.writeBytes(data, offset, length);
			chunk.position = 0;
			chunk.inflate();
			
			length = chunk.length;
			byteWidth = int(length / (height * (width + 1)) + 0.1);
			
			trace(byteWidth, length);
			var c:int = 0;
			var prev:int = 0;
			var curr:int = 0;
			
			var filter:Vector.<uint> = new Vector.<uint>();
			var scanlines:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>();
			var scanline:Vector.<uint> = new Vector.<uint>();
			
			filter.push(1);
			
			for (var i:int = 848815; i < 866867; i++) 
			{
				scanline.push(chunk[i]);
				
				//trace(chunk[i]);
				/*curr = i;
				
				if (chunk[i] == 1 || chunk[i] == 2 || chunk[i] == 3 || chunk[i] == 4)
				{
					trace("index: " + i, "diff: " + String(curr - prev));
					prev = curr;
					c++;
				}*/
			}
			scanlines.push(scanline);
			unfilter(filter, scanlines);
			adc();
			//286 последний
			//trace(c);
			//file = File.createTempFile();
			//file.save(chunk, "rawpixels.rgb");
			/*for (var i:int = 0; i < length; i++) 
			{
				trace(chunk[i]);
			}*/
			/*
			var filter:Vector.<uint> = new Vector.<uint>();
			var scanlines:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>();
			var scanline:Vector.<uint> = new Vector.<uint>();
			
			filter.push(chunk[0]);
			
			for (var i:int = 1; i < length; i++) 
			{
				if (i % (width * byteWidth + 1) == 0)
				{
					trace(i, filter.length, chunk[i]);
					scanlines.push(scanline);
					filter.push(chunk[i]);
					i++;
					scanline = new Vector.<uint>();
				}
				
				scanline.push(chunk[i]);
			}
			scanlines.push(scanline);
			//trace(filter.toString());
			unfilter(filter, scanlines);
			
			adc();*/
		}
		
		
		private function unfilter(filter:Vector.<uint>, scanlines:Vector.<Vector.<uint>>):void
		{
			var recon:Vector.<uint> = new Vector.<uint>();
			var length:int = filter.length;
			
			unfilterScanline(recon, scanlines[0], null, filter[0]);
			
			for (var j:int = 0; j < recon.length; j++) 
			{
				pixels.push(recon[j]);
			}
			
			for (var i:int = 1; i < length; i++) 
			{
				var precon:Vector.<uint> = recon;
				recon = new Vector.<uint>();
				
				unfilterScanline(recon, scanlines[i], precon, filter[i]);
				
				for (j = 0; j < recon.length; j++) 
				{
					pixels.push(recon[j]);
				}
			}
		}
		
		private function unfilterScanline(recon:Vector.<uint>, scanline:Vector.<uint>, precon:Vector.<uint>, filter:int):void
		{
			var length:int = scanline.length;
			
			switch(filter)
			{
				case 0:
					{
						for(var i:int = 0; i != length; ++i) recon[i] = scanline[i];
						
						break;
					}
					
				case 1:
					{
						for (i = 0; i < byteWidth; ++i) recon[i] = scanline[i];
						for (i = byteWidth; i < length; ++i) recon[i] = (scanline[i] + recon[i - byteWidth]) % 256;
						
						break;
					}
				case 2:
					{
						if(precon != null)
						{
							for(i = 0; i < length; ++i) recon[i] = (scanline[i] + precon[i])%256;
						}
						else
						{
							for(i = 0; i < length; ++i) recon[i] = scanline[i];
						}
						
						break;
					}
				case 4:
					{
						if (precon != null)
						{
							for (i = 0; i != byteWidth; ++i)
							{
								recon[i] = (scanline[i] + precon[i]) % 256;
							}
							
							for (i = byteWidth; i < length; ++i)
							{
								recon[i] = (scanline[i] + paethPredictor(recon[i - byteWidth], precon[i], precon[i - byteWidth])) % 256;
							}
						}
						else
						{
							for(i = 0; i != byteWidth; ++i)
							{
								recon[i] = scanline[i];
							}
							
							for(i = byteWidth; i < length; ++i)
							{
								recon[i] = (scanline[i] + recon[i - byteWidth]) % 256;
							}
						}
						
						break;
					}
					/*
				case 3:
				  if(precon)
				  {
					for(i = 0; i != bytewidth; ++i) recon[i] = scanline[i] + (precon[i] >> 1);
					for(i = bytewidth; i < length; ++i) recon[i] = scanline[i] + ((recon[i - bytewidth] + precon[i]) >> 1);
				  }
				  else
				  {
					for(i = 0; i != bytewidth; ++i) recon[i] = scanline[i];
					for(i = bytewidth; i < length; ++i) recon[i] = scanline[i] + (recon[i - bytewidth] >> 1);
				  }
				  break;
				
				  break;
			  }*/
			}
		}
		
		
		
		private function adc():void
		{
			var bitmap:Bitmap = new Bitmap(new BitmapData(width + 1, height + 1));
			var dx:int = 0;
			var dy:int = 0;
			var length:int = pixels.length / byteWidth;
			
			for (var i:int = 0; i < length; i++)
			{
				bitmap.bitmapData.setPixel(dx, dy, bytesToColor(pixels[i * byteWidth], pixels[i * byteWidth + 1], pixels[i * byteWidth + 2], pixels[i * byteWidth + 2]));
				dx++
				
				if (dx >= width)
				{
					dx = 0;
					dy++;
				}
			}
			
			//bitmap.scaleX = bitmap.scaleY = 8;
			container.addChild(bitmap);
		}
		
		private var container:DisplayObjectContainer;
		
		private function bytesToColor(r:uint, g:uint, b:uint, a:uint):uint
		{
			return/* a << 24 | */r << 16 | g << 8 | b;
		}
		
		public function show(container:DisplayObjectContainer):void
		{
			this.container = container;
		}
		
		private function search(bytes:ByteArray, word:String, position:int = 0):Vector.<int>
		{
			var indeces:Vector.<int> = new Vector.<int>();
			var length:int = bytes.length;
			var wordLength:int = word.length;
			
			bytes.position = position;
			
			for (var i:int = 0; i < length; i++) 
			{
				if (bytes[i] == word.charCodeAt(0))
				{
					for (var j:int = 1; j < wordLength; j++) 
					{
						if (bytes[i + j] != word.charCodeAt(j)) break;
						if (j == wordLength - 1) indeces.push(i);
					}
				}
			}
			
			return indeces;
		}
		
		
		private function paethPredictor(a:uint, b:uint, c:uint):uint
		{
			var pa:int = Math.abs(b - c);
			var pb:int = Math.abs(a - c);
			var pc:int = Math.abs(a + b - c - c);
			
			if (pc < pa && pc < pb) return c;
			else if (pb < pa) return b;
			else return a;
		}
	}
}