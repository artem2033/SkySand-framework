package skysand.text 
{
	import flash.events.FileListEvent;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import skysand.file.SkyTextureAtlas;
	import skysand.utils.SkyPictureConverter;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyFontGenerator
	{
		/**
		 * Массив символов верхнего регистра.
		 */
		private var uppercase:Vector.<String>;
		
		/**
		 * Строка для генерации класса.
		 */
		private var string:String;
		
		/**
		 * Файл для сохранения класса.
		 */
		private var file:File;
		
		/**
		 * Текстовое поле для отрисовки символов.
		 */
		private var textField:TextField;
		
		/**
		 * Битмапа, в которую рисуются символы.
		 */
		private var bitmapData:BitmapData;
		
		/**
		 * Матрица трансформации.
		 */
		private var matrix:Matrix;
		
		/**
		 * Формат текстового поля.
		 */
		private var format:TextFormat;
		
		/**
		 * Символы для отрисовки.
		 */
		private var chars:String;
		
		/**
		 * Итоговый массив байтов с текстурой шрифта.
		 */
		private var bytes:ByteArray;
		
		public function SkyFontGenerator() 
		{
			uppercase = new Vector.<String>();
			uppercase.push("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
			uppercase.fixed = true;
			
			chars = " !\"#$%&'()*+,-./";
			chars += "0123456789";
			chars += ":;<=>?@";
			chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			chars += "[\\]^_`";
			chars += "abcdefghijklmnopqrstuvwxyz";
			chars += "{|}~";
			chars += "ЁАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
			chars += "абвгдежзийклмнопрстуфхцчшщъыьэюяё";
			chars += "№";
			
			bytes = new ByteArray();
			matrix = new Matrix();
		}
		
		/**
		 * Сохранить текстуру с шрифтом на жёсткий диск.
		 */
		public function saveTextureFont():void
		{
			file = File.createTempFile();
			file.save(bytes, "font.sta");
		}
		
		/**
		 * Создать sta текстуру с шрифтом и данными о символах.
		 * @param	font шрифт.
		 * @param	fontSize размер шрифта.
		 * @return возвращает получившуюся текстуру в виде байтового массива.
		 */
		public function createTexture(font:String, fontSize:Number, embedFonts:Boolean = true):ByteArray
		{
			format = new TextFormat();
			format.font = font;
			format.size = fontSize;
			
			textField = new TextField();
			textField.embedFonts = embedFonts;
			textField.defaultTextFormat = format;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.textColor = 0xFFFFFF;
			textField.text = "A";
			
			var maxHeight:int = Math.ceil(10 * textField.height);
			var count:int = 0;
			
			while (maxHeight >= 1)
			{
				maxHeight /= 2;
				count++;
			}
			//count++;
			
			var size:int = 2 << count - 1;
			var bitmapData:BitmapData = new BitmapData(size, size, true, 0x0);
			
			count = 0;
			bytes.clear();
			matrix.identity();
			
			for (var i:int = 0; i < chars.length; i++) 
			{
				textField.text = chars.charAt(i);
				var w:int = Math.round(textField.width) + 2;
				var h:int = Math.round(textField.height);
				
				bytes.writeUTF(textField.text);
				bytes.writeInt(matrix.tx);
				bytes.writeInt(matrix.ty);
				bytes.writeInt(w - 1);
				bytes.writeInt(h);
				
				if (textField.text == ' ' || textField.text == '\t') continue;
				
				bitmapData.drawWithQuality(textField, matrix);
				matrix.translate(w, 0);
				count++;
				
				if (count == 16)
				{
					count = 0;
					matrix.tx = 0;
					matrix.translate(0, h);
				}
			}
			
			var name:String = font + (fontSize < 10 ? "0" + fontSize.toString() : fontSize.toString());
			
			var converter:SkyPictureConverter = new SkyPictureConverter();
			bytes = converter.convert(bitmapData, name, bytes);
			bitmapData.dispose();
			
			return bytes;
		}
		
		/**
		 * Сгенерировать класс as3 с выбранными шрифтами.
		 */
		public function createClass():void
		{
			file = new File();
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, opened);
			file.browseForOpenMultiple("Select fonts", [new FileFilter("Fonts", "*.ttf;*.otf;")]);
		}
		
		/**
		 * Генерирует класс as3 с выбранными шрифтами.
		 * @param	event событие открытия нескольких файлов.
		 */
		private function opened(event:FileListEvent):void
		{
			file.removeEventListener(FileListEvent.SELECT_MULTIPLE, opened);
			
			var names:Vector.<String> = new Vector.<String>();
			
			string = "";
			string += "package skysand.text\n";
			string += "{\n";
			string += "\timport flash.text.Font;\n\n"
			string += "\tpublic class SkyFont\n"
			string += "\t{\n";
			
			for (var i:int = 0; i < event.files.length; i++) 
			{
				var name:String = event.files[i].name;
				
				string += "\t\t[Embed(source = \"fonts/";
				string += name;
				string += "\", fontName = \"";
				
				name = name.split(".")[0];
				names.push(name);
				
				string += name;
				string += "\", embedAsCFF = \"false\")]\n";
				string += "\t\tprivate static var ";
				string += name + "Font:Class;\n\t\t\n";
			}
			
			for (i = 0; i < names.length; i++) 
			{
				string += "\t\tpublic static const ";
				
				var result:String = "";
				name = names[i];
				
				for (var j:int = 0; j < name.length; j++) 
				{
					if (isUppercase(name.charAt(j))) result += "_";
					
					result += name.charAt(j).toUpperCase();
				}
				
				string += result + ":String = \"";
				string += names[i] + "\";\n";
			}
			
			string += "\t\t\n\t\tprivate static var mFonts:Vector.<String> = new Vector.<String>();\n";
			string += "\t\t\n\t\tpublic function SkyFont()\n";
			string += "\t\t{\n";
			string += "\t\t}\n\t\t\n";
			string += "\t\t/**\n";
			string += "\t\t * Добавить шрифты.\n";
			string += "\t\t */\n";
			string += "\t\tpublic static function register():void\n";
			string += "\t\t{\n";
			
			for (i = 0; i < names.length; i++) 
			{
				string += "\t\t\tFont.registerFont(";
				string += names[i] + "Font";
				string += ");\n";
			}
			
			string += "\t\t\t\n";
			
			for (i = 0; i < names.length; i++) 
			{
				string += "\t\t\tmFonts.push(\"";
				string += names[i];
				string += "\");\n";
			}
			
			string += "\t\t}\n\t\t\n";
			string += "\t\t/**\n";
			string += "\t\t * Получить названия шрифтов.\n";
			string += "\t\t */\n";
			string += "\t\tpublic static function get fonts():Vector.<String>\n";
			string += "\t\t{\n";
			string += "\t\t\treturn mFonts;\n";
			string += "\t\t}\n";
			string += "\t}\n";
			string += "}\n";
			
			file.save(string, "SkyFont.as");
		}
		
		/**
		 * Проверка на то является ли символ заглавным.
		 * @param	char символ для проверки.
		 * @return возвращает true - является, false - нет.
		 */
		private function isUppercase(char:String):Boolean
		{
			for (var i:int = 0; i < 26; i++) 
			{
				if (uppercase[i] == char)
				{
					return true;
				}
			}
			
			return false;
		}
	}
}