package skysand.utils 
{
	import flash.display.BitmapData;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import skysand.debug.Console;
	import skysand.file.SkyAtlasSprite;
	import skysand.file.SkyTextureAtlas;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyPictureConverter extends Object
	{
		public static const FILENAME:String = "STA";
		public static const VERSION_OF_STA:int = 1;
		public static const SPRITE:String = "SPR";
		public static const ANIMATION:String = "ANM";
		public static const ANIMATION_LINE:String = "AML";
		public static const COMPRESSION_NONE:String = "none";
		
		/**
		 * Данные конвертированного файла.
		 */
		private static var picture:ByteArray;
		
		/**
		 * Массив для временной записи данных и их обработки.
		 */
		private static var tempBytes:ByteArray;
		
		/**
		 * Массив с закодированными данными в атласе.
		 */
		private static var atlasBytes:ByteArray;
		
		/**
		 * Декодированные данные.
		 */
		private static var decodedData:SkyPictureDecodedData;
		
		public function SkyPictureConverter()
		{
			
		}
		
		/**
		 * Закодировать картинку из битмап в sta файл.
		 * @param	bitmap исходная картинка.
		 * @param	name название.
		 * @param	atlasData данные о спрайтах на атласе.
		 * @param	compression тип сжатия.
		 * @return возвращает массив байтов в виде sta файла.
		 */
		public static function encode(bitmapData:BitmapData, name:String, atlasData:ByteArray, compression:String = CompressionAlgorithm.DEFLATE):ByteArray
		{
			if (picture == null) init();
			
			tempBytes.clear();
			tempBytes.endian = Endian.LITTLE_ENDIAN;
			bitmapData.copyPixelsToByteArray(bitmapData.rect, tempBytes);
			tempBytes.position = 0;
			
			if (compression != COMPRESSION_NONE)
			{
				tempBytes.compress(compression);
				if (atlasData != null) atlasData.compress(compression);
			}
			
			picture.clear();
			picture.writeByte(0);
			picture.writeUTFBytes(FILENAME);
			picture.writeByte(VERSION_OF_STA);
			picture.writeUTF(compression);
			picture.writeShort(bitmapData.width);
			picture.writeShort(bitmapData.height);
			picture.writeUTF(name);
			
			if (atlasData != null) 
			{
				picture.writeUTFBytes("TAD");
				picture.writeUnsignedInt(atlasData.length);
				picture.writeBytes(atlasData, 0, atlasData.length);
			}
			
			picture.writeUTFBytes("TBA");
			picture.writeUnsignedInt(tempBytes.length);
			picture.writeBytes(tempBytes, 0, tempBytes.length);
			picture.writeUTFBytes("EOF");
			picture.writeByte(0);
			
			return picture;
		}
		
		/**
		 * Раскодировать sta формат в данные для текстурного атласа.
		 * @param	bytes массив байт для раскодировки.
		 * @return возвращает раскодированные данные.
		 */
		public static function decode(bytes:ByteArray):SkyPictureDecodedData
		{
			if (picture == null) init();
			bytes.position = 1;
			
			if (bytes.readUTFBytes(3) != FILENAME)
			{
				throw new Error("Error: incorrect file to decode!");
			}
			
			if (bytes.readByte() < VERSION_OF_STA)
			{
				throw new Error("Error: sta file is outdated!");
			}
			
			decodedData.textureBytes = new ByteArray();
			decodedData.compression = bytes.readUTF();
			decodedData.textureWidth = bytes.readShort();
			decodedData.textureHeight = bytes.readShort();
			decodedData.name = bytes.readUTF();
			
			if (bytes.readUTFBytes(3) == "TAD")
			{
				tempBytes.clear();
				bytes.readBytes(tempBytes, 0, bytes.readUnsignedInt());
				
				if (decodedData.compression != COMPRESSION_NONE)
					tempBytes.uncompress(decodedData.compression);
				
				tempBytes.position = 0;
				
				if (tempBytes.readUTFBytes(3) == SPRITE)
				{
					decodedData.sprites = decodeSprites(tempBytes, decodedData.textureWidth, decodedData.textureHeight);
				}
				else tempBytes.position -= 3;
				
				if (tempBytes.position != tempBytes.length && tempBytes.readUTFBytes(3) == ANIMATION)
				{
					Console.log("Write animation decoding", Console.RED);
				}
				else tempBytes.position -= 3;
			}
			else bytes.position -= 3;
			
			if (bytes.readUTFBytes(3) == "TBA")
			{
				bytes.readBytes(decodedData.textureBytes, 0, bytes.readUnsignedInt());
				
				if (decodedData.compression != COMPRESSION_NONE)
					decodedData.textureBytes.uncompress(decodedData.compression);
			}
			
			return decodedData;
		}
		
		/**
		 * Закодировать данные из атласа в массив байт.
		 * @param	atlas ссылка на атлас.
		 * @return возвращает массив байт.
		 */
		public static function getBytesFromAtlas(atlas:SkyTextureAtlas):ByteArray
		{
			if (picture == null) init();
			
			atlasBytes.clear();
			
			if (atlas.spriteCount > 0)
			{
				atlasBytes.writeUTFBytes(SPRITE);
				atlasBytes.writeShort(atlas.spriteCount);
			}
			
			for (var i:int = 0; i < atlas.spriteCount; i++) 
			{
				var sprite:SkyAtlasSprite = atlas.getSpriteByIndex(i);
				atlasBytes.writeUTF(sprite.name);
				atlasBytes.writeShort(sprite.width);
				atlasBytes.writeShort(sprite.height);
				atlasBytes.writeFloat(sprite.x);
				atlasBytes.writeFloat(sprite.y);
				atlasBytes.writeFloat(sprite.pivotX);
				atlasBytes.writeFloat(sprite.pivotY);
			}
			
			return atlasBytes;
		}
		
		/**
		 * Освободить память.
		 */
		public static function free():void
		{
			tempBytes.clear();
			tempBytes = null;
			
			picture.clear();
			picture = null;
			
			atlasBytes.clear();
			atlasBytes = null;
			
			decodedData.sprites.length = 0;
			decodedData.sprites = null;
			decodedData.animations.length = 0;
			decodedData.animations = null;
			decodedData = null;
		}
		
		/**
		 * Инициализация.
		 */
		private static function init():void
		{
			tempBytes = new ByteArray();
			decodedData = new SkyPictureDecodedData();
			atlasBytes = new ByteArray();
			picture = new ByteArray();
		}
		
		/**
		 * Раскодировать данные о спрайтах.
		 * @param	bytes данные.
		 * @param	textureWidth ширина текстуры.
		 * @param	textureHeight высота текстуры.
		 * @return возвращает массив с данными о каждом спрайте.
		 */
		private static function decodeSprites(bytes:ByteArray, textureWidth:Number, textureHeight:Number):Vector.<SkyAtlasSprite>
		{
			var length:int = bytes.readShort();
			var sprites:Vector.<SkyAtlasSprite> = new Vector.<SkyAtlasSprite>();
			
			for (var i:int = 0; i < length; i++) 
			{
				var data:SkyAtlasSprite = new SkyAtlasSprite();
				data.name = bytes.readUTF();
				data.width = bytes.readShort();
				data.height = bytes.readShort();
				data.x = bytes.readFloat();
				data.y = bytes.readFloat();
				data.pivotX = bytes.readFloat();
				data.pivotY = bytes.readFloat();
				
				data.uvs = new Vector.<Number>(8, true);
				data.uvs[0] = data.x / textureWidth;
				data.uvs[1] = data.y / textureHeight;
				data.uvs[2] = (data.x + data.width) / textureWidth;
				data.uvs[3] = data.y / textureHeight;
				data.uvs[4] = data.x / textureWidth;
				data.uvs[5] = (data.y + data.height) / textureHeight;
				data.uvs[6] = (data.x + data.width) / textureWidth;
				data.uvs[7] = (data.y + data.height) / textureHeight;
				
				sprites.push(data);
			}
			
			return sprites;
		}
	}
}