package skysand.render.hardware 
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkySprite;
	import skysand.display.SkyGraphics;
	import skysand.interfaces.IBatch;
	import skysand.render.RenderObject;
	
	public class SkyHardwareRender extends Object
	{
		public static const MAX_DEPTH:uint = 100000;
		public var updateDepth:Boolean = false;
		private var context3D:Context3D;
		private var modelViewMatrix:Matrix3D;
		private var batches:Vector.<SkyBatchBase>;
		private var nBatches:int;
		private var objects:Vector.<SkyRenderObjectContainer>;
		private var nObjects:uint;
		private var depthCount:uint;
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
		
		public function removeBatch(batch:SkyBatchBase):void
		{
			var index:int = batches.indexOf(batch);
			
			if (index < 0) return;
			
			batches[index] = null;
			batches.removeAt(index);
			nBatches--;
		}
		
		public function initialize(context3D:Context3D, screenWidth:Number, screenHeight:Number):void
		{
			this.context3D = context3D;
			
			context3D.configureBackBuffer(screenWidth, screenHeight, 4, true);
			
			modelViewMatrix = new Matrix3D();
			modelViewMatrix.appendTranslation(-screenWidth / 2, -screenHeight / 2, 0);
			modelViewMatrix.appendScale(2 / screenWidth, -2 / screenHeight, 1);
			
			batches = new Vector.<SkyBatchBase>();
			nBatches = 0;
			
			objects = new Vector.<SkyRenderObjectContainer>();
			nObjects = 0;
		}
		
		public function getBatch(name:String):SkyBatchBase
		{
			var batch:SkyBatchBase;
			
			for (var i:int = 0; i < nBatches; i++) 
			{
				batch = batches[i] as SkyBatchBase;
				
				if (name != "textField" && batch.name == name && batch.verteces.length < 196596)
				{
					return batch;
				}
				else continue;
			}
			
			if (name == "vector")
			{
				batch = new SkyGraphicsBatch();
			}
			else if (name == "textField")
			{
				batch = new SkyTextBatch();
			}
			else
			{
				batch = new SkyStandartQuadBatch();
			}
			
			batch.initialize(context3D, modelViewMatrix, name);
			batches[nBatches] = batch;
			nBatches++;
			
			return batch;
		}
		
		public function removeObjectFromRender(object:SkyRenderObjectContainer):void
		{
			var index:int = objects.indexOf(object);
			
			if (index == -1) return;
			
			objects.splice(index, 1);
			nObjects--;
		}
		
		public function addObjectToRender(object:SkyRenderObjectContainer):void
		{
			if (object.parent)
			{
				var index:int = objects.indexOf(object.parent) + 1;
				
				objects.splice(index, 0, object);
			}
			else
			{
				objects.push(object);
			}
			
			object.updateData();
			nObjects++;
		}
		
		private function calculateDepth(child:SkyRenderObjectContainer):void
		{
			if (!child)
			{
				return;
			}
			
			if (child.parent)
			{
				child.isVisible = child.parent.isAdded ? true : false;
			}
			else child.isVisible = true;
			
			child.depth = MAX_DEPTH - depthCount;
			depthCount++;
			
			if (child.children)
			{
				for (var i:int = 0; i < child.numChildren; i++) 
				{
					calculateDepth(child.children[i]);
				}
			}
		}
		
		public function update():void
		{
			context3D.clear();
			
			if (updateDepth)
			{
				depthCount = 0;
				calculateDepth(SkySand.root);
				
				updateDepth = false;
			}
			//trace("-------------");
			for (var i:int = 0; i < nObjects; i++)
			{
				objects[i].updateData();
				//trace(objects[i].visible, objects[i].globalVisible);
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