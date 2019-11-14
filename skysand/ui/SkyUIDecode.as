package skysand.ui 
{
	import flash.utils.ByteArray;
	import skysand.text.SkyBitmapText;
	import skysand.text.SkyTextField;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyUIDecode extends Object
	{
		
		public function SkyUIDecode() 
		{
			
		}
		
		public static function getBitmapText(bytes:ByteArray):SkyBitmapText
		{
			var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var angle:Number = bytes.readInt();
			var alpha:Number = bytes.readFloat();
			var background:Boolean = bytes.readBoolean();
			var isPassword:Boolean = bytes.readBoolean();
			var textColor:uint = bytes.readUnsignedInt();
			var backgroundColor:uint = bytes.readUnsignedInt();
			var text:String = bytes.readUTF();
			var fontName:String = bytes.readUTF();
			var maxChars:int = bytes.readInt();
			var spacing:Number = bytes.readInt();
			
			var textField:SkyBitmapText = new SkyBitmapText();
			textField.setAtlasFromCache(fontName);
			textField.text = text;
			textField.background = background;
			textField.textColor = textColor;
			textField.backgroundColor = backgroundColor;
			textField.maxChars = maxChars != -1 ? maxChars : -1;
			textField.letterSpacing = spacing;
			textField.displayAsPassword = isPassword;
			textField.name = name;
			textField.setBackgroundSize(width, height);
			textField.alpha = alpha;
			textField.rotation = angle;
			textField.x = x;
			textField.y = y;
			
			return textField;
		}
		
		public static function getButton(bytes:ByteArray):SkyButton
		{
			var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var angle:Number = bytes.readInt();
			var alpha:Number = bytes.readFloat();
			var form:uint = bytes.readByte();
			var isBitmapFont:Boolean = bytes.readBoolean();
			var volume:Boolean = bytes.readBoolean();
			var color:uint = bytes.readUnsignedInt();
			var textColor:uint = bytes.readUnsignedInt();
			var fontSize:Number = bytes.readInt();
			var font:String = bytes.readUTF();
			var bitmapFont:String = bytes.readUTF();
			var text:String = bytes.readUTF();
			
			var button:SkyButton = new SkyButton();
			button.create(form, width, height, color, null, volume);
			button.setAlpha(alpha);
			button.rotation = angle;
			button.name = name;
			button.x = x;
			button.y = y;
			
			if (text != "")
			{
				if (isBitmapFont) button.addBitmapText(bitmapFont, text, textColor);
				else button.addText(text, font, textColor, fontSize); 
			}
			
			return button;
		}
		
		public static function getCheckBox(bytes:ByteArray):SkyCheckBox
		{
			var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var angle:Number = bytes.readInt();
			var alpha:Number = bytes.readFloat();
			var backgroundColor:uint = bytes.readUnsignedInt();
			var iconColor:uint = bytes.readUnsignedInt();
			var isActive:Boolean = bytes.readBoolean();
			var isFrameForm:Boolean = bytes.readBoolean();
			
			var box:SkyCheckBox = new SkyCheckBox();
			box.create(1, backgroundColor, iconColor, null, isFrameForm, width);
			box.active = isActive;
			box.name = name;
			box.x = x;
			box.y = y;
			box.setAlpha(alpha);
			box.rotation = angle;
			
			return box;
		}
		
		public static function getProgressBar(bytes:ByteArray):SkyProgressBar
		{/*
			name = bytes.readUTF()
			width = bytes.readInt();
			height = bytes.readInt();
			x = bytes.readInt();
			y = bytes.readInt();
			angle = bytes.readInt();
			alpha = bytes.readInt() * 100;
			barColor = bytes.readUnsignedInt();
			backgroundColor = bytes.readUnsignedInt();
			isCircleBar = bytes.readBoolean();
			progress = bytes.readInt();
			
			/*var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var text:String = bytes.readUTF();
			var fontSize:Number = bytes.readInt();
			var volume:Boolean = bytes.readBoolean();
			var font:String = bytes.readUTF();
			var form:uint = bytes.readInt();
			var color:uint = bytes.readUnsignedInt();
			var textColor:uint = bytes.readUnsignedInt();
			
			button = new SkyButton();
			button.create(form, width, height, color, null, volume);
			
			if (text != "")
			{
				button.addText(text, font, textColor, fontSize); 
			}
			
			return button;*/
			return null;
		}
		
		public static function getSlider(bytes:ByteArray):SkySlider
		{
			/*
			name = bytes.readUTF();
			width = bytes.readInt();
			height = bytes.readInt();
			x = bytes.readInt();
			y = bytes.readInt();
			angle = bytes.readInt();
			alpha = bytes.readInt() * 100;
			sliderSize = bytes.readInt();
			verticalOrientation = bytes.readBoolean();
			buttonColor = bytes.readUnsignedInt();
			backgroundColor	= bytes.readUnsignedInt();
			
			
			/*var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var text:String = bytes.readUTF();
			var fontSize:Number = bytes.readInt();
			var volume:Boolean = bytes.readBoolean();
			var font:String = bytes.readUTF();
			var form:uint = bytes.readInt();
			var color:uint = bytes.readUnsignedInt();
			var textColor:uint = bytes.readUnsignedInt();
			
			button = new SkyButton();
			button.create(form, width, height, color, null, volume);
			
			if (text != "")
			{
				button.addText(text, font, textColor, fontSize); 
			}
			
			return button;*/
			return null;
		}
		
		public static function getToggleButton(bytes:ByteArray):SkyToggleButton
		{
			/*
			name = bytes.readUTF();
			width = bytes.readInt();
			height = bytes.readInt();
			x = bytes.readInt();
			y = bytes.readInt();
			angle = bytes.readInt();
			alpha = bytes.readInt() * 100;
			isActive = bytes.readBoolean();
			addFill = bytes.readBoolean();
			isIcon = bytes.readBoolean();
			onColor = bytes.readUnsignedInt();
			offColor = bytes.readUnsignedInt();
			buttonColor = bytes.readUnsignedInt();
			backgroundColor = bytes.readUnsignedInt();
			fontSize = bytes.readInt();
			font = bytes.readUTF();
			
			button = new SkyToggleButton();
			button.create(1, backgroundColor, buttonColor, isIcon);
			button.setActive(isActive);
			button.setSize(width);
			button.setColors(buttonColor, backgroundColor, onColor, offColor);
			if (addFill) button.addFill(onColor, offColor);
			button.setFont(font, fontSize);
			addChild(button);
			
			/*var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var text:String = bytes.readUTF();
			var fontSize:Number = bytes.readInt();
			var volume:Boolean = bytes.readBoolean();
			var font:String = bytes.readUTF();
			var form:uint = bytes.readInt();
			var color:uint = bytes.readUnsignedInt();
			var textColor:uint = bytes.readUnsignedInt();
			
			button = new SkyButton();
			button.create(form, width, height, color, null, volume);
			
			if (text != "")
			{
				button.addText(text, font, textColor, fontSize); 
			}
			
			return button;*/
			
			return null;
		}
		
		public static function getList(bytes:ByteArray):SkyList
		{
			/*
			 * name = bytes.readUTF();
			width = bytes.readInt();
			height = bytes.readInt();
			x = bytes.readInt();
			y = bytes.readInt();
			angle = bytes.readInt();
			alpha = bytes.readInt() * 100;
			visibleCount = bytes.readInt();
			itemHeight = bytes.readInt();
			fontSize = bytes.readInt();
			isBitmapFont = bytes.readBoolean();
			autoVisible = bytes.readBoolean();
			color = bytes.readUnsignedInt();
			buttonColor = bytes.readUnsignedInt();
			textColor = bytes.readUnsignedInt();
			backgroundColor = bytes.readUnsignedInt();
			fontName = bytes.readUTF();
			font = bytes.readUTF();
			this.items = bytes.readUTF();
			*/
			var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var visibleCount:int = bytes.readInt();
			var itemHeight:int = bytes.readInt();
			var autoVisible:Boolean = bytes.readBoolean();
			var color:uint = bytes.readUnsignedInt();
			var buttonColor:uint = bytes.readUnsignedInt();
			var textColor:uint = bytes.readUnsignedInt();
			var backgroundColor:uint = bytes.readUnsignedInt();
			var fontSize:Number = bytes.readInt();
			var font:String = bytes.readUTF();
			var names:String = bytes.readUTF();
			
			var list:SkyList = new SkyList();
			list.create(width, itemHeight, color, visibleCount, textColor, font, autoVisible);
			list.setSliderColors(buttonColor, backgroundColor);
			list.name = name;
			list.x = x;
			list.y = y;
			
			var items:Array = names.split(", ");
			
			for (var i:int = 0; i < items.length; i++) 
			{
				list.addItem(items[i], null);
			}
			
			return list
		}
		
		public static function getDropDownList(bytes:ByteArray):SkyDropDownList
		{
			var name:String = bytes.readUTF();
			var width:int = bytes.readInt();
			var height:int = bytes.readInt();
			var x:int = bytes.readInt();
			var y:int = bytes.readInt();
			var angle:int = bytes.readInt();
			var alpha:Number = bytes.readFloat();
			var textColor:uint = bytes.readUnsignedInt();
			var buttonColor:uint = bytes.readUnsignedInt();
			var addArrow:Boolean = bytes.readBoolean();
			var autoOpen:Boolean = bytes.readBoolean();
			var splitList:Boolean = bytes.readBoolean();
			var splitButton:Boolean = bytes.readBoolean();
			var isBitmapFont:Boolean = bytes.readBoolean();
			var fontSize:int = bytes.readInt();
			var font:String = bytes.readUTF();
			var fontName:String = bytes.readUTF();
			var text:String = bytes.readUTF();
			
			var menu:SkyDropDownList = new SkyDropDownList();
			menu.create(SkyUI.RECTANGLE, width, height, buttonColor, !autoOpen, splitButton, splitList, addArrow);
			//menu.setColor(buttonColor, textColor, textColor);
			menu.setAlpha(alpha);
			menu.name = name;
			menu.rotation = angle;
			menu.x = x;
			menu.y = y;
			
			if (isBitmapFont) menu.addBitmapText(fontName, text, textColor);
			else menu.addText(text, font, textColor, fontSize);
			
			return menu;
		}
		
		public static function getTextField(bytes:ByteArray):SkyTextField
		{
			var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var angle:Number = bytes.readInt();
			var alpha:Number = bytes.readFloat();
			var isInput:Boolean = bytes.readBoolean();
			var autoSize:Boolean = bytes.readBoolean();
			var displayAsPassword:Boolean = bytes.readBoolean();
			var background:Boolean = bytes.readBoolean();
			var backgroundColor:uint = bytes.readUnsignedInt();
			var textColor:uint = bytes.readUnsignedInt();
			var maxChars:Number = bytes.readInt();
			var fontSize:Number = bytes.readInt();
			var restrict:String = bytes.readUTF();
			var font:String = bytes.readUTF();
			var text:String = bytes.readUTF();
			
			var textField:SkyTextField = new SkyTextField();
			textField.displayAsPassword = displayAsPassword;
			textField.background = background;
			textField.backgroundColor = backgroundColor
			textField.textColor = textColor;
			textField.size = fontSize;
			textField.restrict = restrict == "" ? null : restrict;
			textField.maxChars = maxChars;
			textField.font = font;
			textField.embedFonts = true;
			textField.text = text;
			textField.height = height;
			textField.width = width;
			textField.type = isInput ? "input" : "dynamic";
			textField.autoSize = autoSize ? "left" : "none";
			textField.name = name;
			textField.x = x;
			textField.y = y;
			textField.alpha = alpha;
			textField.rotation = angle;
			
			return textField;
		}
		
		public static function getInputNumber(bytes:ByteArray):SkyInputNumber
		{
			var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var angle:Number = bytes.readInt();
			var alpha:Number = bytes.readFloat();
			var value:Number = bytes.readFloat()
			var min:Number = bytes.readFloat();
			var max:Number = bytes.readFloat();
			var step:Number = bytes.readFloat();
			var textColor:uint = bytes.readUnsignedInt();
			var arrowColor:uint = bytes.readUnsignedInt();
			var buttonColor:uint = bytes.readUnsignedInt();
			var backgroundColor:uint = bytes.readUnsignedInt();
			var font:String = bytes.readUTF();
			var fontSize:Number = bytes.readInt();
			
			var input:SkyInputNumber = new SkyInputNumber();
			input.create(width, height);
			input.setFont(fontSize, font);
			input.setColors(backgroundColor, textColor, arrowColor, buttonColor);
			input.setAlpha(alpha);
			input.step = step;
			input.min = min;
			input.max = max;
			input.value = value;
			input.name = name;
			input.x = x;
			input.y = y;
			input.rotation = angle;
			
			return input;
		}
		
		public static function getInputColor(bytes:ByteArray):SkyInputColor
		{
			var name:String = bytes.readUTF();
			var width:Number = bytes.readInt();
			var height:Number = bytes.readInt();
			var x:Number = bytes.readInt();
			var y:Number = bytes.readInt();
			var angle:Number = bytes.readInt();
			var alpha:Number = bytes.readFloat();
			var textColor:uint = bytes.readUnsignedInt();
			var backgroundColor:uint = bytes.readUnsignedInt();
			var fontSize:Number = bytes.readInt();
			var font:String = bytes.readUTF();
			
			var inputColor:SkyInputColor = new SkyInputColor();
			inputColor.create(width, height, textColor, backgroundColor, font, fontSize);
			inputColor.setAlpha(alpha);
			inputColor.rotation = angle;
			inputColor.name = name;
			inputColor.x = x;
			inputColor.y = y;
			
			return inputColor;
		}
	}
}