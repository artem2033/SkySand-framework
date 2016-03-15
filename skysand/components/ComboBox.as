import src.components.VerticalSlider;
import ssrc.componentsnts.Button;
package skysand.components components 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class ComboBox extends Sprite
	{
		/**
		 * Видимость списка.
		 */
		public var listVisible:Boolean;
		
		/**
		 * Массив с пунктами выбора.
		 */
		private var items:Vector.<ComboBoxItem>;
		
		/**
		 * Текущее значение пункта.
		 */
		private var currentValue:*;
		
		/**
		 * Вертикальный ползунок.
		 */
		private var slider:VerticalSlider;
		
		/**
		 * Кнопка открытия меню.
		 */
		private var openButton:Button;
		
		/**
		 * Ширина комбо бокс, определяется автоматически.
		 */
		private var maxWidth:Number;
		
		
		private var maxHeight:Number;
		
		/**
		 * Количество пунктов.
		 */
		private var itemCount:int;
		
		/**
		 * Маска списка.
		 */
		private var _mask:Sprite;
		
		/**
		 * Высота маски.
		 */
		private var visibleFieldHeight:Number;
		
		/**
		 * Использовать слайдер или нет.
		 */
		private var useSlider:Boolean;
		
		public function ComboBox() 
		{
			super();
		}
		
		/**
		 * Создает содержимое комбо бокса.
		 * @param	button главная кнопка.
		 * @param	_useSlider использовать вертикальный слайдер.
		 * @param	sliderSize ширина слайдера.
		 * @param	_visibleFieldHeight видимая высота списка.
		 * @param	_visibleFieldWidth видимая ширина списка.
		 */
		public function create(button:Button, _useSlider:Boolean = true, sliderSize:Number = 10, _visibleFieldHeight:Number = 100, _visibleFieldWidth:Number = 50):void
		{
			items = new Vector.<ComboBoxItem>();
			itemCount = 0;
			maxWidth = 0;
			maxHeight = -_visibleFieldHeight - button.height * 0.5 - 2;
			
			visibleFieldHeight = _visibleFieldHeight;
			useSlider = _useSlider;
			listVisible = false;
			
			openButton = button;
			addChild(openButton);
			
			if (useSlider)
			{
				slider = new VerticalSlider();
				slider.create(ComponentColor.STOP_COLOR, visibleFieldHeight + 2, sliderSize, 20);
				slider.y = (openButton.height + slider.height) * 0.5 - 2;
				slider.visible = false;
				addChild(slider);
				
				_mask = new Sprite();
				_mask.graphics.beginFill(0xFFFFFF);
				_mask.graphics.drawRect(-_visibleFieldWidth * 0.5, -openButton.height * 0.5, _visibleFieldWidth + sliderSize, _visibleFieldHeight + openButton.height - 1);
				this.mask = _mask;
				addChild(_mask);
			}
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			removeChild(slider);
			
			for (var i:int = 0; i < itemCount; i++) 
			{
				removeChild(items[i].button);
				items[i].button.free();
				items[i].button = null;
				items[i].position = null;
				items[i] = null;
			}
			
			items.splice(i, items.length);
			currentValue = 0;
			maxWidth = 0;
			itemCount = 0;
			
			slider.free();
			openButton.free();
			
			slider = null;
			openButton = null;
		}
		
		/**
		 * Добавить пункт выбора.
		 * @param	value значение.
		 */
		public function addItem(value:*, button:Button):void
		{
			var item:ComboBoxItem = new ComboBoxItem();
			item.value = value;
			item.button = button;
			item.button.visible = false;
			items.push(item);
			itemCount++;
			
			maxHeight += button.height;
			
			addChildAt(item.button, 0);
			
			if (items.length > 1)
			{
				item.position.y = (items[items.length - 2].button.height + item.button.height) * 0.5 - 2 + items[items.length - 2].button.y;
				item.button.y = item.position.y;
			}
			else 
			{
				item.position.y = (openButton.height + item.button.height) * 0.5 - 2;
				item.button.y = item.position.y;
			}
			
			if (useSlider)
			{
				maxWidth = maxWidth < item.button.width ? item.button.width : maxWidth;
				slider.x = (maxWidth + slider.width) * 0.5 - 1;
			}
		}
		
		/**
		 * Сделать пункт стартовым.
		 * @param	value значение пункта.
		 */
		public function setItem(value:*):void
		{
			for (var i:int = 0; i < itemCount; i++) 
			{
				var item:ComboBoxItem = items[i];
				
				if (item.value == value)
				{
					currentValue = item.value;
					item.button.x = 0;
					item.button.y = 0;
					item.button.visible = true;
					itemsToPosition(item);
					openButton.visible = false;
					return;
				}
			}
		}
		
		/**
		 * Текущая нажатая кнопка из списка.
		 * @param	currentValue значение которое содержиться в данной кнопке.
		 * @return возвращает нажата кнопка или нет.
		 */
		public function getCurrentButtonPressed(currentValue:*):Boolean
		{
			var comboBoxItem:ComboBoxItem;
			
			for (var i:int = 0; i < itemCount; i++) 
			{
				if (items[i].value == currentValue)
				{
					comboBoxItem = items[i];
				}
			}
			
			return comboBoxItem.button.pressed;
		}
		
		/**
		 * Сбросить изменения.
		 */
		public function reset():void
		{
			listVisible = false;
			itemsToPosition(null);
			switchListVisible(false);
			openButton.visible = true;
		}
		
		/**
		 * Обновить комбо бокс.
		 */
		public function update():void
		{
			if (openButton.pressed && openButton.visible)
			{
				listVisible = !listVisible ? true : false;
				switchListVisible(listVisible);
				if (useSlider) slider.visible = listVisible;
				openButton.pressed = false;
			}
			
			for (var i:int = 0; i < itemCount; i++) 
			{
				var item:ComboBoxItem = items[i];
				
				if (item.button.y == 0 && item.button.pressed)
				{
					listVisible = !listVisible ? true : false;
					switchListVisible(listVisible);
					
					if (useSlider)
					{
						slider.visible = listVisible;
						openButton.visible = true;
					}
					
					item.button.pressed = false;
				}
				
				if (item.button.pressed && item.button.y != 0)
				{
					currentValue = item.value;
					item.button.x = 0;
					item.button.y = 0;
					itemsToPosition(item);
					switchListVisible(false);
					openButton.visible = false;
					item.button.pressed = false;
					listVisible = false;
					if (useSlider) slider.visible = false;
				}
				
				if (listVisible && useSlider) item.button.y = item.position.y - slider.position * maxHeight;
			}
			
			if (useSlider) slider.update();
		}
		
		/**
		 * Получить текущее значения combo box.
		 */
		public function get value():*
		{
			return currentValue;
		}
		
		/**
		 * Нарисовать основную кнопку.
		 */
		public function changeColor(colorName:String):void
		{
			slider.changeColor(colorName);
		}
		
		/**
		 * Переключить видимость списка.
		 * @param	value значение.
		 */
		private function switchListVisible(value:Boolean):void
		{
			for (var i:int = 0; i < itemCount; i++) 
			{
				var item:ComboBoxItem = items[i];
				
				if (item.button.y == 0) continue;
				
				item.button.visible = value;
			}
		}
		
		/**
		 * Расставляет пункты по местам.
		 * @param	_item игнорируемый пункт.
		 */ 
		private function itemsToPosition(_item:ComboBoxItem):void
		{
			var itemIndex:int = int.MAX_VALUE;
			
			for (var i:int = 0; i < itemCount; i++) 
			{
				var item:ComboBoxItem = items[i];
				
				if (item == _item) 
				{
					itemIndex = i;
					continue;
				}
				
				if (itemIndex > i) item.button.y = item.position.y;
				else item.button.y = item.position.y - _item.button.height;
			}
		}
	}
}