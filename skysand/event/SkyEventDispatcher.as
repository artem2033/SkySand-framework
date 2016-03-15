package skysand.event 
{
	import eve
	/**
	 * ...
	 * @author Artem Andrienko
	 */
	public class SkyEventDispatcher 
	{
		private static var _instance:SkyEventDispatcher;
		
		public function SkyEventDispatcher()
		{
			if(_instance != null)
			{
				throw new Error("use instance");
			}
			_instance = this;
		}
		
		public static function get instance():SkyEventDispatcher
		{
			return (_instance == null) ? new SkyEventDispatcher() : _instance;
		}
		
		public function dispatchEvent():void
		{
			
		}
	}
}