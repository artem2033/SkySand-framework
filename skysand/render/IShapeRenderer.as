package skysand.render 
{
	import flash.geom.Rectangle;
	import skysand.display.SkyShape;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public interface IShapeRenderer
	{
		function updateVertexBuffer():void;
		function remove(object:SkyShape):void;
		function add(object:SkyShape, indices:Vector.<uint> = null):void;
		
		function get allowCameraTransformation():Boolean;
		function set allowCameraTransformation(value:Boolean):void;
		function get vertices():Vector.<Number>;
		
		function set scissorRect(value:Rectangle):void;
		function get scissorRect():Rectangle;
	}
}