package skysand.render.hardware 
{
	import flash.geom.Matrix3D;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Context3DFillMode;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import skysand.interfaces.IBatch;
	import skysand.display.SkyGraphics;
	import skysand.utils.triangulation.EarCutting;
	
	/**
	 * ...
	 * @author codecoregames
	 */
	public class SkyGraphicsBatch extends SkyBatchBase implements IBatch
	{
		/**
		 * Количество данный на одну вершину.
		 */
		public static const DATA_PER_VERTEX:uint = 7;
		
		/**
		 * Проверка на изменение размеров вершинного и индексного буфферов.
		 */
		private var isChanged:Boolean;
		
		/**
		 * Смещение индексов относительно последних добавленных.
		 */
		private var position:int;
		
		/**
		 * Объекты в данном пакете.
		 */
		private var objects:Vector.<SkyGraphics>;
		
		/**
		 * Количество индексов для одного объекта.
		 */
		private var sizes:Vector.<int>;
		
		public function SkyGraphicsBatch()
		{
			
		}
		
		/**
		 * Инициализировать пакет.
		 * @param	context3D ссылка на контекст.
		 * @param	mvpMatrix model view матрица
		 * @param	name название пакета.
		 */
		override public function initialize(context3D:Context3D, mvpMatrix:Matrix3D, name:String):void
		{
			super.initialize(context3D, mvpMatrix, name);
			
			objects = new Vector.<SkyGraphics>();
			sizes = new Vector.<int>();
			
			isChanged = false;
			_name = name;
			position = 0;
			
			var vertexShader:String = "";
			vertexShader += "m44 op, va0, vc0 \n";
			vertexShader += "mov v0, va1";
			
			var pixelShader:String = "mov oc, v0";
			
			setShader(vertexShader, pixelShader);
		}
		
		/**
		 * Добавить новый объект для отрисовки в пакет.
		 * @param	object объект который нужно отрисовать.
		 */
		public function add(object:SkyGraphics):void
		{
			var length:int = object.vertecesCount;
			
			for (var i:int = 0; i < length; i++)
			{
				verteces.push(0, 0, 0, 1, 1, 1, 1);
			}
			
			sizes.push(indeces.length);
			
			var a:Vector.<uint> = EarCutting.cutFromPoints(object.getVertices);
			
			length = a.length;
			
			for (i = 0; i < length; i++)
			{
				indeces.push(a[i] + position / DATA_PER_VERTEX);
			}
			
			object.indexID = position;
			position = verteces.length;
			objects.push(object);
			
			isChanged = true;
		}
		
		/**
		 * Удалить объект из пакета.
		 * @param	object объект.
		 */
		public function remove(object:SkyGraphics):void
		{
			var index:int = objects.indexOf(object);
			
			if (index < 0) return;
			
			var size:int = object.vertecesCount * DATA_PER_VERTEX;
			var indexCount:int = index + 1 != sizes.length ? sizes[index + 1] - sizes[index] : indeces.length - sizes[index];
			var length:int = 0;
			
			verteces.splice(object.indexID, size);
			indeces.splice(sizes[index], indexCount);
			
			length = indeces.length;
			
			for (var i:int = sizes[index]; i < length; i++) 
			{
				indeces[i] -= size / DATA_PER_VERTEX;
			}
			
			objects.splice(index, 1);
			sizes.splice(index, 1);
			
			position -= size;
			
			length = objects.length;
			
			for (i = index; i < length; i++)
			{
				objects[i].indexID -= size;
				sizes[i] -= indexCount;
			}
			
			isChanged = true;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void
		{
			sizes.length = 0;
			sizes = null;
			
			objects.length = 0;
			objects = null;
			
			super.free();
		}
		
		/**
		 * Отрисовать все спрайты в пакете.
		 */
		override public function render():void
		{
			super.render();
			
			if (isChanged && verteces.length > 0)
			{
				vertexBuffer = context3D.createVertexBuffer(verteces.length / DATA_PER_VERTEX, DATA_PER_VERTEX);
				indexBuffer = context3D.createIndexBuffer(indeces.length);
				
				indexBuffer.uploadFromVector(indeces, 0, indeces.length);
				
				isChanged = false;
			}
			
			vertexBuffer.uploadFromVector(verteces, 0, verteces.length / DATA_PER_VERTEX);
			
			context3D.setProgram(program);
			context3D.setTextureAt(0, null);
			context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mvpMatrix, true);
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
			context3D.drawTriangles(indexBuffer);
		}
	}
}