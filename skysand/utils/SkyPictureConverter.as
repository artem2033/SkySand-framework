package skysand.utils 
{
	import flash.display.BitmapData;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyPictureConverter extends Object
	{
		public static const FILENAME:String = "STA";
		public static const VERSION_OF_STA:int = 1;
		public static const NONE:uint = 0;
		public static const DEFLATE:uint = 1;
		public static const LZMA:uint = 2;
		public static const ZLIB:uint = 3;
		
		/**
		 * Данные о декодированных пикселях.
		 */
		private var data:ByteArray;
		
		/**
		 * Данные конвертированного файла.
		 */
		private var picture:ByteArray;
		
		public function SkyPictureConverter()
		{
			data = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			
			picture = new ByteArray();
		}
		
		/**
		 * Конвертировать картинку из битмап в ssp файл.
		 * @param	bitmap исходная картинка.
		 * @param	name название.
		 * @param	atlasData данные о спрайтах на атласе.
		 * @param	compression тип сжатия.
		 * @return возвращает массив байтов в виде ssp файла.
		 */
		public function convert(bitmapData:BitmapData, name:String, atlasData:ByteArray, compression:int = DEFLATE):ByteArray
		{
			data.clear();
			data.endian = Endian.LITTLE_ENDIAN;
			bitmapData.copyPixelsToByteArray(bitmapData.rect, data);
			data.position = 0;
			
			if (compression == DEFLATE)
			{
				data.compress(CompressionAlgorithm.DEFLATE);
				if (atlasData != null) atlasData.compress(CompressionAlgorithm.DEFLATE);
			}
			else if (compression == LZMA)
			{
				data.compress(CompressionAlgorithm.LZMA);
				if (atlasData != null) atlasData.compress(CompressionAlgorithm.LZMA);
			}
			else if (compression == ZLIB)
			{
				data.compress(CompressionAlgorithm.ZLIB);
				if (atlasData != null) atlasData.compress(CompressionAlgorithm.ZLIB);
			}
			
			picture.clear();
			picture.writeByte(0);
			picture.writeUTFBytes(FILENAME);
			picture.writeByte(VERSION_OF_STA);
			picture.writeByte(compression);
			picture.writeInt(bitmapData.width);
			picture.writeInt(bitmapData.height);
			picture.writeUTF(name);
			
			if (atlasData != null) 
			{
				picture.writeUnsignedInt(atlasData.length);
				picture.writeBytes(atlasData, 0, atlasData.length);
			}
			
			picture.writeUTFBytes("DAT");
			picture.writeBytes(data, 0, data.length);
			picture.writeUTFBytes("EOF");
			picture.writeByte(0);
			
			return picture;
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			data.clear();
			data = null;
			
			picture.clear();
			picture = null;
		}
	}
}