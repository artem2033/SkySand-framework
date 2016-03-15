package skysand.animation
{
	import flash.geom.Rectangle;
	import skysand.animation.SkyAnimationCache;
	import skysand.animation.SkyAnimation;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.*;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import skysand.interfaces.IFrameworkUpdatable;
	import skysand.render.Render;
	import skysand.render.RenderObject;
	
	use namespace framework;
	
	public class SkyClip extends RenderObject implements IFrameworkUpdatable
	{
		/**
		 * Повтор анимации.
		 */
		public var repeat:Boolean;
		
		/**
		 * скорость воспроизведения анимации.
		 */
		public var frameSpeed:Number;
		
		/**
		 * Имя клипа.
		 */
		public var clipName:String;
		
		/**
		 * Общее число кадров.
		 */
		private var totalFrames:int;
		
		/**
		 * Текущее количество кадров.
		 */
		public var currentFrame:Number;
		
		/**
		 * Завершена ли анимация.
		 */
		public var animationComplete:Boolean;
		
		/**
		 * Анимация
		 */
		private var animation:SkyAnimation;
		
		/**
		 * Воспроизводится ли анимация.
		 */
		private var playing:Boolean;
		
		public function SkyClip()
		{
			playing = false;
			animationComplete = false;
			repeat = true;
			frameSpeed = 1;
			currentFrame = 1;
		}
		
		public function setAnimation(name:String):void
		{
			var cache:SkyAnimationCache = SkyAnimationCache.instance;
			animation = cache.getAnimation(name);	
			totalFrames = animation.frames.length;
			drawFrame(currentFrame);
			clipName = name;
		}
		
		private function draw():void
		{
			
		}
		
		public function switchAnimation(clipName:String):void
		{
			
		}
		
		/**
		 * Воспроизвести анимацию.
		 */
		public function play():void
		{
			if (!playing) playing = true;
		}
		
		/**
		 * Остановить анимацию.
		 */
		public function stop():void
		{
			if (playing) playing = false;
		}
		
		/**
		 * Перейти на нужный кадр.
		 * @param	frame номер кадра.
		 */
		public function gotoFrame(frame:int):void
		{
			frame = (frame <= 0) ? 1 : (frame > totalFrames) ? totalFrames : frame;
			drawFrame(frame);
		}
		
		/**
		 * Перейти на нужный кадр и остановить.
		 * @param	frame номер кадра.
		 */
		public function gotoAndStop(frame:int):void
		{
			gotoFrame(frame);
			stop();
		}
		
		/**
		 * Перейти на нужный кадр и воспроизвести.
		 * @param	frame номер кадра.
		 */
		public function gotoAndPlay(frame:int):void
		{
			gotoFrame(frame);
			play();
		}
		
		override public function updateByFramework():void
		{
			if (playing)
			{
				currentFrame += frameSpeed;
				gotoFrame(currentFrame);
				animationComplete = (currentFrame >= totalFrames) ? true : false;
				
				if (repeat)
				{
					currentFrame = (currentFrame >= totalFrames) ? 1 : currentFrame;
				}
				else
				{
					if (currentFrame >= totalFrames)
					{
						animationComplete = true;
						stop();
					}
				}
			}
			
			super.updateByFramework();
		}
		
		/**
		 * Нарисовать текущий кадр.
		 * @param	frame номер кадра.
		 */
		private function drawFrame(frame:int):void
		{
			var frameData:SkyFrameData = animation.frames[frame - 1];
			
			originX = frameData.x;
			originY = frameData.y;
			bitmapData = frameData.bitmapData;
			width = frameData.bitmapData.width;
			height = frameData.bitmapData.height;
		}
	}
}