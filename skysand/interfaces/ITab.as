package skysand.interfaces 
{
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public interface ITab 
	{
		/**
		 * Действие на открытие вкладки.
		 */
		function onEnterTab():void;
		
		/**
		 * Действие при сворачивании вкладки.
		 */
		function onExitTab():void;
		
		/**
		 * Действие при закрытии вкладки.
		 */
		function onCloseTab():void;
	}
}