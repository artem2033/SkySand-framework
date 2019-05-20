package skysand.display 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import skysand.utils.f2Vec;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Scene;
	import flash.geom.Rectangle;
	
	public class SkyCamera extends Object
	{
		public static const NONE:uint = 0;
		public static const FIXED_IN_POINT:uint = 1;
		public static const FIXED_ON_TARGET:uint = 2;
		public static const MOVE_GORIZONTAL:uint = 3;
		public static const MOVE_VERTICAL:uint = 4;
		//public static const MOVE_VERTICAL:uint = 4;
		
		private var viewTransform:Matrix3D;
		private var position:Vector3D;
		private var scaleX:Number;
		private var scaleY:Number;
		
		public function SkyCamera()
		{
			create();
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			position.x = x * scaleX;
			position.y = y * scaleY;
			viewTransform.position = position;
		}
		
		public function create():void
		{
			viewTransform = new Matrix3D();
			position = new Vector3D();
			
			scaleX = -2 / SkySand.SCREEN_WIDTH;
			scaleY = -2 / SkySand.SCREEN_HEIGHT;
		}
		
		public function setScreenSize(width:Number, height:Number):void
		{
			scaleX = -2 / width;
			scaleY = -2 / height;
		}
		
		public function get transformMatrix():Matrix3D
		{
			return viewTransform;
		}
	}
}