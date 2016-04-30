package skysand.display
{
	import skysand.render.hardware.SkyRenderType;
	
	public class SkySprite extends SkyRenderObjectContainer
	{
		public function SkySprite()
		{
			renderType = SkyRenderType.SIMPLE_SPRITE;
		}
		
		public function setAtlasSprite(name:String):void
		{
			
		}
	}
}