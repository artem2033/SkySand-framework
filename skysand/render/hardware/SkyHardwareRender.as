package skysand.render.hardware 
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.interfaces.IQuadBatch;
	
	public class SkyHardwareRender extends Object
	{
		private var context3D:Context3D;
		private var modelViewMatrix:Matrix3D;
		private var batches:Vector.<IQuadBatch>;
		private var nBatches:int;
		private var root:SkyRenderObjectContainer;
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
			
			context3D.configureBackBuffer(screenWidth, screenHeight, 0, true);
			
			modelViewMatrix = new Matrix3D();
			modelViewMatrix.appendTranslation(-screenWidth / 2, -screenHeight / 2, 0);
			modelViewMatrix.appendScale(2 / screenWidth, -2 / screenHeight, 1);
			
			batches = new Vector.<IQuadBatch>();
			nBatches = 0;
		}
		
		public function setRoot(root:SkyRenderObjectContainer):void
		{
			this.root = root;
		}
		
		public function addObject(object:SkyRenderObject, textureName:String, spriteName:String):void
		{
			for (var i:int = 0; i < nBatches; i++) 
			{
				var standartBatch:SkyStandartQuadBatch = batches[i] as SkyStandartQuadBatch;
				
				if (standartBatch.name == textureName)
				{
					standartBatch.add(object, spriteName, textureName);
					
					return;
				}
			}
			
			var batch:SkyStandartQuadBatch = new SkyStandartQuadBatch();
			batch.initialize(context3D);
			batch.setMatrix(modelViewMatrix);
			batch.setTexture(textureName, spriteName);
			batch.add(object, spriteName, textureName);
			batches[nBatches] = batch;
			nBatches++;
		}
		
		private function updateAllChilds(object:SkyRenderObjectContainer):void
		{
			var length:int = object.children.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var objectChild:SkyRenderObjectContainer = object.children[i];
				
				//objectChild.parent.calculateGlobalCoordinates(objectChild);
				
				if (objectChild.children) updateAllChilds(objectChild);
			}
		}
		
		/*private function updateAllChilds(object:SkyRenderObjectContainer):void
		{
			var length:int = object.children.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var objectChild:SkyRenderObjectContainer = object.children[i];
				
				if (!objectChild.visible) continue;
				
				if (object.renderType == SkyRenderType.SIMPLE_SPRITE)
				{
					if (nBatches == 0)
					{
						var batch:SkyStandartQuadBatch = new SkyStandartQuadBatch();
						batch.initialize(context3D);
						batches[nBatches] = batch;
						nBatches++;
					}
					else if (nBatches > 0 && batches[0] is SkyStandartQuadBatch)
					{
						batches[0].add(object);
					}
				}
				
				//objectChild.parent.calculateGlobalData(objectChild);//deleted globalX and globalY = 0;
				
				//if (objectChild.bitmapData) draw(objectChild);
				
				if (object.children) drawAllChilds(objectChild);
			}
		}*/
		
		/*private function prepareBatches():void
		{
			if (root.renderType == SkyRenderType.SIMPLE_SPRITE)
			{
				if (nBatches == 0)
				{
					var batch:SkyStandartQuadBatch = new SkyStandartQuadBatch();
					batches[nBatches] = batch;
					nBatches++;
				}
			}
		}*/
		
		public function update():void
		{
			context3D.clear();
			
			//if(nBatches > 0) updateAllChilds(root);
			
			for (var i:int = 0; i < nBatches; i++)
			{
				batches[i].render();
				SkySand.drawCalls++;
			}
			
			context3D.present();
		}
	}
}