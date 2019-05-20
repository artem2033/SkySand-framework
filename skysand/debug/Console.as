package skysand.debug 
{	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import skysand.render.SkyHardwareRender;
	import skysand.text.SkyTextField;
	import skysand.render.software.RenderObject;
	import skysand.input.SkyKey;
	import skysand.input.SkyKeyboard;
	import skysand.ui.SkyColor;
	import skysand.ui.SkyWindow;
	
	public class Console extends SkyWindow
	{
		public static const GREY:uint = 0xCCCCCC;
		public static const RED:uint = 0xDF4040;
		public static const GREEN:uint = 0x279A63;
		public static const BLUE:uint = 0x316CBF;
		
		/**
		 * Поле ввода команд.
		 */
		private var inputField:SkyTextField;
		
		/**
		 * Поле отображения информации.
		 */
		private var displayField:SkyTextField;
		
		/**
		 * Текстовое поле с подсказками при вводе команд.
		 */
		private var helpField:SkyTextField;
		
		/**
		 * Число строк в поле отображения.
		 */
		private var stringCount:int;
		
		/**
		 * Внешний вид консоли.
		 */
		private var window:SkyWindow;
		
		/**
		 * Массив зарегестрированных команд.
		 */
		private var registredCommand:Vector.<RegisterData>;
		
		/**
		 * Счётчик зарегестрированных команд.
		 */
		private var commandLength:int;
		
		/**
		 * Массив слов с подсказками.
		 */
		private var helpWords:Vector.<String>;
		
		/**
		 * Счётчик числа слов, доступных для выбора.
		 */
		private var helpWordsCount:int;
		
		/**
		 * Текущий номер слова для из поля с подсказками.
		 */
		private var currentItemWord:int;
		
		/**
		 * Ссылка на клавиатуру.
		 */
		private var keyboard:SkyKeyboard;
		
		/**
		 * Ссылка на класс.
		 */
		private static var _instance:Console;
		
		public function Console()
		{
			if(_instance != null)
			{
				throw new Error("use instance");
			}
			_instance = this;
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():Console
		{
			return (_instance == null) ? new Console() : _instance;
		}
		
		/**
		 * Статичный метод для ввода сообщения в консоль.
		 * @param	value данные.
		 */
		public static function log(value:*, color:uint = 0):void
		{
			instance.message(String(value), color);
		}
		
		/**
		 * Если консоль не создана - создать.
		 * @param	_x - координата по х.
		 * @param	_y - координата по у.
		 */
		public function initialize():void
		{
			helpWords = new Vector.<String>();
			stringCount = 0;
			commandLength = 0;
			helpWordsCount = 0;
			currentItemWord = 0;
			
			keyboard = SkyKeyboard.instance;
			
			create(400, 480, 0xDBB71E, 0x151E27);
			addText("DEVELOPER CONSOLE", "verdana",  0x151E27, 12);
			
			displayField = new SkyTextField();
			displayField.textColor = 0xDBB71E;
			displayField.width = 400;
			displayField.height = 455;
			displayField.y = 25;
			displayField.font = "Consolas";
			displayField.size = 12;
			displayField.wordWrap = true;
			addChild(displayField);
			
			inputField = new SkyTextField();
			inputField.type = TextFieldType.INPUT;
			inputField.background = true;
			inputField.width = 400;
			inputField.height = 20;
			inputField.backgroundColor = 0xDBB71E;
			inputField.textColor = 0x151E27;
			inputField.y = 480;
			inputField.font = "Consolas";
			addChild(inputField);
			
			helpField = new SkyTextField();
			helpField.textColor = 0x151E27;
			helpField.y = 500;
			helpField.backgroundColor = 0xDBB71E;
			helpField.background = true;
			helpField.alpha = 0.8;
			helpField.visible = false;
			helpField.autoSize = TextFieldAutoSize.LEFT;
			helpField.font = "Consolas";
			addChild(helpField);
			
			registredCommand = new Vector.<RegisterData>();
			registerCommand("-help", help, []);
			registerCommand("-clear", clear, []);
			registerCommand("-reg", registerWrite, []);
			
			message("Framework: Консоль разработчика создана.", BLUE);
		}
		
		/**
		 * Зарегестрировать команду.
		 * @param	name команда активации функции.
		 * @param	func функция.
		 * @param	arg аргументы.
		 */
		public function registerCommand(name:String, _function:Function, _arguments:Array):void
		{
			var data:RegisterData = new RegisterData();
			data.name = name;
			data.func = _function;
			data.arg = _arguments;
			
			registredCommand[commandLength] = data;
			commandLength++;
			
			message("Console: Зарегистрирована новая команда: " + name, GREY);
		}
		
		/**
		 * Уничтожить консоль.
		 */
		override public function free():void
		{
			super.free();
			
			removeChild(inputField);
			inputField.free();
			inputField = null;
			
			removeChild(displayField);
			displayField.free();
			displayField = null;
			
			keyboard = null;
			
			for (var i:int = 0; i < commandLength; i++) 
			{
				registredCommand[i] = null;
			}
			
			registredCommand.length = 0;
			registredCommand = null;
			
			for (i = 0; i < helpWords.length; i++) 
			{
				helpWords[i] = null;
			}
			
			helpWords.length = 0;
			helpWords = null;
		}
		
		/**
		 * Ввести сообщение в консоль.
		 * @param	text текст.
		 */
		public function message(text:String, _color:uint = 0):void
		{
			if (displayField == null) return;
			
			_color = _color == 0 ? 0xDBB71E : _color;
			displayField.appendText(String(stringCount) + ": " + text + '\n');
			displayField.setColor(_color, displayField.length - text.length - 1, displayField.length);
			displayField.scrollV = displayField.maxScrollV;
			stringCount++;
		}
		
		/**
		 * Включение - выключение консоли.
		 */
		private function visibleControl():void
		{
			if (keyboard.isPressed(SkyKey.BACKQUOTE))
			{
				visible = !visible;
			}
		}
		
		/**
		 * Доступные стандартные команды.
		 */
		private function help():void
		{
			var helpText:String = "\t\t\t\t\tКоманды";
			helpText += "\n-clear - Очистить консоль.";
			helpText += "\n-help - Показать системные команды.";
			helpText += "\n-reg - Показать зарегистрированные команды.";
			
			message(helpText, GREEN);
		}
		
		/**
		 * Обновление консоли.
		 */
		public function update():void
		{
			if (!inputField.focus) visibleControl();
			else
			{
				if (helpWords.length > 0)
				{
					if (keyboard.isPressed(SkyKey.DOWN))
					{
						if (currentItemWord > helpWords.length - 1)
						{
							currentItemWord = 0;
						}
						
						currentItemWord++;
						inputField.text = helpWords[currentItemWord - 1];
						inputField.setSelection(inputField.length, inputField.length);
					}
					else if (keyboard.isPressed(SkyKey.UP))
					{
						if (currentItemWord < 2)
						{
							currentItemWord = helpWords.length + 1;
						}
						
						currentItemWord--;
						inputField.text = helpWords[currentItemWord - 1];
						inputField.setSelection(inputField.length, inputField.length);
					}
				}
				
				if (keyboard.anyCharKeyDown)
				{
					updateHelpWindow();
					keyboard.anyCharKeyDown = false;
				}
				
				applyCommand(inputField.text);
				scrolling();
			}
		}
		
		/**
		 * Скроллинг текста в консоли.
		 */
		private function scrolling():void
		{
			if (keyboard.isPressed(SkyKey.PAGE_UP))
			{
				displayField.scrollV--;
			}
			else if (keyboard.isPressed(SkyKey.PAGE_DOWN))
			{
				displayField.scrollV++;
			}
		}
		
		/**
		 * Показать список зарегестрированных команд.
		 */
		private function registerWrite():void
		{
			for (var i:int = 0; i < registredCommand.length; i++) 
			{
				message(registredCommand[i].name);
			}
		}
		
		/**
		 * Принять введённую команду.
		 * @param	comand - команда.
		 */
		private function applyCommand(command:String):void
		{
			if (keyboard.isPressed(SkyKey.ENTER) && command != "")
			{
				processCommand(command);
				inputField.text = "";
				updateHelpWindow();
			}
		}
		
		/**
		 * Проверить к какому типу относиться переменная и привести к нему.
		 * @param	argument строка с переменной.
		 * @return преобразованная переменная.
		 */
		private function processArguments(argument:String):*
		{
			var value:*;
			
			if (argument == "true")
			{
				value = true;
			}
			else if (argument == "false")
			{
				value = false;
			}
			else if (int(argument) == 0)
			{
				value = argument;
			}
			else
			{
				value = Number(argument);
			}
			
			return value;
		}
		
		/**
		 * Поделить строку на массив слов и строк, разделённых одинарными кавычками.
		 * Пример, строка "'hello world' 10 20" поделится на:
		 * 'hello world'
		 * 10
		 * 20
		 * @param	string исходная строка.
		 * @return возвращает получившийся массив.
		 */
		private function getArrayOfStrings(string:String):Array
		{
			var words:Array = string.split(' ');
			var flag:Boolean = false;
			var index:int = 0;
			
			for (var i:int = 0; i < words.length; i++)
			{
				var str:String = words[i];
				
				if(str.charAt(0) == '\'' && str.charAt(str.length - 1) == '\'')
				{
					str = str.substring(1, str.length - 1);
					words[i] = str;
				}
				
				if (str.charAt(0) == '\'')
				{
					words[i] = str.substring(1);
					index = i;
					flag = true;
				}
				
				if (flag && str.charAt(str.length - 1) != '\'')
				{
					if (i != index)
					{
						words[index] += ' ' + str;
						words.splice(i, 1);
						i--;
					}
				}
				else if (str.charAt(str.length - 1) == '\'')
				{
					flag = false;
					words[index] += ' ' + str.substring(0, str.length - 1);
					words.splice(i, 1);
					i--;
				} 
			}
			
			return words;
		}
		
		/**
		 * Проверить есть ли такая команда, если да то выполнить.
		 * @param	command текст команды.
		 */
		private function processCommand(command:String):void
		{
			var words:Array = command.indexOf('\'') != -1 ? getArrayOfStrings(command) : command.split(' ');
			var name:String = words[0];
			var arg:Array = [];
			
			for (var i:int = 1; i < words.length; i++) 
			{
				arg.push(processArguments(words[i]));
			}
			
			for (i = 0; i < commandLength; i++)
			{
				var data:RegisterData = registredCommand[i];
				
				if (data.name == name)
				{
					message(command);
					
					if (data.arg.length > 0)
					{
						data.func.apply(null, data.arg);
					}
					else
					{
						if (arg.length > 0 && data.func.length > 0)
						{
							data.func.apply(null, arg);
						}
						else if (arg.length != data.func.length)//arg.length == 0 || 
						{
							message("Error: empty, less or more function arguments!", RED);
						}
						else
						{
							data.func.apply();
						}
					}
					
					break;
				}
				else if (data.name != name && i == commandLength - 1) message("Unknown command: " + command, RED);
			}
		}
		
		/**
		 * Обновить окно с подсказками для ввода команд.
		 */
		private function updateHelpWindow():void
		{
			helpField.text = "";
			helpWords.splice(0, helpWordsCount);
			helpWordsCount = 0;
			
			for (var i:int = 0; i < commandLength; i++)
			{
				var data:RegisterData = registredCommand[i];
				
				if (data.name.match(inputField.text))
				{
					helpField.appendText(data.name + "\n");
					helpWords[helpWordsCount] = data.name;
					helpWordsCount++;
				}
			}
			
			if (inputField.text == "")
			{
				helpField.text = "";
				helpWords.splice(0, helpWordsCount);
				helpWordsCount = 0;
				helpField.visible = false;
			}
			else
			{
				helpField.visible = true;
			}
		}
		
		/**
		 * Очистить поле консоли.
		 */
		private function clear():void
		{
			stringCount = 0;
			displayField.text = "";
		}
	}
}