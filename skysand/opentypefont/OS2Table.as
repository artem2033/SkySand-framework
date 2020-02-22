package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class OS2Table 
	{
		public var version:uint;
		public var xAvgCharWidth:int;
		public var usWeightClass:uint;
		public var usWidthClass:uint;
		public var fsType:uint;
		public var ySubscriptXSize:int;
		public var ySubscriptYSize:int;
		public var ySubscriptXOffset:int;
		public var ySubscriptYOffset:int;
		public var ySuperscriptXSize:int;
		public var ySuperscriptYSize:int;
		public var ySuperscriptXOffset:int;
		public var ySuperscriptYOffset:int;
		public var yStrikeoutSize:int;
		public var yStrikeoutPosition:int;
		public var sFamilyClass:int;
		public var panose:Vector.<uint>;
		public var ulUnicodeRange1:uint;
		public var ulUnicodeRange2:uint;
		public var ulUnicodeRange3:uint;
		public var ulUnicodeRange4:uint;
		public var achVendID:Vector.<uint>;
		public var fsSelection:uint;
		public var usFirstCharIndex:uint;
		public var usLastCharIndex:uint;
		public var sTypoAscender:int;
		public var sTypoDescender:int;
		public var sTypoLineGap:int;
		public var usWinAscent:uint;
		public var usWinDescent:uint;
		//v1
		public var ulCodePageRange1:uint;
		public var ulCodePageRange2:uint;
		//v4 v2 v3
		public var sxHeight:int;
		public var sCapHeight:int;
		public var usDefaultChar:uint;
		public var usBreakChar:uint;
		public var usMaxContext:uint;
		//v5
		public var usLowerOpticalPointSize:uint;	
		public var usUpperOpticalPointSize:uint;
		
		public function OS2Table() 
		{
			panose = new Vector.<uint>(10, true);
			achVendID = new Vector.<uint>(4, true);
		}
		
		/**
		 * Считать данные таблицы из массива байт.
		 * @param	bytes ссылка на массив байт.
		 */
		public function readBytes(bytes:ByteArray):void
		{
			version = bytes.readUnsignedShort();
			xAvgCharWidth = bytes.readShort();
			usWeightClass = bytes.readUnsignedShort();
			usWidthClass = bytes.readUnsignedShort();
			fsType = bytes.readUnsignedShort();
			ySubscriptXSize = bytes.readShort();
			ySubscriptYSize = bytes.readShort();
			ySubscriptXOffset = bytes.readShort();
			ySubscriptYOffset = bytes.readShort();
			ySuperscriptXSize = bytes.readShort();
			ySuperscriptYSize = bytes.readShort();
			ySuperscriptXOffset = bytes.readShort();
			ySuperscriptYOffset = bytes.readShort();
			yStrikeoutSize = bytes.readShort();
			yStrikeoutPosition = bytes.readShort();
			sFamilyClass = bytes.readShort();
			
			for (var i:int = 0; i < 10; i++) 
			{
				panose[i] = bytes.readUnsignedByte();
			}
			
			ulUnicodeRange1 = bytes.readUnsignedInt();
			ulUnicodeRange2 = bytes.readUnsignedInt();
			ulUnicodeRange3 = bytes.readUnsignedInt();
			ulUnicodeRange4 = bytes.readUnsignedInt();
			
			for (i = 0; i < 4; i++) 
			{
				achVendID[i] = bytes.readUnsignedByte();
			}
			
			fsSelection = bytes.readUnsignedShort();
			usFirstCharIndex = bytes.readUnsignedShort();
			usLastCharIndex = bytes.readUnsignedShort();
			sTypoAscender = bytes.readShort();
			sTypoDescender = bytes.readShort();
			sTypoLineGap = bytes.readShort();
			usWinAscent = bytes.readUnsignedShort();
			usWinDescent = bytes.readUnsignedShort();
			
			if (version == 1)
			{
				ulCodePageRange1 = bytes.readUnsignedInt();
				ulCodePageRange2 = bytes.readUnsignedInt();
			}
			
			if (version >= 2 && version < 5)
			{
				sxHeight = bytes.readShort();
				sCapHeight = bytes.readShort();
				usDefaultChar = bytes.readUnsignedShort();
				usBreakChar = bytes.readUnsignedShort();
				usMaxContext = bytes.readUnsignedShort();
			}
			
			if (version == 5)
			{
				usLowerOpticalPointSize = bytes.readUnsignedShort();	
				usUpperOpticalPointSize = bytes.readUnsignedShort();
			}
		}
		
		/**
		 * Вывести в консоль данные таблицы.
		 */
		public function log():void
		{
			Console.log(toString());
		}
		
		/**
		 * Преобразовать данные таблицы в строку.
		 * @return возвращает строку.
		 */
		public function toString():String
		{
			var string:String = "------------------";
			string += "\nversion: " + version;
			string += "\nxAvgCharWidth: " + xAvgCharWidth;
			string += "\nusWeightClass :" + usWeightClass;
			string += "\nusWidthClass: " + usWidthClass;
			string += "\nfsType: " + fsType;
			string += "\nySubscriptXSize: " + ySubscriptXSize;
			string += "\nySubscriptYSize: " + ySubscriptYSize;
			string += "\nySubscriptXOffset: " + ySubscriptXOffset;
			string += "\nySubscriptYOffset: " + ySubscriptYOffset;
			string += "\nySuperscriptXSize: " + ySuperscriptXSize;
			string += "\nySuperscriptYSize: " + ySuperscriptYSize;
			string += "\nySuperscriptXOffset: " + ySuperscriptXOffset;
			string += "\nySuperscriptYOffset: " + ySuperscriptYOffset;
			string += "\nyStrikeoutSize: " + yStrikeoutSize;
			string += "\nyStrikeoutPosition: " + yStrikeoutPosition;
			string += "\nsFamilyClass: " + sFamilyClass;
			string += "\npanose: " + panose.toString();
			string += "\nulUnicodeRange1: " + ulUnicodeRange1;
			string += "\nulUnicodeRange2: " + ulUnicodeRange2;
			string += "\nulUnicodeRange3: " + ulUnicodeRange3;
			string += "\nulUnicodeRange4: " + ulUnicodeRange4;
			string += "\nachVendID: " + achVendID.toString();
			string += "\nfsSelection: " + fsSelection;
			string += "\nusFirstCharIndex: " + usFirstCharIndex;
			string += "\nusLastCharIndex: " + usLastCharIndex;
			string += "\nsTypoAscender: " + sTypoAscender;
			string += "\nsTypoDescender: " + sTypoDescender;
			string += "\nsTypoLineGap: " + sTypoLineGap;
			string += "\nusWinAscent: " + usWinAscent;
			string += "\nusWinDescent: " + usWinDescent;
			
			if (version == 1)
			{
				string += "\nulCodePageRange1: " + ulCodePageRange1;
				string += "\nulCodePageRange2: " + ulCodePageRange2;
			}
			
			if (version >= 2 && version < 5)
			{
				string += "\nsxHeight: " + sxHeight;
				string += "\nsCapHeight: " + sCapHeight;
				string += "\nusDefaultChar: " + usDefaultChar;
				string += "\nusBreakChar: " + usBreakChar;
				string += "\nusMaxContext: " + usMaxContext;
			}
			
			if (version == 5)
			{
				string += "\nusLowerOpticalPointSize: " + usLowerOpticalPointSize;
				string += "\nusUpperOpticalPointSize: " + usUpperOpticalPointSize;
			}
			
			return string;
		}
	}
}