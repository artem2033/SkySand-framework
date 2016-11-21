package skysand.render.hardware 
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkySprite;
	import skysand.interfaces.IBatch;
	import skysand.render.RenderObject;
	
	public class SkyHardwareRender extends Object
	{
		private var context3D:Context3D;
		private var modelViewMatrix:Matrix3D;
		private var batches:Vector.<IBatch>;
		private var nBatches:int;
		private var objects:Vector.<SkyRenderObject>;
		private var nObjects:uint;
		/**
		 * Ссылка класса на самого себя.
		 */
		private static var _instance:SkyHardwareRender;
		
		public function SkyHardwareRender()
		{
			if (_instance != null)
			{
				throw new Error("Используйте instance для доступа к экземпляру класса SkyHardwareRender");
			}
			_instance = this;
		}
		
		/**
		 * Получить ссылку на класс.
		 */
		public static function get instance():SkyHardwareRender
		{
			return _instance == null ? new SkyHardwareRender() : _instance;
		}
		
		public function initialize(context3D:Context3D, screenWidth:Number, screenHeight:Number):void
		{
			this.context3D = context3D;
			
			context3D.configureBackBuffer(screenWidth, screenHeight, 4, true);
			
			modelViewMatrix = new Matrix3D();
			modelViewMatrix.appendTranslation(-screenWidth / 2, -screenHeight / 2, 0);
			modelViewMatrix.appendScale(2 / screenWidth, -2 / screenHeight, 1);
			
			batches = new Vector.<IBatch>();
			nBatches = 0;
			
			objects = new Vector.<SkyRenderObject>;
			nObjects = 0;
		}
		
		public function getBatch(name:String):SkyStandartQuadBatch
		{
			for (var i:int = 0; i < nBatches; i++) 
			{
				var standartBatch:SkyStandartQuadBatch = batches[i] as SkyStandartQuadBatch;
				
				if (standartBatch.name == name && standartBatch.verteces.length < 196596)
				{
					return standartBatch;
				}
				else continue;
			}
			
			var batch:SkyStandartQuadBatch = new SkyStandartQuadBatch();
			batch.initialize(context3D, modelViewMatrix, name);
			batches[nBatches] = batch;
			nBatches++;
			
			return batch;
		}
		
		public function removeObjectFromRender(object:SkyRenderObject):void
		{
			var index:int = objects.indexOf(object);
			
			if (index == -1) return;
			
			objects.splice(index, 1);
			nObjects--;
		}
		
		public function addObjectToRender(object:SkyRenderObject):void
		{
			objects.push(object);
			nObjects++;
		}
		
		public function update():void
		{
			context3D.clear();
			
			var object:SkyRenderObject;
			
			for (var i:int = 0; i < nObjects; i++)
			{
				object = objects[i];
				object.updateCoordinates();
			}
			
			for (i = 0; i < nBatches; i++)
			{
				batches[i].render();
				SkySand.drawCalls++;
			}
			
			context3D.present();
		}
	}
}