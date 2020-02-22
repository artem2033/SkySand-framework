package skysand.render.shaders 
{
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyShader 
	{
		private var string:String = "";
		protected var vertex:String = "";
		protected var pixel:String = "";
		
		/**
		 * Пиксельные регистры. 
		 */
		private var mFragmentConst:SkyRegister;
		private var mFragmentOuputColor:SkyRegister;
		private var mFragmentTemporary:SkyRegister;
		private var mFragmentSampler:SkyRegister;
		private var mFragmentOutput:SkyRegister;
		private var mInstanceID:SkyRegister;
		
		/**
		 * Вершинные регистры. 
		 */
		private var mVertexAttribute:SkyRegister;
		private var mVertexConst:SkyRegister;
		private var mVertexTemporary:SkyRegister;
		private var mVertexOutput:SkyRegister;
		private var mVertexVarying:SkyRegister;
		private var mVertexSampler:SkyRegister;
		
		protected var assembler:AGALMiniAssembler;
		
		public function SkyShader() 
		{
			mInstanceID = new SkyRegister("iid");
			
			mVertexConst = new SkyRegister("vc");
			mVertexOutput = new SkyRegister("op");
			mVertexVarying = new SkyRegister("v");
			mVertexSampler = new SkyRegister("vs");
			mVertexTemporary = new SkyRegister("vt");
			mVertexAttribute = new SkyRegister("va");
			
			mFragmentConst = new SkyRegister("fc");
			mFragmentOutput = new SkyRegister("fo");
			mFragmentSampler = new SkyRegister("fs");
			mFragmentTemporary = new SkyRegister("ft");
			mFragmentOuputColor = new SkyRegister("oc");
			
			assembler = new AGALMiniAssembler();
		}
		
		/**
		 * Очистить записанную в строку программу.
		 */
		public function clear():void
		{
			string = "";
		}
		
		/**
		 * Копирует текущий написанный шейдер в пиксельный.
		 */
		public function setAsPixel():void
		{
			pixel = string;
			string = "";
		}
		
		/**
		 * Копирует текущий написанный шейдер в вершинный.
		 */
		public function setAsVertex():void
		{
			vertex = string;
			string = "";
		}
		
		/**
		 * Собрать шейдерную программу.
		 */
		public function compile(version:int):Program3D
		{
			return assembler.assemble2(SkySand.CONTEXT_3D, version, vertex, pixel);
		}
		
		/**
		 * Получить результат в виде строки.
		 */
		public function get toString():String
		{
			return string;
		}
		
		/**
		 * Преобразовать в строку.
		 * @param	value строка или регистр.
		 * @return возвращает строку.
		 */
		private function getString(value:*):String
		{
			return value is String ? value : SkyRegister(value).name;
		}
		
		/**
		 * Копирует данные из source в dest, покомпонентно.
		 * dest = source.
		 */
		public function mov(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "mov " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, cуммирует значения sourceA и sourceB, сохроняя в dest.
		 * dest = sourceA + sourceB.
		 */
		public function add(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "add " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, вычитает значения sourceB из sourceA, сохроняя в dest.
		 * dest = sourceA - sourceB.
		 */
		public function sub(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "sub " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, умножает значения sourceA и sourceB, сохроняя в dest.
		 * dest = sourceA * sourceB.
		 */
		public function mul(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "mul " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, делит значения sourceA на sourceB, сохроняя в dest.
		 * dest = sourceA / sourceB.
		 */
		public function div(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "div " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно делит 1 на source, сохроняя в dest, покомпонентно.
		 * dest = 1 / source.
		 */
		public function rcp(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "rcp " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, сравнивает значения sourceA и sourceB, сохроняя в dest минимальное.
		 * dest = minimum(sourceA, sourceB).
		 */
		public function min(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "min " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, сравнивает значения sourceA и sourceB, сохроняя в dest максимальное.
		 * dest = maximum(sourceA, sourceB).
		 */
		public function max(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "max " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, сохраняет в dest дробную часть от source.
		 * dest = source - (float)floor(source).
		 */
		public function frc(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "frc " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, берёт квадратный корень от source, сохроняя в dest.
		 * dest = sqrt(source).
		 */
		public function sqt(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "sqt " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, берёт обратный квадратный корень от source, сохроняя в dest.
		 * dest = 1/sqrt(source).
		 */
		public function rsq(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "rsq " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, возводит sourceA в степень sourceB, сохроняя в dest.
		 * dest = pow(sourceA, sourceB).
		 */
		public function pow(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "pow " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, берёт логарифм от source, сохроняя в dest.
		 * dest = log_2(source).
		 */
		public function log(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "log " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, возводит 2 в степень source и сохроняет в dest.
		 * dest = 2^source.
		 */
		public function exp(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "exp " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, нормализует значения source, сохроняя в dest.
		 * (возвращает значения только для 3 компонент, dest должно использовать маску .xyz или меньше)
		 * dest = normalize(source).
		 */
		public function nrm(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "nrm " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, берёт синус от source, сохроняя в dest.
		 * dest = sin(source).
		 */
		public function sin(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "sin " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, берёт косинус от source, сохроняя в dest.
		 * dest = cos(source).
		 */
		public function cos(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "cos " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, вычисляет векторное произведение между sourceA и sourceB, сохроняя dest.
		 * (возвращает значения только для 3 компонент, dest должно использовать маску .xyz или меньше)
		 * dest.x = sourceA.y * sourceB.z - sourceA.z * sourceB.y
		 * dest.y = sourceA.z * sourceB.x - sourceA.x * sourceB.z
		 * dest.z = sourceA.x * sourceB.y - sourceA.y * sourceB.x.
		 */
		public function crs(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "crs " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Вычисляет скалярное произведение векторов sourceA и sourceB для 3 компонент, сохроняя в dest.
		 * dest = sourceA.x * sourceB.x + sourceA.y * sourceB.y + sourceA.z * sourceB.z.
		 */
		public function dp3(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "dp3 " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Вычисляет скалярное произведение векторов sourceA и sourceB для 4 компонент, сохроняя в dest.
		 * dest = sourceA.x * sourceB.x + sourceA.y * sourceB.y + sourceA.z * sourceB.z + sourceA.w * sourceB.w.
		 */
		public function dp4(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "dp4 " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, вычисляет абсолютные значения source, сохроняя в dest.
		 * dest = abs(source).
		 */
		public function abs(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "abs " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, меняет знаки source, сохроняя в dest.
		 * dest = -source.
		 */
		public function neg(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "neg " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, возвращает значение в интервале от 0 до 1 для source, сохроняя в dest.
		 * dest = maximum(minimum(source, 1) ,0).
		 */
		public function sat(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "sat " + dest + ", " + source + " \n";
		}
		
		/**
		 * Покомпонентно, умножает матрицу 3х3 sourceB на вектор sourceA, cохроняя в dest.
		 * (возвращает значения только для 3 компонент, dest должно использовать маску .xyz или меньше)
		 * dest.x = (sourceA.x * sourceB[0].x) + (sourceA.y * sourceB[0].y) + (sourceA.z * sourceB[0].z).
		 * dest.y = (sourceA.x * sourceB[1].x) + (sourceA.y * sourceB[1].y) + (sourceA.z * sourceB[1].z).
		 * dest.z = (sourceA.x * sourceB[2].x) + (sourceA.y * sourceB[2].y) + (sourceA.z * sourceB[2].z).
		 */
		public function m33(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "m33 " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, умножает матрицу 4х4 sourceB на вектор sourceA, cохроняя в dest.
		 * dest.x = (sourceA.x * sourceB[0].x) + (sourceA.y * sourceB[0].y) + (sourceA.z * sourceB[0].z) + (sourceA.w * sourceB[0].w).
		 * dest.y = (sourceA.x * sourceB[1].x) + (sourceA.y * sourceB[1].y) + (sourceA.z * sourceB[1].z) + (sourceA.w * sourceB[1].w).
		 * dest.z = (sourceA.x * sourceB[2].x) + (sourceA.y * sourceB[2].y) + (sourceA.z * sourceB[2].z) + (sourceA.w * sourceB[2].w).
		 * dest.w = (sourceA.x * sourceB[3].x) + (sourceA.y * sourceB[3].y) + (sourceA.z * sourceB[3].z) + (sourceA.w * sourceB[3].w).
		 */
		public function m44(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "m44 " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, умножает матрицу 3х4 sourceB на вектор sourceA, cохроняя в dest.
		 * (возвращает значения только для 3 компонент, dest должно использовать маску .xyz или меньше)
		 * dest.x = (sourceA.x * sourceB[0].x) + (sourceA.y * sourceB[0].y) + (sourceA.z * sourceB[0].z) + (sourceA.w * sourceB[0].w).
		 * dest.y = (sourceA.x * sourceB[1].x) + (sourceA.y * sourceB[1].y) + (sourceA.z * sourceB[1].z) + (sourceA.w * sourceB[1].w).
		 * dest.z = (sourceA.x * sourceB[2].x) + (sourceA.y * sourceB[2].y) + (sourceA.z * sourceB[2].z) + (sourceA.w * sourceB[2].w).
		 */
		public function m34(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "m34 " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Вычисляет частную производную по Х из source в dest.
		 */
		public function ddx(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "ddx " + dest + ", " + source + " \n";
		}
		
		/**
		 * Вычисляет частную производную по Y из source в dest.
		 */
		public function ddy(dest:*, source:*):void
		{	
			dest = dest is String ? dest : SkyRegister(dest).name;
			source = source is String ? source : SkyRegister(source).name;
			
			string += "ddy " + dest + ", " + source + " \n";
		}
		
		/**
		 * Выполняет код принадлежащий условию если sourceA равен sourceB.
		 * if equal to. (sourceA == sourceB)
		 */
		public function ife(sourceA:*, sourceB:*):void
		{
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "ife " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Выполняет код принадлежащий условию если sourceA не равен sourceB.
		 * if not equal to. (sourceA != sourceB)
		 */
		public function ine(sourceA:*, sourceB:*):void
		{
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "ine " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Выполняет код принадлежащий условию если sourceA больше sourceB.
		 * if greater than. (sourceA > sourceB)
		 */
		public function ifg(sourceA:*, sourceB:*):void
		{
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "ifg " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Выполняет код принадлежащий условию если sourceA меньше sourceB.
		 * if less than. (sourceA < sourceB)
		 */
		public function ifl(sourceA:*, sourceB:*):void
		{
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "ifl " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Else блок.
		 * else.
		 */
		public function els():void
		{
			string += "els \n";
		}
		
		/**
		 * Закрывает if или else блок.
		 * Endif.
		 */
		public function eif():void
		{
			string += "eif \n";
		}
		
		/**
		 * Неизвестно.
		 */
		public function ted(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "ted " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Если один из компонентов меньше 0, прекращается выполнение обработки пикселя и не рисует его в буффер кадра.
		 */
		public function kil(source:*):void
		{
			string += "kil " + (source is String ? source : SkyRegister(source).name) + " \n";
		}
		
		/**
		 * Выборка значения из текстуры.
		 * Заносит в dest значение цвета в координатах textureCoord из текстуры sample.
		 * @param format формат текстуры.
		 * @param tileType тайлинг текстуры.
		 * @param filter фильтрация текстуры.
		 * @param mimap мипмаппинг.
		 * tex ft0, v0, fs0 <2d, repeat, linear, miplinear>
		 */
		public function tex(dest:*, textureCoord:*, sample:*, format:String = "2d", tileType:String = "clamp", filter:String = "anisotropic16x", mipmap:String = "nomip"):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sample = sample is String ? sample : SkyRegister(sample).name;
			textureCoord = textureCoord is String ? textureCoord : SkyRegister(textureCoord).name;
			
			string += "tex " + dest + ", " + textureCoord + ", " + sample + " <" + format + ", " + tileType + ", " + filter + ", " + mipmap + "> \n";
		}
		
		/**
		 * Выборка значения из текстуры для вершинной программы.
		 * Заносит в dest значение цвета в координатах textureCoord из текстуры sample.
		 * @param format формат текстуры.
		 * @param tileType тайлинг текстуры.
		 * @param filter фильтрация текстуры.
		 * @param mimap мипмаппинг.
		 * vt0, va0, vs0 <2d, linear, miplinear>
		 */
		public function tld(dest:*, textureCoord:*, sample:*, format:String, filter:String, mipmap:String):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sample = sample is String ? sample : SkyRegister(sample).name;
			textureCoord = textureCoord is String ? textureCoord : SkyRegister(textureCoord).name;
			
			string += "tld " + dest + ", " + textureCoord + ", " + sample + " <" + format + ", " + filter + ", " + mipmap + "> \n";
		}
		
		/**
		 * Покомпонентно, сравнивает sourceA и sourceB возвращая 1, если sourceA больше или равен sourceB, иначе 0.
		 * dest = sourceA >= sourceB ? 1 : 0.
		 */
		public function sge(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "sge " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, сравнивает sourceA и sourceB возвращая 1, если sourceA меньше sourceB, иначе 0.
		 * dest = sourceA < sourceB ? 1 : 0.
		 */
		public function slt(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "slt " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Пока неизвестно!
		 * Покомпонентно, сравнивает sourceA и sourceB возвращая 1, если sourceA меньше sourceB, иначе 0.
		 * dest = sourceA < sourceB ? 1 : 0.
		 */
		public function sgn(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "sgn " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, сравнивает sourceA и sourceB возвращая 1, если sourceA равен sourceB, иначе 0.
		 * dest = sourceA == sourceB ? 1 : 0.
		 */
		public function seq(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "seq " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Покомпонентно, сравнивает sourceA и sourceB возвращая 1, если sourceA не равен sourceB, иначе 0.
		 * dest = sourceA != sourceB ? 1 : 0.
		 */
		public function sne(dest:*, sourceA:*, sourceB:*):void
		{
			dest = dest is String ? dest : SkyRegister(dest).name;
			sourceA = sourceA is String ? sourceA : SkyRegister(sourceA).name;
			sourceB = sourceB is String ? sourceB : SkyRegister(sourceB).name;
			
			string += "sne " + dest + ", " + sourceA + ", " + sourceB + " \n";
		}
		
		/**
		 * Instancing id.
		 */
		public function get iid():String
		{
			return "iid.x";
		}
		
		/**
		 * Вершинный регистр-результат.
		 */
		public function get op():SkyRegister
		{
			return mVertexOutput;
		}
		
		/**
		 * Вершинная регистр-константа.
		 * vertex constant.
		 */
		public function vc(index:int):SkyRegister
		{
			mVertexConst.index = String(index);
			return mVertexConst;
		}
		
		/**
		 * varying.
		 */
		public function v(index:int):SkyRegister
		{
			mVertexVarying.index = String(index);
			return mVertexVarying;
		}
		
		/**
		 * Вершинный семплер-регистр.
		 */
		public function vs(index:int):SkyRegister
		{
			mVertexSampler.index = String(index);
			return mVertexSampler;
		}
		
		/**
		 * Вершинная регистр-переменная.
		 * vertex temporary.
		 */
		public function vt(index:int):SkyRegister
		{
			mVertexTemporary.index = String(index);
			return mVertexTemporary;
		}
		
		/**
		 * Регистр-интерполятор.
		 * vertex attribute.
		 */
		public function va(index:int):SkyRegister
		{
			mVertexAttribute.index = String(index);
			return mVertexAttribute;
		}
		
		/**
		 * Пиксельный регистр-результат.
		 */
		public function get oc():SkyRegister
		{
			return mFragmentOuputColor;
		}
		
		/**
		 * Пиксельная регистр-константа.
		 */
		public function fc(index:int):SkyRegister
		{
			mFragmentConst.index = String(index);
			return mFragmentConst;
		}
		
		/**
		 * Пиксельный регистр-вывод.
		 */
		public function fo(index:int):SkyRegister
		{
			mFragmentOutput.index = String(index);
			return mFragmentOutput;
		}
		
		/**
		 * Пиксельный регистр-переменная.
		 */
		public function ft(index:int):SkyRegister
		{
			mFragmentTemporary.index = String(index);
			return mFragmentTemporary;
		}
		
		/**
		 * Пиксельный регистр-cемплер.
		 */
		public function fs(index:int):SkyRegister
		{
			mFragmentSampler.index = String(index);
			return mFragmentSampler;
		}
		
		/**
		 * Регистр буффера глубины.
		 */
		public function get od():String
		{
			return "od.x";
		}
	}
}