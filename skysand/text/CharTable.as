package skysand.text 
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.system.System;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	public class CharTable extends Object
	{
		/**
		 * Количество символов.
		 */
		public static const CHAR_NUMBER:uint = 160;
		
		/**
		 * Массив символов.
		 */
		private var chars:Vector.<Char>;
		
		/**
		 * Строка с символами нужными для растеризации.
		 */
		private var string:String = "";
		
		/**
		 * Текстовое поле для растеризации символов.
		 */
		private var textField:TextField;
		
		/**
		 * Матрица трансформации.
		 */
		private var matrix:Matrix;
		
		private var textFormat:TextFormat;
		
		public function CharTable() 
		{
			chars = new Vector.<Char>(CharTable.CHAR_NUMBER, true);
			
			fillCharacterInString();
			
			textField = new TextField();
			//textField.create(0xFFFFFF);
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.thickness = 200;
			textField.autoSize = TextFieldAutoSize.LEFT;
			//textField.wordWrap = true;
			
			matrix = new Matrix();
			
			for (var i:int = 0; i < CharTable.CHAR_NUMBER; i++) 
			{
				chars[i] = charToBitmapData(string.charAt(i), i);
			}
			
			chars.sort(compare);
			
			textFormat = new TextFormat();
		}
		
		public function transformColor(color:uint):void
		{
			textFormat.color = color;
			textField.defaultTextFormat = textFormat;
			
			for (var i:int = 0; i < CharTable.CHAR_NUMBER; i++) 
			{
				var char:Char = chars[i];
				char.data.dispose();
				char.data = drawCharBitmapData(string.charAt(i));
			}
			
			chars.sort(compare);
		}
		
		public function set font(value:String):void
		{
			textFormat.font = value;
			textField.defaultTextFormat = textFormat;
			
			for (var i:int = 0; i < CharTable.CHAR_NUMBER; i++) 
			{
				var char:Char = chars[i];
				
				char.data.dispose();
				
				char.data = drawCharBitmapData(string.charAt(i));
			}	
		}
		
		public function set bold(value:int):void
		{
			textFormat.bold = value;
			textField.defaultTextFormat = textFormat;
			
			for (var i:int = 0; i < CharTable.CHAR_NUMBER; i++) 
			{
				var char:Char = chars[i];
				
				char.data.dispose();
				
				char.data = drawCharBitmapData(string.charAt(i));
			}	
		}
		
		public function set italic(value:Boolean):void
		{
			textFormat.italic = value;
			textField.defaultTextFormat = textFormat;
			
			for (var i:int = 0; i < CharTable.CHAR_NUMBER; i++)
			{
				var char:Char = chars[i];
				
				char.data.dispose();
				
				char.data = drawCharBitmapData(string.charAt(i));
			}	
		}
		
		public function set size(value:int):void
		{
			textFormat.size = value;
			textField.defaultTextFormat = textFormat;
			
			for (var i:int = 0; i < CharTable.CHAR_NUMBER; i++)
			{
				var char:Char = chars[i];
				
				char.data.dispose();
				
				char.data = drawCharBitmapData(string.charAt(i));
			}	
		}
		
		/**
		 * Получить BitmapData символа.
		 * @param	_charCode код символа.
		 * @return возвращает BitmapData.
		 */
		public function getChar(charCode:Number):BitmapData
		{
			var i:int = 0;
			
			if (charCode <= 33)
			{
				i = charCode - 32;
			}
			else if (charCode <= 91)
			{
				i = charCode - 33;
			}
			else if (charCode <= 126)
			{
				i = charCode - 34;
			}
			else if (charCode == 1025)
			{
				i = 93;
			}
			else if (charCode <= 1103)
			{
				i = charCode - 946;
			}
			else if (charCode == 1105)
			{
				i = 158;
			}
			else if (charCode == 8470)
			{
				i = 159;
			}
			
			if (i < 0) return null;
			
			return chars[i].data;
		}
		
		private function compare(a:Char, b:Char):Number
		{
			return a.id > b.id ? 1 : a.id < b.id ? -1 : 0;
		}
		
		private function charToBitmapData(_char:String, index:int):Char
		{
			textField.text = _char;
			var bitmapData:BitmapData = new BitmapData(textField.width - 4, textField.height, true, 0x000000);
			matrix.translate(textField.x - 2, textField.y);
			bitmapData.draw(textField, matrix);
			
			var char:Char = new Char();
			char.data = bitmapData;
			char.id = _char.charCodeAt(0);
			
			matrix.identity();
			
			return char;
		}
		
		public function drawCharBitmapData(_char:String):BitmapData
		{
			textField.text = _char;
			
			var bitmapData:BitmapData = new BitmapData(textField.width - 4, textField.height, true, 0x000000);
			matrix.translate(textField.x - 2, textField.y);
			bitmapData.draw(textField, matrix);
			
			matrix.identity();
			
			return bitmapData;
		}
		
		/**
		 * Заполнить строку символами.
		 */
		private function fillCharacterInString():void
		{
			string = " !#$%&'()*+,-./";
			string += "0123456789";
			string += ":;<=>?@";
			string += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			string += "[]^_`";
			string += "abcdefghijklmnopqrstuvwxyz";
			string += "{|}~";
			string += "ЁАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
			string += "абвгдежзийклмнопрстуфхцчшщъыьэюяё";
			string += '№';
		}
	}
}