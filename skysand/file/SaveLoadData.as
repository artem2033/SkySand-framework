package skysand.file 
{
	import flash.display.Sprite;
	import flash.net.SharedObject;
	
	public class SaveLoadData extends Sprite
	{
		private static var _instance:SaveLoadData;
		private var Data:SharedObject = SharedObject.getLocal("GateDefenseSaveData");
		
		public function SaveLoadData() 
		{
			if (_instance != null)
			{
				throw("Error, use getInstance in SaveLoadData");
			}
		}
		
		public static function get instance():SaveLoadData
		{
			return (_instance == null) ? new SaveLoadData() : _instance;
		}
		
		public function saveData(name:String, variable:*):void
		{
			Data.data[name] = variable;
			Data.flush();
		}
		
		public function loadData(name:String):*
		{
			var variable:* = null;
			
			if (Data.data[name] != null)
			{
				variable = Data.data[name];
			}
			else
			{
				//Console.getInstance().message("Error saveData empty!", Console.ERROR);
			}
			return variable;
		}
	}
}