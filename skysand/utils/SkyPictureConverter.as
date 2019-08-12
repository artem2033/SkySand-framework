package skysand.utils 
{
	import flash.display.BitmapData;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	
	import skysand.debug.Console;
	import skysand.file.SkyAtlasSprite;
	import skysand.file.SkyTextureAtlas;
	import skysand.file.SkyAnimationData;
	
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
					decodedData.animations = decodeAnimations(tempBytes, decodedData.textureWidth, decodedData.textureHeight);
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
			
			if (atlas.animationsCount > 0)
			{
				atlasBytes.writeUTFBytes(ANIMATION);
				atlasBytes.writeShort(atlas.animationsCount);
			}
			
			for (i = 0; i < atlas.animationsCount; i++) 
			{
				var animation:SkyAnimationData = atlas.getAnimationByIndex(i);
				var length:int = animation.frames.length;
				
				atlasBytes.writeUTF(animation.name);
				atlasBytes.writeShort(length);
				
				for (var j:int = 0; j < length; j++) 
				{
					sprite = animation.frames[j];
					atlasBytes.writeUTF(sprite.name);
					atlasBytes.writeShort(sprite.width);
					atlasBytes.writeShort(sprite.height);
					atlasBytes.writeFloat(sprite.delay);
					atlasBytes.writeFloat(sprite.x);
					atlasBytes.writeFloat(sprite.y);
					atlasBytes.writeFloat(sprite.pivotX);
					atlasBytes.writeFloat(sprite.pivotY);
				}
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
				data.setUV(data.x, data.y, data.width, data.height, textureWidth, textureHeight);
				
				sprites.push(data);
			}
			
			return sprites;
		}
		
		/**
		 * Раскодировать данные с анимациями.
		 * @param	bytes данные.
		 * @param	textureWidth ширина текстуры.
		 * @param	textureHeight высота текстуры.
		 * @return возвращает массив с данными о каждой анимации.
		 */
		private static function decodeAnimations(bytes:ByteArray, textureWidth:Number, textureHeight:Number):Vector.<SkyAnimationData>
		{
			var length:int = bytes.readShort();
			var animations:Vector.<SkyAnimationData> = new Vector.<SkyAnimationData>();
			
			for (var i:int = 0; i < length; i++) 
			{
				var animation:SkyAnimationData = new SkyAnimationData();
				animation.name = bytes.readUTF();
				
				var framesCount:int = bytes.readShort();
				animation.frames = new Vector.<SkyAtlasSprite>(framesCount, true);
				
				for (var j:int = 0; j < framesCount; j++) 
				{
					var frame:SkyAtlasSprite = new SkyAtlasSprite();
					frame.name = bytes.readUTF();
					frame.width = bytes.readShort();
					frame.height = bytes.readShort();
					frame.delay = bytes.readFloat();
					frame.x = bytes.readFloat();
					frame.y = bytes.readFloat();
					frame.pivotX = bytes.readFloat();
					frame.pivotY = bytes.readFloat();
					frame.setUV(frame.x, frame.y, frame.width, frame.height, textureWidth, textureHeight);
					
					animation.frames[j] = frame;
				}
				
				animations.push(animation);
			}
			
			return animations;
		}
	}
}