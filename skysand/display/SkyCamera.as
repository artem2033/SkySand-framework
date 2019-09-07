package skysand.display 
{
	import flash.geom.Matrix3D;
	
	import skysand.utils.SkyVector2D;
	
	public class SkyCamera extends Object
	{
		/**
		 * Отключить\включить безопасную зону.
		 */
		public var enableSafeZone:Boolean;
		
		/**
		 * Ширина свободного перемещения без смещения камеры.
		 */
		public var deadZoneWidth:Number;
		
		/**
		 * Высота свободного перемещения без смещения камеры.
		 */
		public var deadZoneHeight:Number;
		
		/**
		 * Ширина ограничения сглаживания движения.
		 */
		private var mSafeZoneWidth:Number;
		
		/**
		 * Высота ограничения сглаживания движения.
		 */
		private var mSafeZoneHeight:Number;
		
		/**
		 * Сглаживание следования камеры за указаными координатами по оси х.
		 */
		private var mDampingX:Number;
		
		/**
		 * Сглаживание следования камеры за указаными координатами по оси у.
		 */
		private var mDampingY:Number;
		
		/**
		 * Масштаб изображения относительно камеры на оси х.
		 */
		private var scaleX:Number;
		
		/**
		 * Масштаб изображения относительно камеры на оси у.
		 */
		private var scaleY:Number;
		
		/**
		 * Текущая ширина окна.
		 */
		private var screenWidth:Number;
		
		/**
		 * Текущая высота окна.
		 */
		private var screenHeight:Number;
		
		/**
		 * Координта камеры по оси х.
		 */
		private var mX:Number;
		
		/**
		 * Координта камеры по оси у.
		 */
		private var mY:Number;
		
		/**
		 * Точка смещения относительно начала координат.
		 */
		private var offset:SkyVector2D;
		
		/**
		 * Точка слежения камеры.
		 */
		private var mTrackingPoint:SkyVector2D;
		
		/**
		 * Расстояние смещения камеры.
		 */
		public var mLookAheadDistance:Number;
		
		/**
		 * Ускорение смещения камеры.
		 */
		public var mLookAheadAcseleration:Number;
		
		/**
		 * Скорость смещения точки до указанного расстояния lookAheadDistance.
		 */
		private var lookAheadSpeed:Number;
		
		/**
		 * Предыдущая координата точки.
		 */
		private var prevX:Number;
		
		/**
		 * Матрица трансформации камеры.
		 */
		private var viewTransform:Matrix3D;
		
		public function SkyCamera()
		{
			mX = 0;
			mY = 0;
			prevX = 0;
			mDampingX = 1;
			mDampingY = 1;
			deadZoneWidth = 0;
			deadZoneHeight = 0;
			mSafeZoneWidth = 0;
			mSafeZoneHeight = 0;
			lookAheadSpeed = 0;
			mLookAheadDistance = 0;
			mLookAheadAcseleration = 1;
			
			scaleX = -2 / SkySand.SCREEN_WIDTH;
			scaleY = -2 / SkySand.SCREEN_HEIGHT;
			screenWidth = SkySand.SCREEN_WIDTH;
			screenHeight = SkySand.SCREEN_HEIGHT;
			enableSafeZone = true;
			
			offset = new SkyVector2D(SkySand.SCREEN_WIDTH / 2, SkySand.SCREEN_HEIGHT / 2);
			mTrackingPoint = new SkyVector2D();
			viewTransform = new Matrix3D();
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			offset = null
			mTrackingPoint = null;
			viewTransform = null;
		}
		
		/**
		 * Переместить камеру в заданную точку.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function moveTo(x:Number, y:Number):void
		{
			viewTransform.appendTranslation((x - mX) * scaleX, (mY - y) * scaleY, 0);
			mTrackingPoint.setTo(x, y);
			
			mX = x;
			mY = y;
		}
		
		/**
		 * Задать смещение камеры относительно начала координат.
		 * @param	x смещение по оси х.
		 * @param	y смещение по оси у.
		 */
		public function setScreenOffset(x:Number, y:Number):void
		{
			/*viewTransform.identity();
			viewTransform.appendTranslation(mX * scaleX, mY * scaleY, 0);
			SkySand.watch(mX - x);*/
			offset.setTo(x, y);
		}
		
		/**
		 * Задать размеры окна.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function setScreenSize(width:Number, height:Number):void
		{
			offset.setTo(width / 2, height / 2);
			
			screenWidth = width;
			screenHeight = height;
			scaleX = -2 / width;
			scaleY = -2 / height;
			
			viewTransform.identity();
			viewTransform.appendTranslation((mX - offset.x) * scaleX, (offset.y - mY) * scaleY, 0);
			//viewTransform.appendTranslation((mX - offset.x) * scaleX, (mY + offset.y) * scaleY, 0);
		}
		
		/**
		 * Задать смещение по центру экрана.
		 */
		public function setCentralOffset():void
		{
			offset.setTo(screenWidth / 2, screenHeight / 2);
			
			viewTransform.identity();
			viewTransform.appendTranslation((mX - offset.x) * scaleX, (mY + offset.y) * scaleY, 0);
		}
		
		/**
		 * Следование за точкой с учётом настроенных параметров.
		 * @param	x координата точки.
		 * @param	y координата точки.
		 */
		public function follow(x:Number, y:Number):void
		{
			if(lookAheadDistance > 0)
				x = calculateAheadPoint(x);
			
			var distance:Number = 0;
			
			if (x > mX + deadZoneWidth * 0.5)
			{
				distance = x - mX - deadZoneWidth * 0.5;
				distance = distance <= 1 ? 1 : distance;
				mX += distance * mDampingX;
			}
			else if (x < mX - deadZoneWidth * 0.5)
			{
				distance = x - mX + deadZoneWidth * 0.5;
				distance = distance >= -1 ? -1 : distance;
				mX += distance * mDampingX;
			}
			
			if (y > deadZoneHeight * 0.5 - mY)
			{
				distance = y + mY - deadZoneHeight * 0.5;
				distance = distance < 1 ? 1 : distance;
				mY -= distance * mDampingY;
			}
			else if (y < -deadZoneHeight * 0.5 - mY)
			{
				distance = y + mY + deadZoneHeight * 0.5;
				distance = distance > -1 ? -1 : distance;
				mY -= distance * mDampingY;
			}
			
			if (enableSafeZone)
			{
				if (x > mX + mSafeZoneWidth * 0.5) mX = x - mSafeZoneWidth * 0.5;
				else if (x < mX - mSafeZoneWidth * 0.5) mX = x + mSafeZoneWidth * 0.5;
				
				if (y > mSafeZoneHeight * 0.5 - mY) mY = mSafeZoneHeight * 0.5 - y;
				else if (y < -mY - mSafeZoneHeight * 0.5) mY = -y - mSafeZoneHeight * 0.5;
			}
			
			mTrackingPoint.setTo(x, y);
			viewTransform.identity();
			viewTransform.appendTranslation((mX - offset.x) * scaleX, (mY + offset.y) * scaleY, 0);
		}
		
		/**
		 * Координаты смещения камеры.
		 */
		public function get screenOffset():SkyVector2D
		{
			return offset;
		}
		
		/**
		 * Положение камеры на оси х.
		 */
		public function set x(value:Number):void
		{
			viewTransform.appendTranslation((value - mX) * scaleX, 0, 0);
			mTrackingPoint.x = value;
			mX = value;
		}
		
		/**
		 * Положение камеры на оси х.
		 */
		public function get x():Number
		{
			return mX;
		}
		
		/**
		 * Положение камеры на оси у.
		 */
		public function set y(value:Number):void
		{
			viewTransform.appendTranslation(0, (mY - value) * scaleY, 0);
			mTrackingPoint.y = value;
			mY = value;
		}
		
		/**
		 * Положение камеры на оси у.
		 */
		public function get y():Number
		{
			return mY;
		}
		
		/**
		 * Сглаживание следования камеры за указаными координатами по оси у.
		 * Значение от 1 (нет сглаживания) до близкого к 0 (максимальное сглаживание).
		 */
		public function set dampingY(value:Number):void
		{
			mDampingY = value <= 0 ? 0.01 : value > 1 ? 1 : value;
		}
		
		/**
		 * Сглаживание следования камеры за указаными координатами по оси у.
		 * Значение от 1 (нет сглаживания) до близкого к 0 (максимальное сглаживание).
		 */
		public function get dampingY():Number
		{
			return mDampingY;
		}
		
		/**
		 * Сглаживание следования камеры за указаными координатами по оси x.
		 * Значение от 1 (нет сглаживания) до близкого к 0 (максимальное сглаживание).
		 */
		public function get dampingX():Number
		{
			return mDampingX;
		}
		
		/**
		 * Сглаживание следования камеры за указаными координатами по оси x.
		 * Значение от 1 (нет сглаживания) до близкого к 0 (максимальное сглаживание).
		 */
		public function set dampingX(value:Number):void
		{
			mDampingX = value <= 0 ? 0.01 : value > 1 ? 1 : value;
		}
		
		/**
		 * Получить точку слежения камеры.
		 */
		public function get trackingPoint():SkyVector2D
		{
			return mTrackingPoint;
		}
		
		/**
		 * Матрица транформации камеры.
		 */
		public function get transformMatrix():Matrix3D
		{
			return viewTransform;
		}
		
		/**
		 * Ширина ограничивающая сглаженное движение камеры.
		 */
		public function set safeZoneWidth(value:Number):void
		{
			mSafeZoneWidth = value <= deadZoneWidth ? deadZoneWidth : value;
		}
		
		/**
		 * Ширина ограничивающая сглаженное движение камеры.
		 */
		public function get safeZoneWidth():Number
		{
			return mSafeZoneWidth;
		}
		
		/**
		 * Высота ограничивающая сглаженное движение камеры.
		 */
		public function set safeZoneHeight(value:Number):void
		{
			mSafeZoneHeight = value <= deadZoneHeight ? deadZoneHeight : value;
		}
		
		/**
		 * Высота ограничивающая сглаженное движение камеры.
		 */
		public function get safeZoneHeight():Number
		{
			return mSafeZoneHeight;
		}
		
		/**
		 * Расстояние на которое будет смещаться камера следуя за точкой.
		 * При 0 расстояние не рассчитывается.
		 */
		public function set lookAheadDistance(value:Number):void
		{
			mLookAheadDistance = value < 0 ? 0 : value;
		}
		
		/**
		 * Расстояние на которое будет смещаться камера следуя за точкой.
		 * При 0 расстояние не рассчитывается.
		 */
		public function get lookAheadDistance():Number
		{
			return mLookAheadDistance;
		}
		
		/**
		 * Ускорение смещения камеры.
		 */
		public function set lookAheadAcseleration(value:Number):void
		{
			mLookAheadAcseleration = value < 1 ? 1 : value;
		}
		
		/**
		 * Ускорение смещения камеры.
		 */
		public function get lookAheadAcseleration():Number
		{
			return mLookAheadAcseleration;
		}
		
		/**
		 * Плавно сдвинуть точку на указанное расстояние lookAheadDistance.
		 * Смещение рассчитывается в направлении движения камеры.
		 * @param	x сдвигаемая точка. 
		 * @return результат сдвига.
		 */
		private function calculateAheadPoint(x:Number):Number
		{
			if (x - prevX > 0)
			{
				lookAheadSpeed += mLookAheadAcseleration;
				lookAheadSpeed = lookAheadSpeed > mLookAheadDistance ? mLookAheadDistance : lookAheadSpeed;
			}
			else if (x - prevX < 0)
			{
				lookAheadSpeed -= mLookAheadAcseleration;
				lookAheadSpeed = lookAheadSpeed < -mLookAheadDistance ? -mLookAheadDistance : lookAheadSpeed;
			}
			else if (lookAheadSpeed != 0)
			{
				if (lookAheadSpeed < 0)
				{
					lookAheadSpeed += mLookAheadAcseleration;
					lookAheadSpeed = lookAheadSpeed >= 0 ? 0 : lookAheadSpeed;
				}
				else if (lookAheadSpeed > 0)
				{
					lookAheadSpeed -= mLookAheadAcseleration;
					lookAheadSpeed = lookAheadSpeed < 0 ? 0 : lookAheadSpeed;
				}
			}
			
			prevX = x;
			
			return x + lookAheadSpeed;
		}
	}
}