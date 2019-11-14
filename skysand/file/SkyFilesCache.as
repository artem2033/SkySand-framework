package skysand.file 
{
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.FileListEvent;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import skysand.utils.SkyPool;
	
	import skysand.debug.Console;
	import skysand.file.SkyAtlasSprite;
	import skysand.file.SkyTextureAtlas;
	
	public class SkyFilesCache extends Object
	{
		public static const APPLICATION_STORAGE_DIRECTORY:uint = 0;
		public static const APPLICATION_DIRECTORY:uint = 1;
		public static const DOCUMENTS_DIRECTORY:uint = 2;
		public static const DESKTOP_DIRECTORY:uint = 3;
		public static const CACHE_DIRECTORY:uint = 4;
		public static const USER_DIRECTORY:uint = 5;
		
		/**
		 * Загрузчик.
		 */
		private var loader:Loader;
		
		/**
		 * Функция срабатывающая после загрузки картинки.
		 */
		private var pictureListener:Function;
		
		/**
		 * Фильтр для файлов.
		 */
		private var imagesFilter:FileFilter;
		
		/**
		 * Файл, для работы с данными.
		 */
		private var file:File;
		
		/**
		 * Массив текстурных атласов.
		 */
		private var atlases:Vector.<SkyTextureAtlas>;
		
		/**
		 * Счётчик для номера загруженной картинки.
		 */
		private var count:int = 0;
		
		/**
		 * Событие выбора нескольких картинок.
		 */
		private var fileListEvent:FileListEvent;
		
		/**
		 * Пул с асинхронными объектами.
		 */
		private static var asyncFiles:SkyPool;
		
		/**
		 * Поток файлов для чтения из файла и записи в него.
		 */
		private static var fileStream:FileStream;
		
		public function SkyFilesCache()
		{
			
		}
		
		/**
		 * Инициализировать класс.
		 * @param	context3D ссылка на context3D.
		 */
		public function initialize():void
		{
			imagesFilter = new FileFilter("Images", "*.jpg;*.gif;*.png");
			atlases = new Vector.<SkyTextureAtlas>();
			fileStream = new FileStream();
			loader = new Loader();
			
			asyncFiles = new SkyPool();
			asyncFiles.initialize(SkyAsyncFileStream, 8);
		}
		
		/**
		 * Загрузить xml из директории приложения.
		 * @param	path путь к файлу.
		 * @return возвращает загруженный xml.
		 */
		public static function loadXml(path:String):XML
		{
			var file:File = File.applicationDirectory.resolvePath(path);
			
			fileStream.open(file, "read");
			var xml:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			
			return xml;
		}
		
		/**
		 * Получить файл из определённой директории.
		 * @param	path путь к файлу.
		 * @param	directory директория.
		 * @return возвращает файл.
		 */
		public static function getFile(path:String, directory:uint):File
		{
			switch(directory)
			{
				case APPLICATION_STORAGE_DIRECTORY:
					{
						return File.applicationStorageDirectory.resolvePath(path);
					}
					
				case APPLICATION_DIRECTORY:
					{
						return File.applicationDirectory.resolvePath(path);
					}
					
				case DOCUMENTS_DIRECTORY:
					{
						return File.documentsDirectory.resolvePath(path);
					}
					
				case DESKTOP_DIRECTORY:
					{
						return File.desktopDirectory.resolvePath(path);
					}
					
				case CACHE_DIRECTORY:
					{
						return File.cacheDirectory.resolvePath(path);
					}
					
				case USER_DIRECTORY:
					{
						return File.userDirectory.resolvePath(path);
					}
			}
			
			return null;
		}
		
		/**
		 * Загрузить массив байтов из файла.
		 * @param	file файл.
		 * @return возвращает массив байтов.
		 */
		public static function loadBytesFromFile(file:File):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			
			fileStream.open(file, "read");
			fileStream.readBytes(bytes);
			fileStream.close();
			
			return bytes;
		}
		
		/**
		 * Загрузить массив байтов из файла.
		 * @param	file файл.
		 * @return возвращает массив байтов.
		 */
		public static function loadBytesFromFileAsync(file:File, listener:Function):void
		{
			var stream:SkyAsyncFileStream = SkyAsyncFileStream(asyncFiles.item);
			stream.open(file, listener, asyncFiles);
		}
		
		/**
		 * Сохранить байты в выбранную директорию.
		 * @param	bytes массив байтов.
		 */
		public static function saveBytes(bytes:ByteArray):void
		{
			var file:File = new File();
			file.save(bytes);
		}
		
		/**
		 * Добавить атлас в кэш.
		 * @param	atlas тесктурный атлас.
		 */
		public function addTextureAtlas(atlas:SkyTextureAtlas):void
		{
			var length:int = atlases.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				if (atlases[i].name == atlas.name)
				{
					Console.log("Error: Texture atlas with name " + atlas.name + " is contains in cache!", Console.RED);
					return;
				}
			}
			
			atlases.push(atlas);
		}
		
		/**
		 * Содержится ли атлас в кэше с таким именем.
		 * @param	name имя атласа.
		 * @return true - содержится, false - нет.
		 */
		public function isAtlasContains(name:String):Boolean
		{
			var length:int = atlases.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				if (atlases[i].name == name)
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Получить тестурный атлас из кэша.
		 * @param	name имя атласа.
		 * @return возвращает текстурный атлас.
		 */
		public function getTextureAtlas(name:String):SkyTextureAtlas
		{
			var length:int = atlases.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var atlas:SkyTextureAtlas = atlases[i];
				
				if (atlas.name == name)
				{
					return atlas;
				}
			}
			
			throw new Error("Error: Texture atlas absent in cache!");
			
			return null;
		}
		
		/**
		 * Удалить тестурный атлас из кэша.
		 * @param	name имя атласа.
		 */
		public function removeTextureAtlas(name:String):void
		{
			var length:int = atlases.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var atlas:SkyTextureAtlas = atlases[i];
				
				if (atlas.name == name)
				{
					atlases.removeAt(i);
					return;
				}
			}
		}
		
		/*private function generateMimMaps(texture:Texture, byteArray:ByteArray = null, bitmapData:BitmapData = null):void
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
		}*/
		
		/**
		 * Запрос на открытие картинки из файловой системы.
		 * @param	listener функция, срабатывающая при загрузке картинки, принимает 1 параметр - Bitmap.
		 * @param	multiple открыть одну или несколько картинок.
		 */
		public function browseForOpenPicture(listener:Function, multiple:Boolean = false):void
		{
			pictureListener = listener; 
			
			file = new File();
			
			if (multiple)
			{
				file.browseForOpenMultiple("", [imagesFilter]);
				file.addEventListener(FileListEvent.SELECT_MULTIPLE, onMultipleSelectListener);
			}
			else
			{
				file.browseForOpen("", [imagesFilter]);
				file.addEventListener(Event.SELECT, onSelectListener);
			}
		}
		
		/**
		 * Событие, срабатывающее при выборе картинок больше одной.
		 * @param	event событие выбора картинок.
		 */
		public function onMultipleSelectListener(event:FileListEvent):void
		{
			file.removeEventListener(FileListEvent.SELECT_MULTIPLE, onMultipleSelectListener);
			fileListEvent = event;
			
			var bytes:ByteArray = new ByteArray();
			
			fileStream.open(event.files[count], FileMode.READ);
			fileStream.readBytes(bytes);
			fileStream.close();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteListener);
			loader.loadBytes(bytes);
		}
		
		/**
		 * Функция срабатывающая при выборе картинки, запускает загрузчик.
		 * @param	event событие выбора картинки.
		 */
		private function onSelectListener(event:Event):void
		{
			file.removeEventListener(Event.SELECT, onSelectListener);
			
			var bytes:ByteArray = new ByteArray();
			
			fileStream.open(file, FileMode.READ);
			fileStream.readBytes(bytes);
			fileStream.close();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteListener);
			loader.loadBytes(bytes);
		}
		
		/**
		 * Функция завершения загрузки картинки.
		 * @param	event событие завершения загрузки.
		 */
		private function onCompleteListener(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteListener);
			pictureListener.apply(null, [loader.content as Bitmap]);
			
			if (fileListEvent != null)
			{
				count++;
				
				if (count < fileListEvent.files.length) onMultipleSelectListener(fileListEvent);
				else 
				{
					count = 0;
					fileListEvent = null;
				}
			}
		}
	}
}