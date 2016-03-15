package skysand.utils 
{
	import skysand.console.Console;
	import skysand.render.RenderObject;
	import skysand.text.SkyTextField;
	import flash.system.System;
	/**
	 * ...
	 * @author debil
	 */
	public class SkyWatcher extends RenderObject
	{
		private var textField:SkyTextField;
		
		/**
		 * Ссылка на класс.
		 */
		private static var _instance:SkyWatcher;
		public var value:*;
		public var string:String;
		
		public function SkyWatcher()
		{
			if(_instance != null)
			{
				throw new Error("use instance");
			}
			
			_instance = this;
			initialize();
		}
		
		/*public function watch(name:String, value:*):void
		{
			
		}*/
		
		public function update():void
		{
			textField.text = String(SkySand.NUM_ON_STAGE);
		}
		
		private function initialize():void
		{
			string = "";
			
			//visible = false;
			
			textField = new SkyTextField();
			textField.background = true;
			textField.backgroundColor = 0x000000;
			textField.textColor = 0xFFFFFF;
			textField.width = 100;
			textField.height = 20;
			addChild(textField);
			
			Console.instance.registerCommand("-sv_watcherVisible", setVisible, []);
		}
		
		private function setVisible(value:Boolean):void
		{
			visible = value;
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():SkyWatcher
		{
			return (_instance == null) ? new SkyWatcher() : _instance;
		}
	}
}