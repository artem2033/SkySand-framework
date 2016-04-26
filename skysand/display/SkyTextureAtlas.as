package skysand.display 
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Rectangle;
	import skysand.utils.SkyFile;
	import skysand.utils.SkyFilesCache;
	
	public class SkyTextureAtlas extends Object
	{
		public var name:String;
		private var width:Number;
		private var height:Number;
		public var texture:Texture;
		private var sprites:Vector.<SkyAtlasData>;
		
		public function SkyTextureAtlas() 
		{
			sprites = new Vector.<SkyAtlasData>();
			name = "";
			width = 1;
			height = 1;
			texture = null;
		}
		
		public function createSprite(width:Number, height:Number, x:Number, y:Number, name:String):void
		{
			var data:SkyAtlasData = new SkyAtlasData();
			data.name = name;
			data.rectangle = new Rectangle(x, y, width, height);
			data.vertices = new Vector.<Number>(8, true);
			data.vertices[0] = x == 0 ? 0 : x / this.width;
			data.vertices[1] = y == 0 ? 0 : y / this.height;
			data.vertices[2] = width / this.width;
			data.vertices[3] = y == 0 ? 0 : y / this.height;
			data.vertices[4] = x == 0 ? 0 : x / this.width;
			data.vertices[5] = height / this.height;
			data.vertices[6] = width / this.width;
			data.vertices[7] = height / this.height;
			
			sprites.push(data);
		}
		
		public function createSpritesFromXML(xml:XML):void
		{
			
		}
		
		public function setTexture(texture:Texture, width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
			this.texture = texture;
		}
		
		public function get textureWidth():Number
		{
			return width;
		}
		
		public function get textureHeight():Number
		{
			return height;
		}
		
		public function getSprite(spriteName:String):SkyAtlasData
		{
			var length:int = sprites.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var data:SkyAtlasData = sprites[i];
				
				if (data.name == spriteName)
				{
					return data;
				}
			}
			
			return null;
		}
	}
}