package skysand.utils 
{
	import flash.utils.ByteArray;
	
	import skysand.file.SkyAtlasSprite;
	import skysand.file.SkyAnimationData;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyPictureDecodedData extends Object
	{
		/**
		 * Название атласа.
		 */
		public var name:String;
		
		/**
		 * Ширина текстуры.
		 */
		public var textureWidth:int;
		
		/**
		 * Высота текстуры.
		 */
		public var textureHeight:int;
		
		/**
		 * Тип сжатия файла.
		 */
		public var compression:String;
		
		/**
		 * Массив с данными для текстуры.
		 */
		public var textureBytes:ByteArray;
		
		/**
		 * Массив с данными о спрайтах.
		 */
		public var sprites:Vector.<SkyAtlasSprite>;
		
		/**
		 * Массив с данными о анимациях.
		 */
		public var animations:Vector.<SkyAnimationData>;
	}
}