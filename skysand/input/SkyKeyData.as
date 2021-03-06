package skysand.input 
{
	public class SkyKeyData extends Object
	{
		/**
		 * Код клавиши.
		 */
		public var сode:uint = 0;
		
		/**
		 * Текущее состояние при зажатой кнопке: 1 - нажата, 0 - не нажата.
		 */
		public var downState:uint = 0;
		
		/**
		 * Текущее состояние при нажатой кнопке: 1 - нажата, 0 - не нажата.
		 */
		public var pressedState:uint = 0;
		
		/**
		 * Основная функция привязанная к кнопке.
		 */
		public var mainMetod:Function = null;
		
		/**
		 * Дополнительная функция.
		 */
		public var secondMetod:Function = null;
		
		/**
		 * Выполнять функции пока нажата клавиши или нет.
		 */
		public var doWhileKeyDown:Boolean = false;
		
		/**
		 * Можно ли перезаписать функцию к данной клавише.
		 */
		public var isOverwritten:Boolean = true;
	}
}