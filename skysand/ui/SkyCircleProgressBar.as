package skysand.ui
{
	import flash.geom.Point;
	
	import skysand.utils.SkyMath;
	import skysand.display.SkyShape;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyCircleProgressBar extends SkyShape
	{
		/**
		 * Половина числа пи.
		 */
		private const HALF_PI:Number = Math.PI / 2;
		
		/**
		 * Число для рассчёта толщины кольца.
		 */
		private const HEGHT_COEF:Number = 0.14;
		
		/**
		 * Оригинальные вершины шестиугольника.
		 */
		private var originVerteces:Vector.<Number>;
		
		/**
		 * Точка для рассчёта угла поворота.
		 */
		private var point:Point;
		
		/**
		 * Радиус шкалы прогресса.
		 */
		private var radius:Number;
		
		/**
		 * Численное значение прогресса.
		 */
		private var mProgress:Number;
		
		/**
		 * Фон.
		 */
		private var background:SkyShape;
		
		/**
		 * Шкала.
		 */
		private var bar:SkyShape;
		
		/**
		 * Внешняя маска.
		 */
		private var ringMask:SkyShape;
		
		/**
		 * Внутренняя маска.
		 */
		private var circleMask:SkyShape;
		
		public function SkyCircleProgressBar()
		{
			
		}
		
		/**
		 * Создать круговую шкалу прогресса.
		 * @param	outRadius внешний радиус.
		 * @param	inRadius внутренний радиус.
		 * @param	numSides число сторон.
		 */
		public function create(outRadius:Number, inRadius:Number, numSides:Number):void
		{
			ringMask = new SkyShape();
			ringMask.color = SkyColor.WET_ASPHALT;
			ringMask.drawRing(0, 0, outRadius + 1, (1 - HEGHT_COEF) * outRadius, numSides);
			ringMask.alpha = 0;
			ringMask.mouseEnabled = false;
			addChild(ringMask);
			
			if (inRadius < outRadius && inRadius != 0)
			{
				inRadius -= HEGHT_COEF * outRadius;
				
				circleMask = new SkyShape();
				circleMask.color = SkyColor.WET_ASPHALT;
				circleMask.drawCircle(0, 0, inRadius, numSides);
				circleMask.alpha = 0;
				circleMask.mouseEnabled = false;
				addChild(circleMask);
			}
			
			background = SkyUI.getForm(SkyUI.CIRCLE, SkyColor.DARK_BLUE_GREY, outRadius, 6);
			background.mouseEnabled = false;
			addChildAt(background, 0);
			
			originVerteces = new Vector.<Number>();
			
			bar = new SkyShape();
			bar.color = SkyColor.TIFFANY;
			bar.mouseEnabled = false;
			
			var angleDelta:Number = Math.PI / 3;
			var angle:Number = -HALF_PI;
			
			for (var i:int = 0; i < 7; i++)
			{
				var dx:Number = Math.cos(angle) * outRadius;
				var dy:Number = Math.sin(angle) * outRadius;
				
				bar.addVertex(dx, dy);
				originVerteces.push(dx, dy);
				
				angle -= angleDelta;
			}
			
			bar.addVertex(0, 0);
			addChildAt(bar, 1);
			
			radius = outRadius;
			mProgress = 0;
			
			point = new Point();
		}
		
		/**
		 * Прозрачность.
		 * @param	value значение от 0 до 1.
		 */
		public function setAlpha(value:Number):void
		{
			bar.alpha = value;
			background.alpha = value;
		}
		
		/**
		 * Изменить размеры прогресс бара.
		 * @param	outRadius внешний радиус.
		 * @param	inRadius внутренний радиус.
		 */
		public function setRadius(outRadius:Number, inRadius:Number):void
		{
			removeChild(ringMask);
			ringMask.free();
			ringMask = new SkyShape();
			ringMask.color = SkyColor.WET_ASPHALT;
			ringMask.drawRing(0, 0, outRadius + 1, (1 - HEGHT_COEF) * outRadius, 100);
			ringMask.alpha = 0;
			ringMask.mouseEnabled = false;
			addChild(ringMask);
			
			if (inRadius < outRadius && inRadius != 0)
			{
				inRadius -= HEGHT_COEF * outRadius;
				
				removeChild(circleMask);
				circleMask.free();
				circleMask = new SkyShape();
				circleMask.color = SkyColor.WET_ASPHALT;
				circleMask.drawCircle(0, 0, inRadius, 100);
				circleMask.alpha = 0;
				circleMask.mouseEnabled = false;
				addChild(circleMask);
			}
			
			var color:uint = background.color;
			
			removeChild(background);
			background.free();
			background = SkyUI.getForm(SkyUI.CIRCLE, color, outRadius, 6);
			background.mouseEnabled = false;
			addChildAt(background, 0);
			
			color = bar.color;
			removeChild(bar);
			bar.free();
			bar = new SkyShape();
			bar.color = color;
			bar.mouseEnabled = false;
			
			originVerteces.length = 0;
			
			var angleDelta:Number = Math.PI / 3;
			var angle:Number = -HALF_PI;
			
			for (var i:int = 0; i < 7; i++)
			{
				var dx:Number = Math.cos(angle) * outRadius;
				var dy:Number = Math.sin(angle) * outRadius;
				
				bar.addVertex(dx, dy);
				originVerteces.push(dx, dy);
				
				angle -= angleDelta;
			}
			
			bar.addVertex(0, 0);
			addChildAt(bar, 1);
			
			radius = outRadius;
			mProgress = 0;
		}
		
		/**
		 * Задать цвета.
		 * @param	backgroundColor цвет фона.
		 * @param	barColor цвет шкалы.
		 */
		public function setColors(backgroundColor:uint, barColor:uint):void
		{
			background.color = backgroundColor;
			bar.color = barColor;
		}
		
		/**
		 * Задать прогресс от 0 до 1.
		 */
		public function set progress(value:Number):void
		{
			value = value > 1 ? 1 : value;
			mProgress = value;
			
			var radian:Number = SkyMath.toRadian(value * 360) - HALF_PI;
			
			point.x = radius * Math.cos(radian);
			point.y = radius * Math.sin(radian);
			
			var verteces:Vector.<Number> = bar.getVertices();
			var index:int = bar.indexID;
			
			verteces[0] = point.x;
			verteces[1] = point.y;
			
			value = 1 - value;
			
			if (value * 360 > 60)
			{
				verteces[2] = point.x;
				verteces[3] = point.y;
			}
			else
			{
				verteces[2] = originVerteces[2];
				verteces[3] = originVerteces[3];
			}
			
			if (value * 360 > 120)
			{
				verteces[4] = point.x;
				verteces[5] = point.y;
			}
			else
			{
				verteces[4] = originVerteces[4];
				verteces[5] = originVerteces[5];
			}
			
			if (value * 360 > 180)
			{
				verteces[6] = point.x;
				verteces[7] = point.y;
			}
			else
			{
				verteces[6] = originVerteces[6];
				verteces[7] = originVerteces[7];
			}
			
			if (value * 360 > 240)
			{
				verteces[8] = point.x;
				verteces[9] = point.y;
			}
			else
			{
				verteces[8] = originVerteces[8];
				verteces[9] = originVerteces[9];
			}
			
			if (value * 360 > 300)
			{
				verteces[10] = point.x;
				verteces[11] = point.y;
			}
			else
			{
				verteces[10] = originVerteces[10];
				verteces[11] = originVerteces[11];
			}
		}
		
		/**
		 * Получить прогресс от 0 до 1.
		 */
		public function get progress():Number
		{
			return mProgress;
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(background);
			background.free();
			background = null;
			
			removeChild(bar);
			bar.free();
			bar = null;
			
			removeChild(ringMask);
			ringMask.free();
			ringMask = null;
			
			removeChild(circleMask);
			circleMask.free();
			circleMask = null;
			
			originVerteces.length = 0;
			originVerteces = null;
			point = null;
			
			super.free();
		}
	}
}