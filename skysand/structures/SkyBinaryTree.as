package skysand.structures 
{
	import skysand.debug.Console;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyBinaryTree 
	{
		private var root:SkyBinaryNode;
		
		public function SkyBinaryTree() 
		{
			
		}
		
		public function contains(element:SkyBinaryNode):Boolean
		{
			return false;
		}
		
		public function add(key:Number, data:Object):void
		{
			var x:SkyBinaryNode = root;
			var y:SkyBinaryNode = null;
			
			while (x != null)
			{
				if (x.key == key) return;
				else
				{
					y = x;
					x = x.key > key ? x.left : x.right;
				}
			}
			
			var node:SkyBinaryNode = new SkyBinaryNode();
			node.data = data;
			node.key = key;
			
			if (y == null)
			{
				root = node;
			}
			else
			{
				if (y.key > key)
					y.left = node;
				else 
					y.right = node;
			}
		}
		
		public function toString():String
		{
			print(root);
			return string;
		}
		private var string:String = "";
		
		private function print(node:SkyBinaryNode):void
		{
			string += node.key + "\n";
			
			if (node.left) print(node.left);
			if (node.right) print(node.right);
		}
	}
}