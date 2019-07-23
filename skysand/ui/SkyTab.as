package skysand.ui 
{
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyShape;
	import skysand.interfaces.ITab;
	import skysand.utils.SkyUtils;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyTab extends SkyRenderObjectContainer
	{
		/**
		 * Класс привязанный к вкладке.
		 */
		public var listener:ITab;
		
		/**
		 * Кнопка для отображения вкладки.
		 */
		private var mButton:SkyButton;
		
		/**
		 * Иконка уведомление.
		 */
		private var markIcon:SkyShape;
		
		/**
		 * Ссылка на панель вкладок.
		 */
		private var panel:SkyTabPanel;
		
		public function SkyTab()
		{
			
		}
		
		/**
		 * Создать вкладку.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	panel ссылка на панель с вкладками.
		 */
		public function create(width:Number, height:Number, panel:SkyTabPanel):void
		{
			mButton = new SkyButton();
			mButton.create(SkyUI.RECTANGLE, width, height, SkyColor.CLOUDS, onTabPressed);
			addChild(mButton);
			
			var dx:Number = height / 7;
			
			markIcon = new SkyShape();
			markIcon.color = 0xFFFFFF;
			markIcon.addVertex(-1, 0);
			markIcon.addVertex(0, 0);
			markIcon.addVertex(dx, dx);
			markIcon.addVertex(0, dx * 2);
			markIcon.addVertex(dx, dx * 3);
			markIcon.addVertex(0, dx * 4);
			markIcon.addVertex(dx, dx * 5);
			markIcon.addVertex(0, dx * 6);
			markIcon.addVertex(dx, dx * 7);
			markIcon.addVertex(-1, dx * 7);
			markIcon.rotation = 180;
			markIcon.x = width;
			markIcon.y = height;
			addChild(markIcon);
			
			this.panel = panel;
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Получить ссылку на кнопку.
		 */
		public function get button():SkyButton
		{
			return mButton;
		}
		
		/**
		 * Цвет отметки.
		 */
		public function setMarkColor(value:uint):void
		{
			markIcon.color = value;
		}
		
		/**
		 * Показать отметку.
		 */
		public function mark():void
		{
			markIcon.x = width;
			markIcon.visible = true;
		}
		
		/**
		 * Скрыть отметку.
		 */
		public function unmark():void
		{
			markIcon.visible = false;
		}
		
		/**
		 * Выделить вкладку.
		 */
		public function select():void
		{
			if (panel.mCurrentTab != null)
			{
				panel.mCurrentTab.mButton.setColor(color);
			}
			
			mButton.setColor(SkyUtils.changeColorBright(color, 30));
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			listener.onCloseTab();
			listener = null;
			
			removeChild(mButton);
			mButton.free();
			mButton = null;
			
			removeChild(markIcon);
			markIcon.free();
			markIcon = null;
			
			panel = null;
		}
		
		/**
		 * Событие при нажатии на кнопку.
		 */
		private function onTabPressed():void
		{
			if (panel.mCurrentTab != null)
			{
				panel.mCurrentTab.mButton.setColor(color);
				panel.mCurrentTab.listener.onExitTab();
			}
			
			mButton.setColor(SkyUtils.changeColorBright(color, 30));
			panel.mCurrentTab = this;
			listener.onEnterTab();
		}
	}
}