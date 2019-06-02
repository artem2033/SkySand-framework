package skysand.file 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyAnimationData
	{
		public var name:String = "";
		public var frames:Vector.<SkyAtlasSprite> = new Vector.<SkyAtlasSprite>();
		
		public function SkyAnimationData()
		{
			
		}
		
		public function free():void
		{
			var length:int = frames.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				frames[i].uvs.length = 0;
				frames[i].uvs = null;
				frames[i] = null;
			}
			
			frames.length = 0;
			frames = null;
		}
	}
}