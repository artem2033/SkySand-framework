package skysand.render 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyRegister 
	{
		private var name:String = "";
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
		
		public function SkyRegister(registerName:String) 
		{
			name = registerName;
		}
		
		public function get x():String {return name + "." + mX;}
		public function get y():String {return name + "." + mY;}
		public function get z():String {return name + "." + mZ;}
		public function get w():String {return name + "." + mW; }
		
		public function get xx():String {return name + "." + mXX;}
		public function get xy():String {return name + "." + mXY;}
		public function get xz():String {return name + "." + mXZ;}
		public function get xw():String {return name + "." + mXW;}
		public function get yx():String {return name + "." + mYX;}
		public function get yy():String {return name + "." + mYY;}
		public function get yz():String {return name + "." + mYZ;}
		public function get yw():String {return name + "." + mYW;}
		public function get zx():String {return name + "." + mZX;}
		public function get zy():String {return name + "." + mZY;}
		public function get zz():String {return name + "." + mZZ;}
		public function get zw():String {return name + "." + mZW;}
		public function get wx():String {return name + "." + mWX;}
		public function get wy():String {return name + "." + mWY;}
		public function get wz():String {return name + "." + mWZ;}
		public function get ww():String {return name + "." + mWW; }	
		
		public function get xxx():String {return name + "." + mXXX;}
		public function get xxy():String {return name + "." + mXXY;}
		public function get xxz():String {return name + "." + mXXZ;}
		public function get xxw():String {return name + "." + mXXW;}
		public function get xyx():String {return name + "." + mXYX;}
		public function get xyy():String {return name + "." + mXYY;}
		public function get xyz():String {return name + "." + mXYZ;}
		public function get xyw():String {return name + "." + mXYW;}
		public function get xzx():String {return name + "." + mXZX;}
		public function get xzy():String {return name + "." + mXZY;}
		public function get xzz():String {return name + "." + mXZZ;}
		public function get xzw():String {return name + "." + mXZW;}
		public function get xwx():String {return name + "." + mXWX;}
		public function get xwy():String {return name + "." + mXWY;}
		public function get xwz():String {return name + "." + mXWZ;}
		public function get xww():String {return name + "." + mXWW;}
		public function get yxx():String {return name + "." + mYXX;}
		public function get yxy():String {return name + "." + mYXY;}
		public function get yxz():String {return name + "." + mYXZ;}
		public function get yxw():String {return name + "." + mYXW;}
		public function get yyx():String {return name + "." + mYYX;}
		public function get yyy():String {return name + "." + mYYY;}
		public function get yyz():String {return name + "." + mYYZ;}
		public function get yyw():String {return name + "." + mYYW;}
		public function get yzx():String {return name + "." + mYZX;}
		public function get yzy():String {return name + "." + mYZY;}
		public function get yzz():String {return name + "." + mYZZ;}
		public function get yzw():String {return name + "." + mYZW;}
		public function get ywx():String {return name + "." + mYWX;}
		public function get ywy():String {return name + "." + mYWY;}
		public function get ywz():String {return name + "." + mYWZ;}
		public function get yww():String {return name + "." + mYWW;}
		public function get zxx():String {return name + "." + mZXX;}
		public function get zxy():String {return name + "." + mZXY;}
		public function get zxz():String {return name + "." + mZXZ;}
		public function get zxw():String {return name + "." + mZXW;}
		public function get zyx():String {return name + "." + mZYX;}
		public function get zyy():String {return name + "." + mZYY;}
		public function get zyz():String {return name + "." + mZYZ;}
		public function get zyw():String {return name + "." + mZYW;}
		public function get zzx():String {return name + "." + mZZX;}
		public function get zzy():String {return name + "." + mZZY;}
		public function get zzz():String {return name + "." + mZZZ;}
		public function get zzw():String {return name + "." + mZZW;}
		public function get zwx():String {return name + "." + mZWX;}
		public function get zwy():String {return name + "." + mZWY;}
		public function get zwz():String {return name + "." + mZWZ;}
		public function get zww():String {return name + "." + mZWW;}
		public function get wxx():String {return name + "." + mWXX;}
		public function get wxy():String {return name + "." + mWXY;}
		public function get wxz():String {return name + "." + mWXZ;}
		public function get wxw():String {return name + "." + mWXW;}
		public function get wyx():String {return name + "." + mWYX;}
		public function get wyy():String {return name + "." + mWYY;}
		public function get wyz():String {return name + "." + mWYZ;}
		public function get wyw():String {return name + "." + mWYW;}
		public function get wzx():String {return name + "." + mWZX;}
		public function get wzy():String {return name + "." + mWZY;}
		public function get wzz():String {return name + "." + mWZZ;}
		public function get wzw():String {return name + "." + mWZW;}
		public function get wwx():String {return name + "." + mWWX;}
		public function get wwy():String {return name + "." + mWWY;}
		public function get wwz():String {return name + "." + mWWZ;}
		public function get www():String {return name + "." + mWWW;}
		public function get xxxx():String {return name + "." + mXXXX;}
		public function get xxxy():String {return name + "." + mXXXY;}
		public function get xxxz():String {return name + "." + mXXXZ;}
		public function get xxxw():String {return name + "." + mXXXW;}
		public function get xxyx():String {return name + "." + mXXYX;}
		public function get xxyy():String {return name + "." + mXXYY;}
		public function get xxyz():String {return name + "." + mXXYZ;}
		public function get xxyw():String {return name + "." + mXXYW;}
		public function get xxzx():String {return name + "." + mXXZX;}
		public function get xxzy():String {return name + "." + mXXZY;}
		public function get xxzz():String {return name + "." + mXXZZ;}
		public function get xxzw():String {return name + "." + mXXZW;}
		public function get xxwx():String {return name + "." + mXXWX;}
		public function get xxwy():String {return name + "." + mXXWY;}
		public function get xxwz():String {return name + "." + mXXWZ;}
		public function get xxww():String {return name + "." + mXXWW;}
		public function get xyxx():String {return name + "." + mXYXX;}
		public function get xyxy():String {return name + "." + mXYXY;}
		public function get xyxz():String {return name + "." + mXYXZ;}
		public function get xyxw():String {return name + "." + mXYXW;}
		public function get xyyx():String {return name + "." + mXYYX;}
		public function get xyyy():String {return name + "." + mXYYY;}
		public function get xyyz():String {return name + "." + mXYYZ;}
		public function get xyyw():String {return name + "." + mXYYW;}
		public function get xyzx():String {return name + "." + mXYZX;}
		public function get xyzy():String {return name + "." + mXYZY;}
		public function get xyzz():String {return name + "." + mXYZZ;}
		public function get xyzw():String {return name + "." + mXYZW;}
		public function get xywx():String {return name + "." + mXYWX;}
		public function get xywy():String {return name + "." + mXYWY;}
		public function get xywz():String {return name + "." + mXYWZ;}
		public function get xyww():String {return name + "." + mXYWW;}
		public function get xzxx():String {return name + "." + mXZXX;}
		public function get xzxy():String {return name + "." + mXZXY;}
		public function get xzxz():String {return name + "." + mXZXZ;}
		public function get xzxw():String {return name + "." + mXZXW;}
		public function get xzyx():String {return name + "." + mXZYX;}
		public function get xzyy():String {return name + "." + mXZYY;}
		public function get xzyz():String {return name + "." + mXZYZ;}
		public function get xzyw():String {return name + "." + mXZYW;}
		public function get xzzx():String {return name + "." + mXZZX;}
		public function get xzzy():String {return name + "." + mXZZY;}
		public function get xzzz():String {return name + "." + mXZZZ;}
		public function get xzzw():String {return name + "." + mXZZW;}
		public function get xzwx():String {return name + "." + mXZWX;}
		public function get xzwy():String {return name + "." + mXZWY;}
		public function get xzwz():String {return name + "." + mXZWZ;}
		public function get xzww():String {return name + "." + mXZWW;}
		public function get xwxx():String {return name + "." + mXWXX;}
		public function get xwxy():String {return name + "." + mXWXY;}
		public function get xwxz():String {return name + "." + mXWXZ;}
		public function get xwxw():String {return name + "." + mXWXW;}
		public function get xwyx():String {return name + "." + mXWYX;}
		public function get xwyy():String {return name + "." + mXWYY;}
		public function get xwyz():String {return name + "." + mXWYZ;}
		public function get xwyw():String {return name + "." + mXWYW;}
		public function get xwzx():String {return name + "." + mXWZX;}
		public function get xwzy():String {return name + "." + mXWZY;}
		public function get xwzz():String {return name + "." + mXWZZ;}
		public function get xwzw():String {return name + "." + mXWZW;}
		public function get xwwx():String {return name + "." + mXWWX;}
		public function get xwwy():String {return name + "." + mXWWY;}
		public function get xwwz():String {return name + "." + mXWWZ;}
		public function get xwww():String {return name + "." + mXWWW;}
		public function get yxxx():String {return name + "." + mYXXX;}
		public function get yxxy():String {return name + "." + mYXXY;}
		public function get yxxz():String {return name + "." + mYXXZ;}
		public function get yxxw():String {return name + "." + mYXXW;}
		public function get yxyx():String {return name + "." + mYXYX;}
		public function get yxyy():String {return name + "." + mYXYY;}
		public function get yxyz():String {return name + "." + mYXYZ;}
		public function get yxyw():String {return name + "." + mYXYW;}
		public function get yxzx():String {return name + "." + mYXZX;}
		public function get yxzy():String {return name + "." + mYXZY;}
		public function get yxzz():String {return name + "." + mYXZZ;}
		public function get yxzw():String {return name + "." + mYXZW;}
		public function get yxwx():String {return name + "." + mYXWX;}
		public function get yxwy():String {return name + "." + mYXWY;}
		public function get yxwz():String {return name + "." + mYXWZ;}
		public function get yxww():String {return name + "." + mYXWW;}
		public function get yyxx():String {return name + "." + mYYXX;}
		public function get yyxy():String {return name + "." + mYYXY;}
		public function get yyxz():String {return name + "." + mYYXZ;}
		public function get yyxw():String {return name + "." + mYYXW;}
		public function get yyyx():String {return name + "." + mYYYX;}
		public function get yyyy():String {return name + "." + mYYYY;}
		public function get yyyz():String {return name + "." + mYYYZ;}
		public function get yyyw():String {return name + "." + mYYYW;}
		public function get yyzx():String {return name + "." + mYYZX;}
		public function get yyzy():String {return name + "." + mYYZY;}
		public function get yyzz():String {return name + "." + mYYZZ;}
		public function get yyzw():String {return name + "." + mYYZW;}
		public function get yywx():String {return name + "." + mYYWX;}
		public function get yywy():String {return name + "." + mYYWY;}
		public function get yywz():String {return name + "." + mYYWZ;}
		public function get yyww():String {return name + "." + mYYWW;}
		public function get yzxx():String {return name + "." + mYZXX;}
		public function get yzxy():String {return name + "." + mYZXY;}
		public function get yzxz():String {return name + "." + mYZXZ;}
		public function get yzxw():String {return name + "." + mYZXW;}
		public function get yzyx():String {return name + "." + mYZYX;}
		public function get yzyy():String {return name + "." + mYZYY;}
		public function get yzyz():String {return name + "." + mYZYZ;}
		public function get yzyw():String {return name + "." + mYZYW;}
		public function get yzzx():String {return name + "." + mYZZX;}
		public function get yzzy():String {return name + "." + mYZZY;}
		public function get yzzz():String {return name + "." + mYZZZ;}
		public function get yzzw():String {return name + "." + mYZZW;}
		public function get yzwx():String {return name + "." + mYZWX;}
		public function get yzwy():String {return name + "." + mYZWY;}
		public function get yzwz():String {return name + "." + mYZWZ;}
		public function get yzww():String {return name + "." + mYZWW;}
		public function get ywxx():String {return name + "." + mYWXX;}
		public function get ywxy():String {return name + "." + mYWXY;}
		public function get ywxz():String {return name + "." + mYWXZ;}
		public function get ywxw():String {return name + "." + mYWXW;}
		public function get ywyx():String {return name + "." + mYWYX;}
		public function get ywyy():String {return name + "." + mYWYY;}
		public function get ywyz():String {return name + "." + mYWYZ;}
		public function get ywyw():String {return name + "." + mYWYW;}
		public function get ywzx():String {return name + "." + mYWZX;}
		public function get ywzy():String {return name + "." + mYWZY;}
		public function get ywzz():String {return name + "." + mYWZZ;}
		public function get ywzw():String {return name + "." + mYWZW;}
		public function get ywwx():String {return name + "." + mYWWX;}
		public function get ywwy():String {return name + "." + mYWWY;}
		public function get ywwz():String {return name + "." + mYWWZ;}
		public function get ywww():String {return name + "." + mYWWW;}
		public function get zxxx():String {return name + "." + mZXXX;}
		public function get zxxy():String {return name + "." + mZXXY;}
		public function get zxxz():String {return name + "." + mZXXZ;}
		public function get zxxw():String {return name + "." + mZXXW;}
		public function get zxyx():String {return name + "." + mZXYX;}
		public function get zxyy():String {return name + "." + mZXYY;}
		public function get zxyz():String {return name + "." + mZXYZ;}
		public function get zxyw():String {return name + "." + mZXYW;}
		public function get zxzx():String {return name + "." + mZXZX;}
		public function get zxzy():String {return name + "." + mZXZY;}
		public function get zxzz():String {return name + "." + mZXZZ;}
		public function get zxzw():String {return name + "." + mZXZW;}
		public function get zxwx():String {return name + "." + mZXWX;}
		public function get zxwy():String {return name + "." + mZXWY;}
		public function get zxwz():String {return name + "." + mZXWZ;}
		public function get zxww():String {return name + "." + mZXWW;}
		public function get zyxx():String {return name + "." + mZYXX;}
		public function get zyxy():String {return name + "." + mZYXY;}
		public function get zyxz():String {return name + "." + mZYXZ;}
		public function get zyxw():String {return name + "." + mZYXW;}
		public function get zyyx():String {return name + "." + mZYYX;}
		public function get zyyy():String {return name + "." + mZYYY;}
		public function get zyyz():String {return name + "." + mZYYZ;}
		public function get zyyw():String {return name + "." + mZYYW;}
		public function get zyzx():String {return name + "." + mZYZX;}
		public function get zyzy():String {return name + "." + mZYZY;}
		public function get zyzz():String {return name + "." + mZYZZ;}
		public function get zyzw():String {return name + "." + mZYZW;}
		public function get zywx():String {return name + "." + mZYWX;}
		public function get zywy():String {return name + "." + mZYWY;}
		public function get zywz():String {return name + "." + mZYWZ;}
		public function get zyww():String {return name + "." + mZYWW;}
		public function get zzxx():String {return name + "." + mZZXX;}
		public function get zzxy():String {return name + "." + mZZXY;}
		public function get zzxz():String {return name + "." + mZZXZ;}
		public function get zzxw():String {return name + "." + mZZXW;}
		public function get zzyx():String {return name + "." + mZZYX;}
		public function get zzyy():String {return name + "." + mZZYY;}
		public function get zzyz():String {return name + "." + mZZYZ;}
		public function get zzyw():String {return name + "." + mZZYW;}
		public function get zzzx():String {return name + "." + mZZZX;}
		public function get zzzy():String {return name + "." + mZZZY;}
		public function get zzzz():String {return name + "." + mZZZZ;}
		public function get zzzw():String {return name + "." + mZZZW;}
		public function get zzwx():String {return name + "." + mZZWX;}
		public function get zzwy():String {return name + "." + mZZWY;}
		public function get zzwz():String {return name + "." + mZZWZ;}
		public function get zzww():String {return name + "." + mZZWW;}
		public function get zwxx():String {return name + "." + mZWXX;}
		public function get zwxy():String {return name + "." + mZWXY;}
		public function get zwxz():String {return name + "." + mZWXZ;}
		public function get zwxw():String {return name + "." + mZWXW;}
		public function get zwyx():String {return name + "." + mZWYX;}
		public function get zwyy():String {return name + "." + mZWYY;}
		public function get zwyz():String {return name + "." + mZWYZ;}
		public function get zwyw():String {return name + "." + mZWYW;}
		public function get zwzx():String {return name + "." + mZWZX;}
		public function get zwzy():String {return name + "." + mZWZY;}
		public function get zwzz():String {return name + "." + mZWZZ;}
		public function get zwzw():String {return name + "." + mZWZW;}
		public function get zwwx():String {return name + "." + mZWWX;}
		public function get zwwy():String {return name + "." + mZWWY;}
		public function get zwwz():String {return name + "." + mZWWZ;}
		public function get zwww():String {return name + "." + mZWWW;}
		public function get wxxx():String {return name + "." + mWXXX;}
		public function get wxxy():String {return name + "." + mWXXY;}
		public function get wxxz():String {return name + "." + mWXXZ;}
		public function get wxxw():String {return name + "." + mWXXW;}
		public function get wxyx():String {return name + "." + mWXYX;}
		public function get wxyy():String {return name + "." + mWXYY;}
		public function get wxyz():String {return name + "." + mWXYZ;}
		public function get wxyw():String {return name + "." + mWXYW;}
		public function get wxzx():String {return name + "." + mWXZX;}
		public function get wxzy():String {return name + "." + mWXZY;}
		public function get wxzz():String {return name + "." + mWXZZ;}
		public function get wxzw():String {return name + "." + mWXZW;}
		public function get wxwx():String {return name + "." + mWXWX;}
		public function get wxwy():String {return name + "." + mWXWY;}
		public function get wxwz():String {return name + "." + mWXWZ;}
		public function get wxww():String {return name + "." + mWXWW;}
		public function get wyxx():String {return name + "." + mWYXX;}
		public function get wyxy():String {return name + "." + mWYXY;}
		public function get wyxz():String {return name + "." + mWYXZ;}
		public function get wyxw():String {return name + "." + mWYXW;}
		public function get wyyx():String {return name + "." + mWYYX;}
		public function get wyyy():String {return name + "." + mWYYY;}
		public function get wyyz():String {return name + "." + mWYYZ;}
		public function get wyyw():String {return name + "." + mWYYW;}
		public function get wyzx():String {return name + "." + mWYZX;}
		public function get wyzy():String {return name + "." + mWYZY;}
		public function get wyzz():String {return name + "." + mWYZZ;}
		public function get wyzw():String {return name + "." + mWYZW;}
		public function get wywx():String {return name + "." + mWYWX;}
		public function get wywy():String {return name + "." + mWYWY;}
		public function get wywz():String {return name + "." + mWYWZ;}
		public function get wyww():String {return name + "." + mWYWW;}
		public function get wzxx():String {return name + "." + mWZXX;}
		public function get wzxy():String {return name + "." + mWZXY;}
		public function get wzxz():String {return name + "." + mWZXZ;}
		public function get wzxw():String {return name + "." + mWZXW;}
		public function get wzyx():String {return name + "." + mWZYX;}
		public function get wzyy():String {return name + "." + mWZYY;}
		public function get wzyz():String {return name + "." + mWZYZ;}
		public function get wzyw():String {return name + "." + mWZYW;}
		public function get wzzx():String {return name + "." + mWZZX;}
		public function get wzzy():String {return name + "." + mWZZY;}
		public function get wzzz():String {return name + "." + mWZZZ;}
		public function get wzzw():String {return name + "." + mWZZW;}
		public function get wzwx():String {return name + "." + mWZWX;}
		public function get wzwy():String {return name + "." + mWZWY;}
		public function get wzwz():String {return name + "." + mWZWZ;}
		public function get wzww():String {return name + "." + mWZWW;}
		public function get wwxx():String {return name + "." + mWWXX;}
		public function get wwxy():String {return name + "." + mWWXY;}
		public function get wwxz():String {return name + "." + mWWXZ;}
		public function get wwxw():String {return name + "." + mWWXW;}
		public function get wwyx():String {return name + "." + mWWYX;}
		public function get wwyy():String {return name + "." + mWWYY;}
		public function get wwyz():String {return name + "." + mWWYZ;}
		public function get wwyw():String {return name + "." + mWWYW;}
		public function get wwzx():String {return name + "." + mWWZX;}
		public function get wwzy():String {return name + "." + mWWZY;}
		public function get wwzz():String {return name + "." + mWWZZ;}
		public function get wwzw():String {return name + "." + mWWZW;}
		public function get wwwx():String {return name + "." + mWWWX;}
		public function get wwwy():String {return name + "." + mWWWY;}
		public function get wwwz():String {return name + "." + mWWWZ;}
		public function get wwww():String {return name + "." + mWWWW;}
	}
}