package skysand.render 
{
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyMacroShader 
	{
		private var string:String = "";
		
		public function SkyMacroShader() 
		{
			var vertexShader:String = "";
				vertexShader += "m44 op, va0, vc0 \n";
				vertexShader += "mov v0, va1 \n";//color
				vertexShader += "mov v1, va2";//uv
		}
		
		public function mov(destination:String, source:String):void
		{
			string += "mov " + destination + ", " + source// + " \n";
		}
		
		public function add(destination:String, source0:String, source1:String):void
		{
			string += "add " + destination + ", " + source0 + ", " + source1// + " \n";
		}
		
		public function sub(destination:String, source0:String, source1:String):void
		{
			string += "sub " + destination + ", " + source0 + ", " + source1// + " \n";
		}
		
		public function m44(destination:String, source0:String, source1:String):void
		{
			string += "m44 " + destination + ", " + source0 + ", " + source1// + " \n";
		}
		
		public function get result():String
		{
			return string;//.substr(0, string.length - 4);
		}
	}
}