package skysand.mouse
{ 
	import skysand.animation.SkyClip;
	import skysand.animation.SkyAnimation;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SkyMouse extends Object
	{
		private static var _instance:SkyMouse;
		
		public var LBMPressed:Boolean = false;
		public var RBMPressed:Boolean = false;
		private var _stage:Stage;
		public var isDrag:Boolean = false;
		private var Anim:SkyAnimation;
		
		public function SkyMouse():void
		{
			if (_instance != null)
			{
				throw("getInstance()");
			}
			_instance = this;
		}
		
		public function initialize(_stage:Stage):void
		{
			this._stage = _stage;
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightDown);
			_stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, rightUp);
		}
		
		public function get x():Number
		{
			return _stage.mouseX;
		}
		
		public function get y():Number
		{
			return _stage.mouseY;
		}
		
		public static function get instance():SkyMouse
		{
			return (_instance == null) ? new SkyMouse() : _instance;
		}
		
		private function rightDown(me:MouseEvent):void
		{
			RBMPressed = true;
		}
		
		private function rightUp(me:MouseEvent):void
		{
			RBMPressed = false;
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			LBMPressed = true;
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			LBMPressed = false;
		}
		
		public function addCursor(key:String, clip:Class, point:Point):void
		{/*
			Anim = new FeatherAnimation();
			Anim.createAnimation(clip, 1, 1);
			var mouseCursorData:MouseCursorData = new MouseCursorData();
			//Anim.frames[0].applyFilter(Anim.frames[0], Anim.frames[0].rect, new Point(0, 0), new BlurFilter(4, 4, 1)); 
			mouseCursorData.data = Anim.frames;
			mouseCursorData.hotSpot = point;
			mouseCursorData.frameRate = 1;
			
			Mouse.registerCursor(key, mouseCursorData);*/
		}
	}
}