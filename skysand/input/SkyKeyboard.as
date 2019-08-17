package skysand.input
{
	import flash.display.Stage;
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldType;
	import flash.text.TextField;
	
	public class SkyKeyboard extends Object
	{
		/**
		 * Символ введёный с клавиатуры.
		 */
		public static var char:String;
		
		/**
		 * Нажата ли любая из клавиш.
		 */
		public static var anyKeyDown:Boolean;
		
		/**
		 * Нажата ли клавиша с символом.
		 */
		public static var anyCharKeyDown:Boolean;
		
		/**
		 * Оключить клавиатуру.
		 */
		public static var isActive:Boolean;
		
		/**
		 * Текстовое поле для получения символов.
		 */
		private var textField:TextField;
		
		/**
		 * Число клавиш на клавиатуре.
		 */
		private const NUM_KEYS:int = 99;
		
		/**
		 * Массив клавиш с данными о каждой.
		 */
		private static var keys:Vector.<SkyKeyData>;
		
		/**
		 * Конструктор.
		 */
		public function SkyKeyboard()
		{
			
		}
		
		/**
		 * Инициализация класса.
		 * @param	_stage ссылка на сцену.
		 */
		public function initialize(stage:Stage):void
		{
			keys = new Vector.<SkyKeyData>(NUM_KEYS, true);
			addKeys();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			
			anyKeyDown = false;
			anyCharKeyDown = false;
			char = "";
			isActive = true;
			
			textField = new TextField();
			textField.type = TextFieldType.INPUT;
			textField.visible = false;
			textField.mouseEnabled = false;
			textField.selectable = false;
			textField.addEventListener(TextEvent.TEXT_INPUT, onTextInputHandler);
		}
		
		/**
		 * Была ли нажата клавиша.
		 * @param	keyID уникальный номер клавиши из класса SkyKey.
		 * @return возвращает true если нажата клавиша.
		 */
		public static function isPressed(keyID:uint):Boolean
		{
			return keys[keyID].pressedState == 1 && isActive ? true : false;;
		}
		
		/**
		 * Была ли зажата клавиша.
		 * @param	keyID уникальный номер клавиши из класса SkyKey.
		 * @return возвращает true если клавиша зажата.
		 */
		public static function isDown(keyID:uint):Boolean
		{
			return keys[keyID].downState == 1 && isActive ? true : false;
		}
		
		/**
		 * Слушатель на ввод в текстовое поле.
		 * @param	textEvent событие текста.
		 */
		private function onTextInputHandler(textEvent:TextEvent):void
		{
			char = textEvent.text.charAt(0);
			textEvent.preventDefault();
			
			if (char.length != 0) anyCharKeyDown = true;
		}
		
		/**
		 * Привязать функцию к клавише.
		 * @param	keyID уникальный номер клавиши из класса SkyKey.
		 * @param	metod функция которую нужно привязать.
		 * @param	doWhileKeyDown выполнять пока зажата клавиши или однократное выполнение.
		 * @param	isOverwritten можно ли после первого раза перезаписать клавишу.
		 */
		public function addFunctionToKey(keyID:uint, metod:Function, doWhileKeyDown:Boolean = false, isOverwritten:Boolean = true):void
		{
			if (keys[keyID].isOverwritten)
			{
				keys[keyID].mainMetod = metod;
				keys[keyID].doWhileKeyDown = doWhileKeyDown;
				keys[keyID].isOverwritten = isOverwritten;
			}
		}
		
		/**
		 * Привязать дополнительную(вторую) функцию к клавише.
		 * @param	keyID уникальный номер клавиши из класса SkyKey.
		 * @param	metod функция которую нужно привязать.
		 */
		public function addSecondFunctionToKey(keyID:uint, metod:Function):void
		{
			if (keys[keyID].isOverwritten && keys[keyID].mainMetod != null) keys[keyID].secondMetod = metod;
		}
		
		/**
		 * Обновить экземпляр класса.
		 */
		public function update():void
		{
			if (!isActive) return;
			
			for (var i:int = 0; i < NUM_KEYS; i++) 
			{
				var key:SkyKeyData = keys[i];
				
				if (key.mainMetod == null) continue;
				
				if (key.doWhileKeyDown)
				{
					if (isPressed(i))
					{
						key.mainMetod.apply();
						if (key.secondMetod != null) key.secondMetod.apply();
					}
				}
				else
				{
					if (isDown(i))
					{
						key.mainMetod.apply();
						if (key.secondMetod != null) key.secondMetod.apply();
					}
				}
			}
		}
		
		/**
		 * Сбросить значения кнопок к ненажатым.
		 */
		public function reset():void
		{
			for (var i:int = 0; i < NUM_KEYS; i++) 
			{
				keys[i].pressedState = 0;
			}
		}
		
		/**
		 * Добавить все клавиши с их кодами в массив.
		 */
		private function addKeys():void
		{
			addKey(SkyKey.A, 65);
			addKey(SkyKey.ALTERNATE, 18);
			addKey(SkyKey.B, 66);
			addKey(SkyKey.BACKQUOTE, 192);
			addKey(SkyKey.BACKSLASH, 220);
			addKey(SkyKey.BACKSPACE, 8);
			addKey(SkyKey.C, 67);
			addKey(SkyKey.CAPS_LOCK, 20);
			addKey(SkyKey.COMMA, 188);
			addKey(SkyKey.COMMAND, 15);
			addKey(SkyKey.CONTROL, 17);
			addKey(SkyKey.D, 68);
			addKey(SkyKey.DELETE, 46);
			addKey(SkyKey.DOWN, 40);
			addKey(SkyKey.E, 69);
			addKey(SkyKey.END, 35);
			addKey(SkyKey.ENTER, 13);
			addKey(SkyKey.EQUAL, 187);
			addKey(SkyKey.ESCAPE, 27);
			addKey(SkyKey.F, 70);
			addKey(SkyKey.F1, 112);
			addKey(SkyKey.F10, 121);
			addKey(SkyKey.F11, 122);
			addKey(SkyKey.F12, 123);
			addKey(SkyKey.F13, 124);
			addKey(SkyKey.F14, 125);
			addKey(SkyKey.F15, 126);
			addKey(SkyKey.F2, 113);
			addKey(SkyKey.F3, 114);
			addKey(SkyKey.F4, 115);
			addKey(SkyKey.F5, 116);
			addKey(SkyKey.F6, 117);
			addKey(SkyKey.F7, 118);
			addKey(SkyKey.F8, 119);
			addKey(SkyKey.F9, 120);
			addKey(SkyKey.G, 71);
			addKey(SkyKey.H, 72);
			addKey(SkyKey.HOME, 36);
			addKey(SkyKey.I, 73);
			addKey(SkyKey.INSERT, 45);
			addKey(SkyKey.J, 74);
			addKey(SkyKey.K, 75);
			addKey(SkyKey.L, 76);
			addKey(SkyKey.LEFT, 37);
			addKey(SkyKey.LEFTBRACKET, 219);
			addKey(SkyKey.M, 77);
			addKey(SkyKey.MINUS, 189);
			addKey(SkyKey.N, 78);
			addKey(SkyKey.NUMBER_0, 48);
			addKey(SkyKey.NUMBER_1, 49);
			addKey(SkyKey.NUMBER_2, 50);
			addKey(SkyKey.NUMBER_3, 51);
			addKey(SkyKey.NUMBER_4, 52);
			addKey(SkyKey.NUMBER_5, 53);
			addKey(SkyKey.NUMBER_6, 54);
			addKey(SkyKey.NUMBER_7, 55);
			addKey(SkyKey.NUMBER_8, 56);
			addKey(SkyKey.NUMBER_9, 57);
			addKey(SkyKey.NUMPAD, 21);
			addKey(SkyKey.NUMPAD_0, 96);
			addKey(SkyKey.NUMPAD_1, 97);
			addKey(SkyKey.NUMPAD_2, 98);
			addKey(SkyKey.NUMPAD_3, 99);
			addKey(SkyKey.NUMPAD_4, 100);
			addKey(SkyKey.NUMPAD_5, 101);
			addKey(SkyKey.NUMPAD_6, 102);
			addKey(SkyKey.NUMPAD_7, 103);
			addKey(SkyKey.NUMPAD_8, 104);
			addKey(SkyKey.NUMPAD_9, 105);
			addKey(SkyKey.NUMPAD_ADD, 107);
			addKey(SkyKey.NUMPAD_DECIMAL, 110);
			addKey(SkyKey.NUMPAD_DIVIDE, 111);
			addKey(SkyKey.NUMPAD_ENTER, 108);
			addKey(SkyKey.NUMPAD_MULTIPLY, 106);
			addKey(SkyKey.NUMPAD_SUBTRACT, 109);
			addKey(SkyKey.O, 79);
			addKey(SkyKey.P, 80);
			addKey(SkyKey.PAGE_DOWN, 34);
			addKey(SkyKey.PAGE_UP, 33);
			addKey(SkyKey.PERIOD, 190);
			addKey(SkyKey.Q, 81);
			addKey(SkyKey.QUOTE, 222);
			addKey(SkyKey.R, 82);
			addKey(SkyKey.RIGHT, 39);
			addKey(SkyKey.RIGHTBRACKET, 221);
			addKey(SkyKey.S, 83);
			addKey(SkyKey.SEMICOLON, 186);
			addKey(SkyKey.SHIFT, 16);
			addKey(SkyKey.SLASH, 191);
			addKey(SkyKey.SPACE, 32);
			addKey(SkyKey.T, 84);
			addKey(SkyKey.TAB, 9);
			addKey(SkyKey.U, 85);
			addKey(SkyKey.UP, 38);
			addKey(SkyKey.V, 86);
			addKey(SkyKey.W, 87);
			addKey(SkyKey.X, 88);
			addKey(SkyKey.Y, 89);
			addKey(SkyKey.Z, 90);
		}
		
		/**
		 * Добавить одну клавишу.
		 * @param	index номер клавиши.
		 * @param	keyCode код клавиши.
		 */
		private function addKey(index:int, keyCode:uint):void
		{
			var key:SkyKeyData = new SkyKeyData();
			key.сode = keyCode;
			keys[index] = key;
		}
		
		/**
		 * Слушатель на нажатие клавиши на клавиатуре.
		 * @param	keyboardEvent событие клавиатуры.
		 */
		private function onKeyDownHandler(keyboardEvent:KeyboardEvent):void
		{
			for (var i:int = 0; i < NUM_KEYS; i++) 
			{
				var key:SkyKeyData = keys[i];
				
				if (keyboardEvent.keyCode == key.сode)
				{
					key.downState = 1;
					key.pressedState = 1;
					break;
				}
			}
			
			anyKeyDown = true;
			
			
			if (keyboardEvent.charCode != 0) anyCharKeyDown = true;
			if (keyboardEvent.keyCode == 27) keyboardEvent.preventDefault();
		}
		
		/**
		 * Слушатель на отпускание клавиши на клавиатуре.
		 * @param	keyboardEvent событие клавиатуры.
		 */
		private function onKeyUpHandler(keyboardEvent:KeyboardEvent):void
		{
			for (var i:int = 0; i < NUM_KEYS; i++) 
			{
				var key:SkyKeyData = keys[i];
				
				if (keyboardEvent.keyCode == key.сode)
				{
					key.downState = 0;
					break;
				}
			}
			
			anyKeyDown = false;
			anyCharKeyDown = false;
			char = "";
		}
	}
}