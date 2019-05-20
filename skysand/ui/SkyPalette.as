package skysand.ui 
{
	import skysand.debug.Console;
	import skysand.display.SkyShape;
	import skysand.input.SkyMouse;
	import skysand.utils.SkyUtils;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyPalette extends SkyShape
	{
		private var background:SkyShape;
		private var colors:Vector.<SkyShape>;
		private var frame:SkyShape;
		private var mouse:SkyMouse = SkyMouse.instance;
		
		public function SkyPalette() 
		{
			
		}
		
		public function create(kind:uint, backgroundColor:uint, colors:Vector.<uint>, colorSize:Number = 5):void
		{
			var colorCount:int = colors.length;
			var length:int = getLength(colorCount);
			var size:Number = (colorSize + 2) * length + 2;
			var index:int = 0;
			colorSize = 10;
			this.colors = new Vector.<SkyShape>();
			
			//background = SkyUI.getForm(kind, backgroundColor, size, size);
			//addChild(background);
			
			for (var i:int = 0; i < length; i++) 
			{
				for (var j:int = 0; j < length; j++) 
				{
					if (index < colorCount)
					{
						var color:SkyShape = SkyUI.getForm(SkyUI.CIRCLE, colors[index], colorSize, colorSize*2);
						color.x = 2 + j * (colorSize*2 + 8);
						color.y = 2 + i * (colorSize*2 + 8);
						addChild(color);
						
						this.colors.push(color);
						index++;
					}
				}
			}
			
			frame = new SkyShape();
			frame.color = 0xFFFFFF;
			frame.drawCircle(0, 0, colorSize + 3, colorSize * 2);//frame.drawFrame(0, 0, colorSize + 2, colorSize + 2, 2);
			frame.visible = false;
			frame.alpha = 0.4;
			addChild(frame);
			
			SkyMouse.instance.addFunctionOnClick(onClickListener, SkyMouse.LEFT);
		}
		
		private function getLength(colorCount:int):int
		{
			var length:int = 0;
			
			for (var i:int = 0; i < colorCount; i++) 
			{
				if (i * i > colorCount)
				{
					length = i;
					break;
				}
			}
			
			return length;
		}
		
		private var currentColor:uint = 0;
		private var mFunction:Function;
		
		public function setFunction(mFunction:Function):void
		{
			this.mFunction = mFunction;
		}
		
		public function getColor():uint
		{
			return currentColor;
		}
		
		private function onClickListener():void 
		{
			var length:int = colors.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var color:SkyShape = colors[i];
				
				if (color.depth != mouse.upperIndex) continue;
				
				if (color.hitTestBoundsWithMouse())
				{
					currentColor = color.color;
					frame.visible = true;
					frame.x = color.x;
					frame.y = color.y;
					frame.color = color.color;
					if (mFunction != null) mFunction.apply(null, [currentColor]);
					break;
				}
			}
		}
	}
}