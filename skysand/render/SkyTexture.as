package skysand.render
{
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.TextureBase;
	import flash.display3D.textures.Texture;
	
	import skysand.utils.SkyUtils;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyTexture extends Object
	{
		/**
		 * Контекст.
		 */
		private var context3D:Context3D;
		
		/**
		 * Текстура.
		 */
		private var mTexture:TextureBase;
		
		/**
		 * Ширина.
		 */
		private var mWidth:Number;
		
		/**
		 * Высота.
		 */
		private var mHeight:Number;
		
		/**
		 * Формат текстуры.
		 */
		private var mFormat:String;
		
		/**
		 * Оптимизировать ли текстуру для рендера в неё.
		 */
		private var mOptimizeForRenderToTexture:Boolean;
		
		/**
		 * @param	width ширина текстуры.
		 * @param	height высота текстуры.
		 * @param	format формат текстуры.
		 * @param	optimizeForRenderToTexture оптимизировать ли текстуру для рендера в неё.
		 */
		public function SkyTexture(width:Number, height:Number, format:String = Context3DTextureFormat.BGRA, optimizeForRenderToTexture:Boolean = false) 
		{
			context3D = SkySand.CONTEXT_3D;
			
			createTexture(width, height, format, optimizeForRenderToTexture);
		}
		
		/**
		 * Изменить размеры текстуры.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function setSize(width:Number, height:Number):void
		{
			if (width != mWidth || height != mHeight)
			{
				mTexture.dispose();
				createTexture(width, height, mFormat, mOptimizeForRenderToTexture);
				
				mWidth = width;
				mHeight = height;
			}
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			mTexture.dispose();
			mTexture = null;
			context3D = null;
		}
		
		/**
		 * Загрузить данные из битмапы.
		 * @param	bitmapData ссылка на битмапу.
		 */
		public function uploadFromBitmapData(bitmapData:BitmapData):void
		{
			if (mTexture is Texture)
			{
				Texture(mTexture).uploadFromBitmapData(bitmapData);
			}
			else
			{
				RectangleTexture(mTexture).uploadFromBitmapData(bitmapData);
			}
		}
		
		/**
		 * Загрузить данные из битмапы асинхронно.
		 * @param	bitmapData ссылка на битмапу.
		 */
		public function uploadFromBitmapDataAsync(bitmapData:BitmapData):void
		{
			if (mTexture is Texture)
			{
				Texture(mTexture).uploadFromBitmapDataAsync(bitmapData);
			}
			else
			{
				RectangleTexture(mTexture).uploadFromBitmapDataAsync(bitmapData);
			}
		}
		
		/**
		 * Загрузить данные из массива байт.
		 * @param	bytes ссылка на массив.
		 * @param	offset начало чтения массива.
		 */
		public function uploadFromByteArray(bytes:ByteArray, offset:uint = 0):void
		{
			if (mTexture is Texture)
			{
				Texture(mTexture).uploadFromByteArray(bytes, offset);
			}
			else
			{
				RectangleTexture(mTexture).uploadFromByteArray(bytes, offset);
			}
		}
		
		/**
		 * Загрузить данные из массива байт асинхронно.
		 * @param	bytes ссылка на массив.
		 * @param	offset начало чтения массива.
		 */
		public function uploadFromByteArrayAsync(bytes:ByteArray, offset:uint = 0):void
		{
			if (mTexture is Texture)
			{
				Texture(mTexture).uploadFromByteArrayAsync(bytes, offset);
			}
			else
			{
				RectangleTexture(mTexture).uploadFromByteArrayAsync(bytes, offset);
			}
		}
		
		/**
		 * Высота.
		 */
		public function get width():Number
		{
			return mWidth;
		}
		
		/**
		 * Ширина.
		 */
		public function get height():Number
		{
			return mHeight;
		}
		
		/**
		 * Текстура.
		 */
		public function get data():TextureBase
		{
			return mTexture;
		}
		
		/**
		 * Создать текстуру.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	format формат текстуры.
		 * @param	optimizeForRenderToTexture оптимизировать ли текстуру для рендера в неё.
		 */
		private function createTexture(width:Number, height:Number, format:String, optimizeForRenderToTexture:Boolean):void
		{
			if (width == height && SkyUtils.isPowerOfTwo(width))
			{
				mTexture = context3D.createTexture(width, height, format, optimizeForRenderToTexture);
			}
			else mTexture = context3D.createRectangleTexture(width, height, format, optimizeForRenderToTexture);
			
			mWidth = width;
			mHeight = height;
			mFormat = format;
			mOptimizeForRenderToTexture = optimizeForRenderToTexture;
		}
	}
}