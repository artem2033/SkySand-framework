package skysand.utils 
{
	import skysand.interfaces.IPoolObject;
	
	/**
	 * ...
	 * @author codecoregames
	 */
	public class SkyPool extends Object
	{
		/**
		 * Массив для объектов.
		 */
		private var array:Vector.<IPoolObject>;
		
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
			array = new Vector.<IPoolObject>(capacity, fixed);
			
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
		public function release(item:IPoolObject):void
		{
			if (array.fixed && index + 1 >= array.length) return;
			
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
		 * Оставшееся количество объектов.
		 */
		public function get freeCount():uint
		{
			return array.length - index;
		}
		
		/**
		 * Получить объект из пула.
		 */
		public function get item():IPoolObject
		{
			var temp:IPoolObject;
			
			if (index > 0)
			{
				temp = array[index];
				index--;
				
				return temp;
			}
			else return new mClass();
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
		public function free():void
		{
			var length:int = array.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				array[i].free();
				array[i] = null;
				array.removeAt(0);
			}
			
			array = null;
			mClass = null;
		}
	}
}