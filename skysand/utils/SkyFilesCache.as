package skysand.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.Endian;
	import skysand.display.SkyAtlasData;
	import skysand.display.SkyTextureAtlas;
	import skysand.display.SkyTextureData;
	
	public class SkyFilesCache extends Object
	{
		private var file:File;
		private var fileStream:FileStream;
		private var files:Vector.<SkyFile>;
		private var context3D:Context3D;
		private var nTextures:int;
		private var nAtlases:int;
		private var textures:Vector.<SkyTextureData>;
		private var atlases:Vector.<SkyTextureAtlas>;
		/**
		 * Ссылка класса на самого себя.
		 */
		private static var _instance:SkyFilesCache;
		
		public function SkyFilesCache()
		{
			if (_instance != null)
			{
				throw new Error("Используйте instance для доступа к экземпляру класса SkyFilesCache");
			}
			_instance = this;
		}
		
		public function initialize(context3D:Context3D):void
		{
			files = new Vector.<SkyFile>();
			atlases = new Vector.<SkyTextureAtlas>();
			textures = new Vector.<SkyTextureData>();
			
			this.context3D = context3D;
			nTextures = 0;
			nAtlases = 0;
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():SkyFilesCache
		{
			return _instance == null ? new SkyFilesCache() : _instance;
		}
		
		public function addTextureFromEmbedClass(name:String, _Class:Class, mipMaps:Boolean):void
		{
			var bitmap:Bitmap = new _Class();
			
			var texture:Texture = context3D.createTexture(bitmap.bitmapData.width, bitmap.bitmapData.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bitmap.bitmapData);
			
			if (mipMaps) generateMimMaps(texture, null, bitmap.bitmapData);
			
			var file:SkyFile = new SkyFile();
			file.file = texture;
			file.name = name;
			files.push(file);
			nTextures++;
		}
		
		public function addTextureFromLocalFile(path:String, width:Number, height:Number, name:String):void
		{
			var file:File = File.applicationDirectory.resolvePath(path);
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, "read");
			fileStream.readBytes(bytes);
			fileStream.close();
			
			bytes.uncompress(CompressionAlgorithm.DEFLATE);
			
			var texture:Texture = context3D.createTexture(width, height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromByteArray(bytes, 0);
			
			var data:SkyTextureData = new SkyTextureData();
			data.height = height;
			data.width = width;
			data.name = name;
			data.texture = texture;
			
			textures[nTextures] = data;
			nTextures++;
		}
		
		public function addTextureAtlasFromFile(path:String, width:Number, height:Number, name:String):void
		{
			var file:File = File.applicationDirectory.resolvePath(path);
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, "read");
			fileStream.readBytes(bytes);
			fileStream.close();
			
			bytes.uncompress(CompressionAlgorithm.DEFLATE);
			
			var texture:Texture = context3D.createTexture(width, height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromByteArray(bytes, 0);
			
			var atlas:SkyTextureAtlas = new SkyTextureAtlas();
			atlas.name = name;
			atlas.setTexture(texture, width, height);
			trace(name);
			atlases[nAtlases] = atlas;
			nAtlases++;
		}
		
		public function getAtlasUV(name:String, atlasName:String):Vector.<Number>
		{
			for (var i:int = 0; i < nAtlases; i++) 
			{
				var atlas:SkyTextureAtlas = atlases[i];
				
				if (atlas.name == atlasName)
				{
					return atlas.getSprite(name).vertices;
				}
			}
			
			return null;
		}
		
		public function getAtlas(name:String):SkyTextureAtlas
		{
			for (var i:int = 0; i < nAtlases; i++) 
			{
				var atlas:SkyTextureAtlas = atlases[i];
				
				if (atlas.name == name)
				{
					return atlas;
				}
			}
			
			return null;
		}
		
		public function createSpriteForAtlas(name:String, x:Number, y:Number, width:Number, height:Number, spriteName:String):void
		{
			for (var i:int = 0; i < nAtlases; i++) 
			{
				var atlas:SkyTextureAtlas = atlases[i];
				
				if (atlas.name == name)
				{
					atlas.createSprite(width, height, x, y, spriteName);
					return;
				}
			}
		}
		
		public function getTexture(name:String):SkyTextureData
		{
			for (var i:int = 0; i < nTextures; i++) 
			{
				if (textures[i].name == name) return textures[i];
			}
			
			return null;
		}
		
		private function generateMimMaps(texture:Texture, byteArray:ByteArray = null, bitmapData:BitmapData = null):void
		{
			var currentWidth:int = bitmapData.width >> 1;
			var currentHeight:int = bitmapData.height >> 1;
			var level:int = 1;
			var canvas:BitmapData = new BitmapData(currentWidth, currentHeight, true, 0);
			var transform:Matrix = new Matrix(0.5, 0, 0, 0.5);
			
			while (currentWidth >= 1 || currentHeight >= 1)
			{
				canvas.fillRect(new Rectangle(0, 0, Math.max(currentWidth, 1), Math.max(currentHeight, 1)), 0);
				canvas.draw(bitmapData, transform, null, null, null, true);
				texture.uploadFromBitmapData(canvas, level++);
				transform.scale(0.5, 0.5);
				
				currentWidth = currentWidth >> 1;
				currentHeight = currentHeight >> 1;
			}
		}
	}
}