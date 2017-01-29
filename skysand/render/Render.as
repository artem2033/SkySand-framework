package skysand.render 
{
	import adobe.utils.CustomActions;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import skysand.components.SkyWindow;
	import skysand.interfaces.IFrameworkUpdatable;
	import skysand.interfaces.IUpdatable;
	import skysand.text.SkyTextField;
	import skysand.text.TextArea;
	import skysand.animation.SkyClip;
	import skysand.utils.SkyMath;
	
	use namespace framework;
	
	public class Render extends Sprite
	{	
		/**
		 * Время на отрисовку списка объектов.
		 */
		public var timePassed:int;
		
		/**
		 * Список отрисовываемых объектов.
		 */
		public var mainRenderObject:RenderObject;
		
		/**
		 * BitmapData куда отрисовываются объекты.
		 */
		private var buffer:BitmapData;
		
		/**
		 * Bitmap для отображениия buffer.
		 */
		private var renderScreen:Bitmap;
		
		/**
		 * Матрица для отрисовки методом draw.
		 */
		private var transformMatrix:Matrix;
		
		/**
		 * Точка для отрисовки объекта в заданных координатах.
		 */
		private var destination:Point;
		
		/**
		 * Прямоугольник для отрисовки объекта.
		 */
		private var rectangle:Rectangle;
		
		/**
		 * Прямоугольник для очистки содержимого экрана.
		 */
		private var fillRectangle:Rectangle;
		
		private var fillColor:uint;
		
		private var oldX:Number;
		private var oldY:Number;
		private var id:uint = 0;
		
		/**
		 * Ссылка на класс синглтон.
		 */
		private static var _instance:Render;
		
		public static var array:Vector.<RenderObject> = new Vector.<RenderObject>();
		
		public function Render()
		{
			if(_instance != null)
			{
				throw new Error("use instance");
			}
			_instance = this;
		}
		
		/**
		 * Получить ссылку на класс Синглтон.
		 */
		public static function get instance():Render
		{
			return (_instance == null) ? new Render() : _instance;
		}
		
		/**
		 * Инициализация Рендера.
		 * @param	gameScreenWidth ширина экрана игры.
		 * @param	gameScreenHeight высота экрана игры.
		 */
		public function initialize(gameScreenWidth:Number, gameScreenHeight:Number, _fillColor:uint = 0x0):void
		{
			fillColor = _fillColor;
			mainRenderObject = new RenderObject();
			
			fillRectangle = new Rectangle(0, 0, gameScreenWidth, gameScreenHeight);
			buffer = new BitmapData(gameScreenWidth, gameScreenHeight, false, _fillColor);
			renderScreen = new Bitmap(buffer);
			addChild(renderScreen);
			transformMatrix = new Matrix();
			destination = new Point();
			rectangle = new Rectangle();
			
			timePassed = 0;
			oldX = 0;
			oldY = 0;
		}
		
		/**
		 * Добавить объект в список отображения.
		 * @param	object объект.
		 */
		public function set rootRenderObject(object:RenderObject):void
		{
			mainRenderObject = object;
		}
		
		/**
		 * Обновить отрисовку экрана.
		 */
		public function update():void
		{
			buffer.lock();
			buffer.fillRect(fillRectangle, fillColor);
			
			SkySand.NUM_ON_STAGE = 0;
			//SkyWindow.N = 0;
			id = 0;
			drawAllChilds(mainRenderObject);
			//trace(SkyWindow.N);
			buffer.unlock();
		}
		
		private function drawAllChilds(object:RenderObject):void
		{
			var length:int = object.numChildren;
			
			for (var i:int = 0; i < length; i++) 
			{
				var objectChild:RenderObject = object.children[i];
				id++;
				objectChild.renderID = id;
				
				if (!objectChild.visible) continue;
				
				if (objectChild is IFrameworkUpdatable) (objectChild as IFrameworkUpdatable).updateByFramework();
				
				objectChild.parent.calculateGlobalData(objectChild);//deleted globalX and globalY = 0;
				
				if (objectChild.bitmapData) draw(objectChild);
				
				if (object.children) drawAllChilds(objectChild);
			}
		}
		
		/**
		 * Отрисовать объект.
		 * @param	object
		 */
		private function draw(object:RenderObject):void
		{
			if (object.globalX + object.originX > buffer.width) return;
			if (object.globalX - object.originX < -object.width) return;
			if (object.globalY + object.originX > buffer.height) return;
			if (object.globalY - object.originY < -object.height) return;
			SkySand.NUM_ON_STAGE++;
			if (object.angle != 0 || object.scaleX != 1 || object.scaleY != 1)
			{
				var angle:Number = SkyMath.toRadian(object.globalAngle);
				
				transformMatrix.translate(object.originX, object.originY);
				transformMatrix.scale(object.scaleX, object.scaleY);
				transformMatrix.rotate(angle);
				transformMatrix.tx += object.globalX;
				transformMatrix.ty += object.globalY;
				
				buffer.draw(object.bitmapData, transformMatrix);
				transformMatrix.identity();
			}
			else
			{
				rectangle.width = object.width;
				rectangle.height = object.height;
				
				destination.x = object.originX + object.globalX;
				destination.y = object.originY + object.globalY;
				
				buffer.copyPixels(object.bitmapData, rectangle, destination);
			}
		}
	}
}