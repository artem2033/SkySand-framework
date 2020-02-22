package skysand.render.shaders 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyRegister 
	{
		private var mName:String = "";
		private const mX:String = "x";
		private const mY:String = "y";
		private const mZ:String = "z";
		private const mW:String = "w";
		
		private const mXX:String = "xx";
		private const mXY:String = "xy";
		private const mXZ:String = "xz";
		private const mXW:String = "xw";
		private const mYX:String = "yx";
		private const mYY:String = "yy";
		private const mYZ:String = "yz";
		private const mYW:String = "yw";
		private const mZX:String = "zx";
		private const mZY:String = "zy";
		private const mZZ:String = "zz";
		private const mZW:String = "zw";
		private const mWX:String = "wx";
		private const mWY:String = "wy";
		private const mWZ:String = "wz";
		private const mWW:String = "ww";
		
		private const mXXX:String = "xxx";
		private const mXXY:String = "xxy";
		private const mXXZ:String = "xxz";
		private const mXXW:String = "xxw";
		private const mXYX:String = "xyx";
		private const mXYY:String = "xyy";
		private const mXYZ:String = "xyz";
		private const mXYW:String = "xyw";
		private const mXZX:String = "xzx";
		private const mXZY:String = "xzy";
		private const mXZZ:String = "xzz";
		private const mXZW:String = "xzw";
		private const mXWX:String = "xwx";
		private const mXWY:String = "xwy";
		private const mXWZ:String = "xwz";
		private const mXWW:String = "xww";
		private const mYXX:String = "yxx";
		private const mYXY:String = "yxy"; 
		private const mYXZ:String = "yxz";
		private const mYXW:String = "yxw";
		private const mYYX:String = "yyx";
		private const mYYY:String = "yyy";
		private const mYYZ:String = "yyz";
		private const mYYW:String = "yyw";
		private const mYZX:String = "yzx";
		private const mYZY:String = "yzy";
		private const mYZZ:String = "yzz";
		private const mYZW:String = "yzw";
		private const mYWX:String = "ywx";
		private const mYWY:String = "ywy";
		private const mYWZ:String = "ywz";
		private const mYWW:String = "yww";
		private const mZXX:String = "zxx";
		private const mZXY:String = "zxy";
		private const mZXZ:String = "zxz";
		private const mZXW:String = "zxw";
		private const mZYX:String = "zyx";
		private const mZYY:String = "zyy";
		private const mZYZ:String = "zyz";
		private const mZYW:String = "zyw";
		private const mZZX:String = "zzx";
		private const mZZY:String = "zzy";
		private const mZZZ:String = "zzz";
		private const mZZW:String = "zzw";
		private const mZWX:String = "zwx";
		private const mZWY:String = "zwy";
		private const mZWZ:String = "zwz";
		private const mZWW:String = "zww";
		private const mWXX:String = "wxx";
		private const mWXY:String = "wxy";
		private const mWXZ:String = "wxz";
		private const mWXW:String = "wxw";
		private const mWYX:String = "wyz";
		private const mWYY:String = "wyy";
		private const mWYZ:String = "wyz";
		private const mWYW:String = "wyw";
		private const mWZX:String = "wzx";
		private const mWZY:String = "wzy";
		private const mWZZ:String = "wzz";
		private const mWZW:String = "wzw";
		private const mWWX:String = "wwx";
		private const mWWY:String = "wwy";
		private const mWWZ:String = "wwz";
		private const mWWW:String = "www";
		
		private const mXXXX:String = "xxxx";
		private const mXXXY:String = "xxxy";
		private const mXXXZ:String = "xxxz";
		private const mXXXW:String = "xxxw";
		private const mXXYX:String = "xxyx";
		private const mXXYY:String = "xxyy";
		private const mXXYZ:String = "xxyz";
		private const mXXYW:String = "xxyw";
		private const mXXZX:String = "xxzx";
		private const mXXZY:String = "xxzy";
		private const mXXZZ:String = "xxzz";
		private const mXXZW:String = "xxzw";
		private const mXXWX:String = "xxwx";
		private const mXXWY:String = "xxwy";
		private const mXXWZ:String = "xxwz";
		private const mXXWW:String = "xxww";
		private const mXYXX:String = "xyxx";
		private const mXYXY:String = "xyxy"; 
		private const mXYXZ:String = "xyxz";
		private const mXYXW:String = "xyxw";
		private const mXYYX:String = "xyyx";
		private const mXYYY:String = "xyyy";
		private const mXYYZ:String = "xyyz";
		private const mXYYW:String = "xyyw";
		private const mXYZX:String = "xyzx";
		private const mXYZY:String = "xyzy";
		private const mXYZZ:String = "xyzz";
		private const mXYZW:String = "xyzw";
		private const mXYWX:String = "xywx";
		private const mXYWY:String = "xywy";
		private const mXYWZ:String = "xywz";
		private const mXYWW:String = "xyww";
		private const mXZXX:String = "xzxx";
		private const mXZXY:String = "xzxy";
		private const mXZXZ:String = "xzxz";
		private const mXZXW:String = "xzxw";
		private const mXZYX:String = "xzyx";
		private const mXZYY:String = "xzyy";
		private const mXZYZ:String = "xzyz";
		private const mXZYW:String = "xzyw";
		private const mXZZX:String = "xzzx";
		private const mXZZY:String = "xzzy";
		private const mXZZZ:String = "xzzz";
		private const mXZZW:String = "xzzw";
		private const mXZWX:String = "xzwx";
		private const mXZWY:String = "xzwy";
		private const mXZWZ:String = "xzwz";
		private const mXZWW:String = "xzww";
		private const mXWXX:String = "xwxx";
		private const mXWXY:String = "xwxy";
		private const mXWXZ:String = "xwxz";
		private const mXWXW:String = "xwxw";
		private const mXWYX:String = "xwyz";
		private const mXWYY:String = "xwyy";
		private const mXWYZ:String = "xwyz";
		private const mXWYW:String = "xwyw";
		private const mXWZX:String = "xwzx";
		private const mXWZY:String = "xwzy";
		private const mXWZZ:String = "xwzz";
		private const mXWZW:String = "xwzw";
		private const mXWWX:String = "xwwx";
		private const mXWWY:String = "xwwy";
		private const mXWWZ:String = "xwwz";
		private const mXWWW:String = "xwww";
		private const mYXXX:String = "yxxx";
		private const mYXXY:String = "yxxy";
		private const mYXXZ:String = "yxxz";
		private const mYXXW:String = "yxxw";
		private const mYXYX:String = "yxyx";
		private const mYXYY:String = "yxyy";
		private const mYXYZ:String = "yxyz";
		private const mYXYW:String = "yxyw";
		private const mYXZX:String = "yxzx";
		private const mYXZY:String = "yxzy";
		private const mYXZZ:String = "yxzz";
		private const mYXZW:String = "yxzw";
		private const mYXWX:String = "yxwx";
		private const mYXWY:String = "yxwy";
		private const mYXWZ:String = "yxwz";
		private const mYXWW:String = "yxww";
		private const mYYXX:String = "yyxx";
		private const mYYXY:String = "yyxy"; 
		private const mYYXZ:String = "yyxz";
		private const mYYXW:String = "yyxw";
		private const mYYYX:String = "yyyx";
		private const mYYYY:String = "yyyy";
		private const mYYYZ:String = "yyyz";
		private const mYYYW:String = "yyyw";
		private const mYYZX:String = "yyzx";
		private const mYYZY:String = "yyzy";
		private const mYYZZ:String = "yyzz";
		private const mYYZW:String = "yyzw";
		private const mYYWX:String = "yywx";
		private const mYYWY:String = "yywy";
		private const mYYWZ:String = "yywz";
		private const mYYWW:String = "yyww";
		private const mYZXX:String = "yzxx";
		private const mYZXY:String = "yzxy";
		private const mYZXZ:String = "yzxz";
		private const mYZXW:String = "yzxw";
		private const mYZYX:String = "yzyx";
		private const mYZYY:String = "yzyy";
		private const mYZYZ:String = "yzyz";
		private const mYZYW:String = "yzyw";
		private const mYZZX:String = "yzzx";
		private const mYZZY:String = "yzzy";
		private const mYZZZ:String = "yzzz";
		private const mYZZW:String = "yzzw";
		private const mYZWX:String = "yzwx";
		private const mYZWY:String = "yzwy";
		private const mYZWZ:String = "yzwz";
		private const mYZWW:String = "yzww";
		private const mYWXX:String = "ywxx";
		private const mYWXY:String = "ywxy";
		private const mYWXZ:String = "ywxz";
		private const mYWXW:String = "ywxw";
		private const mYWYX:String = "ywyz";
		private const mYWYY:String = "ywyy";
		private const mYWYZ:String = "ywyz";
		private const mYWYW:String = "ywyw";
		private const mYWZX:String = "ywzx";
		private const mYWZY:String = "ywzy";
		private const mYWZZ:String = "ywzz";
		private const mYWZW:String = "ywzw";
		private const mYWWX:String = "ywwx";
		private const mYWWY:String = "ywwy";
		private const mYWWZ:String = "ywwz";
		private const mYWWW:String = "ywww";
		private const mZXXX:String = "zxxx";
		private const mZXXY:String = "zxxy";
		private const mZXXZ:String = "zxxz";
		private const mZXXW:String = "zxxw";
		private const mZXYX:String = "zxyx";
		private const mZXYY:String = "zxyy";
		private const mZXYZ:String = "zxyz";
		private const mZXYW:String = "zxyw";
		private const mZXZX:String = "zxzx";
		private const mZXZY:String = "zxzy";
		private const mZXZZ:String = "zxzz";
		private const mZXZW:String = "zxzw";
		private const mZXWX:String = "zxwx";
		private const mZXWY:String = "zxwy";
		private const mZXWZ:String = "zxwz";
		private const mZXWW:String = "zxww";
		private const mZYXX:String = "zyxx";
		private const mZYXY:String = "zyxy"; 
		private const mZYXZ:String = "zyxz";
		private const mZYXW:String = "zyxw";
		private const mZYYX:String = "zyyx";
		private const mZYYY:String = "zyyy";
		private const mZYYZ:String = "zyyz";
		private const mZYYW:String = "zyyw";
		private const mZYZX:String = "zyzx";
		private const mZYZY:String = "zyzy";
		private const mZYZZ:String = "zyzz";
		private const mZYZW:String = "zyzw";
		private const mZYWX:String = "zywx";
		private const mZYWY:String = "zywy";
		private const mZYWZ:String = "zywz";
		private const mZYWW:String = "zyww";
		private const mZZXX:String = "zzxx";
		private const mZZXY:String = "zzxy";
		private const mZZXZ:String = "zzxz";
		private const mZZXW:String = "zzxw";
		private const mZZYX:String = "zzyx";
		private const mZZYY:String = "zzyy";
		private const mZZYZ:String = "zzyz";
		private const mZZYW:String = "zzyw";
		private const mZZZX:String = "zzzx";
		private const mZZZY:String = "zzzy";
		private const mZZZZ:String = "zzzz";
		private const mZZZW:String = "zzzw";
		private const mZZWX:String = "zzwx";
		private const mZZWY:String = "zzwy";
		private const mZZWZ:String = "zzwz";
		private const mZZWW:String = "zzww";
		private const mZWXX:String = "zwxx";
		private const mZWXY:String = "zwxy";
		private const mZWXZ:String = "zwxz";
		private const mZWXW:String = "zwxw";
		private const mZWYX:String = "zwyz";
		private const mZWYY:String = "zwyy";
		private const mZWYZ:String = "zwyz";
		private const mZWYW:String = "zwyw";
		private const mZWZX:String = "zwzx";
		private const mZWZY:String = "zwzy";
		private const mZWZZ:String = "zwzz";
		private const mZWZW:String = "zwzw";
		private const mZWWX:String = "zwwx";
		private const mZWWY:String = "zwwy";
		private const mZWWZ:String = "zwwz";
		private const mZWWW:String = "zwww";
		private const mWXXX:String = "wxxx";
		private const mWXXY:String = "wxxy";
		private const mWXXZ:String = "wxxz";
		private const mWXXW:String = "wxxw";
		private const mWXYX:String = "wxyx";
		private const mWXYY:String = "wxyy";
		private const mWXYZ:String = "wxyz";
		private const mWXYW:String = "wxyw";
		private const mWXZX:String = "wxzx";
		private const mWXZY:String = "wxzy";
		private const mWXZZ:String = "wxzz";
		private const mWXZW:String = "wxzw";
		private const mWXWX:String = "wxwx";
		private const mWXWY:String = "wxwy";
		private const mWXWZ:String = "wxwz";
		private const mWXWW:String = "wxww";
		private const mWYXX:String = "wyxx";
		private const mWYXY:String = "wyxy"; 
		private const mWYXZ:String = "wyxz";
		private const mWYXW:String = "wyxw";
		private const mWYYX:String = "wyyx";
		private const mWYYY:String = "wyyy";
		private const mWYYZ:String = "wyyz";
		private const mWYYW:String = "wyyw";
		private const mWYZX:String = "wyzx";
		private const mWYZY:String = "wyzy";
		private const mWYZZ:String = "wyzz";
		private const mWYZW:String = "wyzw";
		private const mWYWX:String = "wywx";
		private const mWYWY:String = "wywy";
		private const mWYWZ:String = "wywz";
		private const mWYWW:String = "wyww";
		private const mWZXX:String = "wzxx";
		private const mWZXY:String = "wzxy";
		private const mWZXZ:String = "wzxz";
		private const mWZXW:String = "wzxw";
		private const mWZYX:String = "wzyx";
		private const mWZYY:String = "wzyy";
		private const mWZYZ:String = "wzyz";
		private const mWZYW:String = "wzyw";
		private const mWZZX:String = "wzzx";
		private const mWZZY:String = "wzzy";
		private const mWZZZ:String = "wzzz";
		private const mWZZW:String = "wzzw";
		private const mWZWX:String = "wzwx";
		private const mWZWY:String = "wzwy";
		private const mWZWZ:String = "wzwz";
		private const mWZWW:String = "wzww";
		private const mWWXX:String = "wwxx";
		private const mWWXY:String = "wwxy";
		private const mWWXZ:String = "wwxz";
		private const mWWXW:String = "wwxw";
		private const mWWYX:String = "wwyz";
		private const mWWYY:String = "wwyy";
		private const mWWYZ:String = "wwyz";
		private const mWWYW:String = "wwyw";
		private const mWWZX:String = "wwzx";
		private const mWWZY:String = "wwzy";
		private const mWWZZ:String = "wwzz";
		private const mWWZW:String = "wwzw";
		private const mWWWX:String = "wwwx";
		private const mWWWY:String = "wwwy";
		private const mWWWZ:String = "wwwz";
		private const mWWWW:String = "wwww";
		public var index:String = "";
		
		public function SkyRegister (registerName:String) 
		{
			mName = registerName;
		}
		
		public function get name():String
		{
			return mName + index;
		}
		
		public function get x():String {return mName + index + "." + mX;}
		public function get y():String {return mName + index + "." + mY;}
		public function get z():String {return mName + index + "." + mZ;}
		public function get w():String {return mName + index + "." + mW; }
		
		public function get xx():String {return mName + index + "." + mXX;}
		public function get xy():String {return mName + index + "." + mXY;}
		public function get xz():String {return mName + index + "." + mXZ;}
		public function get xw():String {return mName + index + "." + mXW;}
		public function get yx():String {return mName + index + "." + mYX;}
		public function get yy():String {return mName + index + "." + mYY;}
		public function get yz():String {return mName + index + "." + mYZ;}
		public function get yw():String {return mName + index + "." + mYW;}
		public function get zx():String {return mName + index + "." + mZX;}
		public function get zy():String {return mName + index + "." + mZY;}
		public function get zz():String {return mName + index + "." + mZZ;}
		public function get zw():String {return mName + index + "." + mZW;}
		public function get wx():String {return mName + index + "." + mWX;}
		public function get wy():String {return mName + index + "." + mWY;}
		public function get wz():String {return mName + index + "." + mWZ;}
		public function get ww():String {return mName + index + "." + mWW; }	
		
		public function get xxx():String {return mName + index + "." + mXXX;}
		public function get xxy():String {return mName + index + "." + mXXY;}
		public function get xxz():String {return mName + index + "." + mXXZ;}
		public function get xxw():String {return mName + index + "." + mXXW;}
		public function get xyx():String {return mName + index + "." + mXYX;}
		public function get xyy():String {return mName + index + "." + mXYY;}
		public function get xyz():String {return mName + index + "." + mXYZ;}
		public function get xyw():String {return mName + index + "." + mXYW;}
		public function get xzx():String {return mName + index + "." + mXZX;}
		public function get xzy():String {return mName + index + "." + mXZY;}
		public function get xzz():String {return mName + index + "." + mXZZ;}
		public function get xzw():String {return mName + index + "." + mXZW;}
		public function get xwx():String {return mName + index + "." + mXWX;}
		public function get xwy():String {return mName + index + "." + mXWY;}
		public function get xwz():String {return mName + index + "." + mXWZ;}
		public function get xww():String {return mName + index + "." + mXWW;}
		public function get yxx():String {return mName + index + "." + mYXX;}
		public function get yxy():String {return mName + index + "." + mYXY;}
		public function get yxz():String {return mName + index + "." + mYXZ;}
		public function get yxw():String {return mName + index + "." + mYXW;}
		public function get yyx():String {return mName + index + "." + mYYX;}
		public function get yyy():String {return mName + index + "." + mYYY;}
		public function get yyz():String {return mName + index + "." + mYYZ;}
		public function get yyw():String {return mName + index + "." + mYYW;}
		public function get yzx():String {return mName + index + "." + mYZX;}
		public function get yzy():String {return mName + index + "." + mYZY;}
		public function get yzz():String {return mName + index + "." + mYZZ;}
		public function get yzw():String {return mName + index + "." + mYZW;}
		public function get ywx():String {return mName + index + "." + mYWX;}
		public function get ywy():String {return mName + index + "." + mYWY;}
		public function get ywz():String {return mName + index + "." + mYWZ;}
		public function get yww():String {return mName + index + "." + mYWW;}
		public function get zxx():String {return mName + index + "." + mZXX;}
		public function get zxy():String {return mName + index + "." + mZXY;}
		public function get zxz():String {return mName + index + "." + mZXZ;}
		public function get zxw():String {return mName + index + "." + mZXW;}
		public function get zyx():String {return mName + index + "." + mZYX;}
		public function get zyy():String {return mName + index + "." + mZYY;}
		public function get zyz():String {return mName + index + "." + mZYZ;}
		public function get zyw():String {return mName + index + "." + mZYW;}
		public function get zzx():String {return mName + index + "." + mZZX;}
		public function get zzy():String {return mName + index + "." + mZZY;}
		public function get zzz():String {return mName + index + "." + mZZZ;}
		public function get zzw():String {return mName + index + "." + mZZW;}
		public function get zwx():String {return mName + index + "." + mZWX;}
		public function get zwy():String {return mName + index + "." + mZWY;}
		public function get zwz():String {return mName + index + "." + mZWZ;}
		public function get zww():String {return mName + index + "." + mZWW;}
		public function get wxx():String {return mName + index + "." + mWXX;}
		public function get wxy():String {return mName + index + "." + mWXY;}
		public function get wxz():String {return mName + index + "." + mWXZ;}
		public function get wxw():String {return mName + index + "." + mWXW;}
		public function get wyx():String {return mName + index + "." + mWYX;}
		public function get wyy():String {return mName + index + "." + mWYY;}
		public function get wyz():String {return mName + index + "." + mWYZ;}
		public function get wyw():String {return mName + index + "." + mWYW;}
		public function get wzx():String {return mName + index + "." + mWZX;}
		public function get wzy():String {return mName + index + "." + mWZY;}
		public function get wzz():String {return mName + index + "." + mWZZ;}
		public function get wzw():String {return mName + index + "." + mWZW;}
		public function get wwx():String {return mName + index + "." + mWWX;}
		public function get wwy():String {return mName + index + "." + mWWY;}
		public function get wwz():String {return mName + index + "." + mWWZ;}
		public function get www():String {return mName + index + "." + mWWW;}
		public function get xxxx():String {return mName + index + "." + mXXXX;}
		public function get xxxy():String {return mName + index + "." + mXXXY;}
		public function get xxxz():String {return mName + index + "." + mXXXZ;}
		public function get xxxw():String {return mName + index + "." + mXXXW;}
		public function get xxyx():String {return mName + index + "." + mXXYX;}
		public function get xxyy():String {return mName + index + "." + mXXYY;}
		public function get xxyz():String {return mName + index + "." + mXXYZ;}
		public function get xxyw():String {return mName + index + "." + mXXYW;}
		public function get xxzx():String {return mName + index + "." + mXXZX;}
		public function get xxzy():String {return mName + index + "." + mXXZY;}
		public function get xxzz():String {return mName + index + "." + mXXZZ;}
		public function get xxzw():String {return mName + index + "." + mXXZW;}
		public function get xxwx():String {return mName + index + "." + mXXWX;}
		public function get xxwy():String {return mName + index + "." + mXXWY;}
		public function get xxwz():String {return mName + index + "." + mXXWZ;}
		public function get xxww():String {return mName + index + "." + mXXWW;}
		public function get xyxx():String {return mName + index + "." + mXYXX;}
		public function get xyxy():String {return mName + index + "." + mXYXY;}
		public function get xyxz():String {return mName + index + "." + mXYXZ;}
		public function get xyxw():String {return mName + index + "." + mXYXW;}
		public function get xyyx():String {return mName + index + "." + mXYYX;}
		public function get xyyy():String {return mName + index + "." + mXYYY;}
		public function get xyyz():String {return mName + index + "." + mXYYZ;}
		public function get xyyw():String {return mName + index + "." + mXYYW;}
		public function get xyzx():String {return mName + index + "." + mXYZX;}
		public function get xyzy():String {return mName + index + "." + mXYZY;}
		public function get xyzz():String {return mName + index + "." + mXYZZ;}
		public function get xyzw():String {return mName + index + "." + mXYZW;}
		public function get xywx():String {return mName + index + "." + mXYWX;}
		public function get xywy():String {return mName + index + "." + mXYWY;}
		public function get xywz():String {return mName + index + "." + mXYWZ;}
		public function get xyww():String {return mName + index + "." + mXYWW;}
		public function get xzxx():String {return mName + index + "." + mXZXX;}
		public function get xzxy():String {return mName + index + "." + mXZXY;}
		public function get xzxz():String {return mName + index + "." + mXZXZ;}
		public function get xzxw():String {return mName + index + "." + mXZXW;}
		public function get xzyx():String {return mName + index + "." + mXZYX;}
		public function get xzyy():String {return mName + index + "." + mXZYY;}
		public function get xzyz():String {return mName + index + "." + mXZYZ;}
		public function get xzyw():String {return mName + index + "." + mXZYW;}
		public function get xzzx():String {return mName + index + "." + mXZZX;}
		public function get xzzy():String {return mName + index + "." + mXZZY;}
		public function get xzzz():String {return mName + index + "." + mXZZZ;}
		public function get xzzw():String {return mName + index + "." + mXZZW;}
		public function get xzwx():String {return mName + index + "." + mXZWX;}
		public function get xzwy():String {return mName + index + "." + mXZWY;}
		public function get xzwz():String {return mName + index + "." + mXZWZ;}
		public function get xzww():String {return mName + index + "." + mXZWW;}
		public function get xwxx():String {return mName + index + "." + mXWXX;}
		public function get xwxy():String {return mName + index + "." + mXWXY;}
		public function get xwxz():String {return mName + index + "." + mXWXZ;}
		public function get xwxw():String {return mName + index + "." + mXWXW;}
		public function get xwyx():String {return mName + index + "." + mXWYX;}
		public function get xwyy():String {return mName + index + "." + mXWYY;}
		public function get xwyz():String {return mName + index + "." + mXWYZ;}
		public function get xwyw():String {return mName + index + "." + mXWYW;}
		public function get xwzx():String {return mName + index + "." + mXWZX;}
		public function get xwzy():String {return mName + index + "." + mXWZY;}
		public function get xwzz():String {return mName + index + "." + mXWZZ;}
		public function get xwzw():String {return mName + index + "." + mXWZW;}
		public function get xwwx():String {return mName + index + "." + mXWWX;}
		public function get xwwy():String {return mName + index + "." + mXWWY;}
		public function get xwwz():String {return mName + index + "." + mXWWZ;}
		public function get xwww():String {return mName + index + "." + mXWWW;}
		public function get yxxx():String {return mName + index + "." + mYXXX;}
		public function get yxxy():String {return mName + index + "." + mYXXY;}
		public function get yxxz():String {return mName + index + "." + mYXXZ;}
		public function get yxxw():String {return mName + index + "." + mYXXW;}
		public function get yxyx():String {return mName + index + "." + mYXYX;}
		public function get yxyy():String {return mName + index + "." + mYXYY;}
		public function get yxyz():String {return mName + index + "." + mYXYZ;}
		public function get yxyw():String {return mName + index + "." + mYXYW;}
		public function get yxzx():String {return mName + index + "." + mYXZX;}
		public function get yxzy():String {return mName + index + "." + mYXZY;}
		public function get yxzz():String {return mName + index + "." + mYXZZ;}
		public function get yxzw():String {return mName + index + "." + mYXZW;}
		public function get yxwx():String {return mName + index + "." + mYXWX;}
		public function get yxwy():String {return mName + index + "." + mYXWY;}
		public function get yxwz():String {return mName + index + "." + mYXWZ;}
		public function get yxww():String {return mName + index + "." + mYXWW;}
		public function get yyxx():String {return mName + index + "." + mYYXX;}
		public function get yyxy():String {return mName + index + "." + mYYXY;}
		public function get yyxz():String {return mName + index + "." + mYYXZ;}
		public function get yyxw():String {return mName + index + "." + mYYXW;}
		public function get yyyx():String {return mName + index + "." + mYYYX;}
		public function get yyyy():String {return mName + index + "." + mYYYY;}
		public function get yyyz():String {return mName + index + "." + mYYYZ;}
		public function get yyyw():String {return mName + index + "." + mYYYW;}
		public function get yyzx():String {return mName + index + "." + mYYZX;}
		public function get yyzy():String {return mName + index + "." + mYYZY;}
		public function get yyzz():String {return mName + index + "." + mYYZZ;}
		public function get yyzw():String {return mName + index + "." + mYYZW;}
		public function get yywx():String {return mName + index + "." + mYYWX;}
		public function get yywy():String {return mName + index + "." + mYYWY;}
		public function get yywz():String {return mName + index + "." + mYYWZ;}
		public function get yyww():String {return mName + index + "." + mYYWW;}
		public function get yzxx():String {return mName + index + "." + mYZXX;}
		public function get yzxy():String {return mName + index + "." + mYZXY;}
		public function get yzxz():String {return mName + index + "." + mYZXZ;}
		public function get yzxw():String {return mName + index + "." + mYZXW;}
		public function get yzyx():String {return mName + index + "." + mYZYX;}
		public function get yzyy():String {return mName + index + "." + mYZYY;}
		public function get yzyz():String {return mName + index + "." + mYZYZ;}
		public function get yzyw():String {return mName + index + "." + mYZYW;}
		public function get yzzx():String {return mName + index + "." + mYZZX;}
		public function get yzzy():String {return mName + index + "." + mYZZY;}
		public function get yzzz():String {return mName + index + "." + mYZZZ;}
		public function get yzzw():String {return mName + index + "." + mYZZW;}
		public function get yzwx():String {return mName + index + "." + mYZWX;}
		public function get yzwy():String {return mName + index + "." + mYZWY;}
		public function get yzwz():String {return mName + index + "." + mYZWZ;}
		public function get yzww():String {return mName + index + "." + mYZWW;}
		public function get ywxx():String {return mName + index + "." + mYWXX;}
		public function get ywxy():String {return mName + index + "." + mYWXY;}
		public function get ywxz():String {return mName + index + "." + mYWXZ;}
		public function get ywxw():String {return mName + index + "." + mYWXW;}
		public function get ywyx():String {return mName + index + "." + mYWYX;}
		public function get ywyy():String {return mName + index + "." + mYWYY;}
		public function get ywyz():String {return mName + index + "." + mYWYZ;}
		public function get ywyw():String {return mName + index + "." + mYWYW;}
		public function get ywzx():String {return mName + index + "." + mYWZX;}
		public function get ywzy():String {return mName + index + "." + mYWZY;}
		public function get ywzz():String {return mName + index + "." + mYWZZ;}
		public function get ywzw():String {return mName + index + "." + mYWZW;}
		public function get ywwx():String {return mName + index + "." + mYWWX;}
		public function get ywwy():String {return mName + index + "." + mYWWY;}
		public function get ywwz():String {return mName + index + "." + mYWWZ;}
		public function get ywww():String {return mName + index + "." + mYWWW;}
		public function get zxxx():String {return mName + index + "." + mZXXX;}
		public function get zxxy():String {return mName + index + "." + mZXXY;}
		public function get zxxz():String {return mName + index + "." + mZXXZ;}
		public function get zxxw():String {return mName + index + "." + mZXXW;}
		public function get zxyx():String {return mName + index + "." + mZXYX;}
		public function get zxyy():String {return mName + index + "." + mZXYY;}
		public function get zxyz():String {return mName + index + "." + mZXYZ;}
		public function get zxyw():String {return mName + index + "." + mZXYW;}
		public function get zxzx():String {return mName + index + "." + mZXZX;}
		public function get zxzy():String {return mName + index + "." + mZXZY;}
		public function get zxzz():String {return mName + index + "." + mZXZZ;}
		public function get zxzw():String {return mName + index + "." + mZXZW;}
		public function get zxwx():String {return mName + index + "." + mZXWX;}
		public function get zxwy():String {return mName + index + "." + mZXWY;}
		public function get zxwz():String {return mName + index + "." + mZXWZ;}
		public function get zxww():String {return mName + index + "." + mZXWW;}
		public function get zyxx():String {return mName + index + "." + mZYXX;}
		public function get zyxy():String {return mName + index + "." + mZYXY;}
		public function get zyxz():String {return mName + index + "." + mZYXZ;}
		public function get zyxw():String {return mName + index + "." + mZYXW;}
		public function get zyyx():String {return mName + index + "." + mZYYX;}
		public function get zyyy():String {return mName + index + "." + mZYYY;}
		public function get zyyz():String {return mName + index + "." + mZYYZ;}
		public function get zyyw():String {return mName + index + "." + mZYYW;}
		public function get zyzx():String {return mName + index + "." + mZYZX;}
		public function get zyzy():String {return mName + index + "." + mZYZY;}
		public function get zyzz():String {return mName + index + "." + mZYZZ;}
		public function get zyzw():String {return mName + index + "." + mZYZW;}
		public function get zywx():String {return mName + index + "." + mZYWX;}
		public function get zywy():String {return mName + index + "." + mZYWY;}
		public function get zywz():String {return mName + index + "." + mZYWZ;}
		public function get zyww():String {return mName + index + "." + mZYWW;}
		public function get zzxx():String {return mName + index + "." + mZZXX;}
		public function get zzxy():String {return mName + index + "." + mZZXY;}
		public function get zzxz():String {return mName + index + "." + mZZXZ;}
		public function get zzxw():String {return mName + index + "." + mZZXW;}
		public function get zzyx():String {return mName + index + "." + mZZYX;}
		public function get zzyy():String {return mName + index + "." + mZZYY;}
		public function get zzyz():String {return mName + index + "." + mZZYZ;}
		public function get zzyw():String {return mName + index + "." + mZZYW;}
		public function get zzzx():String {return mName + index + "." + mZZZX;}
		public function get zzzy():String {return mName + index + "." + mZZZY;}
		public function get zzzz():String {return mName + index + "." + mZZZZ;}
		public function get zzzw():String {return mName + index + "." + mZZZW;}
		public function get zzwx():String {return mName + index + "." + mZZWX;}
		public function get zzwy():String {return mName + index + "." + mZZWY;}
		public function get zzwz():String {return mName + index + "." + mZZWZ;}
		public function get zzww():String {return mName + index + "." + mZZWW;}
		public function get zwxx():String {return mName + index + "." + mZWXX;}
		public function get zwxy():String {return mName + index + "." + mZWXY;}
		public function get zwxz():String {return mName + index + "." + mZWXZ;}
		public function get zwxw():String {return mName + index + "." + mZWXW;}
		public function get zwyx():String {return mName + index + "." + mZWYX;}
		public function get zwyy():String {return mName + index + "." + mZWYY;}
		public function get zwyz():String {return mName + index + "." + mZWYZ;}
		public function get zwyw():String {return mName + index + "." + mZWYW;}
		public function get zwzx():String {return mName + index + "." + mZWZX;}
		public function get zwzy():String {return mName + index + "." + mZWZY;}
		public function get zwzz():String {return mName + index + "." + mZWZZ;}
		public function get zwzw():String {return mName + index + "." + mZWZW;}
		public function get zwwx():String {return mName + index + "." + mZWWX;}
		public function get zwwy():String {return mName + index + "." + mZWWY;}
		public function get zwwz():String {return mName + index + "." + mZWWZ;}
		public function get zwww():String {return mName + index + "." + mZWWW;}
		public function get wxxx():String {return mName + index + "." + mWXXX;}
		public function get wxxy():String {return mName + index + "." + mWXXY;}
		public function get wxxz():String {return mName + index + "." + mWXXZ;}
		public function get wxxw():String {return mName + index + "." + mWXXW;}
		public function get wxyx():String {return mName + index + "." + mWXYX;}
		public function get wxyy():String {return mName + index + "." + mWXYY;}
		public function get wxyz():String {return mName + index + "." + mWXYZ;}
		public function get wxyw():String {return mName + index + "." + mWXYW;}
		public function get wxzx():String {return mName + index + "." + mWXZX;}
		public function get wxzy():String {return mName + index + "." + mWXZY;}
		public function get wxzz():String {return mName + index + "." + mWXZZ;}
		public function get wxzw():String {return mName + index + "." + mWXZW;}
		public function get wxwx():String {return mName + index + "." + mWXWX;}
		public function get wxwy():String {return mName + index + "." + mWXWY;}
		public function get wxwz():String {return mName + index + "." + mWXWZ;}
		public function get wxww():String {return mName + index + "." + mWXWW;}
		public function get wyxx():String {return mName + index + "." + mWYXX;}
		public function get wyxy():String {return mName + index + "." + mWYXY;}
		public function get wyxz():String {return mName + index + "." + mWYXZ;}
		public function get wyxw():String {return mName + index + "." + mWYXW;}
		public function get wyyx():String {return mName + index + "." + mWYYX;}
		public function get wyyy():String {return mName + index + "." + mWYYY;}
		public function get wyyz():String {return mName + index + "." + mWYYZ;}
		public function get wyyw():String {return mName + index + "." + mWYYW;}
		public function get wyzx():String {return mName + index + "." + mWYZX;}
		public function get wyzy():String {return mName + index + "." + mWYZY;}
		public function get wyzz():String {return mName + index + "." + mWYZZ;}
		public function get wyzw():String {return mName + index + "." + mWYZW;}
		public function get wywx():String {return mName + index + "." + mWYWX;}
		public function get wywy():String {return mName + index + "." + mWYWY;}
		public function get wywz():String {return mName + index + "." + mWYWZ;}
		public function get wyww():String {return mName + index + "." + mWYWW;}
		public function get wzxx():String {return mName + index + "." + mWZXX;}
		public function get wzxy():String {return mName + index + "." + mWZXY;}
		public function get wzxz():String {return mName + index + "." + mWZXZ;}
		public function get wzxw():String {return mName + index + "." + mWZXW;}
		public function get wzyx():String {return mName + index + "." + mWZYX;}
		public function get wzyy():String {return mName + index + "." + mWZYY;}
		public function get wzyz():String {return mName + index + "." + mWZYZ;}
		public function get wzyw():String {return mName + index + "." + mWZYW;}
		public function get wzzx():String {return mName + index + "." + mWZZX;}
		public function get wzzy():String {return mName + index + "." + mWZZY;}
		public function get wzzz():String {return mName + index + "." + mWZZZ;}
		public function get wzzw():String {return mName + index + "." + mWZZW;}
		public function get wzwx():String {return mName + index + "." + mWZWX;}
		public function get wzwy():String {return mName + index + "." + mWZWY;}
		public function get wzwz():String {return mName + index + "." + mWZWZ;}
		public function get wzww():String {return mName + index + "." + mWZWW;}
		public function get wwxx():String {return mName + index + "." + mWWXX;}
		public function get wwxy():String {return mName + index + "." + mWWXY;}
		public function get wwxz():String {return mName + index + "." + mWWXZ;}
		public function get wwxw():String {return mName + index + "." + mWWXW;}
		public function get wwyx():String {return mName + index + "." + mWWYX;}
		public function get wwyy():String {return mName + index + "." + mWWYY;}
		public function get wwyz():String {return mName + index + "." + mWWYZ;}
		public function get wwyw():String {return mName + index + "." + mWWYW;}
		public function get wwzx():String {return mName + index + "." + mWWZX;}
		public function get wwzy():String {return mName + index + "." + mWWZY;}
		public function get wwzz():String {return mName + index + "." + mWWZZ;}
		public function get wwzw():String {return mName + index + "." + mWWZW;}
		public function get wwwx():String {return mName + index + "." + mWWWX;}
		public function get wwwy():String {return mName + index + "." + mWWWY;}
		public function get wwwz():String {return mName + index + "." + mWWWZ;}
		public function get wwww():String {return mName + index + "." + mWWWW;}
	}
}