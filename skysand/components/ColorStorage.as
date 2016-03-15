package skysand.components 
{
	public class ColorStorage 
	{
		private static var _instance:ColorStorage;
		
		private var colors:Vector.<ComponentColor>;
		
		public function ColorStorage() 
		{
			if (_instance != null)
			{
				throw new Error("Use instance");
			}
			_instance = this;
			
			colors = new Vector.<ComponentColor>();
			
			addDefaultColors();
		}
		
		public function getColor(name:String):ComponentColor
		{
			var color:ComponentColor;
			
			for (var i:int = 0; i < colors.length; i++) 
			{
				if (colors[i].name == name)
				{
					color = colors[i];
				}
			}
			
			return color;
		}
		
		public function addColor(color:ComponentColor):void
		{
			colors.push(color);
		}
		
		public function removeColor(name:String):void
		{
			for (var i:int = 0; i < colors.length; i++) 
			{
				if (colors[i].name == name)
				{
					colors[i] = null;
					colors.splice(i, 1);
				}
			}
		}
		
		public static function get instance():ColorStorage
		{
			return (_instance == null) ? new ColorStorage() : _instance;
		}
		
		private function addDefaultColors():void
		{
			var color:ComponentColor = new ComponentColor();
			color.name = "peach";
			color.bright = 0xE4B086;
			color.main = 0xF68970;
			color.dark = 0xE04A5D;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "stop";
			color.bright = 0xB8A381;
			color.main = 0x70695A;
			color.dark = 0x313640;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "metal-peach";
			color.bright = 0xFFD3AD;
			color.main = 0xD98666;
			color.dark = 0x9B8D80;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "store";
			color.bright = 0xFFC976;
			color.main = 0xF6BE6B;
			color.dark = 0xE8A467;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "dark-purple";
			color.bright = 0x8C3450;
			color.main = 0x2F2438;
			color.dark = 0x161621;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "purple";
			color.bright = 0xDB6958;
			color.main = 0xC94F4F;
			color.dark = 0x8C3450;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "panic";
			color.bright = 0xD93F3D;
			color.main = 0x8C2D3E;
			color.dark = 0x481E45;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "mistery";
			color.bright = 0x853142;
			color.main = 0x5C2B3F;
			color.dark = 0x3D232E;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "pikaboo";
			color.bright = 0xF3D667;
			color.main = 0xE5C77C;
			color.dark = 0x918B26;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "green";
			color.bright = 0xDCB146;
			color.main = 0xA7A358;
			color.dark = 0x384C3D;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "black";
			color.bright = 0x3E587B;
			color.main = 0x132332;
			color.dark = 0x0D0D0D;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "dearly";
			color.bright = 0xABA285;
			color.main = 0x99827A;
			color.dark = 0x836565;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "wear";
			color.bright = 0xE38164;
			color.main = 0x330818;
			color.dark = 0x57112B;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "pink";
			color.bright = 0xF9D379;
			color.main = 0xF9A979;
			color.dark = 0xF98879;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "wheel";
			color.bright = 0x596679;
			color.main = 0x5C587D;
			color.dark = 0x060141;
			addColor(color);
			
			color = new ComponentColor();
			color.name = "black-yellow";
			color.bright = 0x151E33;
			color.main = 0x151E27;
			color.dark = 0xDBB71E;//0x1BB4D9
			addColor(color);
			
			color = new ComponentColor();
			color.name = "test";
			color.bright = 0x91b8ed;
			color.main = 0x18202e;
			color.dark = 0x39181a;//0x1BB4D9
			addColor(color);
		}
	}
}