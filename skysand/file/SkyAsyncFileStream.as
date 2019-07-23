package skysand.file 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import skysand.utils.SkyPool;
	import skysand.interfaces.IPoolObject;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyAsyncFileStream implements IPoolObject
	{
		/**
		 * Поток для открытия и чтения файла.
		 */
		private var stream:FileStream;
		
		/**
		 * Байты загруженные из файла.
		 */
		private var bytes:ByteArray;
		
		/**
		 * Пул хранящий асинхронные файлы.
		 */
		private var pool:SkyPool;
		
		/**
		 * Функция, вызываемая во время завершения открытия и загрузки файла.
		 */
		private var onOpenListener:Function;
		
		public function SkyAsyncFileStream() 
		{
			stream = new FileStream();
			stream.addEventListener(Event.COMPLETE, onCompleteListener);
		}
		
		/**
		 * Открыть файл асинхронно.
		 * @param	file ссылка на файл.
		 * @param	listener слушатель окончания загрузки, принимает 1 параметр в виде массива байт.
		 * @param	pool ссылка на пул данных файлов.
		 */
		public function open(file:File, listener:Function, pool:SkyPool):void
		{
			this.pool = pool;
			onOpenListener = listener;
			stream.openAsync(file, FileMode.READ);
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			stream.removeEventListener(Event.COMPLETE, onCompleteListener);
			stream = null;
			bytes = null;
			pool = null;
			onOpenListener = null;
		}
		
		/**
		 * Слушатель на завершение открытия файла.
		 */
		private function onCompleteListener(event:Event):void
		{
			bytes = new ByteArray();
			stream.readBytes(bytes);
			
			onOpenListener.apply(null, [bytes]);
			stream.close();
			pool.release(this);
		}
	}
}