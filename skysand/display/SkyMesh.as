package skysand.display 
{
	import skysand.file.SkyAtlasSprite;
	import skysand.file.SkyTextureAtlas;
	import skysand.render.SkyHardwareRender;
	import skysand.render.SkyShapeBatch;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyMesh extends SkyShape
	{
		/**
		 * Массив текстурных координат.
		 */
		private var uvs:Vector.<Number>;
		
		/**
		 * Текстурный атлас.
		 */
		internal var atlas:SkyTextureAtlas;
		
		/**
		 * Данные о спрайте из текстурного атласа.
		 */
		internal var data:SkyAtlasSprite;
		
		//public var batch:SkyShapeBatch;
		
		public function SkyMesh() 
		{
			
		}
		
		/**
		 * Задать атлас из глобального кеша.
		 * @param	name название атласа.
		 */
		public function setAtlasFromCache(name:String):void
		{
			atlas = SkySand.cache.getTextureAtlas(name);
			//batch = SkyHardwareRender.instance.getBatch(name) as SkyShapeBatch;
			
			if (batch == null)
			{
				batch = new SkyShapeBatch();
				//batch.setTexture(atlas.texture);
				//SkyHardwareRender.instance.addBatch(batch, name);
			}
		}
		
		/**
		 * Задать текстурный атлас.
		 * @param	atlas ссылка на текстурный атлас.
		 */
		public function setAtlas(atlas:SkyTextureAtlas):void
		{
			this.atlas = atlas
			//batch = SkyHardwareRender.instance.getBatch(atlas.name) as SkyShapeBatch;
			
			if (batch == null)
			{
				batch = new SkyShapeBatch();
				//batch.setTexture(atlas.texture);
				//SkyHardwareRender.instance.addBatch(batch, atlas.name);
			}
		}
		
		
		/*public function setBitmapData(bitmapData:BitmapData, name:String):void
		{
			/*var texture:RectangleTexture = SkySand.CONTEXT_3D.createRectangleTexture(bitmapData.width, bitmapData.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bitmapData);
			batch = SkyHardwareRender.instance.getBatch(name) as SkyStandartQuadBatch;
			batch.setTexture(texture);
			data = new SkyAtlasSprite();
			data.width = bitmapData.width;
			data.height = bitmapData.height;
			data.uvs[0] = 0;
			data.uvs[1] = 0;
			data.uvs[2] = 1;
			data.uvs[3] = 0;
			data.uvs[4] = 0;
			data.uvs[5] = 1;
			data.uvs[6] = 1;
			data.uvs[7] = 1;
			width = bitmapData.width;
			height = bitmapData.height;
		}*/
		
		/**
		 * Задать спрайт из текстурного атласа.
		 * @param	name название спрайта.
		 */
		public function setMesh(name:String):void
		{
			if (atlas != null)
			{
				data = atlas.getSprite(name);
				/*width = data.width;
				height = data.height;
				pivotX = data.pivotX;
				pivotY = data.pivotY;*/
				
				/*if (uvs)
				{
					var index:int = indexID / 7 * 2;
					var length:int = data.uvs.length;
					
					for (var i:int = 0; i < length; i++) 
					{
						uvs[index + i] = data.uvs[i];
					}
				}*/
			}
			else throw new Error("Error: Atlas is null, set atlas before calling setSprite!");
		}
		/*
		private var matrix:Matrix = new Matrix();
		
		private function calculateUV(mesh:SkyMesh, data:SkyAtlasSprite, atlasWidth:Number, atlasHeight:Number):void
		{
			matrix.identity();
			matrix.scale(data.width / mesh.width, data.height / mesh.height);
			
			var length:int = verteces.length / 2;
			
			for (var i:int = position; i < length; i++) 
			{
				var x:int = verteces[i * 2];
				var y:int = verteces[i * 2 + 1];
				
				var dx:Number = data.pivotX + x * matrix.a + y * matrix.c;
				var dy:Number = data.pivotY + x * matrix.b + y * matrix.d;
				
				uvs.push(dx / atlasWidth, dy / atlasHeight);
			}
		}*/
		
		/**
		 * Задать спрайт из тектурного атласа.
		 * @param	index номер спрайта.
		 */
		public function setSpriteByIndex(index:int):void
		{
			/*if (atlas != null)
			{
				data = atlas.getSpriteByIndex(index);
				width = data.width;
				height = data.height;
				pivotX = data.pivotX;
				pivotY = data.pivotY;
				
				if (uvs)
				{
					var index:int = indexID / 7 * 2;
					
					uvs[index] = data.uvs[0];
					uvs[index + 1] = data.uvs[1];
					uvs[index + 2] = data.uvs[2];
					uvs[index + 3] = data.uvs[3];
					uvs[index + 4] = data.uvs[4];
					uvs[index + 5] = data.uvs[5];
					uvs[index + 6] = data.uvs[6];
					uvs[index + 7] = data.uvs[7];
				}
			}
			else throw new Error("Error: Atlas is null, set atlas before calling setSprite!");*/
		}
		
		override public function init():void 
		{
			if (batch != null)
			{
				/*batch.addMesh(this, data, atlas);
				batchVerteces = batch.verteces;
				uvs = batch.uvs;*/
			}
		}
		
		override public function remove():void 
		{
			if (batch != null)
			{
				batch.remove(this);
				uvs = null;
				//batchVerteces = null;
			}
			
			super.remove();
		}
	}
}