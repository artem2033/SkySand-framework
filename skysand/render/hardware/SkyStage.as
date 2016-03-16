package skysand.render.hardware
{
	import flash.display3D.Context3D;
	
	/**
	 * ...
	 * @author
	 */
	public class SkyStage extends Object
	{
		private var batches:Vector.<SkyQuadBatchBase>;
		private var context3D:Context3D;
		private var numBatches:int;
		/**
		 * Ссылка класса на самого себя.
		 */
		private static var _instance:SkyStage;
		
		public function SkyStage()
		{
			if (_instance != null)
			{
				throw new Error("Используйте instance для доступа к классу");
			}
			_instance = this;
		}
		
		public function initialize(context3D:Context3D):void
		{
			this.context3D = context3D;
			
			batches = new Vector.<SkyQuadBatchBase>();
		}
		
		public function render():void
		{
			for (var i:int = 0; i < numBatches; i++)
			{
				batches[i].render();
			}
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():SkyStage
		{
			return _instance == null ? new SkyStage() : _instance;
		}
	}
}