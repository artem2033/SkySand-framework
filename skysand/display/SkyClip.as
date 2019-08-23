package skysand.display
{
	import skysand.display.SkySprite;
	import skysand.file.SkyAtlasSprite;
	import skysand.utils.SkyTrackingSystem;
	
	public class SkyClip extends SkySprite
	{
		/**
		 * Повтор анимации.
		 */
		public var repeat:Boolean;
		
		/**
		 * Задержка перед сменой кадра в секундах.
		 */
		private var mDelay:Number;
		
		/**
		 * Воспроизведение анимации в обратную сторону.
		 */
		private var mReverse:Boolean;
		
		/**
		 * Количество кадров за единицу времени.
		 */
		private var frameSpeed:int;
		
		/**
		 * Общее число кадров.
		 */
		private var mTotalFrames:int;
		
		/**
		 * Текущее количество кадров.
		 */
		private var mCurrentFrame:Number;
		
		/**
		 * Счётчик накопленной задержки для перехода на следующий кадр.
		 */
		private var delayAccumulator:Number;
		
		/**
		 * Воспроизводится ли анимация.
		 */
		private var playing:Boolean;
		
		/**
		 * Массив с данными о каждом кадре анимации.
		 */
		private var frames:Vector.<SkyAtlasSprite>;
		
		/**
		 * Система с двигающимися точками.
		 */
		private var trackingSystem:SkyTrackingSystem;
		
		/**
		 * Функция, которая вызывается в конце анимации.
		 */
		private var mFunction:Function;
		
		/**
		 * Проверка на начало прохода цикла первый раз.
		 */
		private var isStarted:Boolean;
		
		public function SkyClip()
		{
			repeat = true;
			playing = false;
			mReverse = false;
			isStarted = true;
			
			mDelay = 0;
			frameSpeed = 1;
			mTotalFrames = 0;
			mCurrentFrame = 1;
			delayAccumulator = 0;
		}
		
		/**
		 * Воспроизвести анимацию.
		 */
		public function play():void
		{
			playing = true;
		}
		
		/**
		 * Остановить анимацию.
		 */
		public function stop():void
		{
			playing = false;
		}
		
		/**
		 * Перейти в предыдущий кадр.
		 */
		public function prevFrame():void
		{
			mCurrentFrame = mCurrentFrame <= 1 ? mTotalFrames : mCurrentFrame - 1;
			setFrame(mCurrentFrame);
		}
		
		/**
		 * Перейти в следующий кадр.
		 */
		public function nextFrame():void
		{
			mCurrentFrame = mCurrentFrame >= mTotalFrames ? 1 : mCurrentFrame + 1;
			setFrame(mCurrentFrame);
		}
		
		/**
		 * Перейти на нужный кадр.
		 * @param	frame номер кадра.
		 */
		public function setFrame(frame:int):void
		{
			var index:int = indexID / 7 * 2;
			
			width = frames[frame - 1].width;
			height = frames[frame - 1].height;
			pivotX = frames[frame - 1].pivotX;
			pivotY = frames[frame - 1].pivotY;
			mDelay = frames[frame - 1].delay;
			
			uvs[index] = frames[frame - 1].uvs[0];
			uvs[index + 1] = frames[frame - 1].uvs[1];
			uvs[index + 2] = frames[frame - 1].uvs[2];
			uvs[index + 3] = frames[frame - 1].uvs[3];
			uvs[index + 4] = frames[frame - 1].uvs[4];
			uvs[index + 5] = frames[frame - 1].uvs[5];
			uvs[index + 6] = frames[frame - 1].uvs[6];
			uvs[index + 7] = frames[frame - 1].uvs[7];
			
			if (trackingSystem) trackingSystem.update(frame);
		}
		
		public function get isPlaying():Boolean
		{
			return playing;
		}
		
		/**
		 * Перейти на нужный кадр и остановить.
		 * @param	frame номер кадра.
		 */
		public function gotoAndStop(frame:int):void
		{
			setFrame(frame);
			playing = false;
			mCurrentFrame = frame;
			delayAccumulator = 0;
		}
		
		/**
		 * Перейти на нужный кадр и воспроизвести.
		 * @param	frame номер кадра.
		 */
		public function gotoAndPlay(frame:int):void
		{
			setFrame(frame);
			playing = true;
			mCurrentFrame = frame;
			delayAccumulator = 0;
		}
		
		/**
		 * Задать функцию, которая будет вызываться в конце воспроизведения анимации.
		 * @param	_function ссылка на функцию.
		 */
		public function setEndListener(_function:Function):void
		{
			mFunction = _function;
		}
		
		/**
		 * Задать отслеживающую систему.
		 * @param	system система.
		 */
		public function setTrackSystem(system:SkyTrackingSystem):void
		{
			trackingSystem = system;
		}
		
		/**
		 * Задать покадровую анимацию.
		 * @param	name название анимации.
		 */
		public function setAnimation(name:String):void
		{
			if (atlas != null)
			{
				frames = atlas.getAnimation(name).frames;
				mTotalFrames = frames.length;
				mCurrentFrame = 1;
				data = frames[0];
				
				width = data.width;
				height = data.height;
				pivotX = data.pivotX;
				pivotY = data.pivotY;
				
				if (isAdded && !batch.contains(this))
				{
					init();
				}
				
				if (uvs != null)
				{
					var index:int = indexID / 7 * 2;
					
					uvs[index] = data.uvs[0];
					uvs[index + 1] = data.uvs[1];
					uvs[index + 2] = data.uvs[2];
					uvs[index + 3] = data.uvs[3];
					uvs[index + 4] = data.uvs[4];
					uvs[index + 5] = data.uvs[5];
					uvs[index + 6] = data.uvs[6];
					uvs[index + 7] = data.uvs[7];
				}
			}
			else throw new Error("Error: Atlas is null, set atlas before calling setAnimation!");
		}
		
		/**
		 * Задать покадровую анимацию.
		 * @param	index номер анимации в списке.
		 */
		public function setAnimationByIndex(index:int):void
		{
			if (atlas != null)
			{
				frames = atlas.getAnimationByIndex(index).frames;
				mTotalFrames = frames.length;
				mCurrentFrame = 1;
				data = frames[0];
				
				width = data.width;
				height = data.height;
				pivotX = data.pivotX;
				pivotY = data.pivotY;
				
				if (uvs)
				{
					var index:int = indexID / 7 * 2;
					
					uvs[index] = data.uvs[0];
					uvs[index + 1] = data.uvs[1];
					uvs[index + 2] = data.uvs[2];
					uvs[index + 3] = data.uvs[3];
					uvs[index + 4] = data.uvs[4];
					uvs[index + 5] = data.uvs[5];
					uvs[index + 6] = data.uvs[6];
					uvs[index + 7] = data.uvs[7];
				}
			}
			else throw new Error("Error: Atlas is null, set atlas before calling setAnimation!");
		}
		
		/**
		 * Задать порядок обхода кадров, false - прямой/true - обратный.
		 */
		public function set reverse(value:Boolean):void
		{
			mReverse = value;
			frameSpeed = value ? -1 : 1;
		}
		
		/**
		 * Задать порядок обхода кадров.
		 */
		public function get reverse():Boolean
		{
			return mReverse;
		}
		
		/**
		 * Получить номер текущего кадра.
		 */
		public function get currentFrame():int
		{
			return mCurrentFrame;
		}
		
		/**
		 * Задержка между кадрами в мс, задаётся для всех кадров.
		 */
		public function get delay():Number
		{
			return mDelay;
		}
		
		/**
		 * Задержка между кадрами в мс, задаётся для всех кадров.
		 */
		public function set delay(value:Number):void
		{
			mDelay = value;
			
			for (var i:int = 0; i < mTotalFrames; i++) 
			{
				frames[i].delay = mDelay;
			}
		}
		
		/**
		 * Получить количество кадров в анимации.
		 */
		public function get totalFrames():int
		{
			return mTotalFrames;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			frames.length = 0;
			frames = null;
			
			super.free();
		}
		
		/**
		 * Функция обновления координат и других данных.
		 */
		override public function updateData(deltaTime:Number):void
		{
			if (globalVisible == 1)
			{
				if (playing)
				{
					if (delayAccumulator >= 1)
					{
						mCurrentFrame += frameSpeed;
						
						if (mCurrentFrame < 1)
						{
							mCurrentFrame = mTotalFrames;
							
							if (mFunction != null) mFunction.apply();
							
							if (!repeat && !isStarted)
							{
								playing = false;
								isStarted = false;
								mCurrentFrame = 1;
							}
							
							isStarted = true;
						}
						else if(mCurrentFrame > mTotalFrames)
						{
							mCurrentFrame = 1;
							
							if (mFunction != null) mFunction.apply();
							
							if (!repeat)
							{
								playing = false;
							}
						}
						
						setFrame(mCurrentFrame);
						delayAccumulator = 0;
					}
					
					delayAccumulator += mDelay > 0 ? deltaTime / mDelay : 1;
				}
			}
			
			super.updateData(deltaTime);
		}
	}
}