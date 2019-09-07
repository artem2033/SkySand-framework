package skysand.debug 
{
	import adobe.utils.CustomActions;
	import skysand.display.SkyCamera;
	import skysand.display.SkyFrame;
	import skysand.display.SkyLine;
	import skysand.display.SkyRenderObjectContainer;
	import skysand.display.SkyShape;
	import skysand.text.SkyFont;
	import skysand.text.SkyTextField;
	import skysand.ui.SkyCheckBox;
	import skysand.ui.SkyColor;
	import skysand.ui.SkyInputNumber;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyCameraRender extends SkyRenderObjectContainer
	{
		private const AXIS_LINE_COLOR:uint = SkyColor.BRILLIANT_GREENISH_BLUE;
		private const DOT_COLOR:uint = SkyColor.CARMINE_PINK;
		
		private var camera:SkyCamera;
		private var safeZone:SkyFrame;
		private var leftDeadZone:SkyShape;
		private var rightDeadZone:SkyShape;
		private var upDeadZone:SkyShape;
		private var downDeadZone:SkyShape;
		private var dot:SkyShape;
		private var cameraPostionText:SkyTextField;
		private var container:SkyRenderObjectContainer;
		private var labels:Vector.<SkyTextField>;
		
		private var dampingX:SkyInputNumber;
		private var dampingY:SkyInputNumber;
		
		private var deadZoneWidth:SkyInputNumber;
		private var deadZoneHeight:SkyInputNumber;
		
		private var safeZoneWidth:SkyInputNumber;
		private var safeZoneHeight:SkyInputNumber;
		
		private var lookAheadDistance:SkyInputNumber;
		private var lookAheadAcsel:SkyInputNumber;
		
		private var enableSafeZone:SkyCheckBox;
		private var offsetX:SkyInputNumber;
		private var offsetY:SkyInputNumber;
		private var offset:Number = 0;
		
		public function SkyCameraRender() 
		{
			
		}
		
		public function get cameraSetupUI():SkyRenderObjectContainer
		{
			if (container == null)
			{
				container = new SkyRenderObjectContainer();
				labels = new Vector.<SkyTextField>();
				
				dampingX = createInput("Damping X", 0.01, 1, 0.01, 1);
				dampingY = createInput("Damping Y", 0.01, 1, 0.01, 1);
				offsetX = createInput("offset X", 1, 10);
				offsetY = createInput("offset Y", 1, 10);
				deadZoneWidth = createInput("dead zone width", 1, 200, 0);
				deadZoneHeight = createInput("dead zone height", 1, 200, 0);
				safeZoneWidth = createInput("safe zone width", 1, 300, 0);
				safeZoneHeight = createInput("safe zone height", 1, 600, 0);
				lookAheadDistance = createInput("look ahead distance", 1, 400, 0);
				lookAheadAcsel = createInput("look ahead acsel", 1, 40, 0.1);
			}
			
			if (camera != null)
			{
				dampingX.value = camera.dampingX;
				dampingY.value = camera.dampingY;
				offsetX.value = camera.screenOffset.x;
				offsetY.value = camera.screenOffset.y;
				deadZoneWidth.value = camera.deadZoneWidth;
				deadZoneHeight.value = camera.deadZoneHeight;
				safeZoneWidth.value = camera.safeZoneWidth;
				safeZoneHeight.value = camera.safeZoneHeight;
				lookAheadDistance.value = camera.lookAheadDistance;
				lookAheadAcsel.value = camera.lookAheadAcseleration;
			}
			
			return container;
		}
		
		private function createInput(label:String, step:Number, value:Number, min:Number = -1000000, max:Number = 1000000):SkyInputNumber
		{
			var textField:SkyTextField = new SkyTextField();
			textField.width = 200;
			textField.height = 24;
			textField.size = 14;
			textField.embedFonts = true;
			textField.textColor = SkyColor.CLOUDS;
			textField.font = SkyFont.OPEN_SANS;
			textField.text = label;
			textField.y = offset;
			addChild(textField);
			
			labels.push(textField);
			
			var input:SkyInputNumber = new SkyInputNumber();
			input.batchName = "cameraDebug";
			input.create(40, 24);
			input.x = 150;
			input.y = offset;
			input.step = step;
			input.value = value;
			
			if (min != -1000000) input.min = min;
			if (max != 1000000) input.max = max;
			
			addChild(input);
			offset += 26;
			
			return input;
		}
		
		
		
		/**
		 * Освободить память.
		 */
		override public function free():void 
		{
			removeChild(safeZone);
			safeZone.free();
			safeZone = null;
			
			removeChild(leftDeadZone);
			leftDeadZone.free();
			leftDeadZone = null;
			
			removeChild(rightDeadZone);
			rightDeadZone.free();
			rightDeadZone = null;
			
			removeChild(upDeadZone);
			upDeadZone.free();
			upDeadZone = null;
			
			removeChild(downDeadZone);
			downDeadZone.free();
			downDeadZone = null;
			
			removeChild(dot);
			dot.free();
			dot = null;
			
			camera = null;
			super.free();
		}
		
		public function initialize(camera:SkyCamera):void
		{
			this.camera = camera;
			
			safeZone = new SkyFrame();
			safeZone.create(SkySand.SCREEN_WIDTH, SkySand.SCREEN_HEIGHT, "cameraDebug");
			safeZone.setColor(SkyColor.CARMINE_PINK);
			safeZone.alignToCenter();
			safeZone.thickness = 2;
			safeZone.setAlpha(0.5);
			addChild(safeZone);
			
			leftDeadZone = new SkyShape();
			leftDeadZone.batchName = "cameraDebug";
			leftDeadZone.color = AXIS_LINE_COLOR;
			leftDeadZone.drawRect(0, 0, 2, SkySand.SCREEN_HEIGHT);
			addChild(leftDeadZone);
			
			rightDeadZone = new SkyShape();
			rightDeadZone.batchName = "cameraDebug";
			rightDeadZone.color = AXIS_LINE_COLOR;
			rightDeadZone.drawRect(0, 0, 2, SkySand.SCREEN_HEIGHT);
			addChild(rightDeadZone);
			
			downDeadZone = new SkyShape();
			downDeadZone.batchName = "cameraDebug";
			downDeadZone.color = AXIS_LINE_COLOR;
			downDeadZone.drawRect(0, 0, SkySand.SCREEN_WIDTH, 2);
			addChild(downDeadZone);
			
			upDeadZone = new SkyShape();
			upDeadZone.batchName = "cameraDebug";
			upDeadZone.color = AXIS_LINE_COLOR;
			upDeadZone.drawRect(0, 0, SkySand.SCREEN_WIDTH, 2);
			addChild(upDeadZone);
			
			cameraPostionText = new SkyTextField();
			cameraPostionText.width = 200;
			cameraPostionText.height = 58;
			cameraPostionText.text = "hello";
			addChild(cameraPostionText);
			
			dot = new SkyShape();
			dot.color = SkyColor.CARMINE_PINK;
			dot.drawRect(0, 0, 4, 4);
			addChild(dot);
		}
		
		public function hide():void
		{
			rightDeadZone.visible = false;
			leftDeadZone.visible = false;
			downDeadZone.visible = false;
			upDeadZone.visible = false;
			safeZone.visible = false;
			dot.visible = false;
		}
		
		public function show():void
		{
			rightDeadZone.visible = true;
			leftDeadZone.visible = true;
			downDeadZone.visible = true;
			upDeadZone.visible = true;
			safeZone.visible = true;
			dot.visible = true;
		}
		
		public function update():void
		{
			camera.dampingX = dampingX.value;
			camera.dampingY = dampingY.value;
			camera.setScreenOffset(offsetX.value, offsetY.value);
			camera.deadZoneHeight = deadZoneHeight.value;
			camera.deadZoneWidth = deadZoneWidth.value;
			camera.safeZoneHeight = safeZoneHeight.value;
			camera.safeZoneWidth = safeZoneWidth.value;
			camera.lookAheadDistance = lookAheadDistance.value;
			camera.lookAheadAcseleration = lookAheadAcsel.value;
			
			dot.x = camera.trackingPoint.x;
			dot.y = camera.trackingPoint.y;
			
			safeZone.setSize(camera.safeZoneWidth + 2, camera.safeZoneHeight + 2);
			safeZone.x = camera.screenOffset.x;
			safeZone.y = camera.screenOffset.y;
			
			leftDeadZone.height = SkySand.SCREEN_HEIGHT;
			leftDeadZone.x = camera.screenOffset.x - camera.deadZoneWidth / 2;
			
			rightDeadZone.height = SkySand.SCREEN_HEIGHT;
			rightDeadZone.x = camera.screenOffset.x + camera.deadZoneWidth / 2;
			
			downDeadZone.width = SkySand.SCREEN_WIDTH;
			downDeadZone.y = camera.screenOffset.y + camera.deadZoneHeight / 2;
			
			upDeadZone.width = SkySand.SCREEN_WIDTH;
			upDeadZone.y = camera.screenOffset.y - camera.deadZoneHeight / 2;
		}
	}
}