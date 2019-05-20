package skysand.ui 
{
	import skysand.display.SkyShape;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyProgressBar extends SkyShape
	{
		/**
		 * Фон.
		 */
		private var background:SkyShape;
		
		/**
		 * Шкала.
		 */
		private var bar:SkyShape;
		
		public function SkyProgressBar() 
		{
			
		}
		
		/**
		 * Создать шкалу прогресса.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	kind внешний вид.
		 */
		public function create(width:Number, height:Number, kind:uint = 1):void
		{
			if (kind != SkyUI.RECTANGLE)
			{
				var radius:Number = (kind == SkyUI.LOW_ROUND_RECTANGLE) ? 4 : (kind == SkyUI.MIDDLE_ROUND_RECTANGLE) ? 8 : height;
				
				var leftDown:SkyShape = SkyUI.getForm(SkyUI.IN_ROUND_RECTANGLE, SkyColor.CLOUDS, radius, radius);
				leftDown.alpha = 0;
				leftDown.y = height;
				addChild(leftDown);
				
				var leftUp:SkyShape = SkyUI.getForm(SkyUI.IN_ROUND_RECTANGLE, SkyColor.CLOUDS, radius, radius);
				leftUp.rotation = 90;
				leftUp.alpha = 0;
				addChild(leftUp);
				
				var rightUp:SkyShape = SkyUI.getForm(SkyUI.IN_ROUND_RECTANGLE, SkyColor.CLOUDS, radius, radius);
				rightUp.rotation = 180;
				rightUp.x = width;
				rightUp.alpha = 0;
				addChild(rightUp);
				
				var rightDown:SkyShape = SkyUI.getForm(SkyUI.IN_ROUND_RECTANGLE, SkyColor.CLOUDS, radius, radius);
				rightDown.rotation = 270;
				rightDown.y = height;
				rightDown.x = width;
				rightDown.alpha = 0;
				addChild(rightDown);
				
				background = SkyUI.getForm(SkyUI.RECTANGLE, SkyColor.DARK_BLUE_GREY, width, height);
				addChildAt(background, 0);
				
				bar = SkyUI.getForm(SkyUI.RECTANGLE, SkyColor.CLOUDS, width, height);
				addChildAt(bar, 1);
			}
			else
			{
				background = SkyUI.getForm(SkyUI.RECTANGLE, SkyColor.DARK_BLUE_GREY, width, height);
				addChild(background);
				
				bar = SkyUI.getForm(SkyUI.RECTANGLE, SkyColor.CLOUDS, width, height);
				addChild(bar);
			}
			
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Изменить размеры.
		 * @param	width ширина.
		 * @param	height высота.
		 */
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
			
			background.width = width;
			background.height = height;
			
			bar.height = height;
		}
		
		/**
		 * Поменять цвета шкалы.
		 * @param	backgroundColor цвет фона.
		 * @param	barColor цвет шкалы.
		 */
		public function setColors(backgroundColor:uint, barColor:uint):void
		{
			bar.color = barColor;
			background.color = backgroundColor;
		}
		
		/**
		 * Прозрачность.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			background.alpha = value;
			bar.alpha = value;
			alpha = value;
		}
		
		/**
		 * Получить значение прогресса от 0 до 1.
		 */
		public function get progress():Number
		{
			return bar.width / width;
		}
		
		/**
		 * Задать значение прогресса от 0 до 1.
		 */
		public function set progress(value:Number):void
		{
			value = value > 1 ? 1 : value;
			bar.width = value * width;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(background);
			background.free();
			background = null;
			
			removeChild(bar);
			bar.free();
			bar = null;
			
			if (numChildren > 0)
			{
				for (var i:int = 0; i < numChildren; i++) 
				{
					var child:SkyShape = SkyShape(getChildAt(0));
					removeChild(child);
					child.free();
					child = null;
				}
			}
			
			super.free();
		}
	}
}