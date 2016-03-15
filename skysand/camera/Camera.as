package skysand.camera 
{
	import skysand.utils.f2Vec;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Scene;
	import flash.geom.Rectangle;
	
	public class Camera extends Sprite
	{
		public static const NONE:uint = 0;
		public static const FIXED_IN_POINT:uint = 1;
		public static const FIXED_ON_TARGET:uint = 2;
		public static const MOVE_GORIZONTAL:uint = 3;
		public static const MOVE_VERTICAL:uint = 4;
		//public static const MOVE_VERTICAL:uint = 4;
		
		public var scroll:f2Vec;
		public var buffer:BitmapData;
		
		private var bitmap:Bitmap;
		private var rect:Rectangle;
		private var cameraType:uint;
		private var _target:Object;
		
		public function Camera()
		{
			
		}
		
		public function free():void
		{
			buffer.dispose();
			buffer = null;
			bitmap = null;
			scroll = null;
		}
		
		public function init():void
		{
			scroll = new f2Vec(0, 0);
			rect = new Rectangle(0, 0, 640, 480);
			buffer = new BitmapData(640, 480, true, 0);
			bitmap = new Bitmap(buffer);
			_target = new Object();
			addChild(bitmap);
		}
		
		public function fixTarget(target:Object):void
		{
			_target = target;
		}
		
		public function startRender():void
		{
			buffer.lock();
			buffer.fillRect(rect, 0);
		}
		
		public function endRender():void
		{
			buffer.unlock();
		}
		
		public function update(delta_time:Number):void
		{
		}
	}
}