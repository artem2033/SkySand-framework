package skysand.render
{
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D
	import flash.utils.ByteArray;
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
		protected var indices:Vector.<uint>;
		
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
		
		/**
		 * Количество отрисовываемых объектов.
		 */
		protected var nObjects:uint;
		
		/**
		 * Ассемблер.
		 */ 
		protected var assembler:AGALMiniAssembler;
		
		public function SkyBatchBase()
		{
			super();
		}
		
		/**
		 * Инициализировать пакет отрисовки.
		 * @param	context3D ссылка на context3D.
		 * @param	mvpMatrix ссылка на матрицу.
		 * @param	name название.
		 */
		public function initialize(context3D:Context3D, mvpMatrix:Matrix3D, name:String):void
		{
			this.context3D = context3D;
			this.mvpMatrix = mvpMatrix;
			
			assembler = new AGALMiniAssembler();
			
			verteces = new Vector.<Number>();
			indices = new Vector.<uint>();
			
			nObjects = 0;
			_name = name;
		}
		
		/**
		 * Создать шейдер для загрузки в видеокарту.
		 * @param	vertexShader вершиный шейдер.
		 * @param	pixelShader пиксельный шейдер.
		 */
		public function setShader(vertexShader:String, pixelShader:String):void
		{
			if (program != null) program.dispose();
			program = assembler.assemble2(context3D, SkyHardwareRender.shaderVersion, vertexShader, pixelShader);
		}
		
		/**
		 * Отрисовать пакет.
		 */
		public function render():void
		{
			
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			verteces.length = 0;
			verteces = null;
			
			indices.length = 0;
			indices = null;
			
			mvpMatrix = null;
			context3D = null;
			
			program.dispose();
			program = null;
			
			if (vertexBuffer != null)
			{
				vertexBuffer.dispose();
				vertexBuffer = null;
			}
			
			if (indexBuffer != null)
			{
				indexBuffer.dispose();
				indexBuffer = null;
			}
			
			assembler = null;
			
			SkySand.render.removeBatch(this);
		}
		
		/**
		 * Добавить спрайт в пакет.
		 * @param	sprite спрайт.
		 */
		/*public function add(object:SkyRenderObject):void
		   {
		
		   }*/
		
		/**
		 * Удалить спрайт из пакета.
		 * @param	sprite спрайт.
		 */
		/*public function remove(sprite:SkySprite):void
		   {
		   /*verteces.splice(sprite.indexID, 12);
		   indices.splice(sprite.indexID / 2, 6);
		   //uvs.splice(sprite.indexID, 12);
		   isChanged = true;
		   }*/
		
		/**
		 * Получить имя пакета.
		 */
		public function get name():String
		{
			return _name;
		}
	}
}