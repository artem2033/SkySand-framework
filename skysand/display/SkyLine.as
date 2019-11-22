package skysand.display 
{
	import flash.geom.Point;
	
	import skysand.utils.SkyMath;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyLine extends SkyRenderObjectContainer
	{
		/**
		 * Линии.
		 */
		private var lines:Vector.<SkyShape>;
		
		/**
		 * Точки.
		 */
		private var dots:Vector.<SkyShape>;
		
		/**
		 * Начальная точка линии.
		 */
		private var start:Point;
		
		/**
		 * Опорные точки.
		 */
		private var anchorA:Point;
		private var anchorB:Point;
		
		/**
		 * Конечная точка линии.
		 */
		private var end:Point;
		
		/**
		 * Количество сегментов в линии.
		 */
		private var mStep:int;
		
		/**
		 * Используется для оптимизации расчётов.
		 */
		private var isUpdated:Boolean;
		
		/**
		 * Является ли линия кривой.
		 */
		private var isCurve:Boolean;
		
		/**
		 * Является ли линия квадратичной кривой.
		 */
		private var isSquareCurve:Boolean;
		
		/**
		 * Имя пакета отрисовки.
		 */
		public var batchName:String;
		
		public function SkyLine() 
		{
			anchorA = new Point();
			anchorB = new Point();
			start = new Point();
			end = new Point();
			
			batchName = "shape";
			isCurve = false;
			isUpdated = false;
			isSquareCurve = true;
		}
		
		/**
		 * Создать линию.
		 * @param	mStep число сегментов
		 */
		public function create(mStep:int = 1):void 
		{
			lines = new Vector.<SkyShape>();
			dots = new Vector.<SkyShape>();
			
			this.mStep = mStep;
			
			for (var i:int = 0; i < mStep; i++) 
			{
				var line:SkyShape = new SkyShape();
				line.batchName = batchName;
				line.drawRect(0, -1, 2, 2);
				line.visible = false;
				addChild(line);
				
				lines.push(line);
				
				var dot:SkyShape = new SkyShape();
				dot.batchName = batchName;
				dot.drawCircle(0, 0, 1, 8);
				dot.visible = false;
				addChild(dot);
				
				dots.push(dot);
			}
			
			dot = new SkyShape();
			dot.batchName = batchName;
			dot.drawCircle(0, 0, 1, 8);
			dot.visible = false;
			addChild(dot);
			
			dots.push(dot);
			
			lines[0].visible = true;
			dots[0].visible = true;
			dots[mStep].visible = true;
		}
		
		/**
		 * Удалить неиспользуемые сегменты.
		 */
		public function freeUnusedSegments():void
		{
			for (var i:int = lines.length - 1; i > mStep; i--) 
			{
				if (lines[i].visible) break;
				
				var line:SkyShape = lines.pop();
				removeChild(line)
				line.free();
				line = null;
			}
			
			for (i = dots.length - 2; i > mStep; i--) 
			{
				if (dots[i].visible) break;
				
				var dot:SkyShape = dots.removeAt(i) as SkyShape;
				removeChild(dot)
				dot.free();
				dot = null;
			}
		}
		
		/**
		 * Задать начальную точку линии.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function moveTo(x:Number, y:Number):void
		{
			if (start.x != x || start.y != y)
			{
				start.x = x;
				start.y = y;
				dots[0].x = x;
				dots[0].y = y;
				
				isUpdated = false;
			}
		}
		private var id:int = 1;
		/**
		 * Задать конечную точку линии.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function lineTo(x:Number, y:Number):void
		{
			//if (end.x != x || end.y != y)
			//{
				//end.x = x;
				//end.y = y;
				dots[id].x = x;
				dots[id].y = y;
				id++;
				
				isUpdated = false;
			//}
		}
		
		/**
		 * Задать первую опорную точку. Использовать для квадратичной кривой.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function setAnchorA(x:Number, y:Number):void
		{
			anchorA.x = x;
			anchorA.y = y;
			
			if (!isCurve)
			{
				for (var i:int = 0; i < mStep; i++) 
				{
					lines[i].visible = true;
					dots[i].visible = true;
				}
				
				dots[mStep].visible = true;
				isCurve = true;
			}
			
			isUpdated = false;
		}
		
		/**
		 * Задать вторую опорную точку. Использовать вместе с первой точкой для кубической кривой.
		 * @param	x координата х.
		 * @param	y координата у.
		 */
		public function setAnchorB(x:Number, y:Number):void
		{
			if (!isCurve) return;
			
			anchorB.x = x;
			anchorB.y = y;
			
			isSquareCurve = false;
			isUpdated = false;
		}
		
		/**
		 * Цвет линии.
		 */
		public function setColor(value:uint):void
		{
			color = value;
			
			for (var i:int = 0; i < mStep; i++) 
			{
				lines[i].color = value;
				dots[i].color = value;
			}
			
			dots[mStep].color = value;
		}
		
		/**
		 * Толщина линии.
		 */
		public function set thickness(value:Number):void
		{
			value = value <= 0 ? 1 : value;
			
			for (var i:int = 0; i < mStep; i++) 
			{
				lines[i].height = value;
				dots[i].width = value;
				dots[i].height = value;
			}
			
			dots[mStep].width = value;
			dots[mStep].height = value;
		}
		
		/**
		 * Толщина линии.
		 */
		public function get thickness():Number
		{
			return lines[0].height;
		}
		
		/**
		 * Число сегментов линии(по умолчанию 10).
		 */
		public function set step(value:int):void
		{
			var difference:int = value - mStep;
			var thickness:Number = lines[0].height;
			
			if (difference > 0)
			{
				for (var i:int = 0; i < difference; i++) 
				{
					var line:SkyShape = new SkyShape();
					line.batchName = batchName;
					line.drawRect(0, -1, thickness, thickness);
					line.color = color;
					line.height = lines[0].height;
					line.visible = isCurve;
					addChild(line);
					
					lines.push(line);
					
					var dot:SkyShape = new SkyShape();
					dot.batchName = batchName;
					dot.drawCircle(0, 0, thickness / 2, 8);
					dot.color = color;
					dot.width = lines[0].height;
					dot.height = lines[0].height;
					dot.visible = isCurve;
					addChild(dot);
					
					dots.push(dot);
				}
				
				dots[mStep].visible = false;
				dots[value].visible = true;
			}
			else
			{
				var length:int = lines.length
				var startIndex:int = length + difference;
				
				for (i = startIndex; i < length; i++) 
				{
					lines[i].visible = false;
					dots[i].visible = false;
				}
				
				dots[length].visible = false;
				dots[value].visible = true;
			}
			
			mStep = value;
		}
		
		/**
		 * Число сегментов линии.
		 */
		public function get step():int
		{
			return mStep;
		}
		
		/**
		 * Обновить данные.
		 * @param	deltaTime промежуток времени межнду кадрами.
		 */
		override public function updateData(deltaTime:Number):void 
		{
			super.updateData(deltaTime);
			
			if (isVisible)
			{
				if (!isUpdated)
				{
					if (!isCurve)
					{
						lines[0].x = dots[mStep - 1].x;
						lines[0].y = dots[mStep - 1].y;
						lines[0].width = SkyMath.distance(start.x, start.y, dots[0].x, dots[0].y);
						lines[0].rotation = SkyMath.toDegrees(SkyMath.radian(dots[0].x, dots[0].y, dots[mStep - 1].x, dots[mStep - 1].y));
						
						for (var i:int = 1; i < mStep; i++) 
						{
							var ax:Number = dots[i - 1].x;
							var ay:Number = dots[i - 1].y;
							var x:Number = dots[i].x;
							var y:Number = dots[i].y;
							
							var line:SkyShape = lines[i];
							line.visible = true;
							line.width = SkyMath.distance(ax, ay, x, y);
							line.rotation = SkyMath.toDegrees(SkyMath.radian(x, y, ax, ay));
							line.x = ax;
							line.y = ay;
						}
					}
					else
					{
						for (var i:int = 1; i < mStep; i++) 
						{
							var t:Number = i / mStep;
							
							if (isSquareCurve)
							{
								var x:Number = (1 - t) * (1 - t) * start.x + 2 * t * (1 - t) * anchorA.x + t * t * end.x;
								var y:Number = (1 - t) * (1 - t) * start.y + 2 * t * (1 - t) * anchorA.y + t * t * end.y;
							}
							else
							{
								x = (1 - t) * (1 - t) * (1 - t) * start.x + 3 * t * (1 - t) * (1 - t) * anchorA.x + 3 * t * t * (1 - t) * anchorB.x + t * t * t * end.x;
								y = (1 - t) * (1 - t) * (1 - t) * start.y + 3 * t * (1 - t) * (1 - t) * anchorA.y + 3 * t * t * (1 - t) * anchorB.y + t * t * t * end.y;
							}
							
							dots[i].x = x;
							dots[i].y = y;
							
							var ax:Number = dots[i - 1].x;
							var ay:Number = dots[i - 1].y;
							
							var line:SkyShape = lines[i - 1];
							line.width = SkyMath.distance(ax, ay, x, y);
							line.rotation = SkyMath.toDegrees(SkyMath.radian(x, y, ax, ay));
							line.x = ax;
							line.y = ay;
						}
						
						ax = dots[mStep - 1].x;
						ay = dots[mStep - 1].y;
						var bx:Number = dots[mStep].x;
						var by:Number = dots[mStep].y;
						
						line = lines[mStep - 1];
						line.width = SkyMath.distance(ax, ay, bx, by);
						line.rotation = SkyMath.toDegrees(SkyMath.radian(bx, by, ax, ay));
						line.x = ax;
						line.y = ay;
					}
					
					isUpdated = true;
				}
			}
		}
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			super.free();
			
			for (var i:int = 0; i < lines.length; i++) 
			{
				removeChild(lines[i]);
				lines[i].free();
				lines[i] = null;
			}
			
			for (i = 0; i < dots.length; i++) 
			{
				removeChild(dots[i]);
				dots[i].free();
				dots[i] = null;
			}
			
			lines.length = 0;
			lines = null;
			
			dots.length = 0;
			dots = null;
			
			end = null;
			start = null;
			anchorA = null;
			anchorB = null;
		}
	}
}