package skysand.render.shaders 
{
	import flash.display3D.Program3D;
	
	import skysand.render.SkyHardwareRender;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyBaseShaderList extends SkyShader
	{
		public static const SIMPLE_SHAPE:uint = 0;
		public static const SIMPLE_SPRITE:uint = 1;
		public static const SIMPLE_TEXT_FIELD:uint = 2;
		
		private var programs:Vector.<Program3D>
		
		public function SkyBaseShaderList() 
		{
			
		}
		
		private function createShapeProgram():void
		{
			m44(op, va(0), vc(0));
			mov(v(0), va(1));//color
			
			setAsVertex();
			
			mov(ft(0), v(0));
			mul(ft(0).xyz, ft(0).xyz, v(0).w);//alpha
			mov(oc, ft(0));
			
			setAsPixel();
			
			programs[SIMPLE_SHAPE] = compile(SkyHardwareRender.shaderVersion);
		}
		
		private function createSpriteProgram():void
		{
			m44(op, va(0), vc(0));
			mov(v(0), va(1));//color
			mov(v(1), va(2));//uv
			
			setAsVertex();
			
			tex(ft(0), v(1), fs(0));
			mul(ft(0), ft(0), v(0));//alpha
			mov(oc, ft(0));
			
			setAsPixel();
			
			programs[SIMPLE_SPRITE] = compile(SkyHardwareRender.shaderVersion);
		}
		
		private function createTextFieldProgram():void
		{
			m44(op, va(0), vc(0));
			mov(v(0), va(2));//uv
			mov(v(0).z, va(1).x);//alpha
			
			setAsVertex();
			
			tex(ft(0), v(0), fs(0));
			mul(ft(0), ft(0), v(0).z);//alpha multiply
			mov(oc, ft(0));
			
			setAsPixel();
			
			programs[SIMPLE_TEXT_FIELD] = compile(SkyHardwareRender.shaderVersion);
		}
		
		public function create():Program3D
		{
			m44(vt(0), va(0), vc(0));
			mov(op, vt(0));
			div(vt(0).xy, va(0).xy, vc(4).xy);
			//mul(vt(0).x, va(0).x, vc(0).x);
			//mul(vt(0).y, va(0).y, vc(1).y);
			//div(vt(0).xy, vt(0).xy, vc(4).zz);
			//neg(vt(0).y, vt(0).y);
			mov(v(0), vt(0).xyxy);
			//mov(v(0).z, vt(0).z);
			
			setAsVertex();
			//[1, 2, 0, 255];
			//sge(ft(2).x, od, v(0).z);
			//mov(ft(1), v(0).xyxy);
			//div(ft(1).xy, fc(0).xx, v(0).xy);
			tex(ft(0), v(0).xy, fs(0));
			mul(ft(0).xyz, ft(0).xyz, fc(0).w);
			div(ft(0).xyz, ft(0).xyz, fc(0).y);
			frc(ft(1).xyz, ft(0).xyz);
			mul(ft(0).xyz, ft(1).xyz, fc(0).y);
			seq(ft(0).xyz, ft(0).xyz, fc(0).x);
			seq(ft(0).w, ft(0).w, fc(0).z);
			//mul(ft(0), ft(0), v(1));
			mov(oc, ft(0));
			
			setAsPixel();
			return compile(4);
		}
		
		public function getList():Vector.<Program3D>
		{
			programs = new Vector.<Program3D>();
			createShapeProgram();
			createSpriteProgram();
			createTextFieldProgram();
			
			return programs;
		}
	}
}