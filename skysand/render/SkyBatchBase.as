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
		public var drawCallCount:int = 0;
		
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
		 * Матрица трансформации мировых координат.
		 */
		protected var worldMatrix:Matrix3D;
		
		/**
		 * Текущая активная матрица.
		 */
		protected var currentMatrix:Matrix3D;
		
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
		public function initialize(context3D:Context3D, mvpMatrix:Matrix3D, worldMatrix:Matrix3D, name:String):void
		{
			this.context3D = context3D;
			this.mvpMatrix = mvpMatrix;
			this.worldMatrix = worldMatrix;
			
			currentMatrix = worldMatrix;
			
			verteces = new Vector.<Number>();
			indices = new Vector.<uint>();
			
			nObjects = 0;
			_name = name;
		}
		
		public function set allowCameraTransformation(value:Boolean):void
		{
			currentMatrix = value ? mvpMatrix : worldMatrix;
		}
		
		public function get allowCameraTransformation():Boolean
		{
			return currentMatrix == mvpMatrix ? true : false;
		}
		
		/**
		 * Установить текущий шейдер из общего списка программ.
		 * @param	id идентификатор программы.
		 */
		public function setShaderProgram(id:uint):void
		{
			program = SkySand.render.getProgram(id);
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
			
			worldMatrix = null;
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
			
			SkySand.render.removeBatch(this);
		}
		
		public function hasAvailableSpace(size:uint):Boolean
		{
			return false;
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