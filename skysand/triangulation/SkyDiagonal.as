package skysand.triangulation 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyDiagonal 
	{
		public var startPoint:SkyPolygonPoint;
		public var endPoint:SkyPolygonPoint;
		public var isEdge:Boolean = false;
		
		public function SkyDiagonal(start:SkyPolygonPoint, end:SkyPolygonPoint) 
		{
			startPoint = start;
			startPoint.diagonals.push(this);
			endPoint = end;
			endPoint.diagonals.push(this);
		}
		
		public function getOppositePoint(point:SkyPolygonPoint):SkyPolygonPoint
		{
			return point == startPoint ? endPoint : startPoint;
		}
	}
}