package skysand.render.hardware 
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyRenderObjectContainer;
	
	public class SkyHardwareRender extends Object
	{
		private var context3D:Context3D;
		private var modelViewMatrix:Matrix3D;
		private var batches:Vector.<SkyQuadBatchBase>;
		private var nBatches:int;
		private var root:SkyRenderObjectContainer;
		//private var 
		
		
		public function SkyHardwareRender() 
		{
			
		}
		
		public function initialize(context3D:Context3D, screenWidth:Number, screenHeight:Number):void
		{
			this.context3D = context3D;
			
			context3D.configureBackBuffer(screenWidth, screenHeight, 0, false);
			
			modelViewMatrix = new Matrix3D();
			modelViewMatrix.appendScale(screenWidth / 2, screenHeight / 2, 1);
			modelViewMatrix.appendTranslation( -2.0 / screenWidth, -2.0 / screenHeight, 0);
			
			batches = new Vector.<SkyQuadBatchBase>();
			nBatches = 0;
			
			var batch:SkyStandartQuadBatch = new SkyStandartQuadBatch();
			batch.initialize(context3D);
			batches[nBatches] = batch;
			nBatches++;
		}
		
		public function setRoot(root:SkyRenderObjectContainer):void
		{
			this.root = root;
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
		
		private function prepareBatches():void
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
		}
		
		public function update():void
		{
			context3D.clear();
			
			for (var i:int = 0; i < nBatches; i++)
			{
				batches[i].render();
			}
			
			context3D.present();
		}
	}
}