package skysand.display 
{
	public class SkyRenderObjectContainer extends SkyRenderObject
	{
		
		
		public function SkyRenderObjectContainer() 
		{
			
		}
		
		public function addChild(child:SkyRenderObjectContainer):void
		{
			if (children == null)
			{
				children = new Vector.<SkyRenderObjectContainer>();
				nChildren = 0;
			}
			
			nChildren++;
			child.parent = this;
			
			children.push(child);
		}
		
		/*override public function get x():Number 
		{
			return super.x;
		}
		
		override public function set x(value:Number):void 
		{
			super.x = value;
			
			if (children != null)
			{
				for (var i:int = 0; i < children.length; i++) 
				{
					children[i].x = x + children[i].localX;
				}
			}
		}*/
		
		public function get numChildren():int
		{
			return nChildren;
		}
	}
}