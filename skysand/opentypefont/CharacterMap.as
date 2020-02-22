package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class CharacterMap 
	{
		public var platformID:uint;
		public var encodingID:uint;
		public var formatID:uint;
		public var offset:uint;
		
		public var charCodes:Vector.<uint>;
		public var glyphIndices:Vector.<uint>;
		
		public function CharacterMap() 
		{
			
		}
		
		public function readBytes(bytes:ByteArray):void
		{
			bytes.position = offset;
			formatID = bytes.readUnsignedShort();
			
			switch (formatID)
			{
				case 0:
					{
						readFormat0(bytes);
						break;
					}
				
				case 4:
					{
						readFormat4(bytes);
						break;
					}
					
				case 6:
					{
						readFormat6(bytes);
						break;
					}
					
				case 10:
					{
						readFormat10(bytes);
						break;
					}
					
				case 12:
					{
						readFormat12(bytes);
						break;
					}
					
				case 13:
					{
						readFormat13(bytes);
						break;
					}
					
				default:
					{
						throw new Error("character map format " + formatID + " data reader is not added!");
						break;
					}
			}
		}
		
		private function readFormat0(bytes:ByteArray):void
		{
			var length:uint = bytes.readUnsignedShort();
			var language:uint = bytes.readUnsignedShort();
			
			charCodes = new Vector.<uint>(256, true);
			glyphIndices = new Vector.<uint>(256, true);
			
			for (var i:int = 0; i < 256; i++) 
			{
				charCodes[i] = i;
				glyphIndices[i] = bytes.readUnsignedByte();
			}
		}
		
		private function readFormat2(bytes:ByteArray):void
		{
			var length:uint = bytes.readUnsignedShort();
			var language:uint = bytes.readUnsignedShort();
			
			var subHeaderKeys:Vector.<uint> = new Vector.<uint>(256, true);
			charCodes = new Vector.<uint>(256, true);
			glyphIndices = new Vector.<uint>(256, true);
			
			var count:uint = 0;
								//65536
			for (var i:int = 0; i < 256; i++) 
			{
				subHeaderKeys[i] = bytes.readUnsignedShort();
				count = subHeaderKeys[i] > count ? subHeaderKeys[i] : count;
			}
			//length/8 + 1;
			count = (count >> 3) + 1;
			
			var firstCode:Vector.<uint> = new Vector.<uint>(count, true);
            var entryCount:Vector.<uint> = new Vector.<uint>(count, true);
            var idDelta:Vector.<int> = new Vector.<uint>(count, true);
            var idRangeOffset:Vector.<uint> = new Vector.<uint>(count, true);
			
			for (i = 0; i < count; i++) 
			{
				firstCode[i] = bytes.readUnsignedShort();
				entryCount[i] = bytes.readUnsignedShort();
				idDelta[i] = bytes.readShort();
				idRangeOffset[i] = bytes.readUnsignedShort();
			}
									//wtf
			var size:uint = (length - 518 - count * 8) / 2;
			var glyphIndexArray:Vector.<uint> = new Vector.<uint>(size, true);
			
			for (i = 0; i < size; i++) 
			{
				glyphIndexArray[i] = bytes.readUnsignedShort();
			}
			/*
			var character:uint = 0;
			var highByte:uint = (character >> 8) & 0xFF;
			var lowByte:uint = character & 0xFF;
			var offset:uint = 0//subHeaderOffset(highByte);
			
			if (offset == 0)
			{
				lowByte = highByte;
				highByte = 0;
			}
			
			var firstCode:uint = 0;//firstCode(highByte);
			var entryCode:uint = 0;//entryCount(highByte);
			var idRangeOffset:uint = 0;//idRangeOffset(highByte);
			var pLocation:uint = offset + /*Offset.format2SubHeader_idRangeOffset.offset + idRangeOffset + (lowByte - firstCode) * 0//FontData.DataSize.USHORT.size();;
			//on plocation
			/*var p:uint = bytes.readUnsignedShort();
			if (offset == 0) return p;
			
			var idDelta:int = 0//idDelat(highByte);
			return (p + idDelta) % 65536;*/
		}
		
		private function readFormat4(bytes:ByteArray):void
		{
			var endCode:Vector.<uint> = new Vector.<uint>();
			var startCode:Vector.<uint> = new Vector.<uint>();
			var idDelta:Vector.<int> = new Vector.<int>();
			var idRangeOffset:Vector.<uint> = new Vector.<uint>();
			var glyphIdArray:Vector.<uint> = new Vector.<uint>();
			
			var length:uint = bytes.readUnsignedShort();
			var position:uint = bytes.position - 4;
			var language:uint = bytes.readUnsignedShort();
			var segCount:uint = bytes.readUnsignedShort() / 2;
			var searchRange:uint = bytes.readUnsignedShort();
			var entrySelector:uint = bytes.readUnsignedShort();
			var rangeShift:uint = bytes.readUnsignedShort();
			
			for (var i:int = 0; i < segCount; i++) 
			{
				endCode[i] = bytes.readUnsignedShort();
			}
			
			var reservedPad:uint = bytes.readUnsignedShort();
			
			for (i = 0; i < segCount; i++) 
			{
				startCode[i] = bytes.readUnsignedShort();
			}
			
			for (i = 0; i < segCount; i++) 
			{
				idDelta[i] = bytes.readShort();
			}
			
			for (i = 0; i < segCount; i++) 
			{
				idRangeOffset[i] = bytes.readUnsignedShort();
			}
			
			var count:int = int((length + position - bytes.position) / 2);
			
			for (i = 0; i < count; i++) 
			{
				glyphIdArray[i] = bytes.readUnsignedShort();
			}
			
			charCodes = new Vector.<uint>();
			glyphIndices = new Vector.<uint>();
			count = 0;
			
			for (i = 0; i < segCount; i++) 
			{
				var idOffset:uint = idRangeOffset[i];
				var start:uint = startCode[i];
				var delta:int = idDelta[i];
				var end:uint = endCode[i];
				
				for (var j:uint = start; j <= end; j++) 
				{
					charCodes[count] = j;
					
					if (idOffset == 0)
					{
						glyphIndices[count] = (j + delta) % 65536;
					}
					else
					{
						var offset:uint = idOffset / 2 + (j - start);
						
						glyphIndices[count] = glyphIdArray[offset - segCount + i];
					}
					
					count++;
				}
			}
		}
		
		private function readFormat6(bytes:ByteArray):void
		{
			var length:uint = bytes.readUnsignedShort();
			var language:uint = bytes.readUnsignedShort();
			var firstCode:uint = bytes.readUnsignedShort();
			var entryCount:uint = bytes.readUnsignedShort();
			
			var glyphIdArray:Vector.<uint> = new Vector.<uint>();
			glyphIndices = new Vector.<uint>();
			charCodes = new Vector.<uint>();
			
			for (var i:int = 0; i < entryCount; i++) 
			{
				var index:uint = bytes.readUnsignedShort();
				charCodes[i] = index + firstCode;
				glyphIndices[i] = index;
			}
		}
		
		private function readFormat8(bytes:ByteArray):void
		{
			var reserved:uint = bytes.readUnsignedShort();
			var length:uint = bytes.readUnsignedInt();
			var language:uint = bytes.readUnsignedInt();
			
			//Tightly packed array of bits (8K bytes total) indicating whether the particular 
			//16-bit (index) value is the start of a 32-bit character code
			//uint8	is32[8192]
			var endCharCode:Vector.<uint> = new Vector.<uint>();
			var startCharCode:Vector.<uint> = new Vector.<uint>();
			var startGlyphID:Vector.<uint> = new Vector.<uint>();
			var is32:Vector.<uint> = new Vector.<uint>();
								//or 65535
			for (var i:int = 0; i < 8192; i++) 
			{
				is32[i] = bytes.readUnsignedByte();
			}
			
			var numGroups:uint = bytes.readUnsignedInt();
			
			for (i = 0; i < numGroups; i++) 
			{
				startCharCode[i] = bytes.readUnsignedInt();
				endCharCode[i] = bytes.readUnsignedInt();
				startGlyphID[i] = bytes.readUnsignedInt();
			}
			
			charCodes = new Vector.<uint>();
			var count:int = 0;
			
			for (i = 0; i < numGroups; i++) 
			{
				var start:uint = startCharCode[i];
				var end:uint = endCharCode[i];
				var startGlyph:uint = startGlyphID[i];
				
				var isFirstHalf:int = is32[start / 8] & (1 << (7 - (start % 8))); 
				//if (isFirstHalf == 1)
				
				for (var j:int = start; j <= end; j++) 
				{
					charCodes[count] = j;
				}
			}
			
			//SequentialMapGroup	groups[numGroups]	Array of SequentialMapGroup records
			Console.log("check character map format 6 data!");
		}
		
		private function readFormat10(bytes:ByteArray):void
		{
			var reserved:uint = bytes.readUnsignedShort();
			var length:uint = bytes.readUnsignedInt();
			var language:uint = bytes.readUnsignedInt();
			var startCharCode:uint = bytes.readUnsignedInt();
			var numChars:uint = bytes.readUnsignedInt();
			
			charCodes = new Vector.<uint>();
			glyphIndices = new Vector.<uint>();
			
			for (var i:int = 0; i < numChars; i++) 
			{
				charCodes[i] = startCharCode + i;
				glyphIndices[i] = bytes.readUnsignedShort();
			}
			
			Console.log("cmap format 10 need to test");
		}
		
		private function readFormat12(bytes:ByteArray):void
		{
			var reserved:uint = bytes.readUnsignedShort();
			var length:uint = bytes.readUnsignedInt();
			var language:uint = bytes.readUnsignedInt();
			var numGroups:uint = bytes.readUnsignedInt();
			
			var startCharCode:Vector.<uint> = new Vector.<uint>(numGroups, true);
			var endCharCode:Vector.<uint> = new Vector.<uint>(numGroups, true);
			var startGlyphID:Vector.<uint> = new Vector.<uint>(numGroups, true);
			charCodes = new Vector.<uint>();
			glyphIndices = new Vector.<uint>();
			
			for (var i:int = 0; i < numGroups; i++) 
			{
				startCharCode[i] = bytes.readUnsignedInt();
				endCharCode[i] = bytes.readUnsignedInt();
				startGlyphID[i] = bytes.readUnsignedInt();
			}
			
			var count:int = 0;
			
			for (i = 0; i < numGroups; i++) 
			{
				var start:uint = startCharCode[i];
				var end:uint = endCharCode[i];
				var glyphID:uint = startGlyphID[i];
				
				for (var j:int = start; j <= end; j++) 
				{
					charCodes[count] = j;
					glyphIndices[count] = glyphID + j - start;
					count++;
				}
			}
			
			Console.log("cmap format 12 need to test");
		}
		
		private function readFormat13(bytes:ByteArray):void
		{
			var reserved:uint = bytes.readUnsignedShort();
			var length:uint = bytes.readUnsignedInt();
			var language:uint = bytes.readUnsignedInt();
			var numGroups:uint = bytes.readUnsignedInt();
			
			var startCharCode:Vector.<uint> = new Vector.<uint>(numGroups, true);
			var endCharCode:Vector.<uint> = new Vector.<uint>(numGroups, true);
			var glyphID:Vector.<uint> = new Vector.<uint>(numGroups, true);
			charCodes = new Vector.<uint>();
			glyphIndices = new Vector.<uint>();
			
			for (var i:int = 0; i < numGroups; i++) 
			{
				startCharCode[i] = bytes.readUnsignedInt();
				endCharCode[i] = bytes.readUnsignedInt();
				glyphID[i] = bytes.readUnsignedInt();
			}
			
			var count:int = 0;
			
			for (i = 0; i < numGroups; i++) 
			{
				var start:uint = startCharCode[i];
				var end:uint = endCharCode[i];
				var gID:uint = glyphID[i];
				
				for (var j:int = start; j <= end; j++) 
				{
					charCodes[count] = j;
					glyphIndices[count] = gID;
					count++;
				}
			}
			
			Console.log("cmap format 13 need to test");
		}
		
		public function readFormat14(bytes:ByteArray):void
		{
			var position:uint = bytes.position - 2;
			var length:uint = bytes.readUnsignedInt();
			var numVarSelectorRecords:uint = bytes.readUnsignedInt();
			
			var varSelector:Vector.<uint> = new Vector.<uint>();
			var defaultUVSOffset:Vector.<uint> = new Vector.<uint>();
			var nonDefaultUVSOffset:Vector.<uint> = new Vector.<uint>();
			
			for (var i:int = 0; i < numVarSelectorRecords; i++) 
			{
				varSelector[i] = BytesUtils.readUint24(bytes);
				defaultUVSOffset[i] = bytes.readUnsignedInt();
				nonDefaultUVSOffset[i] = bytes.readUnsignedInt();
			}
			
			var count:int = 0;
			charCodes = new Vector.<uint>();
			glyphIndices = new Vector.<uint>();
			
			for (i = 0; i < numVarSelectorRecords; i++) 
			{
				/*if (defaultUVSOffset[i] != 0)
				{
					bytes.position = position + defaultUVSOffset[i];
					var numUnicodeValueRanges:uint = bytes.readUnsignedInt();
					
					for (var j:int = 0; j < numUnicodeValueRanges; j++) 
					{
						var startUnicodeValue:uint = BytesUtils.readUint24(bytes);
						var additionalCount:uint = bytes.readUnsignedByte();
						
						for (var k:int = 0; k < additionalCount; k++) 
						{
							charCodes[count] = startUnicodeValue + k;
							glyphIndices[count] = k;
							count++;
						}
					}
				}*/
				
				if (nonDefaultUVSOffset[i] != 0)
				{
					bytes.position = position + nonDefaultUVSOffset[i];
					var numUVSMappings:uint = bytes.readUnsignedInt();
					
					for (var j:int = 0; j < numUVSMappings; j++) 
					{
						charCodes[count] = BytesUtils.readUint24(bytes);
						glyphIndices[count] = bytes.readUnsignedShort();
						count++;
					}
				}
			}
			
			Console.log("cmap format 14 need to test");
		}
		
		public function log():void
		{
			Console.log(toString());
		}
		
		public function toString():String
		{
			var string:String = "";
			var length:int = charCodes.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				string += "\n" + charCodes[i] + ": \t" + glyphIndices[i];
			}
			
			return string;
		}
	}
}