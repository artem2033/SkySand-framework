package skysand.opentypefont 
{
	import flash.utils.ByteArray;
	import skysand.debug.Console;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class PostScriptTable 
	{
		public var version:Number;
		public var italicAngle:Number;
		public var underlinePosition:int;
		public var underlineThickness:int;
		public var isFixedPitch:uint;
		public var minMemType42:uint;
		public var maxMemType42:uint;
		public var minMemType1:uint;
		public var maxMemType1:uint;
		/*Fixed	version	0x00010000 for version 1.0
		0x00020000 for version 2.0
		0x00025000 for version 2.5 (deprecated)
		0x00030000 for version 3.0*/
		public var numGlyphs:uint;
		public var glyphNameIndex:Vector.<uint>;
		public var glyphNames:Vector.<String>;
		private var macGlyphNames:Vector.<String>;
		
		public function PostScriptTable() 
		{
			
		}
		
		public function readBytes(bytes:ByteArray):void
		{
			version = BytesUtils.readFixed(bytes);
			italicAngle = BytesUtils.readFixed(bytes);
			underlinePosition = bytes.readShort();
			underlineThickness = bytes.readShort();
			isFixedPitch = bytes.readUnsignedInt();
			minMemType42 = bytes.readUnsignedInt();
			maxMemType42 = bytes.readUnsignedInt();
			minMemType1 = bytes.readUnsignedInt();
			maxMemType1 = bytes.readUnsignedInt();
			
			fillMacGlyphNames();
			
			//(version == 1 || version == 3) macGlyphNames;
			if (version == 2 || version == 3)
			{
				glyphNames = new Vector.<String>();
				glyphNameIndex = new Vector.<uint>();
				numGlyphs = bytes.readUnsignedShort();
				
				for (var i:int = 0; i < numGlyphs; i++) 
				{
					glyphNameIndex[i] = bytes.readUnsignedShort();
					
				}
				
				for (i = 0; i < numGlyphs; i++) 
				{
					var index:uint = glyphNameIndex[i];
					
					if (index < 258)
					{
						glyphNames[i] = macGlyphNames[index];
					}
					else
					{
						var len:int = bytes.readByte();
						glyphNames[i] = bytes.readUTFBytes(len);
					}
				}
			}
			else if (version == 2.5)
			{
				numGlyphs = bytes.readUnsignedShort();
				Console.log("Add 2.5 version postScript font table!");
			}
		}
		
		private function fillMacGlyphNames():void
		{
			macGlyphNames = new Vector.<String>();
			macGlyphNames[0] = ".notdef";
			macGlyphNames[1] =	".null";
			macGlyphNames[2] =  "nonmarkingreturn";
			macGlyphNames[3] =	"space";
			macGlyphNames[4] =	"exclam";
			macGlyphNames[5] =	"quotedbl";
			macGlyphNames[6] =	"numbersign";
			macGlyphNames[7] =	"dollar";
			macGlyphNames[8] =	"percent";
			macGlyphNames[9] =	"ampersand";
			macGlyphNames[10] =	"quotesingle";
			macGlyphNames[11] = "parenleft";
			macGlyphNames[12] =	"parenright";
			macGlyphNames[13] =	"asterisk";
			macGlyphNames[14] =	"plus";
			macGlyphNames[15] =	"comma";
			macGlyphNames[16] =	"hyphen";
			macGlyphNames[17] =	"period";
			macGlyphNames[18] =	"slash";
			macGlyphNames[19] =	"zero";
			macGlyphNames[20] =	"one";
			macGlyphNames[21] =	"two";
			macGlyphNames[22] =	"three";
			macGlyphNames[23] =	"four";
			macGlyphNames[24] =	"five";
			macGlyphNames[25] =	"six";
			macGlyphNames[26] =	"seven";
			macGlyphNames[27] =	"eight";
			macGlyphNames[28] =	"nine";
			macGlyphNames[29] =	"colon";
			macGlyphNames[30] =	"semicolon";
			macGlyphNames[31] =	"less";
			macGlyphNames[32] =	"equal";
			macGlyphNames[33] =	"greater";
			macGlyphNames[34] =	"question";
			macGlyphNames[35] =	"at";
			macGlyphNames[36] =	"A";
			macGlyphNames[37] =	"B";
			macGlyphNames[38] =	"C";
			macGlyphNames[39] =	"D";
			macGlyphNames[40] =	"E";
			macGlyphNames[41] =	"F";
			macGlyphNames[42] =	"G";
			macGlyphNames[43] =	"H";
			macGlyphNames[44] =	"I";
			macGlyphNames[45] =	"J";
			macGlyphNames[46] =	"K";
			macGlyphNames[47] =	"L";
			macGlyphNames[48] =	"M";
			macGlyphNames[49] =	"N";
			macGlyphNames[50] =	"O";
			macGlyphNames[51] =	"P";
			macGlyphNames[52] =	"Q";
			macGlyphNames[53] = "R";
			macGlyphNames[54] = "S";
			macGlyphNames[55] = "T";
			macGlyphNames[56] = "U";
			macGlyphNames[57] = "V";
			macGlyphNames[58] = "W";
			macGlyphNames[59] = "X";
			macGlyphNames[60] = "Y";
			macGlyphNames[61] = "Z";
			macGlyphNames[62] = "bracketleft";
			macGlyphNames[63] = "backslash";
			macGlyphNames[64] = "bracketright";
			macGlyphNames[65] = "asciicircum";
			macGlyphNames[66] = "underscore";
			macGlyphNames[67] = "grave";
			macGlyphNames[68] = "a";
			macGlyphNames[69] = "b";
			macGlyphNames[70] = "c";
			macGlyphNames[71] = "d";
			macGlyphNames[72] = "e";
			macGlyphNames[73] = "f";
			macGlyphNames[74] = "g";
			macGlyphNames[75] = "h";
			macGlyphNames[76] = "i";
			macGlyphNames[77] = "j";
			macGlyphNames[78] = "k";
			macGlyphNames[79] = "l";
			macGlyphNames[80] = "m";
			macGlyphNames[81] = "n";
			macGlyphNames[82] = "o";
			macGlyphNames[83] = "p";
			macGlyphNames[84] = "q";
			macGlyphNames[85] = "r";
			macGlyphNames[86] = "s";
			macGlyphNames[87] = "t";
			macGlyphNames[88] = "u";
			macGlyphNames[89] = "v";
			macGlyphNames[90] = "w";
			macGlyphNames[91] = "x";
			macGlyphNames[92] = "y";
			macGlyphNames[93] = "z";
			macGlyphNames[94] = "braceleft";
			macGlyphNames[95] = "bar";
			macGlyphNames[96] = "braceright";
			macGlyphNames[97] = "vasciitilde";
			macGlyphNames[98] = "Adieresis";
			macGlyphNames[99] = "Aring";
			macGlyphNames[100] = "Ccedilla";
			macGlyphNames[101] = "Eacute";
			macGlyphNames[102] = "Ntilde";
			macGlyphNames[103] = "Odieresis";
			macGlyphNames[104] = "Udieresis";
			macGlyphNames[105] = "aacute";
			macGlyphNames[106] = "agrave";
			macGlyphNames[107] = "acircumflex";
			macGlyphNames[108] = "adieresis";
			macGlyphNames[109] = "atilde";
			macGlyphNames[110] = "aring";
			macGlyphNames[111] = "ccedilla";
			macGlyphNames[112] = "eacute";
			macGlyphNames[113] = "egrave";
			macGlyphNames[114] = "ecircumflex";
			macGlyphNames[115] = "edieresis";
			macGlyphNames[116] = "iacute";
			macGlyphNames[117] = "igrave";
			macGlyphNames[118] = "icircumflex";
			macGlyphNames[119] = "idieresis";
			macGlyphNames[120] = "ntilde";
			macGlyphNames[121] = "oacute";
			macGlyphNames[122] = "ograve";
			macGlyphNames[123] = "ocircumflex";
			macGlyphNames[124] = "odieresis";
			macGlyphNames[125] = "otilde";
			macGlyphNames[126] = "uacute";
			macGlyphNames[127] = "ugrave";
			macGlyphNames[128] = "ucircumflex";
			macGlyphNames[129] = "udieresis";
			macGlyphNames[130] = "dagger";
			macGlyphNames[131] = "degree";
			macGlyphNames[132] = "cent";
			macGlyphNames[133] = "sterling";
			macGlyphNames[134] = "section";
			macGlyphNames[135] = "bullet";
			macGlyphNames[136] = "paragraph";
			macGlyphNames[137] = "germandbls";
			macGlyphNames[138] = "registered";
			macGlyphNames[139] = "copyright";
			macGlyphNames[140] = "trademark";
			macGlyphNames[141] = "acute";
			macGlyphNames[142] = "dieresis";
			macGlyphNames[143] = "notequal";
			macGlyphNames[144] = "AE";
			macGlyphNames[145] = "Oslash";
			macGlyphNames[146] = "infinity";
			macGlyphNames[147] = "plusminus";
			macGlyphNames[148] = "lessequal";
			macGlyphNames[149] = "greaterequal";
			macGlyphNames[150] = "yen";
			macGlyphNames[151] = "mu";
			macGlyphNames[152] = "partialdiff";
			macGlyphNames[153] = "summation";
			macGlyphNames[154] = "product";
			macGlyphNames[155] = "pi";
			macGlyphNames[156] = "integral";
			macGlyphNames[157] = "ordfeminine";
			macGlyphNames[158] = "ordmasculine";
			macGlyphNames[159] = "Omega";
			macGlyphNames[160] = "ae";
			macGlyphNames[161] = "oslash";
			macGlyphNames[162] = "questiondown";
			macGlyphNames[163] = "exclamdown";
			macGlyphNames[164] = "logicalnot";
			macGlyphNames[165] = "radical";
			macGlyphNames[166] = "florin";
			macGlyphNames[167] = "approxequal";
			macGlyphNames[168] = "Delta";
			macGlyphNames[169] = "guillemotleft";
			macGlyphNames[170] = "guillemotright";
			macGlyphNames[171] = "ellipsis";
			macGlyphNames[172] = "nonbreakingspace";
			macGlyphNames[173] = "Agrave";
			macGlyphNames[174] = "Atilde";
			macGlyphNames[175] = "Otilde";
			macGlyphNames[176] = "OE";
			macGlyphNames[177] = "oe";
			macGlyphNames[178] = "endash";
			macGlyphNames[179] = "emdash";
			macGlyphNames[180] = "quotedblleft";
			macGlyphNames[181] = "quotedblright";
			macGlyphNames[182] = "quoteleft";
			macGlyphNames[183] = "quoteright";
			macGlyphNames[184] = "divide";
			macGlyphNames[185] = "lozenge";
			macGlyphNames[186] = "ydieresis";
			macGlyphNames[187] = "Ydieresis";
			macGlyphNames[188] = "fraction";
			macGlyphNames[189] = "currency";
			macGlyphNames[190] = "guilsinglleft";
			macGlyphNames[191] = "guilsinglright";
			macGlyphNames[192] = "fi";
			macGlyphNames[193] = "fl";
			macGlyphNames[194] = "daggerdbl";
			macGlyphNames[195] = "periodcentered";
			macGlyphNames[196] = "quotesinglbase";
			macGlyphNames[197] = "uotedblbase";
			macGlyphNames[198] = "perthousand";
			macGlyphNames[199] = "Acircumflex";
			macGlyphNames[200] = "Ecircumflex";
			macGlyphNames[201] = "Aacute";
			macGlyphNames[202] = "Edieresis";
			macGlyphNames[203] = "Egrave";
			macGlyphNames[204] = "Iacute";
			macGlyphNames[205] = "Icircumflex";
			macGlyphNames[206] = "Idieresis";
			macGlyphNames[207] = "Igrave";
			macGlyphNames[208] = "Oacute";
			macGlyphNames[209] = "Ocircumflex";
			macGlyphNames[210] = "apple";
			macGlyphNames[211] = "Ograve";
			macGlyphNames[212] = "Uacute";
			macGlyphNames[213] = "Ucircumflex";
			macGlyphNames[214] = "Ugrave";
			macGlyphNames[215] = "dotlessi";
			macGlyphNames[216] = "circumflex";
			macGlyphNames[217] = "tilde";
			macGlyphNames[218] = "macron";
			macGlyphNames[219] = "breve";
			macGlyphNames[220] = "dotaccent";
			macGlyphNames[221] = "ring";
			macGlyphNames[222] = "cedilla";
			macGlyphNames[223] = "hungarumlaut";
			macGlyphNames[224] = "ogonek";
			macGlyphNames[225] = "caron";
			macGlyphNames[226] = "slash";
			macGlyphNames[227] = "lslash";
			macGlyphNames[228] = "Scaron";
			macGlyphNames[229] = "scaron";
			macGlyphNames[230] = "Zcaron";
			macGlyphNames[231] = "zcaron";
			macGlyphNames[232] = "brokenbar";
			macGlyphNames[233] = "Eth";
			macGlyphNames[234] = "eth";
			macGlyphNames[235] = "Yacute";
			macGlyphNames[236] = "yacute";
			macGlyphNames[237] = "Thorn";
			macGlyphNames[238] = "thorn";
			macGlyphNames[239] = "minus";
			macGlyphNames[240] = "multiply";
			macGlyphNames[241] = "onesuperior";
			macGlyphNames[242] = "twosuperior";
			macGlyphNames[243] = "threesuperior";
			macGlyphNames[244] = "onehalf";
			macGlyphNames[245] = "onequarter";
			macGlyphNames[246] = "threequarters";
			macGlyphNames[247] = "franc";
			macGlyphNames[248] = "Gbreve";
			macGlyphNames[249] = "gbreve";
			macGlyphNames[250] = "Idotaccent";
			macGlyphNames[251] = "Scedilla";
			macGlyphNames[252] = "scedilla";
			macGlyphNames[253] = "Cacute";
			macGlyphNames[254] = "cacute";
			macGlyphNames[255] = "Ccaron";
			macGlyphNames[256] = "ccaron";
			macGlyphNames[257] = "dcroat";
		}
		
		public function log():void
		{
			Console.log(toString());
		}
		
		public function toString():String
		{
			var string:String = "";
			string += "\nversion: " + version;
			string += "\nitalicAngle: " + italicAngle;
			string += "\nunderlinePosition: " + underlinePosition;
			string += "\nunderlineThickness: " + underlineThickness;
			string += "\nisFixedPitch: " + isFixedPitch;
			string += "\nminMemType42: " + minMemType42;
			string += "\nmaxMemType42: " + maxMemType42;
			string += "\nminMemType1: " + minMemType1;
			string += "\nmaxMemType1: " + maxMemType1;
			
			for (var i:int = 0; i < numGlyphs; i++) 
			{
				string += "\n" + glyphNameIndex[i] + ": " + glyphNames[i];
			}
			
			return string;
		}
	}
}