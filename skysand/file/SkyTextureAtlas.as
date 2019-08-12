package skysand.file 
{
	import flash.display.BitmapData;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.TextureBase;
	import flash.display3D.textures.Texture;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3D;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.filesystem.File;
	import skysand.utils.SkyPictureDecodedData;
	
	import skysand.utils.SkyUtils;
	import skysand.utils.SkyPictureConverter;
	import skysand.file.SkyFilesCache;
	import skysand.render.SkyTexture;
	
	public class SkyTextureAtlas extends Object
	{
		/**
		 * Имя атласа.
		 */
		private var mName:String;
		
		/**
		 * Тестура.
		 */
		private var mTexture:SkyTexture;
		
		/**
		 * Ширина.
		 */
		//private var mWidth:Number;
		
		/**
		 * Высота.
		 */
		//private var mHeight:Number;
		
		/**
		 * Массив с данными о пикселях, для загрузки в текстуру.
		 */
		private var bytes:ByteArray;
		
		/**
		 * Данные о спрайтах из текстурного атласа.
		 */
		private var sprites:Vector.<SkyAtlasSprite>;
		
		/**
		 * Анимации.
		 */
		private var animations:Vector.<SkyAnimationData>;
		
		public function SkyTextureAtlas() 
		{
			mName = "";
			//mWidth = 1;
			//mHeight = 1;
			mTexture = null;
			sprites = new Vector.<SkyAtlasSprite>();
			animations = new Vector.<SkyAnimationData>();
		}
		
		/**
		 * Задать данные о спрайте из атласа.
		 * @param	x левый верхний угол по оси х спрайта на атласе.
		 * @param	y левый верхний угол по оси у спрайта на атласе.
		 * @param	width ширина спрайта.
		 * @param	height высота спрайта.
		 * @param	name имя спрайта.
		 * @param	pivotX осевая точка координаты х.
		 * @param	pivotY осевая точка координаты у.
		 */
		public function setSprite(x:Number, y:Number, width:Number, height:Number, name:String, pivotX:Number = 0, pivotY:Number = 0):void
		{
			var data:SkyAtlasSprite = new SkyAtlasSprite();
			data.x = x;
			data.y = y;
			data.name = name;
			data.width = width;
			data.height = height;
			data.pivotX = pivotX;
			data.pivotY = pivotY;
			data.uvs = new Vector.<Number>(8, true);
			data.uvs[0] = x / mTexture.width;
			data.uvs[1] = y / mTexture.height;
			data.uvs[2] = (x + width) / mTexture.width;
			data.uvs[3] = y / mTexture.height;
			data.uvs[4] = x / mTexture.width;
			data.uvs[5] = (y + height) / mTexture.height;
			data.uvs[6] = (x + width) / mTexture.width;
			data.uvs[7] = (y + height) / mTexture.height;
			
			sprites.push(data);
		}
		
		/**
		 * Добавить данные о спрайте.
		 * @param	sprite ссылка на данные.
		 */
		public function addSprite(sprite:SkyAtlasSprite):void
		{
			if (sprites.indexOf(sprite) < 0) sprites.push(sprite);
		}
		
		public function setMesh(x:Number, y:Number, width:Number, height:Number, name:String):void
		{
			var data:SkyAtlasSprite = new SkyAtlasSprite();
			data.name = name;
			data.pivotX = x;
			data.pivotY = y;
			data.width = width;
			data.height = height;
			
			sprites.push(data);
		}
		
		/**
		 * Создать покадровую анимацию.
		 * @param	name название анимации.
		 * @param	startX начальные координаты по оси x.
		 * @param	startY начальные координаты по оси у.
		 * @param	width ширина ограничивающей рамки одного кадра.
		 * @param	height высота ограничивающей рамки одного кадра.
		 * @param	frameCount число кадров.
		 */
		public function createAnimation(name:String, startX:Number, startY:Number, width:Number, height:Number, frameCount:int):void
		{
			var animation:SkyAnimationData = new SkyAnimationData();
			animation.name = name;
			
			for (var i:int = 0; i < frameCount; i++) 
			{
				var data:SkyAtlasSprite = new SkyAtlasSprite();
				data.name = name + (i + 1).toString();
				data.width = width;
				data.height = height;
				data.pivotX = 0;
				data.pivotY = 0;
				data.uvs[0] = startX / mTexture.width;
				data.uvs[1] = startY / mTexture.height;
				data.uvs[2] = (startX + width) / mTexture.width;
				data.uvs[3] = startY / mTexture.height;
				data.uvs[4] = startX / mTexture.width;
				data.uvs[5] = (startY + height) / mTexture.height;
				data.uvs[6] = (startX + width) / mTexture.width;
				data.uvs[7] = (startY + height) / mTexture.height;
				
				startX += width;
				if (startX + width > mTexture.width) startY += height;
				
				animation.frames.push(data);
			}
			
			animations.push(animation);
		}
		
		/**
		 * Добавить данные анимации.
		 * @param	animation ссылка на данные.
		 */
		public function addAnimation(animation:SkyAnimationData):void
		{
			if (animations.indexOf(animation) < 0) animations.push(animation);
		}
		
		/**
		 * Проверка на наличие анимации в атласе.
		 * @param	name название анимации.
		 * @return true - содержится, false - нет.
		 */
		public function containsAnimation(name:String):Boolean
		{
			var length:int = animations.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				if (animations[i].name == name) return true;
			}
			
			return false;
		}
		
		/**
		 * Задать атлас из битмапдаты.
		 * @param	bitmapData ссылка на битмапдату.
		 * @param	name название атласа.
		 */
		public function loadFromBitmapData(bitmapData:BitmapData, name:String):void
		{	
			bytes = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bitmapData.copyPixelsToByteArray(bitmapData.rect, bytes);
			mName = name;
			
			if (mTexture == null) mTexture = new SkyTexture(bitmapData.width, bitmapData.height);
			mTexture.uploadFromByteArray(bytes);
		}
		
		/**
		 * Загрузить атлас из выбранной директории.
		 * @param	path путь к файлу.
		 * @param	directory директория.
		 */
		public function loadFromDirectory(path:String, directory:uint = 1):void
		{
			loadFromFile(SkyFilesCache.getFile(path, directory));
		}
		
		/**
		 * Загрузить атлас из файла.
		 * @param	file файл с атласом.
		 */
		public function loadFromFile(file:File):void
		{
			var data:SkyPictureDecodedData = SkyPictureConverter.decode(SkyFilesCache.loadBytesFromFile(file));
			loadFromDecodedData(data);
		}
		
		/**
		 * Загрузить атлас из раскодированных данных.
		 * @param	data ссылка на данные.
		 */
		public function loadFromDecodedData(data:SkyPictureDecodedData):void
		{
			if (mTexture == null) mTexture = new SkyTexture(data.textureWidth, data.textureHeight);
			mTexture.uploadFromByteArray(data.textureBytes);
			
			mName = data.name;
			
			if (data.sprites != null)	 sprites 	= sprites.concat(data.sprites);
			if (data.animations != null) animations = animations.concat(data.animations);
		}
		
		/**
		 * Задать текстуру и данные о ней.
		 * @param	texture текстура.
		 * @param	width ширина.
		 * @param	height высота.
		 * @param	name название атласа.
		 */
		public function setTexture(texture:SkyTexture, name:String):void
		{
			if (mTexture != null) mTexture.free();
			
			mTexture = texture;
			mName = name;
		}
		
		/**
		 * Удалить анимацию из атласа.
		 * @param	name имя анимации.
		 */
		public function removeAnimation(name:String):void
		{
			var length:int = animations.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var animation:SkyAnimationData = animations[i];
				
				if (animation.name == name)
				{
					animation.free();
					animations[i] = null;
					animations.removeAt(i);
					return;
				}
			}
		}
		
		/**
		 * Получить анимацию из атласа.
		 * @param	name имя анимации.
		 * @return возвращает данные анимации.
		 */
		public function getAnimation(name:String):SkyAnimationData
		{
			var length:int = animations.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var animation:SkyAnimationData = animations[i];
				
				if (animation.name == name)
				{
					return animation;
				}
			}
			
			return null;
		}
		
		/**
		 * Получить анимацию по его номеру.
		 * @param	index номер спрайта в списке.
		 * @return возвращает данные о спрайте.
		 */
		public function getAnimationByIndex(index:int):SkyAnimationData
		{
			return animations[index];
		}
		
		/**
		 * Удалить спрайт.
		 * @param	name имя спрайта.
		 */
		public function removeSprite(name:String):void
		{
			if (texture == null || sprites.length == 0) return;
			
			var length:int = sprites.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var data:SkyAtlasSprite = sprites[i];
				
				if (data.name == name)
				{
					data.uvs.fixed = false;
					data.uvs.length = 0;
					data.uvs = null;
					sprites.removeAt(i);
					return;
				}
			}
		}
		
		/**
		 * Получить данные о спрайте по его имени.
		 * @param	name имя спрайта.
		 * @return возвращает данные о спрайте.
		 */
		public function getSprite(name:String):SkyAtlasSprite
		{
			if (texture == null || sprites.length == 0) return null;
			
			var length:int = sprites.length;
			
			for (var i:int = 0; i < length; i++) 
			{
				var data:SkyAtlasSprite = sprites[i];
				
				if (data.name == name)
				{
					return data;
				}
			}
			
			throw new Error("Sprite with name \"" + name + "\" is missing!");
			
			return null;
		}
		
		/**
		 * Получить спрайт по его номеру.
		 * @param	index номер спрайта в списке.
		 * @return возвращает данные о спрайте.
		 */
		public function getSpriteByIndex(index:int):SkyAtlasSprite
		{
			return sprites[index];
		}
		
		/**
		 * Освободить память.
		 */
		public function free():void
		{
			mTexture.free();
			mTexture = null;
			
			bytes.clear();
			bytes = null;
			
			for (var i:int = 0; i < sprites.length; i++) 
			{
				sprites[i].uvs.length = 0;
				sprites[i].uvs = null;
				sprites[i] = null;
			}
			
			sprites.length = 0;
			sprites = null;
			
			for (i = 0; i < animations.length; i++) 
			{
				var anim:SkyAnimationData = animations[i];
				
				for (var j:int = 0; j < anim.frames.length; j++) 
				{
					anim.frames[j].uvs.length = 0;
					anim.frames[j].uvs = null;
				}
				
				anim.frames.length = 0;
				anim = null;
			}
			
			animations.length = 0;
			animations = null;
		}
		
		/**
		 * Получить текстуру.
		 */
		public function get texture():SkyTexture
		{
			return mTexture;
		}
		
		/**
		 * Количество спрайтов в атласе.
		 */
		public function get spriteCount():int
		{
			return sprites.length;
		}
		
		/**
		 * Количество анимаций в атласе.
		 */
		public function get animationsCount():int
		{
			return animations.length;
		}
		
		/**
		 * Получить ширину текстуры.
		 */
		public function get width():Number
		{
			return mTexture.width;
		}
		
		/**
		 * Получить высоту текстуры.
		 */
		public function get height():Number
		{
			return mTexture.height;
		}
		
		/**
		 * Имя атласа.
		 */
		public function get name():String
		{
			return mName;
		}
		
		/**
		 * Имя атласа.
		 */
		public function set name(value:String):void
		{
			mName = value;
		}
	}
}