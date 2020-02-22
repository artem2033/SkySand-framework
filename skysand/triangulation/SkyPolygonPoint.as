package skysand.triangulation 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyPolygonPoint 
	{
		public var x:Number = 0;
		public var y:Number = 0;
		public var index:int = 0;
		public var type:int = -1;
		public var next:SkyPolygonPoint;
		public var prev:SkyPolygonPoint;
		public var diagonals:Vector.<SkyDiagonal>;
		
		public function SkyPolygonPoint() 
		{
			diagonals = new Vector.<SkyDiagonal>();
		}
	}
}