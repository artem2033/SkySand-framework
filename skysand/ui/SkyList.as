package skysand.ui
{
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyShape;
	import skysand.input.SkyMouse;
	import skysand.text.SkyFont;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyList extends SkyRenderObjectContainer
	{
		/**
		 * Число видимых кнопок.
		 */
		private var visibleCount:int;
		
		/**
		 * Координаты кнопок.
		 */
		private var positions:Vector.<Number>;
		
		/**
		 * Кнопки.
		 */
		private var items:Vector.<SkyButton>;
		
		/**
		 * Названия кнопок.
		 */
		private var names:Vector.<String>;
		
		/**
		 * Смещение следующей кнопки по оси у.
		 */
		private var dy:Number;
		
		/**
		 * Высота кнопок.
		 */
		private var itemHeight:Number;
		
		/**
		 * Слайдер.
		 */
		private var slider:SkySlider;
		
		/**
		 * Шрифт.
		 */
		private var font:String;
		
		/**
		 * Цвет шрифта.
		 */
		private var textColor:uint;
		
		/**
		 * Автоматически скрывать или показывать слайдер.
		 */
		public var autoVisibleSlider:Boolean;
		
		/**
		 * Добавить слайдер.
		 */
		private var addSlider:Boolean;
		
		/**
		 * Путь к текстурному атласу с шрифтом.
		 */
		private var atlasName:String;
		
		/**
		 * Директория с текстурным атласом.
		 */
		private var directory:uint;
		
		/**
		 * Размер шрифта.
		 */
		private var fontSize:Number;
		
		/**
		 * Растровый или векторный шрифт.
		 */
		private var isBitmapFont:Boolean;
		
		/**
		 * Маски.
		 */
		private var downMask:SkyShape;
		private var upMask:SkyShape;
		
		public function SkyList()
		{
			names = new Vector.<String>();
			items = new Vector.<SkyButton>();
			positions = new Vector.<Number>();
			
			dy = 0;
		}
		
		public function create(width:Number, itemHeight:Number, color:uint, visibleCount:int, textColor:uint, font:String, autoVisibleSlider:Boolean = false):void
		{
			this.autoVisibleSlider = autoVisibleSlider;
			this.visibleCount = visibleCount;
			this.itemHeight = itemHeight;
			this.textColor = textColor;
			this.color = color;
			this.width = width;
			this.font = font;
			
			isBitmapFont = false;
			fontSize = 14;
			atlasName = "";
			directory = 0;
			height = itemHeight * visibleCount;
			
			slider = new SkySlider();
			slider.create(true, SkyUI.RECTANGLE, itemHeight * visibleCount, 8, itemHeight);
			slider.x = width;
			slider.visible = false;
			addChild(slider);
			
			upMask = new SkyShape();
			upMask.color = color;
			upMask.drawRect(0, 0, width, itemHeight);
			upMask.y -= itemHeight;
			upMask.alpha = 0;
			upMask.visible = false;
			addChild(upMask);
			
			downMask = new SkyShape();
			downMask.color = color;
			downMask.drawRect(0, 0, width, itemHeight);
			downMask.y = itemHeight * visibleCount;
			downMask.alpha = 0;
			downMask.visible = false;
			addChild(downMask);
		}
		
		public function set sliderWidth(value:Number):void
		{
			slider.setSize(value, itemHeight * visibleCount);
		}
		
		/**
		 * Число элементов в списке.
		 */
		public function get numItems():int
		{
			return items.length;
		}
		
		/**
		 * Получить массив с кнопками.
		 */
		public function getItems():Vector.<SkyButton>
		{
			return items;
		}
		
		/**
		 * Получить массив с названиями кнопок.
		 */
		public function getNames():Vector.<String>
		{
			return names;
		}
		
		/**
		 * Удалить из списка.
		 * @param	index номер.
		 */
		public function removeItem(index:int):void
		{
			var item:SkyButton = items[index];
			removeChild(item);
			item.free();
			item = null;
			
			names.removeAt(index);
			items.removeAt(index);
			positions.removeAt(index);
			
			for (var i:int = index; i < items.length; i++) 
			{
				items[i].y -= itemHeight;
				positions[i] -= itemHeight;
			}
			
			dy -= itemHeight;
			
			if (items.length <= visibleCount)
			{
				upMask.visible = false;
				downMask.visible = false;
			}
		}
		
		/**
		 * Добавить в список.
		 * @param	text наименование.
		 * @param	mFunction функция, выполняющаяся в результате нажатия.
		 * @param	buttonColor цвет кнопки.
		 * @param	kind форма.
		 * @param	modification модификация формы.
		 */
		public function addItem(text:String, mFunction:Function = null, returnName:Boolean = false, buttonColor:uint = 0, kind:uint = 1, modification:uint = 0):void
		{
			var item:SkyButton = new SkyButton();
			item.create(kind, width, itemHeight, buttonColor != 0 ? buttonColor : color, mFunction, false, modification);
			item.setFunction(mFunction, returnName);
			item.y = dy;
			
			if (text != "") 
			{
				if (atlasName == "") item.addText(text, font, textColor, fontSize);
				else item.addBitmapText(atlasName, text, textColor);
			}
			
			addChildAt(item, 1);
			
			names.push(text);
			items.push(item);
			positions.push(dy);
			dy += itemHeight;
			
			slider.visible = items.length > visibleCount ? true : false;
			addSlider = slider.visible;
			
			if (items.length > visibleCount)
			{
				upMask.visible = true;
				downMask.visible = true;
			}
		}
		
		/**
		 * Сменить текстовые поля у кнопок на растровые.
		 * @param	filePath путь к файлу с шрифтом.
		 * @param	directory директория.
		 */
		public function setBitmapTextField(name:String):void
		{
			atlasName = name;
			var length:int = items.length;
			
			if (isBitmapFont)
			{
				for (var i:int = 0; i < length; i++) 
				{
					items[i].setBitmapFont(name);
				}
				
				return;
			}
			
			for (i = 0; i < length; i++) 
			{
				items[i].addBitmapText(name, items[i].getText(), textColor);
			}
			
			isBitmapFont = true;
		}
		
		/**
		 * Сменить текстовые поля у кнопок на обычные.
		 * @param	font шрифт.
		 * @param	fontSize размер шрифта.
		 */
		public function setTextField(font:String, fontSize:Number):void
		{
			this.font = font;
			this.fontSize = fontSize;
			atlasName = "";
			
			var length:int = items.length;
			
			if (!isBitmapFont)
			{
				for (var i:int = 0; i < length; i++) 
				{
					items[i].setFont(font, fontSize);
				}
				
				return;
			}
			
			for (i = 0; i < length; i++) 
			{
				items[i].addText(items[i].getText(), font, textColor, fontSize);
			}
			
			isBitmapFont = false;
		}
		
		/**
		 * Нажат ли элемент в списке.
		 * @param	index номер кнопки.
		 * @return true - нажата, false - нет.
		 */
		public function isDown(index:int):Boolean
		{
			return items[index].isDown;
		}
		
		/**
		 * Активировать кнопку.
		 * @param	index номер кнопки.
		 */
		public function enableButton(index:int):void
		{
			items[index].enable();
		}
		
		/**
		 * Деактивировать кнопку.
		 * @param	index номер кнопки.
		 */
		public function disableButton(index:int):void
		{
			items[index].disable();
		}
		
		/**
		 * Задать количиство видимых элементов в списке.
		 * @param	count количество.
		 */
		public function setVisibleCount(count:int):void
		{
			downMask.y = itemHeight * count;
			
			visibleCount = count;
		}
		
		/**
		 * Изменить цвет списка.
		 * @param	button цвет кнопки.
		 * @param	text цвет текста.
		 */
		public function setColors(button:uint, text:uint):void
		{
			var length:int = items.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var item:SkyButton = items[i];
				
				item.setColor(button);
				item.setTextColors(text);
			}
		}
		
		/**
		 * Изменить шрифт кнопок.
		 * @param	font шрифт.
		 * @param	size размер.
		 */
		public function setFont(font:String, size:Number = 14):void
		{
			this.font = font;
			fontSize = size;
			
			for (var i:int = 0; i < items.length; i++) 
			{
				var item:SkyButton = items[i];
				item.setFont(font, size);
				item.setText(names[i]);
			}
		}
		
		/**
		 * Изменить размер списка.
		 * @param	width ширина.
		 * @param	itemHeight высота кнопки.
		 */
		public function setSize(width:Number, itemHeight:Number):void
		{
			dy = 0;
			var length:int = items.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var item:SkyButton = items[i];
				item.recreate(1, width, itemHeight);
				item.y = dy;
				positions[i] = dy;
				dy += itemHeight;
			}
			
			downMask.width = width;
			downMask.height = itemHeight;
			downMask.y = dy;
			upMask.width = width;
			upMask.height = itemHeight;
			upMask.y = -itemHeight;
			
			slider.x = width;
			slider.setSize(8, itemHeight * visibleCount);
			
			this.itemHeight = itemHeight;
			this.width = width;
			this.height = itemHeight * visibleCount;
		}
		
		/**
		 * Прозрачность.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			var length:int = items.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				items[i].setAlpha(value);
			}
			
			slider.setAlpha(value);
		}
		
		/**
		 * Изменить цвет слайдера.
		 * @param	buttonColor цвет кнопки.
		 * @param	backgroundColor цвет фона.
		 */
		public function setSliderColors(buttonColor:uint, backgroundColor:uint):void
		{
			slider.setColor(buttonColor, backgroundColor);
		}
		
		/**
		 * Обновить данные.
		 * @param	deltaTime время прошедшее между кадрами.
		 */
		override public function updateData(deltaTime:Number):void 
		{
			if (addSlider)
			{
				var length:int = items.length;
				
				for (var i:int = 0; i < length; i++) 
				{
					var item:SkyButton = items[i]
					
					item.y = positions[i] - slider.position * itemHeight * (length - visibleCount);
					
					if (item.y < -itemHeight + 1 || item.y > height - 1)
					{
						item.visible = false;
					}
					else
					{
						item.visible = true;
					}
				}
				
				if (autoVisibleSlider)
				{
					if (hitTestSlider())
					{
						slider.visible = true;
					}
					else 
					{
						if(!SkyMouse.instance.isDown(SkyMouse.LEFT))
							slider.visible = false;
					}
				}
			}
			
			super.updateData(deltaTime);
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(slider);
			slider.free();
			slider = null;
			
			removeChild(upMask);
			upMask.free();
			upMask = null;
			
			removeChild(downMask);
			downMask.free();
			downMask = null;
			
			var length:int = items.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				removeItem(0);
			}
			
			names.length = 0;
			names = null;
			items = null;
			positions = null;
			
			super.free();
		}
		
		/**
		 * Проверка на столкновение с мышкой.
		 * @return true - столкновение, false - нет столкновения.
		 */
		override public function hitTestMouse():Boolean 
		{
			var mx:Number = SkySand.STAGE.mouseX;
			var my:Number = SkySand.STAGE.mouseY;
			
			if (mx < globalX || mx > globalX + width + 8) return false;
			if (my < globalY || my > globalY + itemHeight * visibleCount) return false;
			
			return true;
		}
		
		/**
		 * Проверка на столкновение с мышкой слайдера.
		 * @return true - столкновение, false - нет столкновения.
		 */
		private function hitTestSlider():Boolean 
		{
			var mx:Number = SkySand.STAGE.mouseX;
			var my:Number = SkySand.STAGE.mouseY;
			
			if (mx < globalX + width || mx > globalX + width + 8) return false;
			if (my < globalY || my > globalY + itemHeight * visibleCount) return false;
			
			return true;
		}
	}
}