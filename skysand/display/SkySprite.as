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
		
		public function setAtlasFromCache(name:String):void
		{
			atlas = SkyFilesCache.instance.getTextureAtlas(name);
			batch = SkyHardwareRender.instance.getBatch(name);
			texture = atlas.texture;
			this.name = name;
		}
		
		override public function addChild(child:SkyRenderObjectContainer):void 
		{
			super.addChild(child);
			
			var sprite:SkySprite = (child as SkySprite);
			
			if (sprite.batch != null)
			{
				sprite.batch.addSprite(sprite);
				sprite.verteces = sprite.batch.verteces;
				sprite.uv = sprite.batch.uvs;
			}
			
			SkyHardwareRender.instance.addObjectToRender(child);
		}
		
		override public function addChildAt(child:SkyRenderObjectContainer, index:int):void 
		{
			super.addChildAt(child, index);
			
			var sprite:SkySprite = (child as SkySprite);
			
			if (sprite.batch != null)
			{
				sprite.batch.addSpriteAt(sprite, index);
				sprite.verteces = sprite.batch.verteces;
				sprite.uv = sprite.batch.uvs;
			}
			
			SkyHardwareRender.instance.addObjectToRender(child);
		}
		
		override public function removeChild(child:SkyRenderObjectContainer):void 
		{
			super.removeChild(child);
			
			var sprite:SkySprite = (child as SkySprite);
			
			sprite.batch.removeSprite(sprite);
			
			SkyHardwareRender.instance.removeObjectFromRender(child);
		}
		
		/*public function setAtlas(atlas:SkyTextureAtlas):void
		{
			this.atlas = atlas;
			batch = SkyHardwareRender.instance.getBatch(atlas.name);
		}
		
		public function setTexture(texture:Texture):void
		{
			
		}
		
		public function setTextureFromCache(name:String):void
		{
			
		}*/
		
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
		
		override public function swapChildren(child0:SkyRenderObjectContainer, child1:SkyRenderObjectContainer):void 
		{
			batch = (child0 as SkySprite).batch;
			batch.swapSprites(child0 as SkySprite, child1 as SkySprite);
			super.swapChildren(child0, child1);
		}
		
		override public function swapChildrenAt(index0:int, index1:int):void 
		{
			swapChildren(children[index0] as SkySprite, children[index1] as SkySprite);
			super.swapChildrenAt(index0, index1);
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
		override public function updateCoordinates():void 
		{
			if (parent.visible && visible)
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
					
					localR = SkyMath.rotatePointFromAngle(x, y, 0, 0, angle);
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
				verteces[indexID + 2] = 1 - (depth + parent.depth) / 100000;//globalDepth;
				verteces[indexID + 5] = 1 - (depth + parent.depth) / 100000;//globalDepth;
				verteces[indexID + 8] = 1 - (depth + parent.depth) / 100000;//globalDepth;
				verteces[indexID + 11] = 1 - (depth + parent.depth) / 100000;//globalDepth;
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