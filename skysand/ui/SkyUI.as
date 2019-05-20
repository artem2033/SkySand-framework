package skysand.ui 
{
	import flash.utils.ByteArray;
	
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyShape;
	import skysand.text.SkyTextField;
	import skysand.text.SkyBitmapText;
	import skysand.file.SkyFilesCache;
	import skysand.file.SkyTextureAtlas;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyUI extends SkyRenderObjectContainer
	{
		public static const CIRCLE:uint = 0;
		public static const RECTANGLE:uint = 1;
		public static const LOW_ROUND_RECTANGLE:uint = 2;
		public static const MIDDLE_ROUND_RECTANGLE:uint = 3;
		public static const FULL_ROUND_RECTANGLE:uint = 4;
		public static const IN_ROUND_RECTANGLE:uint = 5;
		public static const RING:uint = 6;
		public static const FRAME:uint = 7;
		public static const CROSS_ICON:uint = 8;
		public static const CHECK_ICON:uint = 9;
		public static const TRIANGLE:uint = 10;
		
		public static const CUT_LEFT:uint = 1;
		public static const CUT_RIGHT:uint = 2;
		public static const CUT_DOWN:uint = 3;
		public static const CUT_UP:uint = 4;
		
		public static const BUTTON:uint = 0;
		public static const TEXT_FIELD:uint = 1;
		public static const CHECK_BOX:uint = 2;
		public static const DROP_DOWN_LIST:uint = 3;
		public static const LIST:uint = 4;
		public static const INPUT_COLOR:uint = 5;
		public static const INPUT_NUMBER:uint = 6;
		public static const PROGRESS_BAR:uint = 7;
		public static const SLIDER:uint = 8;
		public static const TOGGLE_BUTTON:uint = 9;
		public static const BITMAP_TEXT:uint = 10;
		
		private static const MIN_ROUND:int = 9;
		private static const MID_ROUND:int = 20;
		private static const MAX_ROUND:int = 10;
		
		/**
		 * Массив с загруженными компонентами.
		 */
		private var components:Vector.<SkyRenderObject>;
		
		
		public function SkyUI()
		{
			
		}
		
		public static function getForm(kind:uint, color:uint, width:Number, height:Number, modification:uint = 0):SkyShape
		{
			var form:SkyShape = new SkyShape();
			form.color = color;
			
			const THICKNESS:int = 2;
			
			switch (kind)
			{
				case CIRCLE: 
				{
					form.drawCircle(0, 0, width, height);
					break;
				}
				
				case RECTANGLE: 
				{
					form.drawRect(0, 0, width, height);
					break;
				}
				
				case LOW_ROUND_RECTANGLE: 
				{
					width = width < MIN_ROUND ? MIN_ROUND : width;
					height = height < MIN_ROUND ? MIN_ROUND : height;
					
					var round:int = (MIN_ROUND - 1) / 2;
					
					if (modification == 0)
					{
						form.drawRoundRect(0, 0, width, height, round, MIN_ROUND);
					}
					else if (modification == CUT_DOWN)
					{
						form.drawFullRoundRect(0, 0, width, height, MIN_ROUND, round, round, 0, 0);
					}
					else if (modification == CUT_LEFT)
					{
						form.drawFullRoundRect(0, 0, width, height, MIN_ROUND, 0, round, 0, round);
					}
					else if (modification == CUT_RIGHT)
					{
						form.drawFullRoundRect(0, 0, width, height, MIN_ROUND, round, 0, round, 0);
					}
					else if (modification == CUT_UP)
					{
						form.drawFullRoundRect(0, 0, width, height, MIN_ROUND, 0, 0, round, round);
					}
					
					break;
				}
				
				case MIDDLE_ROUND_RECTANGLE: 
				{
					width = width < MID_ROUND ? MID_ROUND : width;
					height = height < MID_ROUND ? MID_ROUND : height;
					
					if (modification == 0)
					{
						form.drawRoundRect(0, 0, width, height, MID_ROUND / 2, MID_ROUND);
					}
					else if (modification == CUT_DOWN)
					{
						form.drawFullRoundRect(0, 0, width, height, MID_ROUND, MID_ROUND / 2, MID_ROUND / 2, 0, 0);
					}
					else if (modification == CUT_LEFT)
					{
						form.drawFullRoundRect(0, 0, width, height, MID_ROUND, 0, MID_ROUND / 2, 0, MID_ROUND / 2);
					}
					else if (modification == CUT_RIGHT)
					{
						form.drawFullRoundRect(0, 0, width, height, MID_ROUND, MID_ROUND / 2, 0, MID_ROUND / 2, 0);
					}
					else if (modification == CUT_UP)
					{
						form.drawFullRoundRect(0, 0, width, height, MID_ROUND, 0, 0, MID_ROUND / 2, MID_ROUND / 2);
					}
					
					break;
				}
				
				case FULL_ROUND_RECTANGLE: 
				{
					width = width < MAX_ROUND ? MAX_ROUND : width;
					height = height < MAX_ROUND ? MAX_ROUND : height;
					
					const NUM_SIDES:int = 50;
					
					if (modification == 0)
					{
						if (width < height)
						{
							form.drawRoundRect(0, 0, width, height, width / 2, NUM_SIDES);
						}
						else
						{
							form.drawRoundRect(0, 0, width, height, height / 2, NUM_SIDES);
						}
					}
					else if (modification == CUT_DOWN)
					{
						if (width < height)
						{
							form.drawFullRoundRect(0, 0, width, height, NUM_SIDES, width / 2, width / 2, 0, 0);
						}
						else
						{
							form.drawFullRoundRect(0, 0, width, height, NUM_SIDES, height / 2, height / 2, 0, 0);
						}
					}
					else if (modification == CUT_LEFT)
					{
						if (width < height)
						{
							form.drawFullRoundRect(0, 0, width, height, NUM_SIDES, 0, width / 2, 0, width / 2);
						}
						else
						{
							form.drawFullRoundRect(0, 0, width, height, NUM_SIDES, 0, height / 2, 0, height / 2);
						}
					}
					else if (modification == CUT_RIGHT)
					{
						if (width < height)
						{
							form.drawFullRoundRect(0, 0, width, height, NUM_SIDES, width / 2, 0, width / 2, 0);
						}
						else
						{
							form.drawFullRoundRect(0, 0, width, height, NUM_SIDES, height / 2, 0, height / 2, 0);
						}
					}
					else if (modification == CUT_UP)
					{
						if (width < height)
						{
							form.drawFullRoundRect(0, 0, width, height, NUM_SIDES, 0, 0, width / 2, width / 2);
						}
						else
						{
							form.drawFullRoundRect(0, 0, width, height, NUM_SIDES, 0, 0, height / 2, height / 2);
						}
					}
					
					break;
				}
				
				case IN_ROUND_RECTANGLE:
				{
					form.addVertex(0, 0);
					form.addVertex(0, width);
					form.addVertex(width, width);
					
					var numSides:int = height;
					var offset:Number = Math.PI / 2;
					var angleDelta:Number = offset / numSides;
					var angle:Number = angleDelta;
					var radius:Number = width / 2;
					
					for (var i:int = 0; i < numSides - 2; i++)
					{
						var px:Number = Math.cos(angle + offset) * radius + radius;
						var py:Number = Math.sin(angle + offset) * radius + width - radius;
						
						form.addVertex(px, py);
						
						angle += angleDelta;
					}
					
					//form.pivotX = width;
					form.pivotY = width;
					
					break;
				}
				
				case RING: 
				{
					form.drawRing(0, 0, width, width - THICKNESS, width);
					break;
				}
				
				case FRAME: 
				{
					form.drawFrame(0, 0, width - THICKNESS, height - THICKNESS, THICKNESS);
					break;
				}
				
				case CROSS_ICON:
				{
					form.addVertex(0, 1);
					form.addVertex(1, 0);
					form.addVertex(2, 1);
					form.addVertex(3, 0);
					form.addVertex(4, 1);
					form.addVertex(3, 2);
					form.addVertex(4, 3);
					form.addVertex(3, 4);
					form.addVertex(2, 3);
					form.addVertex(1, 4);
					form.addVertex(0, 3);
					form.addVertex(1, 2.001);
					
					break;
				}
				
				case CHECK_ICON:
				{
					form.addVertex(0, 0);
					form.addVertex(1, 1);
					form.addVertex(3, -1);
					form.addVertex(3.5, -0.5);
					form.addVertex(1, 2);
					form.addVertex(-0.5, 0.5);
					
					break;
				}
				
				case TRIANGLE:
				{
					form.addVertex(0, 0);
					form.addVertex(width, 0);
					form.addVertex(0, height);
					
					break;
				}
			}
			
			return form;
		}
		
		
		/**
		 * Загрузить интерфейс из файла.
		 * @param	filePath путь к файлу.
		 * @param	directory директория.
		 */
		public function loadFromBytes(filePath:String, directory:uint = SkyFilesCache.APPLICATION_DIRECTORY):void
		{
			components = new Vector.<SkyRenderObject>();
			
			var bytes:ByteArray = SkyFilesCache.loadBytesFromFile(SkyFilesCache.getFile(filePath, directory));
			
			bytes.readByte();
			if (bytes.readUTFBytes(3) != "SUI") return;
			bytes.readByte();//version
			bytes.readByte();//compression
			bytes.readInt();//width
			bytes.readInt();//height
			bytes.readInt();//gridSize
			bytes.readUTF();//name
			
			if (bytes.readUTFBytes(3) == "FNT") 
			{
				while(bytes.readUTFBytes(3) != "DAT")
				{
					bytes.position -= 3;
					
					var name:String = bytes.readUTF();
					var path:String = bytes.readUTF();
					var dir:int = bytes.readByte();
					
					if (!SkySand.cache.isAtlasContains(name))
					{
						var font:SkyTextureAtlas = new SkyTextureAtlas();
						font.loadFromDirectory(path, dir);
						
						SkySand.cache.addTextureAtlas(font);
					}
				}
			} 
			
			bytes.position -= 3;
			
			if (bytes.readUTFBytes(3) != "DAT") return;
			var length:int = bytes.length - 5;
			
			while (bytes.position <= length)
			{
				switch(bytes.readByte())
				{
					case BUTTON:
						{
							var button:SkyButton = SkyUIDecode.getButton(bytes);
							addChild(button);
							
							components.push(button);
							
							break;
						}
						
					case TEXT_FIELD:
						{
							var textField:SkyTextField = SkyUIDecode.getTextField(bytes);
							addChild(textField);
							
							components.push(textField);
							
							break;
						}
						
					case CHECK_BOX:
						{
							var checkBox:SkyCheckBox = SkyUIDecode.getCheckBox(bytes);
							addChild(checkBox);
							
							components.push(checkBox);
							
							break;
						}
						
					case DROP_DOWN_LIST:
						{
							var menu:SkyDropDownList = SkyUIDecode.getDropDownList(bytes);
							addChild(menu);
							
							components.push(menu);
							break;
						}
						
					case LIST:
						{
							//var list:List = new List();
							//list.loadFromByteArray(bytes, rightPanel, this);
							
							break;
						}
						
					case INPUT_COLOR:
						{
							var inputColor:SkyInputColor = SkyUIDecode.getInputColor(bytes);
							addChild(inputColor);
							
							components.push(inputColor);
							
							break;
						}
						
					case INPUT_NUMBER:
						{
							var inputNumber:SkyInputNumber = SkyUIDecode.getInputNumber(bytes);
							addChild(inputNumber);
							
							components.push(inputNumber);
							
							break;
						}
						
					case PROGRESS_BAR:
						{
							//var	progressBar:ProgressBar = new ProgressBar();
							//progressBar.loadFromByteArray(bytes, rightPanel, this);
							
							break;
						}
						
					case SLIDER:
						{
							//var slider:Slider = new Slider();
							//slider.loadFromByteArray(bytes, rightPanel, this);
							
							break;
						}
						
					case TOGGLE_BUTTON:
						{
							//var toggleButton:ToggleButton = new ToggleButton();
							//toggleButton.loadFromByteArray(bytes, rightPanel, this);
							
							break;
						}
						
					case BITMAP_TEXT:
						{
							var bitmapText:SkyBitmapText = SkyUIDecode.getBitmapText(bytes);
							addChild(bitmapText);
							
							components.push(bitmapText);
							
							break;
						}
				}
			}
			
			//colors.sort(compare);
			components.sort(compare);
		}
		
		/**
		 * Получить ссылку на dropDownList.
		 * @param	name название.
		 * @param	linearSearch использовать линейный или бинарный поиск(по умолчанию бинарный).
		 * @return возвращает ссылку.
		 */
		public function getDropDownList(name:String, linearSearch:Boolean = false):SkyDropDownList
		{
			return SkyDropDownList(linearSearch ? searchLinearByName(name) : searchBinaryByName(name));
		}
		
		/**
		 * Получить ссылку на colorInput.
		 * @param	name название.
		 * @param	linearSearch использовать линейный или бинарный поиск(по умолчанию бинарный).
		 * @return возвращает ссылку.
		 */
		public function getColorInput(name:String, linearSearch:Boolean = false):SkyInputColor
		{
			return SkyInputColor(linearSearch ? searchLinearByName(name) : searchBinaryByName(name));
		}
		
		/**
		 * Получить ссылку на button.
		 * @param	name название.
		 * @param	linearSearch использовать линейный или бинарный поиск(по умолчанию бинарный).
		 * @return возвращает ссылку.
		 */
		public function getButton(name:String, linearSearch:Boolean = false):SkyButton
		{
			return SkyButton(linearSearch ? searchLinearByName(name) : searchBinaryByName(name));
		}
		
		/**
		 * Получить ссылку на textField.
		 * @param	name название.
		 * @param	linearSearch использовать линейный или бинарный поиск(по умолчанию бинарный).
		 * @return возвращает ссылку.
		 */
		public function getTextField(name:String, linearSearch:Boolean = false):SkyTextField
		{
			return SkyTextField(linearSearch ? searchLinearByName(name) : searchBinaryByName(name));
		}
		
		/**
		 * Получить ссылку на inputNumber.
		 * @param	name название.
		 * @param	linearSearch использовать линейный или бинарный поиск(по умолчанию бинарный).
		 * @return возвращает ссылку.
		 */
		public function getInputNumber(name:String, linearSearch:Boolean = false):SkyInputNumber
		{
			return SkyInputNumber(linearSearch ? searchLinearByName(name) : searchBinaryByName(name));
		}
		
		/**
		 * Получить ссылку на checkBox.
		 * @param	name название.
		 * @param	linearSearch использовать линейный или бинарный поиск(по умолчанию бинарный).
		 * @return возвращает ссылку.
		 */
		public function getCheckBox(name:String, linearSearch:Boolean = false):SkyCheckBox
		{
			return SkyCheckBox(linearSearch ? searchLinearByName(name) : searchBinaryByName(name));
		}
		
		/**
		 * Линейный поиск компонента по его имени.
		 * @param	name имя.
		 * @return возвращает SkyRenderObject, необходимо преобразовать в нужный компонент.
		 */
		public function searchLinearByName(name:String):SkyRenderObject
		{
			var length:int = components.length;
			var component:SkyRenderObject = null;
			
			for (var i:int = 0; i < length; i++) 
			{
				if (components[i].name == name)
				{
					component = components[i];
					break;
				}
			}
			
			return component;
		}
		
		/**
		 * Бинарный поиск компонента по его имени.
		 * @param	name имя.
		 * @return возвращает SkyRenderObject, необходимо преобразовать в нужный компонент.
		 */
		public function searchBinaryByName(name:String):SkyRenderObject
		{
			var low:int = 0;
			var high:int = components.length - 1;
			
			while (low <= high)
			{
				var mid:int = int((low + high) * 0.5);
				var value:String = components[mid].name;
				
				if (value < name)
				{
					low = mid + 1; 
				}
				else if (value > name)
				{
					high = mid - 1;
				}
				else return components[mid];
			}
			
			return null;
		}
		
		/**
		 * Компаратор для сортировки по имени компонента.
		 */
		private function compare(a:SkyRenderObject, b:SkyRenderObject):int
		{
			return a.name > b.name ? 1 : -1;
		}
		
		/**
		 * Преобразовать из строки в булево значение.
		 * @param	str строка.
		 * @return возвращает true/false.
		 */
		private function toBoolean(str:String):Boolean
		{
			return str == "false" ? false : true;
		}
	}
}