package skysand.display
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	import skysand.render.SkyBatchBase;
	
	import skysand.utils.SkyMath;
	import skysand.utils.SkyUtils;
	import skysand.file.SkyAtlasSprite;
	import skysand.file.SkyTextureAtlas;
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
		 * Цвета каждой вершины.
		 */
		public var verticesColor:SkySpriteVerticesColor;
		
		/**
		 * Данные о спрайте из текстурного атласа.
		 */
		internal var data:SkyAtlasSprite;
		
		/**
		 * Массив текстурных координат.
		 */
		internal var uvs:Vector.<Number>;
		
		/**
		 * Текстурный атлас.
		 */
		internal var atlas:SkyTextureAtlas;
		
		/**
		 * Массив вершин.
		 */
		private var verteces:Vector.<Number>;
		
		/**
		 * Массив для хранения временных данных о трансформированных вершин.
		 */
		private var v:Vector.<Number>;
		
		/**
		 * Матрица для расчёта поворота спрайта.
		 */
		private var matrix:Matrix;
		
		/**
		 * Старые данные для оптимизации расчётов.
		 */
		private var old:SkyOldData;
		
		public function SkySprite()
		{
			matrix = new Matrix();
			old = new SkyOldData();
			v = new Vector.<Number>(8, true);
			verticesColor = new SkySpriteVerticesColor();
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
			batch = SkyHardwareRender.instance.getBatch(name) as SkyStandartQuadBatch;
			
			if (batch == null)
			{
				batch = new SkyStandartQuadBatch();
				SkyHardwareRender.instance.addBatch(batch, name);
			}
			
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
				
				if (isAdded && !batch.contains(this))
				{
					batch.add(this, data);
					verteces = batch.verteces;
					uvs = batch.uvs;
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
		 * Освободить память.
		 */
		override public function free():void
		{
			v.fixed = false;
			v.length = 0;
			v = null;
			
			old = null;
			uvs = null;
			data = null;
			atlas = null;
			batch = null;
			matrix = null;
			verteces = null;
			verticesColor = null;
			
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
		 * Функция обновления координат и других данных.
		 */
		override public function updateData(deltaTime:Number):void 
		{
			super.updateData(deltaTime);
			
			if (verteces == null) return;
			
			if (globalVisible == 1)
			{
				var w:Number = globalScaleX * width;
				var h:Number = globalScaleY * height;
				
				var px:Number = pivotX * globalScaleX;
				var py:Number = pivotY * globalScaleY;
				
				if (old.rotation != globalRotation || old.scaleX != globalScaleX || old.scaleY != globalScaleY || old.width != width || old.height != height)
				{
					var angle:Number = SkyMath.toRadian(globalRotation);
					
					matrix.rotate(angle);
					
					v[0] = globalR.x - px * matrix.a - py * matrix.c;
					v[1] = globalR.x + (w - px) * matrix.a - py * matrix.c;
					v[2] = globalR.x - px * matrix.a + (h - py) * matrix.c;
					v[3] = globalR.x + (w - px) * matrix.a + (h - py) * matrix.c;
					v[4] = globalR.y - px * matrix.b - py * matrix.d;
					v[5] = globalR.y + (w - px) * matrix.b - py * matrix.d;
					v[6] = globalR.y - px * matrix.b + (h - py) * matrix.d;
					v[7] = globalR.y + (w - px) * matrix.b + (h - py) * matrix.d;
					
					verteces[indexID] = globalX + v[0];
					verteces[indexID + 7] = globalX + v[1];
					verteces[indexID + 14] = globalX + v[2];
					verteces[indexID + 21] = globalX + v[3];
					
					verteces[indexID + 1] = globalY + v[4];
					verteces[indexID + 8] = globalY + v[5];
					verteces[indexID + 15] = globalY + v[6];
					verteces[indexID + 22] = globalY + v[7];
					
					matrix.identity();
					
					old.x = globalX;
					old.y = globalY;
					old.width = width;
					old.height = height;
					old.scaleX = globalScaleX;
					old.scaleY = globalScaleY;
					old.rotation = globalRotation;
				}
				
				if (old.x != globalX)
				{
					verteces[indexID] = globalX + v[0];
					verteces[indexID + 7] = globalX + v[1];
					verteces[indexID + 14] = globalX + v[2];
					verteces[indexID + 21] = globalX + v[3];
					
					old.x = globalX;
				}
				
				if (old.y != globalY)
				{
					verteces[indexID + 1] = globalY + v[4];
					verteces[indexID + 8] = globalY + v[5];
					verteces[indexID + 15] = globalY + v[6];
					verteces[indexID + 22] = globalY + v[7];
					
					old.y = globalY;
				}
				
				if (old.depth != depth)
				{
					verteces[indexID + 2] = depth / SkyHardwareRender.MAX_DEPTH;
					verteces[indexID + 9] = depth / SkyHardwareRender.MAX_DEPTH;
					verteces[indexID + 16] = depth / SkyHardwareRender.MAX_DEPTH;
					verteces[indexID + 23] = depth / SkyHardwareRender.MAX_DEPTH;
					
					old.depth = depth;
				}
				
				if (old.leftUpColor != verticesColor.leftUp)
				{
					verteces[indexID + 3] = verticesColor.leftUpRed;
					verteces[indexID + 4] = verticesColor.leftUpGreen;
					verteces[indexID + 5] = verticesColor.leftUpBlue;
					
					old.leftUpColor = verticesColor.leftUp;
				}
				
				if (old.rightUpColor != verticesColor.rightUp)
				{
					verteces[indexID + 10] = verticesColor.rightUpRed;
					verteces[indexID + 11] = verticesColor.rightUpGreen;
					verteces[indexID + 12] = verticesColor.rightUpBlue;
					
					old.rightUpColor = verticesColor.rightUp;
				}
				
				if (old.leftDownColor != verticesColor.leftDown)
				{
					verteces[indexID + 17] = verticesColor.leftDownRed;
					verteces[indexID + 18] = verticesColor.leftDownGreen;
					verteces[indexID + 19] = verticesColor.leftDownBlue;
					
					old.leftDownColor = verticesColor.leftDown;
				}
				
				if (old.rightDownColor != verticesColor.rightDown)
				{
					verteces[indexID + 24] = verticesColor.rightDownRed;
					verteces[indexID + 25] = verticesColor.rightDownGreen;
					verteces[indexID + 26] = verticesColor.rightDownBlue;
					
					old.rightDownColor = verticesColor.rightDown;
				}
				
				if (old.alpha != alpha)
				{
					verteces[indexID + 6] = alpha;
					verteces[indexID + 13] = alpha;
					verteces[indexID + 20] = alpha;
					verteces[indexID + 27] = alpha;
					
					old.alpha = alpha;
				}
			}
			else if (verteces[indexID + 2] != -1)
			{
				verteces[indexID + 2] = -1;
				verteces[indexID + 9] = -1;
				verteces[indexID + 16] = -1;
				verteces[indexID + 23] = -1;
				
				old.depth = 2;
			}
		}
	}
}