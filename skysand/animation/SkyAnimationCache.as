package skysand.animation
{
	import flash.display.Sprite;
	import skysand.animation.SkyAnimation;
	
	public class SkyAnimationCache extends Object
	{
		/**
		 * Ссылка на этот класс.
		 */
		private static var _instance:SkyAnimationCache;
		
		/**
		 * Хранилище анимаций.
		 */
		private var animations:Vector.<SkyAnimation>;
		
		/**
		 * Количество растерезированных анимаций.
		 */
		private var nAnimations:int;
		
		public function SkyAnimationCache()
		{
			if (_instance != null)
			{
				throw("Error, use instance");
			}
			
			_instance = this;
			animations = new Vector.<SkyAnimation>();
			nAnimations = 0;
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():SkyAnimationCache
		{
			return (_instance == null) ? new SkyAnimationCache() : _instance;
		}
		
		/**
		 * Получить анимацию из хранилища.
		 * @param	Name название анимации.
		 * @return  возвращает анимацию(SkyAnimation) из хранилища.
		 */
		public function getAnimation(name:String):SkyAnimation
		{
			var animation:SkyAnimation;
			
			for (var i:int = 0; i < nAnimations; i++) 
			{
				animation = animations[i];
				
				if (animation.name == name) break;
			}
			
			return animation;
		}
		
		/**
		 * Добавить анимацию в зранилище.
		 * @param	animation ссылка на экземпляр анимации.
		 */
		public function addAnimation(animation:SkyAnimation):void
		{
			animations.push(animation);
			nAnimations++;
		}
		
		/**
		 * Добавить анимацию в хранилище из MovieClip.
		 * @param	_class название класса.
		 * @param	name название анимации.
		 */
		public function addAnimationFromMovieClip(_class:Class, name:String):void
		{
			var animation:SkyAnimation = new SkyAnimation();
			animation.makeAnimationFromMovieClip(_class);
			animation.name = name;
			
			animations.push(animation);
			nAnimations++;
		}
		
		/**
		 * Добавить анимацию в хранилище из Sprite.
		 * @param	sprite спрайт для первого и последнего кадра анимации.
		 * @param	name название анимации.
		 */
		public function addAnimationFromSprite(sprite:Sprite, name:String):void
		{
			var animation:SkyAnimation = new SkyAnimation();
			animation.makeFrameFromSprite(sprite);
			animation.name = name;
			
			animations.push(animation);
			nAnimations++;
		}
	}
}