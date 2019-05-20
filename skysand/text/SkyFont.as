package skysand.text
{
	import flash.text.Font;

	public class SkyFont
	{
		[Embed(source = "fonts/akrobatBlack.otf", fontName = "akrobatBlack", embedAsCFF = "false")]
		private static var akrobatBlackFont:Class;
		
		[Embed(source = "fonts/akrobatBold.otf", fontName = "akrobatBold", embedAsCFF = "false")]
		private static var akrobatBoldFont:Class;
		
		[Embed(source = "fonts/akrobatExtraBold.otf", fontName = "akrobatExtraBold", embedAsCFF = "false")]
		private static var akrobatExtraBoldFont:Class;
		
		[Embed(source = "fonts/akrobatExtraLight.otf", fontName = "akrobatExtraLight", embedAsCFF = "false")]
		private static var akrobatExtraLightFont:Class;
		
		[Embed(source = "fonts/akrobatLight.otf", fontName = "akrobatLight", embedAsCFF = "false")]
		private static var akrobatLightFont:Class;
		
		[Embed(source = "fonts/akrobatRegular.otf", fontName = "akrobatRegular", embedAsCFF = "false")]
		private static var akrobatRegularFont:Class;
		
		[Embed(source = "fonts/akrobatSemiBold.otf", fontName = "akrobatSemiBold", embedAsCFF = "false")]
		private static var akrobatSemiBoldFont:Class;
		
		[Embed(source = "fonts/akrobatThin.otf", fontName = "akrobatThin", embedAsCFF = "false")]
		private static var akrobatThinFont:Class;
		
		[Embed(source = "fonts/anonymous.ttf", fontName = "anonymous", embedAsCFF = "false")]
		private static var anonymousFont:Class;
		
		[Embed(source = "fonts/bariol.ttf", fontName = "bariol", embedAsCFF = "false")]
		private static var bariolFont:Class;
		
		[Embed(source = "fonts/bigJohn.otf", fontName = "bigJohn", embedAsCFF = "false")]
		private static var bigJohnFont:Class;
		
		[Embed(source = "fonts/bitterBold.otf", fontName = "bitterBold", embedAsCFF = "false")]
		private static var bitterBoldFont:Class;
		
		[Embed(source = "fonts/bitterBoldItalic.otf", fontName = "bitterBoldItalic", embedAsCFF = "false")]
		private static var bitterBoldItalicFont:Class;
		
		[Embed(source = "fonts/bitterItalic.otf", fontName = "bitterItalic", embedAsCFF = "false")]
		private static var bitterItalicFont:Class;
		
		[Embed(source = "fonts/bitterRegular.otf", fontName = "bitterRegular", embedAsCFF = "false")]
		private static var bitterRegularFont:Class;
		
		[Embed(source = "fonts/camboRegular.otf", fontName = "camboRegular", embedAsCFF = "false")]
		private static var camboRegularFont:Class;
		
		[Embed(source = "fonts/codeBold.otf", fontName = "codeBold", embedAsCFF = "false")]
		private static var codeBoldFont:Class;
		
		[Embed(source = "fonts/codeLight.otf", fontName = "codeLight", embedAsCFF = "false")]
		private static var codeLightFont:Class;
		
		[Embed(source = "fonts/cyrBit.ttf", fontName = "cyrBit", embedAsCFF = "false")]
		private static var cyrBitFont:Class;
		
		[Embed(source = "fonts/dinpro.otf", fontName = "dinpro", embedAsCFF = "false")]
		private static var dinproFont:Class;
		
		[Embed(source = "fonts/display.ttf", fontName = "display", embedAsCFF = "false")]
		private static var displayFont:Class;
		
		[Embed(source = "fonts/displayBold.ttf", fontName = "displayBold", embedAsCFF = "false")]
		private static var displayBoldFont:Class;
		
		[Embed(source = "fonts/displayLight.ttf", fontName = "displayLight", embedAsCFF = "false")]
		private static var displayLightFont:Class;
		
		[Embed(source = "fonts/droidSans.ttf", fontName = "droidSans", embedAsCFF = "false")]
		private static var droidSansFont:Class;
		
		[Embed(source = "fonts/futura.ttf", fontName = "futura", embedAsCFF = "false")]
		private static var futuraFont:Class;
		
		[Embed(source = "fonts/geometria.otf", fontName = "geometria", embedAsCFF = "false")]
		private static var geometriaFont:Class;
		
		[Embed(source = "fonts/hooge.ttf", fontName = "hooge", embedAsCFF = "false")]
		private static var hoogeFont:Class;
		
		[Embed(source = "fonts/iFlash.ttf", fontName = "iFlash", embedAsCFF = "false")]
		private static var iFlashFont:Class;
		
		[Embed(source = "fonts/inconsolata.ttf", fontName = "inconsolata", embedAsCFF = "false")]
		private static var inconsolataFont:Class;
		
		[Embed(source = "fonts/justSquare.otf", fontName = "justSquare", embedAsCFF = "false")]
		private static var justSquareFont:Class;
		
		[Embed(source = "fonts/lato.ttf", fontName = "lato", embedAsCFF = "false")]
		private static var latoFont:Class;
		
		[Embed(source = "fonts/museoSansBold.otf", fontName = "museoSansBold", embedAsCFF = "false")]
		private static var museoSansBoldFont:Class;
		
		[Embed(source = "fonts/museoSansLight.otf", fontName = "museoSansLight", embedAsCFF = "false")]
		private static var museoSansLightFont:Class;
		
		[Embed(source = "fonts/Mvideo.ttf", fontName = "Mvideo", embedAsCFF = "false")]
		private static var MvideoFont:Class;
		
		[Embed(source = "fonts/openSans.ttf", fontName = "openSans", embedAsCFF = "false")]
		private static var openSansFont:Class;
		
		[Embed(source = "fonts/overpass.ttf", fontName = "overpass", embedAsCFF = "false")]
		private static var overpassFont:Class;
		
		[Embed(source = "fonts/pantonBold.otf", fontName = "pantonBold", embedAsCFF = "false")]
		private static var pantonBoldFont:Class;
		
		[Embed(source = "fonts/pantonBoldItalic.otf", fontName = "pantonBoldItalic", embedAsCFF = "false")]
		private static var pantonBoldItalicFont:Class;
		
		[Embed(source = "fonts/pantonLight.otf", fontName = "pantonLight", embedAsCFF = "false")]
		private static var pantonLightFont:Class;
		
		[Embed(source = "fonts/pantonLightItalic.otf", fontName = "pantonLightItalic", embedAsCFF = "false")]
		private static var pantonLightItalicFont:Class;
		
		[Embed(source = "fonts/pixel.otf", fontName = "pixel", embedAsCFF = "false")]
		private static var pixelFont:Class;
		
		[Embed(source = "fonts/segoe.ttf", fontName = "segoe", embedAsCFF = "false")]
		private static var segoeFont:Class;
		
		[Embed(source = "fonts/segoeSemilight.ttf", fontName = "segoeSemilight", embedAsCFF = "false")]
		private static var segoeSemilightFont:Class;
		
		[Embed(source = "fonts/slimJoe.otf", fontName = "slimJoe", embedAsCFF = "false")]
		private static var slimJoeFont:Class;
		
		[Embed(source = "fonts/splash.otf", fontName = "splash", embedAsCFF = "false")]
		private static var splashFont:Class;
		
		[Embed(source = "fonts/ubuntu.ttf", fontName = "ubuntu", embedAsCFF = "false")]
		private static var ubuntuFont:Class;
		
		[Embed(source = "fonts/yanusC.otf", fontName = "yanusC", embedAsCFF = "false")]
		private static var yanusCFont:Class;
		
		[Embed(source = "fonts/yanusCBold.otf", fontName = "yanusCBold", embedAsCFF = "false")]
		private static var yanusCBoldFont:Class;
		
		public static const AKROBAT_BLACK:String = "akrobatBlack";
		public static const AKROBAT_BOLD:String = "akrobatBold";
		public static const AKROBAT_EXTRA_BOLD:String = "akrobatExtraBold";
		public static const AKROBAT_EXTRA_LIGHT:String = "akrobatExtraLight";
		public static const AKROBAT_LIGHT:String = "akrobatLight";
		public static const AKROBAT_REGULAR:String = "akrobatRegular";
		public static const AKROBAT_SEMI_BOLD:String = "akrobatSemiBold";
		public static const AKROBAT_THIN:String = "akrobatThin";
		public static const ANONYMOUS:String = "anonymous";
		public static const BARIOL:String = "bariol";
		public static const BIG_JOHN:String = "bigJohn";
		public static const BITTER_BOLD:String = "bitterBold";
		public static const BITTER_BOLD_ITALIC:String = "bitterBoldItalic";
		public static const BITTER_ITALIC:String = "bitterItalic";
		public static const BITTER_REGULAR:String = "bitterRegular";
		public static const CAMBO_REGULAR:String = "camboRegular";
		public static const CODE_BOLD:String = "codeBold";
		public static const CODE_LIGHT:String = "codeLight";
		public static const CYR_BIT:String = "cyrBit";
		public static const DINPRO:String = "dinpro";
		public static const DISPLAY:String = "display";
		public static const DISPLAY_BOLD:String = "displayBold";
		public static const DISPLAY_LIGHT:String = "displayLight";
		public static const DROID_SANS:String = "droidSans";
		public static const FUTURA:String = "futura";
		public static const GEOMETRIA:String = "geometria";
		public static const HOOGE:String = "hooge";
		public static const I_FLASH:String = "iFlash";
		public static const INCONSOLATA:String = "inconsolata";
		public static const JUST_SQUARE:String = "justSquare";
		public static const LATO:String = "lato";
		public static const MUSEO_SANS_BOLD:String = "museoSansBold";
		public static const MUSEO_SANS_LIGHT:String = "museoSansLight";
		public static const MVIDEO:String = "Mvideo";
		public static const OPEN_SANS:String = "openSans";
		public static const OVERPASS:String = "overpass";
		public static const PANTON_BOLD:String = "pantonBold";
		public static const PANTON_BOLD_ITALIC:String = "pantonBoldItalic";
		public static const PANTON_LIGHT:String = "pantonLight";
		public static const PANTON_LIGHT_ITALIC:String = "pantonLightItalic";
		public static const PIXEL:String = "pixel";
		public static const SEGOE:String = "segoe";
		public static const SEGOE_SEMILIGHT:String = "segoeSemilight";
		public static const SLIM_JOE:String = "slimJoe";
		public static const SPLASH:String = "splash";
		public static const UBUNTU:String = "ubuntu";
		public static const YANUS_C:String = "yanusC";
		public static const YANUS_C_BOLD:String = "yanusCBold";
		
		private static var mFonts:Vector.<String> = new Vector.<String>();
		
		public function SkyFont()
		{
		}
		
		/**
		 * Добавить шрифты.
		 */
		public static function register():void
		{
			Font.registerFont(akrobatBlackFont);
			Font.registerFont(akrobatBoldFont);
			Font.registerFont(akrobatExtraBoldFont);
			Font.registerFont(akrobatExtraLightFont);
			Font.registerFont(akrobatLightFont);
			Font.registerFont(akrobatRegularFont);
			Font.registerFont(akrobatSemiBoldFont);
			Font.registerFont(akrobatThinFont);
			Font.registerFont(anonymousFont);
			Font.registerFont(bariolFont);
			Font.registerFont(bigJohnFont);
			Font.registerFont(bitterBoldFont);
			Font.registerFont(bitterBoldItalicFont);
			Font.registerFont(bitterItalicFont);
			Font.registerFont(bitterRegularFont);
			Font.registerFont(camboRegularFont);
			Font.registerFont(codeBoldFont);
			Font.registerFont(codeLightFont);
			Font.registerFont(cyrBitFont);
			Font.registerFont(dinproFont);
			Font.registerFont(displayFont);
			Font.registerFont(displayBoldFont);
			Font.registerFont(displayLightFont);
			Font.registerFont(droidSansFont);
			Font.registerFont(futuraFont);
			Font.registerFont(geometriaFont);
			Font.registerFont(hoogeFont);
			Font.registerFont(iFlashFont);
			Font.registerFont(inconsolataFont);
			Font.registerFont(justSquareFont);
			Font.registerFont(latoFont);
			Font.registerFont(museoSansBoldFont);
			Font.registerFont(museoSansLightFont);
			Font.registerFont(MvideoFont);
			Font.registerFont(openSansFont);
			Font.registerFont(overpassFont);
			Font.registerFont(pantonBoldFont);
			Font.registerFont(pantonBoldItalicFont);
			Font.registerFont(pantonLightFont);
			Font.registerFont(pantonLightItalicFont);
			Font.registerFont(pixelFont);
			Font.registerFont(segoeFont);
			Font.registerFont(segoeSemilightFont);
			Font.registerFont(slimJoeFont);
			Font.registerFont(splashFont);
			Font.registerFont(ubuntuFont);
			Font.registerFont(yanusCFont);
			Font.registerFont(yanusCBoldFont);
			
			mFonts.push("akrobatBlack");
			mFonts.push("akrobatBold");
			mFonts.push("akrobatExtraBold");
			mFonts.push("akrobatExtraLight");
			mFonts.push("akrobatLight");
			mFonts.push("akrobatRegular");
			mFonts.push("akrobatSemiBold");
			mFonts.push("akrobatThin");
			mFonts.push("anonymous");
			mFonts.push("bariol");
			mFonts.push("bigJohn");
			mFonts.push("bitterBold");
			mFonts.push("bitterBoldItalic");
			mFonts.push("bitterItalic");
			mFonts.push("bitterRegular");
			mFonts.push("camboRegular");
			mFonts.push("codeBold");
			mFonts.push("codeLight");
			mFonts.push("cyrBit");
			mFonts.push("dinpro");
			mFonts.push("display");
			mFonts.push("displayBold");
			mFonts.push("displayLight");
			mFonts.push("droidSans");
			mFonts.push("futura");
			mFonts.push("geometria");
			mFonts.push("hooge");
			mFonts.push("iFlash");
			mFonts.push("inconsolata");
			mFonts.push("justSquare");
			mFonts.push("lato");
			mFonts.push("museoSansBold");
			mFonts.push("museoSansLight");
			mFonts.push("Mvideo");
			mFonts.push("openSans");
			mFonts.push("overpass");
			mFonts.push("pantonBold");
			mFonts.push("pantonBoldItalic");
			mFonts.push("pantonLight");
			mFonts.push("pantonLightItalic");
			mFonts.push("pixel");
			mFonts.push("segoe");
			mFonts.push("segoeSemilight");
			mFonts.push("slimJoe");
			mFonts.push("splash");
			mFonts.push("ubuntu");
			mFonts.push("yanusC");
			mFonts.push("yanusCBold");
		}
		
		/**
		 * Получить названия шрифтов.
		 */
		public static function get fonts():Vector.<String>
		{
			return mFonts;
		}
	}
}
