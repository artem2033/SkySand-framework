package skysand.structures 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyLinkedList
	{
		private var mFirst:SkyListNode;
		private var last:SkyListNode;
		private var mLength:int = 0;
		private var mCurrent:SkyListNode;
		
		public function SkyLinkedList() 
		{
			
		}
		
		public function get first():SkyListNode
		{
			return mFirst;
		}
		
		public function add(node:SkyListNode):void
		{
			if (mFirst == null)
			{
				mFirst = node;
			}
			else
			{
				last.next = node;
				node.prev = last;
			}
			
			last = node;
			mLength++;
		}
		
		public function lock():void
		{
			mFirst.prev = last;
			last.next = mFirst;
		}
		
		public function get next():SkyListNode
		{
			mCurrent = mCurrent.next;
			return mCurrent;
		}
		
		public function reset():void
		{
			mCurrent = mFirst;
		}
		
		public function get prev():SkyListNode
		{
			mCurrent = mCurrent.prev;
			return mCurrent;
		}
		
		public function get current():SkyListNode
		{
			return mCurrent;
		}
		
		public function remove(node:SkyListNode):void
		{
			var current:SkyListNode = mFirst;
			
			for (var i:int = 0; i < mLength; i++) 
			{
				if (node == current)
				{
					current.prev.next = current.next;
					current.next.prev = current.prev;
					current = null;
					mLength--;
					break;
				}
				
				current = current.next;
			}
		}
		
		public function get length():int
		{
			return mLength;
		}
		
		public function elementAt(index:int):SkyListNode
		{
			if (index < 0) return null;
			var count:int = 0;
			
			for (mCurrent = mFirst; count < index; mCurrent = mCurrent.next)
			{
				count++; 
			}
			
			return mCurrent;
		}
		
		public function insertAt(index:int, node:SkyListNode):void
		{
			var count:int = 0;
			
			for (mCurrent = mFirst; count < index; mCurrent = mCurrent.next)
			{
				count++; 
			}
			if (mFirst == mCurrent) trace("toDo loop");
			node.next = mCurrent;
			mCurrent.prev = node;
			mLength++;
		}
	}
}