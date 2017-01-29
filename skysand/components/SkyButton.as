package skysand.components
{
	import flash.text.TextFieldAutoSize;
	import skysand.display.SkyGraphics;
	import skysand.mouse.SkyMouse;
	import skysand.text.SkyTextField;
	import skysand.utils.SkyUtils;
	
	public class SkyButton extends SkyGraphics
	{
		/**
		 * Режим, при котором одно нажатие включить, ещё одно выключить.
		 */
		public var toggleMode:Boolean;
		
		/**
		 * Ссылка на функцию.
		 */
		private var _function:Function;
		
		/**
		 * Ссылка на мышку.
		 */
		private var mouse:SkyMouse;
		
		/**
		 * Флаг для активации функции.
		 */
		private var isActive:Boolean;
		
		/**
		 * Флаг для проверки на нажатие.
		 */
		private var isPressed:Boolean;
		
		/**
		 * Картинка когда курсор находится над кнопкой.
		 */
		private var overState:SkyGraphics;
		
		/**
		 * Картинка когда пользователь нажал на кнопку.
		 */
		private var downState:SkyGraphics;
		
		/**
		 * Картинка когда курсор не находится над кнопкой.
		 */
		private var normalState:SkyGraphics;
		
		private var upColor:uint;
		private var overColor:uint;
		private var downColor:uint;
		
		private const UP_STATE:int = 0;
		private const OVER_STATE:int = 1;
		private const DOWN_STATE:int = 2;
		private var isSimple:Boolean;
		
		public function SkyButton() 
		{
			
		}
		
		/**
		 * Создать кнопку.
		 * @param	animName имя кэшированной анимации, которая должна состоять из минимум 2 кадров.
		 * @param	_function функция, которую нужно выполнять во время нажатия кнопки.
		 */
		public function create(_function:Function, normalState:SkyGraphics, overState:SkyGraphics = null, downState:SkyGraphics = null):void
		{
			this.normalState = normalState;
			this.downState = downState;
			this.overState = overState;
			this._function = _function;
			
			addChild(this.normalState);
			
			if (this.downState)
			{
				addChild(this.downState);
				
				this.downState.visible = false;
			}
			
			if (this.overState) 
			{
				addChild(this.overState);
				
				this.overState.visible = false;
			}
			
			mouse = SkyMouse.instance;
			
			toggleMode = false;
			isPressed = false;
			isActive = false;
			isSimple = false;
			
			//super.width = normalState.width;
			//super.height = normalState.height;
		}
		
		public function createSimpleButtonWithPreset(normalState:SkyGraphics, upColor:uint, overColor:uint, downColor:uint, _function:Function):void
		{
			this.normalState = normalState;
			this.upColor = upColor;
			this.overColor = overColor;
			this.downColor = downColor;
			this._function = _function;
			
			addChild(normalState);
			
			mouse = SkyMouse.instance;
			
			toggleMode = false;
			isPressed = false;
			isActive = false;
			isSimple = true;
			
			//width = normalState.width;
			//height = normalState.height;
		}
		
		public function createSimpleButton(color:uint, width:Number, height:Number, _function:Function, alpha:Number = 1, name:String = "", textColor:uint = 0xFFFFFF):void
		{
			normalState = new SkyGraphics();
			normalState.color = color;
			normalState.drawRect( -width * 0.5, -height * 0.5, width, height);
			addChild(normalState);
			
			var textField:SkyTextField = new SkyTextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.textColor = textColor;
			textField.size = 20;
			textField.embedFonts = true;
			textField.font = "hooge";
			textField.text = name;
			textField.x = -textField.width * 0.5;
			textField.y = -textField.height * 0.5;
			textField.autoSize = TextFieldAutoSize.NONE;
			addChild(textField);
			
			upColor = color;
			overColor = SkyUtils.changeColorBright(color, 50);
			downColor = SkyUtils.changeColorBright(color, -50);
			
			this._function = _function;
			mouse = SkyMouse.instance;
			
			toggleMode = false;
			isPressed = false;
			isActive = false;
			isSimple = true;
			
			super.width = width;
			super.height = height;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			toggleMode = false;
			isPressed = false;
			isActive = false;
			
			normalState = null;
			//bitmapData = null;
			overState = null;
			downState = null;
			_function = null;
			mouse = null;
			
			super.free();
		}
		
		/**
		 * Выключить (Пока не сделано).
		 */
		public function off():void
		{
			
		}
		
		/**
		 * Включить (Пока не сделано).
		 */
		public function on():void
		{
			
		}
		
		/**
		 * Обновить отрисовываемы объект (используется движком).
		 */
		override public function updateData():void 
		{
			//if (normalState.hitTestMouse() && mouse.LBMPressed) return;
			
			if (normalState.hitTestMouse())// || overState.hitTestMouse() || downState.hitTestMouse())
			{
				if (mouse.LBMPressed)
				{
					if (toggleMode) 
					{
						isActive = isActive ? false : true;
						changeState(isActive ? DOWN_STATE : OVER_STATE);
						mouse.LBMPressed = false;
					}
					else
					{
						changeState(DOWN_STATE);
						isPressed = true;
						isActive = false;
					}
				}
				else
				{
					if (!toggleMode)
					{
						if (isPressed) isActive = true;
						
						isPressed = false;
						changeState(OVER_STATE);
					}
					else if (!isActive)
					{
						changeState(OVER_STATE);
					}
				}
			}
			else
			{
				if (!toggleMode) changeState(UP_STATE);
				else if (!isActive) changeState(UP_STATE);
			}
			
			if (isActive)
			{
				_function.apply();
				if (!toggleMode) isActive = false;
			}
			
			super.updateData();
		}
		
		private function changeState(state:int):void
		{
			if (isSimple) normalState.color = state == UP_STATE ? upColor : state == OVER_STATE ? overColor : downColor;
			else
			{
				if (state == UP_STATE)
				{
					normalState.visible = true;
					
					if (downState) downState.visible = false;
					if (overState) overState.visible = false;
				}
				else if (state == OVER_STATE)
				{
					if (downState) downState.visible = false;
					if (overState)
					{
						overState.visible = true;
						normalState.visible = false;
					}
				}
				else
				{
					if (overState) overState.visible = false;
					if (downState) 
					{
						normalState.visible = false;
						downState.visible = true;
					}
				}
			}
		}
	}
}