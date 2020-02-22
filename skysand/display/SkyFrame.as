package skysand.display 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyFrame extends SkyRenderObjectContainer
	{
		/**
		 * Толщина линий.
		 */
		private var mThickness:Number;
		
		/**
		 * Включена ли привязка к центру координат.
		 */
		private var isAligned:Boolean;
		
		/**
		 * Рамка.
		 */
		private var frame:SkyShape;
		
		public function SkyFrame() 
		{
			
		}
		
		/**
		 * Создать рамку.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	batchName имя пакета в который добавлять линии.
		 */
		public function create(width:Number, height:Number):void
		{
			mThickness = 1;
			isAligned = false;
			
			frame = new SkyShape();
			frame.color = 0xFFFFFF;
			frame.drawFrame(0, 0, width, height, mThickness);
			addChild(frame);
			
			mWidth = width;
			mHeight = height;
		}
		
		/**
		 * Название пакета отрисовки.
		 */
		public function set rendererName(value:String):void
		{
			if (frame.rendererName != value)
				frame.rendererName = value;
		}
		
		/**
		 * Название пакета отрисовки.
		 */
		public function get rendererName():String
		{
			return frame.rendererName;
		}
		
		/**
		 * Изменить размеры.
		 * @param	width высота.
		 * @param	height ширина.
		 */
		public function setSize(width:Number, height:Number):void
		{
			if (mWidth != width || mHeight != height)
			{
				mWidth = width;
				mHeight = height;
				
				frame.vertices[4] = mWidth;
				frame.vertices[6] = mWidth;
				frame.vertices[16] = mWidth - mThickness;
				frame.vertices[18] = mWidth - mThickness;
				
				frame.vertices[7] = mHeight;
				frame.vertices[9] = mHeight;
				frame.vertices[15] = mHeight - mThickness;
				frame.vertices[17] = mHeight - mThickness;
				frame.updateVertices();
			}
			
			if (isAligned)
			{
				frame.x = mWidth / 2;
				frame.y = mHeight / 2;
			}
		}
		
		/**
		 * Привязать центр рамки к началу координат.
		 */
		public function alignToCenter():void
		{
			isAligned = true;
			
			frame.x = mWidth / 2;
			frame.y = mHeight / 2;
		}
		
		/**
		 * Толщина линий.
		 */
		public function set thickness(value:Number):void
		{
			if (mThickness != value)
			{
				mThickness = value;
				
				frame.vertices[0] = mThickness;
				frame.vertices[1] = mThickness;
				frame.vertices[12] = mThickness;
				frame.vertices[13] = mThickness;
				frame.vertices[14] = mThickness;
				frame.vertices[15] = mHeight - mThickness;
				frame.vertices[16] = mWidth - mThickness;
				frame.vertices[17] = mHeight - mThickness;
				frame.vertices[18] = mWidth - mThickness;
				frame.vertices[19] = mThickness;
				frame.updateVertices();
			}
		}
		
		/**
		 * Толщина линий.
		 */
		public function get thickness():Number
		{
			return mThickness
		}
		
		/**
		 * Цвет рамки.
		 */
		override public function set color(value:uint):void 
		{
			if (mColor != value)
			{
				mColor = value;
				frame.color = value;
			}
		}
		
		/**
		 * Прозрачность рамки от 0 до 1.
		 */
		override public function set alpha(value:Number):void 
		{
			if (mAlpha != value)
			{
				mAlpha = value;
				frame.alpha = value;
			}
		}
		
		/**
		 * Ширина.
		 */
		override public function set width(value:Number):void 
		{
			if (mWidth != value)
			{
				mWidth = value;
				
				frame.vertices[4] = mWidth;
				frame.vertices[6] = mWidth;
				frame.vertices[16] = mWidth - mThickness;
				frame.vertices[18] = mWidth - mThickness;
				frame.updateVertices();
			}
		}
		
		/**
		 * Высота.
		 */
		override public function set height(value:Number):void 
		{
			if (mHeight != value)
			{
				mHeight = value;
				
				frame.vertices[7] = mHeight;
				frame.vertices[9] = mHeight;
				frame.vertices[15] = mHeight - mThickness;
				frame.vertices[17] = mHeight - mThickness;
				frame.updateVertices();
			}
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			super.free();
			
			removeChild(frame);
			frame.free();
			frame = null;
		}
	}
}