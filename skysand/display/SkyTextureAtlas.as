package skysand.display 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import skysand.utils.SkyFile;
	import skysand.utils.SkyFilesCache;
	
	public class SkyTextureAtlas extends Object
	{
		public var name:String;
		private var _texture:Texture;
		private var width:Number;
		private var height:Number;
		private var sprites:Vector.<SkyAtlasSprite>;
		private var bytes:ByteArray;
		
		public function SkyTextureAtlas() 
		{
			sprites = new Vector.<SkyAtlasSprite>();
			name = "";
			width = 1;
			height = 1;
			_texture = null;
		}
		
		public function createSprite(x:Number, y:Number, width:Number, height:Number, name:String, pivotX:Number = 0, pivotY:Number = 0):void
		{
			var data:SkyAtlasSprite = new SkyAtlasSprite();
			data.name = name;
			data.width = width;
			data.height = height;
			data.pivotX = pivotX;
			data.pivotY = pivotY;
			data.vertices = new Vector.<Number>(8, true);
			data.vertices[0] = x / this.width;
			data.vertices[1] = y / this.height;
			data.vertices[2] = (x + width) / this.width;
			data.vertices[3] = y / this.height;
			data.vertices[4] = x / this.width;
			data.vertices[5] = (y + height) / this.height;
			data.vertices[6] = (x + width) / this.width;
			data.vertices[7] = (y + height) / this.height;
			
			sprites.push(data);
		}
		
		public function createSpritesFromXML(xml:XML):void
		{
			
		}
		
		public function loadTexture(filePath:String, width:Number, height:Number):void
		{
			bytes = SkyFilesCache.loadByteArray(filePath);
			
			this.width = width;
			this.height = height;
		}
		
		public function setTexture(texture:Texture, width:Number, height:Number):void
		{
			if (texture == null)
			{
				this.width = width;
				this.height = height;
				_texture = texture;
			}
		}
		
		public function get texture():Texture
		{
			if (_texture == null)
			{
				_texture = SkySand.CONTEXT_3D.createTexture(width, height, Context3DTextureFormat.BGRA, false);
				_texture.uploadFromByteArray(bytes, 0);
			}
			
			return _texture;
		}
		
		public function get textureWidth():Number
		{
			return width;
		}
		
		public function get textureHeight():Number
		{
			return height;
		}
		
		public function getSprite(spriteName:String):SkyAtlasSprite
		{
			var length:int = sprites.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var data:SkyAtlasSprite = sprites[i];
				
				if (data.name == spriteName)
				{
					return data;
				}
			}
			
			return null;
		}
	}
}