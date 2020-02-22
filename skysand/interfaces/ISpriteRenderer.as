package skysand.interfaces 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import skysand.display.SkySprite;
	import skysand.file.SkyAtlasSprite;
	import skysand.render.SkyTexture;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public interface ISpriteRenderer 
	{
		function updateVertexBuffer():void;
		function remove(sprite:SkySprite):void;
		function contains(sprite:SkySprite):Boolean;
		function add(sprite:SkySprite, data:SkyAtlasSprite):void;
		
		function setTextureFromBitmapData(bitmapData:BitmapData):void;
		function setTexture(texture:SkyTexture):void;
		function setBlendFactor(source:String, destination:String):void;
		function setTextureFilter(filter:String):void;
		function setWrapMode(mode:String):void;
		
		function set scissorRect(value:Rectangle):void;
		function get scissorRect():Rectangle;
		
		function get uvs():Vector.<Number>;
		function get vertices():Vector.<Number>;
	}
}