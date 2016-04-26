package skysand.display 
{
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	/**
	 * ...
	 * @author codecoregames
	 */
	public class SkyTextureData extends Object
	{
		public var bytes:ByteArray;
		public var bitmapData:BitmapData;
		public var name:String;
		public var width:Number;
		public var height:Number;
		public var texture:Texture;
		
		public function SkyTextureData() {}	
	}
}