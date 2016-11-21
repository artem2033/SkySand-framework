package skysand.render.hardware
{
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.Context3DFillMode;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import skysand.display.SkySprite;
	import skysand.display.SkyAtlasSprite;
	import skysand.interfaces.IBatch;
	
	public class SkyStandartQuadBatch extends SkyBatchBase
	{
		/**
		 * Массив текстурных координат + альфа канал.
		 */
		public var uvs:Vector.<Number>;
		
		/**
		 * Буффер текстурных координат + альфа канал.
		 */
		private var uvBuffer:VertexBuffer3D;
		
		/**
		 * Текстура.
		 */
		private var texture:Texture;
		
		/**
		 * Проверка на изменение размера массивов.
		 */
		private var isChanged:Boolean;
		
		/**
		 * Порядковый номер спрайта.
		 */
		private var id:int;
		
		
		
		public function SkyStandartQuadBatch()
		{
			
		}
		
		/**
		 * Инициализировать пакет.
		 * @param	context3D ссылка на контекст.
		 * @param	mvpMatrix model view матрица
		 * @param	name название пакета.
		 */
		public function initialize(context3D:Context3D, mvpMatrix:Matrix3D, name:String):void
		{
			initBase(context3D, mvpMatrix);
			
			isChanged = false;
			_name = name;
			id = 0;
			
			uvs = new Vector.<Number>();
			
			var vertexShader:String = "";
			vertexShader += "m44 op, va0, vc0 \n";
			vertexShader += "mov v0, va1";
			
			var pixelShader:String = "";
			pixelShader += "tex ft0, v0.xy, fs0 <2d, clamp, linear, nomip> \n";
			pixelShader += "mul ft0, ft0, v0.z \n";
			pixelShader += "mov oc, ft0";
			
			setShader(vertexShader, pixelShader);
		}
		
		/**
		 * Добавить спрайт в пакет.
		 * @param	sprite спрайт.
		 */
		public function addSprite(sprite:SkySprite):void
		{
			addSpriteAt(sprite, verteces.length);
		}
		
		/**
		 * Добавить спрайт в пакет на определённую позицию.
		 * @param	sprite спрайт.
		 * @param	index позиция от 0 до numChildren.
		 */
		public function addSpriteAt(sprite:SkySprite, index:int):void
		{
			index *= index < verteces.length - 1 ? 12 : 1;
			
			//if (index > verteces.length) return;
			
			if (texture == null) texture = sprite.texture;
			
			sprite.indexID = id * 12;
			
			indeces.push(id * 4, id * 4 + 1, id * 4 + 2, id * 4 + 1, id * 4 + 3, id * 4 + 2);
			
			if (sprite.atlas == null)
			{
				uvs.push(0, 0, sprite.alpha);
				uvs.push(1, 0, sprite.alpha);
				uvs.push(0, 1, sprite.alpha);
				uvs.push(1, 1, sprite.alpha);
			}
			else
			{
				var data:SkyAtlasSprite = sprite.spriteData;
				
				uvs.push(data.vertices[0], data.vertices[1], sprite.alpha);
				uvs.push(data.vertices[2], data.vertices[3], sprite.alpha);
				uvs.push(data.vertices[4], data.vertices[5], sprite.alpha);
				uvs.push(data.vertices[6], data.vertices[7], sprite.alpha);
			}
			
			verteces.push(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			
			isChanged = true;
			id++
		}
		
		/**
		 * Удалить спрайт из пакета.
		 * @param	sprite спрайт.
		 */
		public function removeSprite(sprite:SkySprite):void
		{
			verteces.splice(sprite.indexID, 12);
			indeces.splice(sprite.indexID / 2, 6);
			uvs.splice(sprite.indexID, 12);
			isChanged = true;
		}
		
		/**
		 * Удалить спрайт из пакета через его номер.
		 * @param	index номер спрайта.
		 */
		public function removeSpriteAt(index:int):void
		{
			index *= 12;
			
			if (index >= verteces.length || index < 0) return;
			
			verteces.splice(index, 12);
			indeces.splice(index / 2, 6);
			uvs.splice(index, 12);
			
			isChanged = true;
		}
		
		/**
		 * Удалить несколько спрайтов начиная с beginIndex.
		 * @param	beginIndex номер с которого начинать удалять.
		 * @param	count количество спрайтов.
		 */
		public function removeSprites(beginIndex:int = 0, count:int = int.MAX_VALUE):void
		{
			if (beginIndex < 0 || beginIndex > verteces.length) return;
			
			for (var i:int = beginIndex; i < beginIndex + count; i++) 
			{
				removeSpriteAt(i);
				i--;
			}
		}
		
		/**
		 * Поменять очередь отрисовки спрайтов.
		 * @param	sprite0 первый спрайт.
		 * @param	sprite1 второй спрайт.
		 */
		public function swapSprites(sprite0:SkySprite, sprite1:SkySprite):void
		{
			var i:int = sprite0.indexID;
			var j:int = sprite1.indexID;
			
			var temp:Number = 0;
			
			for (var k:int = 0; k < 12; k++) 
			{
				temp = verteces[j + k];
				verteces[j + k] = verteces[i + k];
				verteces[i + k] = temp;
				
				temp = uvs[j + k];
				uvs[j + k] = uvs[i + k];
				uvs[i + k] = temp;
			}
			
			temp = sprite0.indexID;
			sprite0.indexID = sprite1.indexID;
			sprite1.indexID = temp;
		}
		
		/**
		 * Поменять очередь отрисовки спрайтов.
		 * @param	index0 номер первого спрайта.
		 * @param	index1 номер второго спрайта.
		 */
		public function swapSpritesAt(index0:int, index1:int):void
		{
			/*if (children == null) return;
			
			if ((index0 || index1) < 0 || (index0 || index1) > nChildren) return;
			
			var temp:SkyRenderObjectContainer = children[index0];
			children[index0] = children[index1];
			children[index1] = temp;*/
		}
		
		/**
		 * Отрисовать все спрайты в пакете.
		 */
		override public function render():void
		{
			super.render();
			
			if (isChanged)
			{
				vertexBuffer = context3D.createVertexBuffer(verteces.length / 3, 3);
				indexBuffer = context3D.createIndexBuffer(indeces.length);
				uvBuffer = context3D.createVertexBuffer(uvs.length / 3, 3);
				
				indexBuffer.uploadFromVector(indeces, 0, indeces.length);
				
				isChanged = false;
			}
			
			vertexBuffer.uploadFromVector(verteces, 0, verteces.length / 3);
			uvBuffer.uploadFromVector(uvs, 0, uvs.length / 3);
			
			context3D.setProgram(program);
			context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mvpMatrix, true);
			context3D.setTextureAt(0, texture);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.drawTriangles(indexBuffer);
		}
	}
}