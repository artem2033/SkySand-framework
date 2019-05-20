package skysand.display 
{
	import flash.geom.Point;
	
	import skysand.input.SkyMouse;
	import skysand.render.SkyHardwareRender;
	
	/**
	 * ...
	 * @author CodeCoreGames
	 */
	public class SkyRenderObjectContainer extends SkyRenderObject
	{
		/**
		 * Массив дочерних объектов.
		 */
		public var children:Vector.<SkyRenderObjectContainer>;
		
		/**
		 * Количество детей.
		 */
		private var nChildren:int;
		
		public function SkyRenderObjectContainer() 
		{
			nChildren = 0;
			parent = null;
			children = null;
		}
		
		/**
		 * Добавить объект в конец списка отображения.
		 * @param	child объект для отрисовки.
		 */
		public function addChild(child:SkyRenderObjectContainer):void
		{
			if (children == null) children = new Vector.<SkyRenderObjectContainer>();
			
			child.parent = this;
			children.push(child);
			
			child.init();
			child.isAdded = true;
			
			SkyHardwareRender.instance.addObjectToRender(child);
			SkyHardwareRender.instance.updateDepth = true;
			SkyMouse.instance.addObjectToClosestTest(child);
			
			nChildren++;
		}
		
		/**
		 * Добавить объект в список отображения на определённую позицию.
		 * @param	child объект для отрисовки.
		 * @param	index позиция от 0 до numChildren.
		 */
		public function addChildAt(child:SkyRenderObjectContainer, index:int):void
		{
			index = index < 0 ? 0 : index >= nChildren ? nChildren : index;
			
			if (!children) children = new Vector.<SkyRenderObjectContainer>();
			
			if (children.indexOf(child) > -1) return;
			
			if (child.parent) child.parent.removeChild(child);
			
			child.parent = this;
			children.insertAt(index, child);
			child.init();
			child.isAdded = true;
			
			SkyHardwareRender.instance.addObjectToRender(child);
			SkyHardwareRender.instance.updateDepth = true;
			SkyMouse.instance.addObjectToClosestTest(child);
			
			nChildren++;
		}
		
		/**
		 * Получить номер дочернего объекта.
		 * @param	child дочерний объект.
		 * @return возвращает номер объекта.
		 */
		public function getChildIndex(child:SkyRenderObjectContainer):int
		{
			if (children == null) return -1;
			
			return children.indexOf(child);
		}
		
		/**
		 * Получить массив всех объектов под определённой точкой.
		 * @param	point точка.
		 * @return возвращает массив дочерних объектов.
		 */
		public function getChildsUnderPoint(x:Number, y:Number):Vector.<SkyRenderObject>
		{
			var childs:Vector.<SkyRenderObject> = new Vector.<SkyRenderObject>();
			
			for (var i:int = 0; i < nChildren; i++) 
			{
				if (children[i].hitTestPoint(x, y)) childs.push(children[i]);
			}
			
			return childs;
		}
		
		/**
		 * Получить дочерний объект с определённым номером.
		 * @param	index номер объекта.
		 * @return возвращает объект, если он есть в массиве.
		 */
		public function getChildAt(index:int):SkyRenderObjectContainer
		{
			if (children == null) return null;
			
			if (index < 0 || index >= nChildren)
			{
				throw new Error("Ошибка, элемента с номером " + index + " нет в массиве!");
			}
			
			return children[index];
		}
		
		/**
		 * Содержит ли данный дочерний объект, другой дочерний объект.
		 * @param	child объект который нужно проверить.
		 * @return возращает true, если объект содержиться, false, если нет.
		 */
		public function contains(child:SkyRenderObjectContainer):Boolean
		{
			if (children == null) return false;
			if (children.indexOf(child) < 0) return false;
			
			return true;
		}
		
		/**
		 * Удалить объект из списка отображения.
		 * @param	child удаляемый объект.
		 */
		public function removeChild(child:SkyRenderObjectContainer):void
		{
			if (children == null) return;
			
			var index:int = children.indexOf(child);
			
			if (index == -1) return;
			
			children[index] = null;
			children.removeAt(index);
			
			child.isAdded = false;
			child.remove();
			
			SkyHardwareRender.instance.removeObjectFromRender(child);
			SkyHardwareRender.instance.updateDepth = true;
			SkyMouse.instance.removeObjectFromClosestTest(child);
			
			nChildren--;
		}
		
		/**
		 * Удалить дочерний объект через его номер.
		 * @param	index номер объекта в списке от 0 до numChildren.
		 */
		public function removeChildAt(index:int):void
		{
			if (children == null) return;
			
			if (index < 0 || index > nChildren)
			{
				throw new Error("Ошибка, элемента с номером " + index + " нет в массиве!");
			}
			
			children[index].remove();
			
			SkyHardwareRender.instance.removeObjectFromRender(children[index]);
			SkyHardwareRender.instance.updateDepth = true;
			SkyMouse.instance.removeObjectFromClosestTest(children[index]);
			
			children[index].isAdded = false;
			children[index] = null;
			children.removeAt(index);
			nChildren--;
		}
		
		/**
		 * Удалить дочерние объекты в интервале от beginIndex до endIndex.
		 * @param	beginIndex начальный номер с которого начинать удалять дочерние объекты.
		 * @param	endIndex конечный номер до которого удалять дочерние объекты, не включая последний.
		 */
		public function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			if (children == null) return;
			
			beginIndex = beginIndex < 0 ? 0 : beginIndex > nChildren ? nChildren : beginIndex;
			endIndex = endIndex < beginIndex ? beginIndex : endIndex > nChildren ? nChildren : endIndex;
			
			for (var i:int = beginIndex; i < endIndex; i++) 
			{
				removeChildAt(i);
				i--;
				endIndex--;
			}
		}
		
		/**
		 * Поменять местами дочерние объекты в массиве.
		 * @param	child0 первый объект.
		 * @param	child1 второй объект.
		 */
		public function swapChildren(child0:SkyRenderObjectContainer, child1:SkyRenderObjectContainer):void
		{
			if (children == null) return;
			
			var index0:int = children.indexOf(child0);
			var index1:int = children.indexOf(child1);
			
			if (index0 < 0 || index1 < 0) return;
			
			var temp:SkyRenderObjectContainer = children[index0];
			children[index0] = children[index1];
			children[index1] = temp;
			
			var t:uint = child0.depth;
			child0.depth = child1.depth;
			child1.depth = t;
			
			SkyMouse.instance.sortMouseChilds();
			SkyHardwareRender.instance.updateDepth = true;
		}
		
		/**
		 * Поменять местами дочерние объекты в массиве через их номера.
		 * @param	index0 номер первого объекта.
		 * @param	index1 номер второго объекта.
		 */
		public function swapChildrenAt(index0:int, index1:int):void
		{
			if (children == null) return;
			
			if ((index0 || index1) < 0 || (index0 || index1) > nChildren) return;
			
			var temp:SkyRenderObjectContainer = children[index0];
			children[index0] = children[index1];
			children[index1] = temp;
			
			var t:uint = children[index0].depth;
			children[index0].depth = children[index1].depth;
			children[index1].depth = t;
			
			SkyMouse.instance.sortMouseChilds();
			SkyHardwareRender.instance.updateDepth = true;
		}
		
		/**
		 * Получить количество детей в контейнере.
		 */
		public function get numChildren():int
		{
			return nChildren;
		}
	}
}