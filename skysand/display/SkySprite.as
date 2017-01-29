package skysand.display
{
	import air.net.SecureSocketMonitor;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import skysand.mouse.SkyMouse;
	import skysand.render.hardware.SkyHardwareRender;
	import skysand.render.hardware.SkyRenderType;
	import skysand.render.hardware.SkyStandartQuadBatch;
	import skysand.utils.SkyFilesCache;
	import skysand.utils.SkyMath;
	
	public class SkySprite extends SkyRenderObjectContainer
	{
		public var atlas:SkyTextureAtlas;
		public var texture:Texture;
		public var textureName:String;
		public var batch:SkyStandartQuadBatch;
		public var indexID:uint;
		private var old:Point = new Point();
		private var oldRotation:Number = 1;
		public var verteces:Vector.<Number>;
		private var matrix:Matrix = new Matrix();
		private var v:Vector.<Number>;
		public var spriteData:SkyAtlasSprite;
		private var oldScaleX:Number = 0;
		private var oldScaleY:Number = 0;
		public var uv:Vector.<Number>;
		public var id:int;
		public var name:String;
		public var oldDepth:Number;
		public var oldWidth:Number;
		private var mouse:SkyMouse;
		private var drag:Boolean;
		private var offsetDragPoint:Point;
		
		/**
		 * Перетаскивается ли сейчас объект.
		 */
		private static var isDrag:Boolean = false;
		
		public function SkySprite()
		{
			offsetDragPoint = new Point();
			drag = false;
			oldWidth = 0;
			indexID = 0;
			globalR = new Point();
			localR = new Point();
			mouse = SkyMouse.instance;
			v = new Vector.<Number>(8, true);
		}
		
		override public function remove():void 
		{
			if (batch != null)
			{
				batch.removeSprite(this);
			}
			
			super.remove();
		}
		
		override public function init():void 
		{
			if (batch != null)
			{
				batch.add(this);
				verteces = batch.verteces;
				uv = batch.uvs;
			}
			
			super.init();
		}
		
		public function setAtlasFromCache(name:String):void
		{
			atlas = SkyFilesCache.instance.getTextureAtlas(name);
			batch = SkyHardwareRender.instance.getBatch(name) as SkyStandartQuadBatch;
			texture = atlas.texture;
			this.name = name;
		}
		
		
		
		/*public function setAtlas(atlas:SkyTextureAtlas):void
		{
			this.atlas = atlas;
			batch = SkyHardwareRender.instance.getBatch(atlas.name);
		}
		
		public function setTexture(texture:Texture):void
		{
			
		}
		*/
		public function setTextureFromCache(name:String):void
		{
			var data:SkyTextureData = SkyFilesCache.instance.getTexture(name);
			
			texture = data.texture;
			width = data.width;
			height = data.height;
			
			batch = SkyHardwareRender.instance.getBatch(name) as SkyStandartQuadBatch;
		}
		
		public function setSprite(name:String):void
		{
			if (atlas != null)
			{
				spriteData = atlas.getSprite(name);
				width = spriteData.width;
				height = spriteData.height;
				pivotX = spriteData.pivotX;
				pivotY = spriteData.pivotY;
			}
		}
		
		/**
		 * Начать перетаскивание объекта за курсором мыши.
		 * @param	lockCentr перетаскивание без учёта смещения объекта от курсора.
		 */
		public function startDrag(lockCentr:Boolean = false):void
		{
			if (!drag && !isDrag)
			{
				if (!lockCentr)
				{
					offsetDragPoint.x = mouse.x - x;
					offsetDragPoint.y = mouse.y - y;
				}
				else
				{
					offsetDragPoint.x = 0;
					offsetDragPoint.y = 0;
				}
				
				drag = true;
				isDrag = true;
			}
		}
		
		/**
		 * Остановить перетаскивание объекта.
		 * Объект следует за мышью.
		 */
		public function stopDrag():void
		{
			if (drag)
			{
				drag = false;
				isDrag = false;
			}
		}
		
		/**
		 * Функция обновления координат и других данных.
		 */
		override public function updateData():void 
		{
			globalVisible = visible ? 1 * parent.globalVisible : 0 * parent.globalVisible;
			
			if (globalVisible == 1 && isVisible)
			{
				if (drag)
				{
					x = mouse.x - offsetDragPoint.x;
					y = mouse.y - offsetDragPoint.y;
				}
				
				globalX = parent.globalX + x;
				globalY = parent.globalY + y;
				//globalDepth = parent.globalDepth + depth;
				globalScaleX = parent.globalScaleX * scaleX;
				globalScaleY = parent.globalScaleY * scaleY;
				globalRotation = parent.globalRotation + rotation;
				
				var w:Number = globalScaleX * width;
				var h:Number = globalScaleY * height;
				
				var px:Number = pivotX * globalScaleX;
				var py:Number = pivotY * globalScaleY;
				
				if (verteces == null) return;
				
				if (oldRotation != globalRotation || oldScaleX != globalScaleX || oldScaleY != globalScaleY || oldWidth != width)
				{
					var angle:Number = SkyMath.toRadian(parent.globalRotation);
					
					localR = SkyMath.rotatePoint(x, y, 0, 0, angle);
					globalR.x = localR.x + parent.globalR.x - x;
					globalR.y = localR.y + parent.globalR.y - y;
					
					angle = SkyMath.toRadian(globalRotation);
					
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
					verteces[indexID + 3] = globalX + v[1];
					verteces[indexID + 6] = globalX + v[2];
					verteces[indexID + 9] = globalX + v[3];
					
					verteces[indexID + 1] = globalY + v[4];
					verteces[indexID + 4] = globalY + v[5];
					verteces[indexID + 7] = globalY + v[6];
					verteces[indexID + 10] = globalY + v[7];
					
					matrix.rotate( -angle);
					matrix.identity();
					
					old.x = globalX;
					old.y = globalY;
					oldRotation = globalRotation;
					oldScaleX = globalScaleX;
					oldScaleY = globalScaleY;
					oldWidth = width;
				}
				
				if (old.x != globalX)
				{
					verteces[indexID] = globalX + v[0];
					verteces[indexID + 3] = globalX + v[1];
					verteces[indexID + 6] = globalX + v[2];
					verteces[indexID + 9] = globalX + v[3];
					
					old.x = globalX;
				}
				
				if (old.y != globalY)
				{
					verteces[indexID + 1] = globalY + v[4];
					verteces[indexID + 4] = globalY + v[5];
					verteces[indexID + 7] = globalY + v[6];
					verteces[indexID + 10] = globalY + v[7];
					
					old.y = globalY;
				}
				//max 1
				//min 0
				verteces[indexID + 2] = depth / 100000;//globalDepth;
				verteces[indexID + 5] = depth / 100000;//globalDepth;
				verteces[indexID + 8] = depth / 100000;//globalDepth;
				verteces[indexID + 11] = depth / 100000;//globalDepth;
			}
			else
			{
				verteces[indexID] = 0;
				verteces[indexID + 1] = 0;
				verteces[indexID + 3] = 0;
				verteces[indexID + 4] = 0;
				verteces[indexID + 6] = 0;
				verteces[indexID + 7] = 0;
				verteces[indexID + 9] = 0;
				verteces[indexID + 10] = 0;
			}
		}
	}
}