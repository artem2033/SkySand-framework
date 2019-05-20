package skysand.ui 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyColor
	{
		public static const ABRACADABRA:uint = 0xADDCCA;
		public static const ALIZARIN:uint = 0xE74C3C;
		public static const AMARANTH_PURPLE:uint = 0xA9216D;
		public static const AMERICAN_PINK:uint = 0xFF0042;
		public static const AMETHYST:uint = 0x9B59B6;
		public static const ANTHRACITE:uint = 0x404048;
		public static const APRICOT:uint = 0xF9CFAB;
		public static const ASBESTOS:uint = 0x7F8C8D;
		public static const BELIZE_HOLE:uint = 0x2980B9;
		public static const BITTER_SWEET:uint = 0xFF6F6F;
		public static const BLACK_GREY:uint = 0x24272C;
		public static const BLUSISH_BLACK:uint = 0x161719;
		public static const BLUE_GREY:uint = 0x2D3E50;
		public static const BRIGHT_BLUE_GREY:uint = 0x777FAD;
		public static const BRIGHT_ORANGE:uint = 0xF1C754;
		public static const BRIGHT_TURQUOISE:uint = 0x15E2F5;
		public static const BRILLIANT_GREENISH_BLUE:uint = 0x2E9699;
		public static const CARMINE_PINK:uint = 0xF05052;
		public static const CARROT:uint = 0xE67E22;
		public static const CLOUDS:uint = 0xECF0F1;
		public static const CONCRETE:uint = 0x95A5A6;
		public static const COPPER_KRAYOLA:uint = 0xDE8275;
		public static const DARK_BLUE_GREY:uint = 0x262D37;
		public static const DARK_GREEN_BLUE:uint = 0x02172C;
		public static const DARK_GREEN_SEA:uint = 0x9AB999;
		public static const DARK_MAGENTA:uint = 0x452444;
		public static const EMERALD:uint = 0x2ECC71;
		public static const FUCHSIA_KRAYOLA:uint = 0xA568BE;
		public static const GRANITE:uint = 0x343C49;
		public static const GRAYISH_PURPLE:uint = 0x745260;
		public static const GREEN_BLUE:uint = 0x27363B;
		public static const GREEN_SEA:uint = 0x16A085;
		public static const GREY_PINK:uint = 0xD49F99;
		public static const LIGHT_BLUISH_GREEN:uint = 0xA1D6AC;
		public static const LIGHT_POMEGRANATE:uint = 0xF64E31;
		public static const LIGHT_YELLOW_PINK:uint = 0xF8B195;
		public static const MAGENTA_KRAYOLA:uint = 0xF778AB;
		public static const MARSALA:uint = 0xB1616E;
		public static const MELON_KRAYOLA:uint = 0xF6A8A4;
		public static const MINT_TURQUOISE:uint = 0x567B83;
		public static const MODERATE_BLUE:uint = 0x355E7E;
		public static const MODERATE_PINK:uint = 0xEE7482;
		public static const NEPHRITIS:uint = 0x27AE60;
		public static const OFFAL:uint = 0x5B5150;
		public static const OLD_LINEN:uint = 0xECE773;
		public static const ORANGE:uint = 0xF39C12;
		public static const ORANGE_DAWN:uint = 0xF85C60;
		public static const ORANGE_YELLOW_KRAYOLA:uint = 0xF8DA68;
		public static const PETER_RIVER:uint = 0x3498DB;
		public static const PINK_KRAYOLA:uint = 0xE9175E;
		public static const PINK_SHERBET:uint = 0xF48A93;
		public static const POMEGRANATE:uint = 0xC0392B;
		public static const PUMPKIN:uint = 0xD35400;
		public static const PURPLE_PINK:uint = 0xF4837D;
		public static const RASPBERRY_PINK:uint = 0xB13F73;
		public static const RED_KRAYOLA:uint = 0xEB1B4C;
		public static const RED_LILAC:uint = 0x673653;
		public static const RED_ORANGE:uint = 0xFFC154;
		public static const RED_PURPLE:uint = 0xC06C84;
		public static const RED_VIOLET:uint = 0x832D50;
		public static const SAPPHIRE_BLUE:uint = 0x30223C;
		public static const SEROBUROMALINOVY:uint = 0x6E5B7A;
		public static const SHAMROCK_KRAYOLA:uint = 0x59DAA4;
		public static const SILVER:uint = 0xBDC3C7;
		public static const SLATE_BLUE:uint = 0x8278F3;
		public static const SPACE:uint = 0x3E4649;
		public static const SPRING_GREEN_KRAYOLA:uint = 0xDCEBC2;
		public static const SUN_FLOWER:uint = 0xF1C40F;
		public static const SAPPHIRE_GREY:uint = 0x2A3245;
		public static const TIFFANY:uint = 0x0DCDC0;
		public static const TURQUOISE:uint = 0x1ABC9C;
		public static const VAGUELY_BLUE:uint = 0x48647C;
		public static const WET_ASPHALT:uint = 0x34495E;
		public static const WISTERIA:uint = 0x8E44AD;
		public static const YELLOW_GREEN:uint = 0xA7D163;
		public static const YELLOW_PINK:uint = 0xFE7D60;
		
		private static var colors:Vector.<uint>;
		
		public function SkyColor() 
		{
			colors = new Vector.<uint>(76, true);
			colors[0] = 0xADDCCA;
			colors[1] = 0x9AB999;
			colors[2] = 0xA1D6AC;
			colors[3] = 0x2ECC71;
			colors[4] = 0x16A085;
			colors[5] = 0x2E9699;
			colors[6] = 0x27AE60;
			colors[7] = 0x59DAA4;
			colors[8] = 0x0DCDC0;
			colors[9] = 0x1ABC9C;
			colors[10] = 0xA7D163;//
			colors[11] = 0x161719;
			colors[12] = 0x2D3E50;
			colors[13] = 0x777FAD;
			colors[14] = 0xF1C754;
			colors[15] = 0x15E2F5;
			colors[16] = 0xE74C3C;
			colors[17] = 0xF05052;
			colors[18] = 0xE67E22;
			colors[19] = 0xECF0F1;
			colors[20] = 0x95A5A6;
			colors[21] = 0xDE8275;
			colors[22] = 0x262D37;
			colors[23] = 0x02172C;
			colors[24] = 0xA9216D;
			colors[25] = 0x452444;
			colors[26] = 0xFF0042;
			colors[27] = 0xA568BE;
			colors[28] = 0x343C49;
			colors[29] = 0x745260;
			colors[30] = 0x27363B;
			colors[31] = 0x9B59B6;
			colors[32] = 0xD49F99;
			colors[33] = 0x404048;
			colors[34] = 0xF64E31;
			colors[35] = 0xF8B195;
			colors[36] = 0xF778AB;
			colors[37] = 0xB1616E;
			colors[38] = 0xF6A8A4;
			colors[39] = 0x567B83;
			colors[40] = 0x355E7E;
			colors[41] = 0xEE7482;
			colors[42] = 0xF9CFAB;
			colors[43] = 0x5B5150;
			colors[44] = 0xECE773;
			colors[45] = 0xF39C12;
			colors[46] = 0xF85C60;
			colors[47] = 0xF8DA68;
			colors[48] = 0x3498DB;
			colors[49] = 0xE9175E;
			colors[50] = 0xF48A93;
			colors[51] = 0xC0392B;
			colors[52] = 0xD35400;
			colors[53] = 0xF4837D;
			colors[54] = 0xB13F73;
			colors[55] = 0xEB1B4C;
			colors[56] = 0x673653;
			colors[57] = 0xFFC154;
			colors[58] = 0xC06C84;
			colors[59] = 0x832D50;
			colors[60] = 0x30223C;
			colors[61] = 0x6E5B7A;
			colors[62] = 0x7F8C8D;
			colors[63] = 0xBDC3C7;
			colors[64] = 0x8278F3;
			colors[65] = 0x3E4649;
			colors[66] = 0xDCEBC2;
			colors[67] = 0xF1C40F;
			colors[68] = 0x2A3245;
			colors[69] = 0x2980B9;
			colors[70] = 0xFF6F6F;
			colors[71] = 0x48647C;
			colors[72] = 0x34495E;
			colors[73] = 0x8E44AD;
			colors[74] = 0x24272C;
			colors[75] = 0xFE7D60;
			
			
			/*colors[0] = 0xADDCCA;
			colors[1] = 0xE74C3C;
			colors[2] = 0xA9216D;
			colors[3] = 0xFF0042;
			colors[4] = 0x9B59B6;
			colors[5] = 0x404048;
			colors[6] = 0xF9CFAB;
			colors[7] = 0x7F8C8D;
			colors[8] = 0x2980B9;
			colors[9] = 0xFF6F6F;
			colors[10] = 0x24272C;
			colors[11] = 0x161719;
			colors[12] = 0x2D3E50;
			colors[13] = 0x777FAD;
			colors[14] = 0xF1C754;
			colors[15] = 0x15E2F5;
			colors[16] = 0x2E9699;
			colors[17] = 0xF05052;
			colors[18] = 0xE67E22;
			colors[19] = 0xECF0F1;
			colors[20] = 0x95A5A6;
			colors[21] = 0xDE8275;
			colors[22] = 0x262D37;
			colors[23] = 0x02172C;
			colors[24] = 0x9AB999;
			colors[25] = 0x452444;
			colors[26] = 0x2ECC71;
			colors[27] = 0xA568BE;
			colors[28] = 0x343C49;
			colors[29] = 0x745260;
			colors[30] = 0x27363B;
			colors[31] = 0x16A085;
			colors[32] = 0xD49F99;
			colors[33] = 0xA1D6AC;
			colors[34] = 0xF64E31;
			colors[35] = 0xF8B195;
			colors[36] = 0xF778AB;
			colors[37] = 0xB1616E;
			colors[38] = 0xF6A8A4;
			colors[39] = 0x567B83;
			colors[40] = 0x355E7E;
			colors[41] = 0xEE7482;
			colors[42] = 0x27AE60;
			colors[43] = 0x5B5150;
			colors[44] = 0xECE773;
			colors[45] = 0xF39C12;
			colors[46] = 0xF85C60;
			colors[47] = 0xF8DA68;
			colors[48] = 0x3498DB;
			colors[49] = 0xE9175E;
			colors[50] = 0xF48A93;
			colors[51] = 0xC0392B;
			colors[52] = 0xD35400;
			colors[53] = 0xF4837D;
			colors[54] = 0xB13F73;
			colors[55] = 0xEB1B4C;
			colors[56] = 0x673653;
			colors[57] = 0xFFC154;
			colors[58] = 0xC06C84;
			colors[59] = 0x832D50;
			colors[60] = 0x30223C;
			colors[61] = 0x6E5B7A;
			colors[62] = 0x59DAA4;
			colors[63] = 0xBDC3C7;
			colors[64] = 0x8278F3;
			colors[65] = 0x3E4649;
			colors[66] = 0xDCEBC2;
			colors[67] = 0xF1C40F;
			colors[68] = 0x2A3245;
			colors[69] = 0x0DCDC0;
			colors[70] = 0x1ABC9C;
			colors[71] = 0x48647C;
			colors[72] = 0x34495E;
			colors[73] = 0x8E44AD;
			colors[74] = 0xA7D163;
			colors[75] = 0xFE7D60;
			/*
			colors = new Vector.<String>();
			colors.push("ABRACADABRA");
			colors.push("ALIZARIN");
			colors.push("AMARANTH PURPLE");
			colors.push("AMERICAN PINK");
			colors.push("AMETHYST");
			colors.push("ANTHRACITE");
			colors.push("APRICOT");
			colors.push("ASBESTOS");
			colors.push("BELIZE HOLE");
			colors.push("BITTER SWEET");
			colors.push("BLACK GREY");
			colors.push("BLUSISH BLACK");
			colors.push("BLUE GREY");
			colors.push("BRIGHT BLUE GREY");
			colors.push("BRIGHT ORANGE");
			colors.push("BRIGHT TURQUOISE");
			colors.push("BRILLIANT BLUE");
			colors.push("CARMINE PINK");
			colors.push("CARROT");
			colors.push("CLOUDS");
			colors.push("CONCRETE");
			colors.push("COPPER KRAYOLA");
			colors.push("DARK BLUE GREY");
			colors.push("DARK GREEN BLUE");
			colors.push("DARK GREEN SEA");
			colors.push("DARK MAGENTA");
			colors.push("EMERALD");
			colors.push("FUCHSIA KRAYOLA");
			colors.push("GRANITE");
			colors.push("GRAYISH PURPLE");
			colors.push("GREEN BLUE");
			colors.push("GREEN SEA");
			colors.push("GREY PINK");
			colors.push("LIGHT BLUISH GREEN");
			colors.push("LIGHT POMEGRANATE");
			colors.push("LIGHT YELLOW PINK");
			colors.push("MAGENTA KRAYOLA");
			colors.push("MARSALA");
			colors.push("MELON KRAYOLA");
			colors.push("MINT TURQUOISE");
			colors.push("MODERATE BLUE");
			colors.push("MODERATE PINK");
			colors.push("NEPHRITIS");
			colors.push("OFFAL");
			colors.push("OLD LINEN");
			colors.push("ORANGE");
			colors.push("ORANGE DAWN");
			colors.push("ORANGE YELLOW");
			colors.push("PETER RIVER");
			colors.push("PINK KRAYOLA");
			colors.push("PINK SHERBET");
			colors.push("POMEGRANATE");
			colors.push("PUMPKIN");
			colors.push("PURPLE PINK");
			colors.push("RASPBERRY PINK");
			colors.push("RED KRAYOLA");
			colors.push("RED LILAC");
			colors.push("RED ORANGE");
			colors.push("RED PURPLE");
			colors.push("RED VIOLET");
			colors.push("SAPPHIRE BLUE");
			colors.push("SEROBUROMALINOVY");
			colors.push("SHAMROCK KRAYOLA");
			colors.push("SILVER");
			colors.push("SLATE BLUE");
			colors.push("SPACE");
			colors.push("SPRING GREEN");
			colors.push("SUN FLOWER");
			colors.push("SAPPHIRE GREY");
			colors.push("TIFFANY");
			colors.push("TURQUOISE");
			colors.push("VAGUELY BLUE");
			colors.push("WET ASPHALT");
			colors.push("WISTERIA");
			colors.push("YELLOW GREEN");
			colors.push("YELLOW PINK");*/
		}
		
		/**
		 * Поменять яркость цвета.
		 * @param	color исходный цвет.
		 * @param	bright яркость от -255 до 255.
		 * @return результирующий цвет.
		 */
		public static function setBright(color:uint, bright:Number):uint
		{
			var r:uint = (color >> 16) & 0xFF;
			var g:uint = (color >> 8) & 0xFF;
			var b:uint = color & 0xFF;
			
			r = bright + r > 255 ? 255 : bright + r < 0 ? 0 : bright + r;
			g = bright + g > 255 ? 255 : bright + g < 0 ? 0 : bright + g;
			b = bright + b > 255 ? 255 : bright + b < 0 ? 0 : bright + b;
			
			var result:uint = (r << 16) | (g << 8) | b;
			
			return result;
		}
		
		/**
		 * Получить цвет по номеру из списка.
		 * @param	index номер.
		 * @return возвращает цвет.
		 */
		public static function getColor(index:int):uint
		{
			return colors[index];
		}
		
		/**
		 * Получить массив с цветами.
		 * @return возвращает массив цветов.
		 */
		public static function getColors():Vector.<uint>
		{
			return colors;
		}
		
		/**
		 * Получить красную состовляющую цвета.
		 * @param	color исходный цвет.
		 * @return результирующий цвет.
		 */
		public static function getRed(color:uint):uint
		{
			return (color >> 16) & 0xFF;
		}
		
		/**
		 * Получить зелёную состовляющую цвета.
		 * @param	color исходный цвет.
		 * @return результирующий цвет.
		 */
		public static function getGreen(color:uint):uint
		{
			return (color >> 8) & 0xFF;
		}
		
		/**
		 * Получить синию состовляющую цвета.
		 * @param	color исходный цвет.
		 * @return результирующий цвет.
		 */
		public static function getBlue(color:uint):uint
		{
			return color & 0xFF;
		}
	}
}