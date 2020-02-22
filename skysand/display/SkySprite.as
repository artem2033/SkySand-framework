package skysand.display
{
	import flash.display.BitmapData;
	
	import skysand.utils.SkyUtils;
	import skysand.file.SkyAtlasSprite;
	import skysand.file.SkyTextureAtlas;
	import skysand.render.SkyQuadBatch;
	import skysand.render.SkyHardwareRender;
	import skysand.interfaces.ISpriteRenderer;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkySprite extends SkyRenderObjectContainer
	{
		/**
		 * Пакет отрисовки.
		 */
		public var render:ISpriteRenderer;
		
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
		private var vertices:Vector.<Number>;
		
		/**
		 * Класс для отрисовки спрайта.
		 */
		private var mRendererClass:Class;
		
		/**
		 * Название рендера спрайтов для поиска существующего или добавления нового.
		 */
		private var mRendererName:String;
		
		public function SkySprite()
		{
			mRendererClass = SkyQuadBatch;
			mRendererName = "";
		}
		
		/**
		 * Задать атлас из глобального кеша.
		 * @param	name название атласа.
		 */
		public function setAtlasFromCache(name:String):void
		{
			setAtlas(SkySand.cache.getTextureAtlas(name));
		}
		
		/**
		 * Задать текстурный атлас.
		 * @param	atlas ссылка на текстурный атлас.
		 */
		public function setAtlas(atlas:SkyTextureAtlas):void
		{
			if (atlas == this.atlas) return;
			if (render != null) render.remove(this);
			
			var name:String = mRendererName == "" ? atlas.name : mRendererName;
			render = SkySand.render.getBatch(name, mRendererClass, 4) as ISpriteRenderer;
			
			vertices = null;
			this.atlas = atlas
			render.setTexture(atlas.texture);
		}
		
		/**
		 * Задать спрайт из битмапы.
		 * @param	bitmapData битмапа.
		 * @param	name имя пакета отрисовки.
		 */
		public function setBitmapData(bitmapData:BitmapData, name:String):void
		{
			if (render != null)
			{
				render.remove(this);
			}
			
			mRendererName = name;
			render = SkySand.render.getBatch(name, mRendererClass, 4) as ISpriteRenderer;
			render.setTextureFromBitmapData(bitmapData);
			
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
				
				if (isAdded && !render.contains(this))
				{
					render.add(this, data);
					vertices = render.vertices;
					uvs = render.uvs;
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
			if (vertices == null || index > 4) return;
			
			var red:Number = SkyUtils.getRed(color) / 255;
			var green:Number = SkyUtils.getGreen(color) / 255;
			var blue:Number = SkyUtils.getBlue(color) / 255;
			
			vertices[indexID + index * 7 + 3] = red;
			vertices[indexID + index * 7 + 4] = green;
			vertices[indexID + index * 7 + 5] = blue;
			
			render.updateVertexBuffer();
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			uvs = null;
			data = null;
			atlas = null;
			render = null;
			vertices = null;
			
			super.free();
		}
		
		/**
		 * Добавить спрайт в пакет отрисовки.
		 */
		override public function init():void 
		{
			if (render != null)
			{
				render.add(this, data);
				vertices = render.vertices;
				uvs = render.uvs;
			}
		}
		
		/**
		 * Удалить спрайт из пакета отрисовки.
		 */
		override public function remove():void 
		{
			if (render != null)
			{
				render.remove(this);
				uvs = null;
				vertices = null;
			}
		}
		
		/**
		 * Посчитать глобальную видимость.
		 */
		override public function calculateGlobalVisible():void 
		{
			super.calculateGlobalVisible();
			
			if (vertices == null) return;
			
			var depth:Number = !isVisible ? -1 : mDepth / SkyHardwareRender.MAX_DEPTH;
			
			vertices[indexID + 2] = depth;
			vertices[indexID + 9] = depth;
			vertices[indexID + 16] = depth;
			vertices[indexID + 23] = depth;
			
			render.updateVertexBuffer();
		}
		
		/**
		 * Глубина.
		 */
		override public function set depth(value:int):void 
		{
			if (mDepth != value)
			{
				mDepth = value;
				
				if (vertices == null || !isVisible) return;
				
				vertices[indexID + 2] = mDepth / SkyHardwareRender.MAX_DEPTH;
				vertices[indexID + 9] = mDepth / SkyHardwareRender.MAX_DEPTH;
				vertices[indexID + 16] = mDepth / SkyHardwareRender.MAX_DEPTH;
				vertices[indexID + 23] = mDepth / SkyHardwareRender.MAX_DEPTH;
				
				render.updateVertexBuffer();
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
				
				if (vertices == null) return;
				
				vertices[indexID + 6] = alpha;
				vertices[indexID + 13] = alpha;
				vertices[indexID + 20] = alpha;
				vertices[indexID + 27] = alpha;
				
				render.updateVertexBuffer();
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
				
				if (vertices == null) return;
				
				var red:Number = SkyUtils.getRed(value) / 255;
				var green:Number = SkyUtils.getGreen(value) / 255;
				var blue:Number = SkyUtils.getBlue(value) / 255;
				
				vertices[indexID + 3] = red;
				vertices[indexID + 4] = green;
				vertices[indexID + 5] = blue;
				
				vertices[indexID + 10] = red;
				vertices[indexID + 11] = green;
				vertices[indexID + 12] = blue;
				
				vertices[indexID + 17] = red;
				vertices[indexID + 18] = green;
				vertices[indexID + 19] = blue;
				
				vertices[indexID + 24] = red;
				vertices[indexID + 25] = green;
				vertices[indexID + 26] = blue;
				
				render.updateVertexBuffer();
			}
		}
		
		/**
		 * Обновить трансформацию спрайта.
		 */
		override public function updateTransformation():void 
		{
			super.updateTransformation();
			
			if (vertices == null) return;
			worldMatrix.transformSprite(mWidth, mHeight, mPivotX, mPivotY, indexID, vertices);
			
			render.updateVertexBuffer();
		}
		
		/**
		 * Класс для отрисовки текстового поля.
		 */
		public function set rendererClass(value:Class):void
		{
			if (mRendererClass == value) return;
			
			mRendererClass = value;
			
			if (render != null)
			{
				remove();
				init();
			}
		}
		
		/**
		 * Класс для отрисовки текстового поля.
		 */
		public function get rendererClass():Class
		{
			return mRendererClass;
		}
		
		/**
		 * Название рендера спрайтов для поиска существующего или добавления нового.
		 */
		public function set rendererName(value:String):void
		{
			if (mRendererName == value) return;
			
			mRendererName = value;
			
			if (render != null)
			{
				remove();
				init();
			}
		}
		
		/**
		 * Название рендера спрайтов для поиска существующего или добавления нового.
		 */
		public function get rendererName():String
		{
			return mRendererName;
		}
	}
}