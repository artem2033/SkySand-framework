package skysand.file 
{
	/**
	 * ...
	 * @author codecoregames
	 */
	public class SkyAtlasSprite extends Object
	{
		public var name:String = "";
		public var width:Number = 1;
		public var height:Number = 1;
		public var pivotX:Number = 0;
		public var pivotY:Number = 0;
		public var delay:Number = 0;
		public var x:Number = 0;
		public var y:Number = 0;
		public var uvs:Vector.<Number>;
		
		public function SkyAtlasSprite()
		{
			
		}
		
		public function setUV(x:Number, y:Number, width:Number, height:Number, textureWidth:Number, textureHeight:Number):void
		{
			if (uvs == null) uvs = new Vector.<Number>(8, true);
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			uvs[0] = x / textureWidth;
			uvs[1] = y / textureHeight;
			uvs[2] = (x + width) / textureWidth;
			uvs[3] = y / textureHeight;
			uvs[4] = x / textureWidth;
			uvs[5] = (y + height) / textureHeight;
			uvs[6] = (x + width) / textureWidth;
			uvs[7] = (y + height) / textureHeight;
		}
	}
}