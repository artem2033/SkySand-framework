package skysand.display
{
	import flash.display.BitmapData;
	
	import skysand.utils.SkyUtils;
	import skysand.file.SkyAtlasSprite;
	import skysand.file.SkyTextureAtlas;
	import skysand.render.SkyBatchBase;
	import skysand.render.SkyHardwareRender;
	import skysand.render.SkyStandartQuadBatch;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkySprite extends SkyRenderObjectContainer
	{
		/**
		 * Пакет отрисовки.
		 */
		public var batch:SkyStandartQuadBatch;
		
		/**
		 * Данные о спрайте из текстурного атласа.
		 */
		protected var data:SkyAtlasSprite;
		
		/**
		 * Массив текстурных координат.
		 */
		protected var uvs:Vector.<Number>;
		
		/**
		 * Текстурный атлас.
		 */
		protected var atlas:SkyTextureAtlas;
		
		/**
		 * Массив вершин.
		 */
		private var verteces:Vector.<Number>;
		
		public function SkySprite()
		{
		}
		
		/**
		 * Задать атлас из глобального кеша.
		 * @param	name название атласа.
		 * @param	batchName если нужно добавить в пакет с другим именем.
		 */
		public function setAtlasFromCache(name:String, batchName:String = ""):void
		{
			setAtlas(SkySand.cache.getTextureAtlas(name), batchName);
		}
		
		/**
		 * Задать текстурный атлас.
		 * @param	atlas ссылка на текстурный атлас.
		 * @param	batchName если нужно добавить в пакет с другим именем.
		 */
		public function setAtlas(atlas:SkyTextureAtlas, batchName:String = ""):void
		{
			if (atlas == this.atlas) return;
			if (batch != null) batch.remove(this);
			
			var name:String = batchName == "" ? atlas.name : batchName
			batch = SkySand.render.getBatch(name) as SkyStandartQuadBatch;
			
			if (batch == null)
			{
				batch = new SkyStandartQuadBatch();
				SkySand.render.addBatch(batch, name);
			}
			
			verteces = null;
			this.atlas = atlas
			batch.setTexture(atlas.texture);
		}
		
		public function prepareSpriteToTargetRender(batch:SkyStandartQuadBatch, atlas:SkyTextureAtlas):void
		{
			this.batch = batch;
			this.atlas = atlas;
		}
		
		/**
		 * Задать спрайт из битмапы.
		 * @param	bitmapData битмапа.
		 * @param	name имя пакета отрисовки.
		 */
		public function setBitmapData(bitmapData:BitmapData, name:String):void
		{
			if (batch == null) 
			{
				batch = new SkyStandartQuadBatch();
				SkySand.render.addBatch(batch, name);
			}
			
			if (data == null)
			{
				data = new SkyAtlasSprite();
				data.uvs = new Vector.<Number>(8, true);
				data.uvs[0] = 0;
				data.uvs[1] = 0;
				data.uvs[2] = 1;
				data.uvs[3] = 0;
				data.uvs[4] = 0;
				data.uvs[5] = 1;
				data.uvs[6] = 1;
				data.uvs[7] = 1;
			}
			
			batch.setTextureFromBitmapData(bitmapData);
			
			width = bitmapData.width;
			height = bitmapData.height;
			
			data.width = bitmapData.width;
			data.height = bitmapData.height;
		}
		
		/**
		 * Задать спрайт из текстуры.
		 * @param	texture текстура.
		 * @param	name имя пакета отрисовки.
		 */
		/*public function setTexture(texture:TextureBase, width:Number, height:Number, name:String):void
		{
			if (batch == null) 
			{
				batch = new SkyStandartQuadBatch();
				SkyHardwareRender.instance.addBatch(batch, name);
			}
			
			if (data == null)
			{
				data = new SkyAtlasSprite();
				data.uvs = new Vector.<Number>(8, true);
				data.uvs[0] = 0;
				data.uvs[1] = 0;
				data.uvs[2] = 1;
				data.uvs[3] = 0;
				data.uvs[4] = 0;
				data.uvs[5] = 1;
				data.uvs[6] = 1;
				data.uvs[7] = 1;
			}
			
			//batch.setTexture(texture);
			
			this.width = width;
			this.height = height;
			
			data.width = width;
			data.height = height;
		}*/
		
		/**
		 * Задать спрайт из текстурного атласа.
		 * @param	name название спрайта.
		 */
		public function setSprite(name:String):void
		{
			if (atlas != null)
			{
				data = atlas.getSprite(name);
				width = data.width;
				height = data.height;
				pivotX = data.pivotX;
				pivotY = data.pivotY;
				
				if (isAdded && !batch.contains(this))
				{
					batch.add(this, data);
					verteces = batch.verteces;
					uvs = batch.uvs;
				}
				
				if (uvs != null)
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
			else throw new Error("Error: Atlas is null, set atlas before calling setSprite!");
		}
		
		/**
		 * Задать спрайт из тектурного атласа.
		 * @param	index номер спрайта.
		 */
		public function setSpriteByIndex(index:int):void
		{
			if (atlas != null)
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
			else throw new Error("Error: Atlas is null, set atlas before calling setSprite!");
		}
		
		/**
		 * Назначить цвет одной из вершины спрайта(расположение вершин Z).
		 * @param	color цвет вершины.
		 * @param	index номер вершины от 0 до 3.
		 */
		public function setVertexColor(color:uint, index:int):void
		{
			if (verteces == null || index > 4) return;
			
			var red:Number = SkyUtils.getRed(color) / 255;
			var green:Number = SkyUtils.getGreen(color) / 255;
			var blue:Number = SkyUtils.getBlue(color) / 255;
			
			verteces[indexID + index * 7 + 3] = red;
			verteces[indexID + index * 7 + 4] = green;
			verteces[indexID + index * 7 + 5] = blue;
			
			batch.isUpload = false;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			uvs = null;
			data = null;
			atlas = null;
			batch = null;
			verteces = null;
			
			super.free();
		}
		
		/**
		 * Добавить спрайт в пакет отрисовки.
		 */
		override public function init():void 
		{
			if (batch != null)
			{
				batch.add(this, data);
				verteces = batch.verteces;
				uvs = batch.uvs;
			}
			
			super.init();
		}
		
		/**
		 * Удалить спрайт из пакета отрисовки.
		 */
		override public function remove():void 
		{
			if (batch != null)
			{
				batch.remove(this);
				uvs = null;
				verteces = null;
			}
			
			super.remove();
		}
		
		/**
		 * Посчитать глобальную видимость.
		 */
		override public function calculateGlobalVisible():void 
		{
			super.calculateGlobalVisible();
			
			if (verteces == null) return;
			
			var depth:Number = !isVisible ? -1 : mDepth / SkyHardwareRender.MAX_DEPTH;
			
			verteces[indexID + 2] = depth;
			verteces[indexID + 9] = depth;
			verteces[indexID + 16] = depth;
			verteces[indexID + 23] = depth;
			
			batch.isUpload = false;
		}
		
		/**
		 * Глубина.
		 */
		override public function set depth(value:int):void 
		{
			if (mDepth != value)
			{
				mDepth = value;
				
				if (verteces == null || !isVisible) return;
				
				verteces[indexID + 2] = mDepth / SkyHardwareRender.MAX_DEPTH;
				verteces[indexID + 9] = mDepth / SkyHardwareRender.MAX_DEPTH;
				verteces[indexID + 16] = mDepth / SkyHardwareRender.MAX_DEPTH;
				verteces[indexID + 23] = mDepth / SkyHardwareRender.MAX_DEPTH;
				
				batch.isUpload = false;
			}
		}
		
		/**
		 * Прозрачность от 0 до 1.
		 */
		override public function set alpha(value:Number):void 
		{
			if (mAlpha != value)
			{
				mAlpha = value;
				
				if (verteces == null) return;
				
				verteces[indexID + 6] = alpha;
				verteces[indexID + 13] = alpha;
				verteces[indexID + 20] = alpha;
				verteces[indexID + 27] = alpha;
				
				batch.isUpload = false;
			}
		}
		
		/**
		 * Цвет спрайта.
		 */
		override public function set color(value:uint):void 
		{
			if (mColor != value)
			{
				mColor = value;
				
				if (verteces == null) return;
				
				var red:Number = SkyUtils.getRed(value) / 255;
				var green:Number = SkyUtils.getGreen(value) / 255;
				var blue:Number = SkyUtils.getBlue(value) / 255;
				
				verteces[indexID + 3] = red;
				verteces[indexID + 4] = green;
				verteces[indexID + 5] = blue;
				
				verteces[indexID + 10] = red;
				verteces[indexID + 11] = green;
				verteces[indexID + 12] = blue;
				
				verteces[indexID + 17] = red;
				verteces[indexID + 18] = green;
				verteces[indexID + 19] = blue;
				
				verteces[indexID + 24] = red;
				verteces[indexID + 25] = green;
				verteces[indexID + 26] = blue;
				
				batch.isUpload = false;
			}
		}
		
		/**
		 * Обновить трансформацию спрайта.
		 */
		override public function updateTransformation():void 
		{
			super.updateTransformation();
			
			if (verteces == null) return;
			worldMatrix.transformSprite(mWidth, mHeight, mPivotX, mPivotY, indexID, verteces);
			
			batch.isUpload = false;
		}
	}
}