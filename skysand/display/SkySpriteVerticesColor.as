package skysand.display 
{
	import skysand.utils.SkyUtils;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkySpriteVerticesColor extends Object
	{
		/**
		 * Цвет левой верхней вершины.
		 */
		public var leftUp:uint;
		public var leftUpRed:Number;
		public var leftUpGreen:Number;
		public var leftUpBlue:Number;
		
		/**
		 * Цвет правой верхней вершины.
		 */
		public var rightUp:uint;
		public var rightUpRed:Number;
		public var rightUpGreen:Number;
		public var rightUpBlue:Number;
		
		/**
		 * Цвет левой нижней вершины.
		 */
		public var leftDown:uint;
		public var leftDownRed:Number;
		public var leftDownGreen:Number;
		public var leftDownBlue:Number;
		
		/**
		 * Цвет правой нижней вершины.
		 */
		public var rightDown:uint;
		public var rightDownRed:Number;
		public var rightDownGreen:Number;
		public var rightDownBlue:Number;
		
		public function SkySpriteVerticesColor()
		{
			leftUp = 0xFFFFFF;
			leftUpRed = 1;
			leftUpGreen = 1;
			leftUpBlue = 1;
			
			rightUp = 0xFFFFFF;
			rightUpRed = 1;
			rightUpGreen = 1;
			rightUpBlue = 1;
			
			leftDown = 0xFFFFFF;
			leftDownRed = 1
			leftDownGreen = 1;
			leftDownBlue = 1;
			
			rightDown = 0xFFFFFF;
			rightDownRed = 1
			rightDownGreen = 1;
			rightDownBlue = 1;
		}
		
		/**
		 * Задать один цвет для всех вершин.
		 * @param	color цвет.
		 */
		public function setColor(color:uint):void
		{
			var red:Number = SkyUtils.getRed(color) / 255;
			var green:Number = SkyUtils.getGreen(color) / 255;
			var blue:Number = SkyUtils.getBlue(color) / 255;
			
			leftUp = color;
			leftUpRed = red;
			leftUpGreen = green;
			leftUpBlue = blue;
			
			rightUp = color;
			rightUpRed = red;
			rightUpGreen = green;
			rightUpBlue = blue;
			
			leftDown = color;
			leftDownRed = red
			leftDownGreen = green;
			leftDownBlue = blue;
			
			rightDown = color;
			rightDownRed = red
			rightDownGreen = green;
			rightDownBlue = blue;
		}
		
		/**
		 * Задать один цвет для нижних вершин.
		 * @param	color цвет.
		 */
		public function setDown(color:uint):void
		{
			var red:Number = SkyUtils.getRed(color) / 255;
			var green:Number = SkyUtils.getGreen(color) / 255;
			var blue:Number = SkyUtils.getBlue(color) / 255;
			
			leftDown = color;
			leftDownRed = red
			leftDownGreen = green;
			leftDownBlue = blue;
			
			rightDown = color;
			rightDownRed = red
			rightDownGreen = green;
			rightDownBlue = blue;
		}
		
		/**
		 * Задать один цвет для верхних вершин.
		 * @param	color цвет.
		 */
		public function setUp(color:uint):void
		{
			var red:Number = SkyUtils.getRed(color) / 255;
			var green:Number = SkyUtils.getGreen(color) / 255;
			var blue:Number = SkyUtils.getBlue(color) / 255;
			
			leftUp = color;
			leftUpRed = red;
			leftUpGreen = green;
			leftUpBlue = blue;
			
			rightUp = color;
			rightUpRed = red;
			rightUpGreen = green;
			rightUpBlue = blue;
		}
		
		/**
		 * Задать один цвет для левых вершин.
		 * @param	color цвет.
		 */
		public function setLeft(color:uint):void
		{
			var red:Number = SkyUtils.getRed(color) / 255;
			var green:Number = SkyUtils.getGreen(color) / 255;
			var blue:Number = SkyUtils.getBlue(color) / 255;
			
			leftUp = color;
			leftUpRed = red;
			leftUpGreen = green;
			leftUpBlue = blue;
			
			leftDown = color;
			leftDownRed = red
			leftDownGreen = green;
			leftDownBlue = blue;
		}
		
		/**
		 * Задать один цвет для правых вершин.
		 * @param	color цвет.
		 */
		public function setRight(color:uint):void
		{
			var red:Number = SkyUtils.getRed(color) / 255;
			var green:Number = SkyUtils.getGreen(color) / 255;
			var blue:Number = SkyUtils.getBlue(color) / 255;
			
			rightUp = color;
			rightUpRed = red;
			rightUpGreen = green;
			rightUpBlue = blue;
			
			rightDown = color;
			rightDownRed = red
			rightDownGreen = green;
			rightDownBlue = blue;
		}
		
		/**
		 * Задать цвет левой верхней вершины.
		 * @param	color цвет.
		 */
		public function setLeftUp(color:uint):void
		{
			leftUp = color;
			leftUpRed = SkyUtils.getRed(color) / 255;
			leftUpGreen = SkyUtils.getGreen(color) / 255;
			leftUpBlue = SkyUtils.getBlue(color) / 255;
		}
		
		/**
		 * Задать цвет правой верхней вершины.
		 * @param	color цвет.
		 */
		public function setRightUp(color:uint):void
		{
			rightUp = color;
			rightUpRed = SkyUtils.getRed(color) / 255;
			rightUpGreen = SkyUtils.getGreen(color) / 255;
			rightUpBlue = SkyUtils.getBlue(color) / 255;
		}
		
		/**
		 * Задать цвет левой нижней вершины.
		 * @param	color цвет.
		 */
		public function setLeftDown(color:uint):void
		{
			leftDown = color;
			leftDownRed = SkyUtils.getRed(color) / 255;
			leftDownGreen = SkyUtils.getGreen(color) / 255;
			leftDownBlue = SkyUtils.getBlue(color) / 255;
		}
		
		/**
		 * Задать цвет правой нижней вершины.
		 * @param	color цвет.
		 */
		public function setRightDown(color:uint):void
		{
			rightDown = color;
			rightDownRed = SkyUtils.getRed(color) / 255;
			rightDownGreen = SkyUtils.getGreen(color) / 255;
			rightDownBlue = SkyUtils.getBlue(color) / 255;
		}
	}
}