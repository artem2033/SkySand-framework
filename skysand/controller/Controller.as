package skysand.controller 
{
	public class Controller 
	{
		public var objects:Array;
		
		public function Controller() 
		{
			objects = [];
		}
		
		public function add(object:IControlable):void
		{
			objects.push(object);
		}
		
		public function remove(object:IControlable):void
		{
			for (var i:int = 0; i < objects.length; ++i) 
			{
				if (objects[i] == object)
				{
					objects[i] = null;
					objects.splice(i, 1);
					break;
				}
			}
		}
		
		public function update(delay:Number):void
		{
			for (var i:int = 0; i < objects.length; ++i) 
			{
				objects[i].update(delay);
			}
		}
	}
}