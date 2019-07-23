package skysand.ui 
{
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyShape;
	import skysand.interfaces.ITab;
	import skysand.input.SkyMouse;
	import skysand.text.SkyFont;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyTabPanel extends SkyRenderObjectContainer
	{
		/**
		 * Ссылка на текущую вкладку.
		 */
		internal var mCurrentTab:SkyTab;
		
		/**
		 * Фон.
		 */
		private var panel:SkyShape;
		
		/**
		 * Массив с табами.
		 */
		private var tabs:Vector.<SkyTab>;
		
		/**
		 * Расстояние между табами.
		 */
		private var spacing:Number;
		
		/**
		 * Размер шрифта.
		 */
		private var fontSize:Number;
		
		/**
		 * Выпадающее меню со списком всех вкладок.
		 */
		private var menu:SkyDropDownList;
		
		/**
		 * Список вкладок.
		 */
		private var list:SkyList;
		
		/**
		 * Текущая перетаскиваемая вкладка.
		 */
		private var tab:SkyTab;
		
		/**
		 * Перетаскивается ли в данный момент вкладка.
		 */
		private var drag:Boolean;
		
		/**
		 * Проверка на обновление положения и видимости вкладок.
		 */
		private var isUpdated:Boolean;
		
		/**
		 * Ссылка на мышь.
		 */
		private var mouse:SkyMouse;
		
		/**
		 * Высота вкладки.
		 */
		private var tabHeight:Number;
		
		/**
		 * Цвет текста.
		 */
		private var textColor:uint;
		
		/**
		 * Цвет вкладки.
		 */
		private var buttonColor:uint;
		
		/**
		 * Шрифт.
		 */
		private var font:String;
		
		/**
		 * Попал ли курсор, при нажатии, на вкладку.
		 */
		private var isHit:Boolean;
		
		/**
		 * Название шрифта для растрового тектового поля.
		 */
		private var bitmapFontName:String;
		
		public function SkyTabPanel() 
		{
			
		}
		
		/**
		 * Создать панель с табами.
		 * @param	width ширина панели.
		 * @param	height высота панели.
		 * @param	spacing растояние между табами.
		 * @param	tabHeight высота таба.
		 * @param	menuWidth ширина выпадающего списка с именами всех табов.
		 */
		public function create(width:Number, height:Number, spacing:Number, tabHeight:Number, menuWidth:Number):void
		{
			this.tabHeight = tabHeight;
			this.spacing = spacing;
			this.height = height;
			this.width = width;
			
			tab = null;
			drag = false;
			isHit = false;
			isUpdated = false;
			bitmapFontName = "";
			
			font = SkyFont.CODE_BOLD
			fontSize = 14;
			textColor = SkyColor.APRICOT;
			buttonColor = SkyColor.BLUE_GREY;
			
			panel = new SkyShape();
			panel.color = textColor;
			panel.drawRect(0, 0, width, height);
			addChild(panel);
			
			list = new SkyList();
			list.create(menuWidth, 20, buttonColor, 6, textColor, font);
			list.x = 20 - menuWidth - 5;
			
			menu = new SkyDropDownList();
			menu.create(SkyUI.RECTANGLE, 20, 20, textColor, true, false, false, true, false);
			menu.x = width - 20;
			menu.y = height - 20;
			menu.setColor(textColor, textColor, buttonColor);
			menu.addList(list);
			addChild(menu);
			
			tabs = new Vector.<SkyTab>();
			mouse = SkyMouse.instance;
		}
		
		/**
		 * Задать цвет панели.
		 * @param	buttonColor цвет кнопок.
		 * @param	panelColor цвет панели.
		 * @param	textColor цвет текста.
		 */
		public function setColor(buttonColor:uint, panelColor:uint, textColor:uint):void
		{
			panel.color = panelColor;
			list.setColors(buttonColor, textColor);
			menu.setColor(panelColor, buttonColor, textColor);
			menu.setSliderColor(panelColor, buttonColor);
			
			var length:int = tabs.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var button:SkyButton = tabs[i].button;
				button.setColor(buttonColor);
				button.setTextColors(textColor);
				tabs[i].color = buttonColor;
			}
		}
		
		/**
		 * Сменить текстовые поля у кнопок на обычные.
		 * @param	font шрифт.
		 * @param	fontSize размер шрифта.
		 */
		public function setFont(font:String, fontSize:int):void
		{
			this.font = font;
			this.fontSize = fontSize;
			
			list.setTextField(font, fontSize);
			
			var length:int = tabs.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var button:SkyButton = tabs[i].button;
				button.addText(button.getText(), font, textColor, fontSize)
			}
		}
		
		/**
		 * Сменить текстовые поля у кнопок на растровые.
		 * @param	filePath путь к файлу с шрифтом.
		 * @param	directory директория.
		 */
		public function setBitmapFont(name:String):void
		{
			bitmapFontName = name;
			list.setBitmapTextField(name);
			
			var length:int = tabs.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var button:SkyButton = tabs[i].button;
				button.addBitmapText(name, button.getText(), textColor);
			}
		}
		
		/**
		 * Добавить вкладку.
		 * @param	name название.
		 * @param	listener ссылка на класс являющийся вкладкой и реализующий методы интерфейса ITab.
		 * @param	scale коэфициент для расчёта длинны кнопки в зависимости от длины текста.
		 */
		public function addTab(name:String, listener:ITab, scale:Number = 1.5):void
		{
			var tab:SkyTab = new SkyTab();
			tab.create(name.length * fontSize / scale, tabHeight, this);
			tab.button.setColor(buttonColor);
			tab.color = buttonColor;
			tab.setMarkColor(textColor);
			tab.listener = listener;
			tab.x = tabs.length > 0 ? tabs[tabs.length - 1].x + tabs[tabs.length - 1].width + spacing : 0;
			tab.y = height - tabHeight;
			addChild(tab);
			
			if (bitmapFontName != "") tab.button.addBitmapText(bitmapFontName, name, textColor);
			else tab.button.addText(name, font, textColor, fontSize);
			
			list.addItem(name, pushForward, true);
			tabs.unshift(tab);
			
			tab.select();
			if (mCurrentTab != null) mCurrentTab.listener.onExitTab();
			mCurrentTab = tab;
			mCurrentTab.listener.onEnterTab();
			
			isUpdated = false;
		}
		
		/**
		 * Переименовать вкладку.
		 * @param	newName новое имя.
		 * @param	index номер вкладки.
		 * @param	scale коэфициент для расчёта длинны кнопки в зависимости от длины текста.
		 */
		public function renameTab(newName:String, index:int, scale:Number = 1.5):void
		{
			var button:SkyButton = tabs[index].button;
			button.recreate(SkyUI.RECTANGLE, fontSize * newName.length / scale, tabHeight);
			button.setText(newName);
			
			tabs[index].width = fontSize * newName.length / scale;
			tabs[index].height = tabHeight;
			
			isUpdated = false;
		}
		
		/**
		 * Переименовать текущую вкладку.
		 * @param	newName новоё имя.
		 * @param	scale коэфициент для расчёта длинны кнопки в зависимости от длины текста.
		 */
		public function renameCurrentTab(newName:String, scale:Number = 1.5):void
		{
			if (mCurrentTab == null || mCurrentTab.button.getText() == newName) return;
			
			var button:SkyButton = mCurrentTab.button;
			button.recreate(SkyUI.RECTANGLE, fontSize * newName.length / scale, tabHeight);
			button.setText(newName);
			
			mCurrentTab.width = fontSize * newName.length / scale;
			mCurrentTab.height = tabHeight;
			
			isUpdated = false;
		}
		
		/**
		 * Закрыть вкладку по названию.
		 * @param	name название вкладки.
		 */
		public function closeTabByName(name:String):void
		{
			var length:int = tabs.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				if (tabs[i].button.getText() == name)
				{
					closeTabByIndex(i);
					break;
				}
			}
		}
		
		/**
		 * Закрыть вкладку по его индексу.
		 * @param	index номер вкладки в массиве.
		 */
		public function closeTabByIndex(index:int):void
		{
			removeChild(tabs[index]);
			tabs[index].free();
			tabs[index] = null;
			tabs.removeAt(index);
			
			if (tabs.length > 0)
			{
				mCurrentTab = index == tabs.length ? tabs[index - 1] : tabs[index];
				mCurrentTab.listener.onEnterTab();
				mCurrentTab.select();
				
				isUpdated = false;
			}
		}
		
		/**
		 * Закрыть текущую вкладку.
		 */
		public function closeCurrentTab():void
		{
			if (mCurrentTab != null)
			{
				var index:int = tabs.indexOf(mCurrentTab)
				tabs.removeAt(index);
				
				removeChild(mCurrentTab);
				mCurrentTab.free();
				mCurrentTab = null;
				
				if (tabs.length > 0)
				{
					mCurrentTab = index == tabs.length ? tabs[index - 1] : tabs[index];
					mCurrentTab.listener.onEnterTab();
					mCurrentTab.select();
					
					isUpdated = false;
				}
			}
		}
		
		/**
		 * Получить текущую вкладку.
		 */
		public function get currentTab():SkyTab
		{
			return mCurrentTab;
		}
		
		/**
		 * Получить текущее количество вкладок.
		 */
		public function get tabCount():int
		{
			return tabs.length;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			for (var i:int = 0; i < tabs.length; i++) 
			{
				var tab:SkyTab = tabs[i];
				removeChild(tab);
				tab.free();
				tab = null;
			}
			
			tabs.length = 0;
			tabs = null;
			
			removeChild(panel);
			panel.free();
			panel = null;
			
			removeChild(menu)
			menu.free();
			menu = null;
			
			removeChild(list);
			list.free();
			list = null;
			
			tab = null;
			mouse = null;
			mCurrentTab = null;
			
			super.free();
		}
		
		/**
		 * Обновление данных.
		 * @param	deltaTime промежуток времени между сменой кадров.
		 */
		override public function updateData(deltaTime:Number):void 
		{
			super.updateData(deltaTime);
			
			if (tabs.length < 1) return; 
			
			if (mouse.isDown(SkyMouse.RIGHT))
			{
				var length:int = tabs.length;
				
				for (var i:int = 0; i < length; i++) 
				{
					if (tabs[i].hitTestBoundsWithMouse() && !drag && length > 1)
					{
						tabs[i].startDrag(false, true, height - tabHeight, height - tabHeight, 0, width - tab.width - 20);
						tab = tabs.removeAt(i) as SkyTab;
						
						isHit = true;
						
						break;
					}
				}
				
				drag = true;
			}
			else if (drag)
			{
				isUpdated = false;
				drag = false;
				
				if (isHit)
				{
					isHit = false;
					tab.stopDrag();
					length = tabs.length;
					
					if (tab.x <= 0)
					{
						tabs.unshift(tab);
					}
					else if (tab.x >= tabs[length - 1].x)
					{
						tabs.push(tab);
					}
					else
					{
						for (i = 0; i < length; i++)
						{
							if (tab.x < tabs[i].x)
							{
								tabs.insertAt(i, tab);
								
								break;
							}						
						}
					}
				}
			}
			
			if (!drag && !isUpdated)
			{
				tabs[0].x = 0;
				length = tabs.length;
				
				for (i = 1; i < length; i++) 
				{
					tab = tabs[i];
					tab.x = tabs[i - 1].x + tabs[i - 1].width + spacing;
					
					if (tab.x + tab.width > width - 20)
					{
						tab.visible = false;
					}
				}
				
				isUpdated = true;
			}
		}
		
		/**
		 * Перемещает таб в начало.
		 * @param	text название таба.
		 */
		private function pushForward(text:String):void
		{
			for (var i:int = 0; i < tabs.length; i++) 
			{
				if (text == tabs[i].button.getText())
				{
					var tab:SkyTab = tabs.removeAt(i) as SkyTab;
					tab.button.visible = true;
					tab.listener.onEnterTab();
					tab.select();
					tabs.unshift(tab);
					
					mCurrentTab.listener.onExitTab();
					mCurrentTab = tab;
					
					isUpdated = false;
					
					break;
				}
			}
			
			menu.hideList();
		}
	}
}