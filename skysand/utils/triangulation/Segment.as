package skysand.utils.triangulation
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author nicoptere
	 */
	public class Segment 
	{
		public var p0:Point;
		public var p1:Point;
		
		private var p:Point = new Point();
		private var minX:Number = 0;
		private var minY:Number = 0;
		private var maxX:Number = 0;
		private var maxY:Number = 0;
		
		
		public function Segment( p0:Point, p1:Point ) 
		{
			this.p0 = p0;
			this.p1 = p1;
		}
		
		//segmentIntersection function found on :
		//
		//http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/
		public function segmentIntersct( s:Segment, as_seg:Boolean=true  ):Point 
		{
		
			var ip:Point;
			var a1:Number;
			var a2:Number;
			var b1:Number;
			var b2:Number;
			var c1:Number;
			var c2:Number;
		 
			var A:Point = p0;
			var B:Point = p1;
			var E:Point = s.p0;
			var F:Point = s.p1;
			
			a1= B.y-A.y;
			b1= A.x-B.x;
			c1= B.x*A.y - A.x*B.y;
			a2= F.y-E.y;
			b2= E.x-F.x;
			c2= F.x*E.y - E.x*F.y;
		 
			var denom:Number=a1*b2 - a2*b1;
			if(denom == 0){
				return null;
			}
			ip=new Point();
			ip.x=(b1*c2 - b2*c1)/denom;
			ip.y=(a2*c1 - a1*c2)/denom;
		 
			//---------------------------------------------------
			//Do checks to see if intersection to endpoints
			//distance is longer than actual Segments.
			//Return null if it is with any.
			//---------------------------------------------------
			if(as_seg){
				if(Point.distance(ip,B) > Point.distance(A,B)){
					return null;
				}
				if(Point.distance(ip,A) > Point.distance(A,B)){
					return null;
				}	
		 
				if(Point.distance(ip,F) > Point.distance(E,F)){
					return null;
				}
				if(Point.distance(ip,E) > Point.distance(E,F)){
					return null;
				}
			}
			return ip;
		}
		
		
		public function equals( s:Segment ):Boolean
		{
			return ( ( p0 == s.p0 && p1 == s.p1 ) || ( p0 == s.p1 && p1 == s.p0 ) );
		}
		
		public function getCenter():Point
		{
			return new Point( p0.x + ( p1.x - p0.x )/2, p0.y + ( p1.y - p0.y ) / 2 );
		}
		
		public function determinant( p0:Point, p1:Point, p2:Point ):Number
		{
			return ( ( p0.x-p1.x )*( p2.y - p1.y ) ) - ( ( p2.x-p1.x )*( p0.y-p1.y ) );
		}
		public function midPoint():Point
		{
			return new Point( ( p0.x + p1.x ) / 2, ( p0.y + p1.y ) / 2 );
		}
		
		public function render( g:Graphics ):void
		{
			g.moveTo( p0.x, p0.y );
			g.lineTo( p1.x, p1.y );
		}
		
	}
	
}