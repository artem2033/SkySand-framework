package skysand.display 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyFrame extends SkyRenderObjectContainer
	{
		/**
		 * Левая линия рамки.
		 */
		private var leftLine:SkyShape;
		
		/**
		 * Правая линия рамки.
		 */
		private var rightLine:SkyShape;
		
		/**
		 * Нижняя линия рамки.
		 */
		private var downLine:SkyShape;
		
		/**
		 * Верхняя линия рамки.
		 */
		private var upLine:SkyShape;
		
		/**
		 * Толщина линий.
		 */
		private var mThickness:Number;
		
		/**
		 * Включена ли привязка к центру координат.
		 */
		private var isAligned:Boolean;
		
		public function SkyFrame() 
		{
			
		}
		
		/**
		 * Создать рамку.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	batchName имя пакета в который добавлять линии.
		 */
		public function create(width:Number, height:Number, batchName:String = "shape"):void
		{
			mThickness = 1;
			isAligned = false;
			
			leftLine = new SkyShape();
			leftLine.batchName = batchName;
			leftLine.color = 0xFFFFFF;
			leftLine.drawRect(0, 0, mThickness, height);
			addChild(leftLine);
			
			rightLine = new SkyShape();
			rightLine.batchName = batchName;
			rightLine.color = 0xFFFFFF;
			rightLine.drawRect(0, 0, mThickness, height);
			rightLine.x = width - mThickness;
			addChild(rightLine);
			
			downLine = new SkyShape();
			downLine.batchName = batchName;
			downLine.color = 0xFFFFFF;
			downLine.drawRect(0, 0, width, mThickness);
			downLine.y = height - mThickness;
			addChild(downLine);
			
			upLine = new SkyShape();
			upLine.batchName = batchName;
			upLine.color = 0xFFFFFF;
			upLine.drawRect(0, 0, width, mThickness);
			addChild(upLine);
			
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Изменить размеры.
		 * @param	width высота.
		 * @param	height ширина.
		 */
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
			
			leftLine.height = height;
			rightLine.height = height;
			downLine.width = width;
			upLine.width = width;
			
			if (!isAligned)
			{
				rightLine.x = width - mThickness;
				downLine.y = height - mThickness;
			}
			else
			{
				leftLine.x = -width * 0.5;
				leftLine.y = -height * 0.5;
				
				rightLine.x = width * 0.5 - mThickness;
				rightLine.y = -height * 0.5;
				
				downLine.x = -width * 0.5;
				downLine.y = height * 0.5 - mThickness;
				
				upLine.x = -width * 0.5;
				upLine.y = -height * 0.5;
			}
		}
		
		/**
		 * Привязать центр рамки к началу координат.
		 */
		public function alignToCenter():void
		{
			isAligned = true;
			
			leftLine.x = -width * 0.5;
			leftLine.y = -height * 0.5;
			
			rightLine.x = width * 0.5 - mThickness;
			rightLine.y = -height * 0.5;
			
			downLine.x = -width * 0.5;
			downLine.y = height * 0.5 - mThickness;
			
			upLine.x = -width * 0.5;
			upLine.y = -height * 0.5;
		}
		
		/**
		 * Цвет рамки.
		 * @param	value значение цвета.
		 */
		public function setColor(value:uint):void
		{
			leftLine.color = value;
			rightLine.color = value;
			downLine.color = value;
			upLine.color = value;
			
			color = value;
		}
		
		/**
		 * Прозрачность рамки.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			leftLine.alpha = value;
			rightLine.alpha = value;
			downLine.alpha = value;
			upLine.alpha = value;
			
			alpha = value;
		}
		
		/**
		 * Толщина линий.
		 */
		public function set thickness(value:Number):void
		{
			if (mThickness == value) return;
			
			mThickness = value;
			leftLine.width = value;
			rightLine.width = value;
			downLine.height = value;
			upLine.height = value;
			
			rightLine.x = width - value;
			downLine.y = height - value;
		}
		
		/**
		 * Толщина линий.
		 */
		public function get thickness():Number
		{
			return mThickness
		}
	}
}