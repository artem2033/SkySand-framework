package skysand.sound
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	public class SoundManager extends Object
	{
		private var channel:SoundChannel;
		private var sounds:Vector.<Sound>;
		private var position:Number;
		private var soundTransform:SoundTransform;
		
		public function SoundManager() 
		{
			channel = new SoundChannel();
			sounds = new Vector.<Sound>();
			soundTransform = channel.soundTransform;
			position = 0;
		}
		
		public function addSound(source:Sound):void
		{
			sounds.push(source);
		}
		
		public function play(index:int):void
		{
			index = index > sounds.length ? sounds.length - 1 : index;
			
			stop();
			channel = sounds[index].play(position, 1);
		}
		
		public function pause():void
		{
			position = channel.position;
			channel.stop();
		}
		
		public function stop():void
		{
			position = 0;
			channel.stop();
		}
		
		public function get volume():Number
		{
			return soundTransform.volume;
		}
		
		public function set volume(value:Number):void
		{
			soundTransform.volume = value;
			channel.soundTransform = soundTransform;
		}
	}
}