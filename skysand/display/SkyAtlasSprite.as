package skysand.display 
{
	/**
	 * ...
	 * @author codecoregames
	 */
	public class SkyAtlasSprite extends Object
	{
		public var name:String;
		public var width:Number;
		public var height:Number;
		public var pivotX:Number;
		public var pivotY:Number;
		public var vertices:Vector.<Number>;
		
		public function SkyAtlasSprite()
		{
			name = "";
			width = 1;
			height = 1;
			pivotX = 0;
			pivotY = 0;
			vertices = new Vector.<Number>(8, true);
			
			for (var i:int = 0; i < 8; i++) 
			{
				vertices[i] = 0;
			}
		}
	}
}