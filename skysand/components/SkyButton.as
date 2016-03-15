package skysand.components
{
	import flash.display.BitmapData;
	import skysand.mouse.SkyMouse;
	import skysand.render.RenderObject;
	import skysand.animation.SkyAnimation;
	import skysand.animation.SkyAnimationCache;
	import skysand.interfaces.IFrameworkUpdatable;
	
	public class SkyButton extends RenderObject implements IFrameworkUpdatable
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
		private var overState:BitmapData;
		
		/**
		 * Картинка когда пользователь нажал на кнопку.
		 */
		private var downState:BitmapData;
		
		/**
		 * Картинка когда курсор не находится над кнопкой.
		 */
		private var normalState:BitmapData;
		
		public function SkyButton() 
		{
			
		}
		
		/**
		 * Создать кнопку.
		 * @param	animName имя кэшированной анимации, которая должна состоять из минимум 2 кадров.
		 * @param	_function функция, которую нужно выполнять во время нажатия кнопки.
		 */
		public function create(animationName:String, _function:Function):void
		{
			var animation:SkyAnimation = SkyAnimationCache.instance.getAnimation(animationName);
			
			normalState = animation.frames[0].bitmapData;
			downState	= animation.frames[1].bitmapData;
			overState	= animation.frames[2].bitmapData == null ? downState : animation.frames[2].bitmapData;
			bitmapData 	= normalState;
			
			this._function = _function;
			mouse = SkyMouse.instance;
			
			toggleMode = false;
			isPressed = false;
			isActive = false;
			
			super.width = normalState.width;
			super.height = normalState.height;
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
			bitmapData = null;
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
		override public function updateByFramework():void 
		{
			if (hitTestMouse())
			{
				if (mouse.LBMPressed)
				{
					if (toggleMode) 
					{
						isActive = isActive ? false : true;
						bitmapData = isActive ? downState : overState;
						mouse.LBMPressed = false;
					}
					else
					{
						bitmapData = downState;
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
						bitmapData = overState;
						
					}
					else if (!isActive)
					{
						bitmapData = overState;
					}
				}
			}
			else
			{
				if (!toggleMode) bitmapData = normalState;
				else if (!isActive) bitmapData = normalState;
			}
			
			if (isActive)
			{
				_function.apply();
				if (!toggleMode) isActive = false;
			}
			
			super.updateByFramework();
		}
	}
}