package skysand.utils 
{
	/**
	 * ...
	 * @author codecoregames
	 */
	public class SkyPool extends Object
	{
		/**
		 * Массив для объектов.
		 */
		private var array:Vector.<*>;
		
		/**
		 * Класс объектов.
		 */
		private var mClass:Class;
		
		/**
		 * Текущий номер свободного объекта.
		 */
		private var index:int;
		
		public function SkyPool()
		{
			array = null;
			mClass = null;
			index = 0;
		}
		
		/**
		 * Инициализировать пул.
		 * @param	_class класс объектов которые будут храниться.
		 * @param	capacity начальный размер пула.
		 * @param	fixed фиксированная длина пула.
		 */
		public function initialize(_class:Class, capacity:uint, fixed:Boolean = false):void
		{
			mClass = _class;
			array = new Vector.<mClass>(capacity, fixed);
			
			for (var i:int = 0; i < capacity; i++)
			{
				array[i] = new mClass();
			}
			index = capacity - 1;
		}
		
		/**
		 * Вернуть объект в пул.
		 * @param	item объект.
		 */
		public function release(item:*):void
		{
			index++;
			array[index] = item;
		}
		
		/**
		 * Получить максимальный размер пула.
		 */
		public function get length():uint
		{
			return array.length;
		}
		
		/**
		 * Получить объект из пула.
		 */
		public function get item():*
		{
			var temp:*;
			
			if (index > 0)
			{
				temp = array[index];
				index--;
				
				return temp;
			}
			else
			{
				return new mClass();
			}
		}
		
		/**
		 * Размер пула.
		 * @return возвращает строку с текущим размером пула.
		 */
		public function toString():String
		{
			return "Pool of " + mClass + " size " + (index + 1) + " of " + array.length;
		}
		
		/**
		 * Очистить пул.
		 */
		public function clear():void
		{
			var length:int = array.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				array[i] = null;
				array.removeAt(0);
			}
		}
	}
}