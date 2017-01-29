package skysand.render.hardware
{
	import adobe.utils.CustomActions;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.sampler.NewObjectSample;
	import flash.utils.ByteArray;
	import skysand.display.SkyRenderObject;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyTextureAtlas;
	import skysand.display.SkySprite;
	import flash.geom.Matrix3D;
	
	public class SkyBatchBase extends Object
	{
		/**
		 * Массив вершин.
		 */
		public var verteces:Vector.<Number>;
		
		/**
		 * Массив индексов.
		 */
		public var indeces:Vector.<uint>;
		
		//protected var 
		/**
		 * Mvp матрица.
		 */
		protected var mvpMatrix:Matrix3D;
		
		/**
		 * Буффер вершин.
		 */
		protected var vertexBuffer:VertexBuffer3D;
		
		/**
		 * Буффер индексов.
		 */
		protected var indexBuffer:IndexBuffer3D;
		
		/**
		 * Ссылка на context.
		 */
		protected var context3D:Context3D;
		
		/**
		 * Шейдерная программа.
		 */
		protected var program:Program3D;
		
		/**
		 * Имя пакета.
		 */
		protected var _name:String;
		
		protected var nObjects:uint;
		
		private var isChanged:Boolean = false;
		
		public function SkyBatchBase()
		{
			super();
		}
		
		public function initialize(context3D:Context3D, mvpMatrix:Matrix3D, name:String):void
		{
			this.context3D = context3D;
			this.mvpMatrix = mvpMatrix;
			
			verteces = new Vector.<Number>();
			indeces = new Vector.<uint>();
			
			nObjects = 0;
			_name = name;
		}
		
		public function setShader(vertexShader:String, pixelShader:String):void
		{
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			
			var vertexProgram:ByteArray = assembler.assemble(Context3DProgramType.VERTEX, vertexShader);
			var pixelProgram:ByteArray = assembler.assemble(Context3DProgramType.FRAGMENT, pixelShader);
			
			program = context3D.createProgram();
			program.upload(vertexProgram, pixelProgram);
		}
		
		public function render():void
		{
			
		}
		
		public function free():void
		{
			verteces.length = 0;
			verteces = null;
			
			indeces.length = 0;
			indeces = null;
			
			mvpMatrix = null;
			context3D = null;
			
			program.dispose();
			program = null;
			
			if (vertexBuffer)
			{
				vertexBuffer.dispose();
				vertexBuffer = null;
			}
			
			if (indexBuffer)
			{
				indexBuffer.dispose();
				indexBuffer = null;
			}
			
			SkyHardwareRender.instance.removeBatch(this);
		}
		
		/**
		 * Добавить спрайт в пакет.
		 * @param	sprite спрайт.
		 */
		/*public function add(object:SkyRenderObject):void
		{
			
		}*/
		
		/**
		 * Добавить спрайт в пакет на определённую позицию.
		 * @param	sprite спрайт.
		 * @param	index позиция от 0 до numChildren.
		 */
		/*public function addAt(object:SkyRenderObject, index:int):void
		{
			/*var id:int = index;
			
			indeces.push(id * 4, id * 4 + 1, id * 4 + 2, id * 4 + 1, id * 4 + 3, id * 4 + 2);
			
			//			  x  y  z  a  r  g  b
			verteces.push(0, 0, 0, 1, 1, 1, 1);
			verteces.push(0, 0, 0, 1, 1, 1, 1);
			verteces.push(0, 0, 0, 1, 1, 1, 1);
			verteces.push(0, 0, 0, 1, 1, 1, 1);
			
			isChanged = true;
			nObjects++;
		}*/
		
		/**
		 * Удалить спрайт из пакета.
		 * @param	sprite спрайт.
		 */
		/*public function remove(sprite:SkySprite):void
		{
			/*verteces.splice(sprite.indexID, 12);
			indeces.splice(sprite.indexID / 2, 6);
			//uvs.splice(sprite.indexID, 12);
			isChanged = true;
		}*/
		
		/**
		 * Удалить спрайт из пакета через его номер.
		 * @param	index номер спрайта.
		 */
		public function removeAt(index:int):void
		{
			/*index *= 12;
			
			if (index >= verteces.length || index < 0) return;
			
			verteces.splice(index, 12);
			indeces.splice(index / 2, 6);
			//uvs.splice(index, 12);
			
			isChanged = true;*/
		}
		
		/**
		 * Удалить несколько спрайтов начиная с beginIndex.
		 * @param	beginIndex номер с которого начинать удалять.
		 * @param	count количество спрайтов.
		 */
		public function removeAll(beginIndex:int = 0, count:int = int.MAX_VALUE):void
		{
			/*if (beginIndex < 0 || beginIndex > verteces.length) return;
			
			for (var i:int = beginIndex; i < beginIndex + count; i++) 
			{
				//removeSpriteAt(i);
				i--;
			}*/
		}
		
		/**
		 * Поменять очередь отрисовки спрайтов.
		 * @param	sprite0 первый спрайт.
		 * @param	sprite1 второй спрайт.
		 */
		public function swap(sprite0:SkySprite, sprite1:SkySprite):void
		{
			/*var i:int = sprite0.indexID;
			var j:int = sprite1.indexID;
			
			var temp:Number = 0;
			
			for (var k:int = 0; k < 12; k++) 
			{
				temp = verteces[j + k];
				verteces[j + k] = verteces[i + k];
				verteces[i + k] = temp;
				
				//temp = uvs[j + k];
				//uvs[j + k] = uvs[i + k];
				//uvs[i + k] = temp;
			}
			
			temp = sprite0.indexID;
			sprite0.indexID = sprite1.indexID;
			sprite1.indexID = temp;*/
		}
		
		/**
		 * Поменять очередь отрисовки спрайтов.
		 * @param	index0 номер первого спрайта.
		 * @param	index1 номер второго спрайта.
		 */
		public function swapAt(index0:int, index1:int):void
		{
			/*if (children == null) return;
			
			if ((index0 || index1) < 0 || (index0 || index1) > nChildren) return;
			
			var temp:SkyRenderObjectContainer = children[index0];
			children[index0] = children[index1];
			children[index1] = temp;*/
		}
		
		/**
		 * Получить имя пакета.
		 */
		public function get name():String
		{
			return _name;
		}
	}
}