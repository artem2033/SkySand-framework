package skysand.render 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Matrix3D;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyRenderTarget extends SkyTexture
	{
		private var matrix:Matrix3D;
		
		/**
		 * @param	width ширина текстуры.
		 * @param	height высота текстуры.
		 * @param	format формат текстуры.
		 * @param	optimizeForRenderToTexture оптимизировать ли текстуру для рендера в неё.
		 */
		public function SkyRenderTarget(width:Number, height:Number, format:String = Context3DTextureFormat.BGRA, optimizeForRenderToTexture:Boolean = false) 
		{
			super(width, height, format, optimizeForRenderToTexture);
			
			uploadFromBitmapData(new BitmapData(1, 1));
			
			matrix = new Matrix3D();
			matrix.appendTranslation( -width / 2, -height / 2, 0);
			matrix.appendScale(2 / width, -2 / height, 1);
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			
			matrix.identity();
			matrix.appendTranslation( -width / 2, -height / 2, 0);
			matrix.appendScale(2 / width, -2 / height, 1);
		}
		
		public function get targetMatrix():Matrix3D
		{
			return matrix;
		}
	}
}