package skysand.controller 
{
	public interface IControlable 
	{
		function update(delta_time:Number):void;
		function free():void;
	}
}