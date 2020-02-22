package skysand.interfaces 
{
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public interface ITextRenderer 
	{
		function free():void;
		function updateVertexBuffer():void;
		function uploadToTexture(bitmapData:BitmapData):void;
		function setBlendFactor(source:String, destination:String):void
		
		function get vertices():Vector.<Number>;
		function set skipRendering(value:Boolean):void;
	}
}