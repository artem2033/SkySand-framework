package skysand.featherPool 
{
	public class Pool 
	{
		private var pool:Array;
		private var currentClass:Class;
		private var index:int = 0;
		
		public function Pool() 
		{
			
		}
		
		public function create(_class:Class, capacity:int):void
		{
			pool = [];
			index = capacity - 1;
			currentClass = _class;
			
			for (var i:int = 0; i < capacity; ++i) 
			{
				pool[i] = getNewItem();
			}
		}
		
		private function getNewItem():Object
		{
			return new currentClass();
		}
		
		public function release(object:Object):void
		{
			index++;
			
			if (index == pool.length)
			{
				pool[pool.length] = object;
			}
			else
			{
				pool[index] = object;
			}
		}
		
		public function getItem():Object
		{
			if (index >= 0)
			{
				index--;
				
				return pool[index + 1];
			}
			else
			{
				return getNewItem();
			}
		}
		
		public function toString():void
		{
			trace("pool consists of " + pool.length + " " + currentClass);
			trace("Current lenght of pool " + index + " " + currentClass);
			trace("------------------------------------");
		}
	}
}