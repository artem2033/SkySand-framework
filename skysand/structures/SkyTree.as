package skysand.structures 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyTree 
	{
		private var list:Vector.<Number>;
		
		public function SkyTree() 
		{
			list = new Vector.<Number>();
		}
		
		public function contains(element:Number):Boolean
		{
			var low:int = 0;
			var high:int = list.length - 1;
			
			while (low <= high)
			{
				var mid:int = int((low + high) * 0.5);
				var value:Number = list[mid];
				
				if (value < element)
				{
					low = mid + 1; 
				}
				else if (value > element)
				{
					high = mid - 1;
				}
				else return true;
			}
			
			return false;
		}
		
		public function add(element:Number):void
		{
			var length:int = list.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				if (list[i] == element) return;
				
				if (element < list[i])
				{
					list.insertAt(i, element);
					return;
				}
			}
			
			list.push(element);
		}
		
		public function remove(element:Number):void
		{
			list.removeAt(list.indexOf(element));
		}
		
		public function toString():String
		{
			return list.toString();
		}
	}
}