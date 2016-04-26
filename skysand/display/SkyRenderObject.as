package skysand.display
{
	import adobe.utils.CustomActions;
	import flash.geom.Matrix;
	import skysand.render.hardware.SkyHardwareRender;
	import skysand.utils.SkyMath;
	
	public class SkyRenderObject extends Object
	{
		private static var DEPTH_COUNTER:Number;
		public var transformMatrix:Matrix
		
		private var _alpha:Number;
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _rotation:Number;
		private var _width:Number;
		private var _height:Number;
		public var _verteces:Vector.<Number>;
		public var globalX:Number = 0;
		public var globalY:Number = 0;
		public var localX:Number = 0;
		public var localY:Number = 0;
		private var _depth:Number;
		public var renderType:uint;
		public var uv:Vector.<Number>;
		public var textureName:String;
		public var atlasName:String;
		public var id:int;
		public var visible:Boolean;
		public var parent:SkyRenderObjectContainer;
		public var children:Vector.<SkyRenderObjectContainer>;
		protected var nChildren:int;
		private var vertecesIndex:int;
		
		public function SkyRenderObject()
		{
			textureName = "";
			atlasName = "";
			id = 0;
			visible = true;
			_depth = 0.01;
			_width = 512;
			_height = 512;
			transformMatrix = new Matrix();
			
			nChildren = 0;
		}
		
		public function setBatchVertices(vertices:Vector.<Number>, id:uint):void
		{
			//x y z
			_verteces = vertices;
			_verteces.push(0, 0, _depth);
			_verteces.push(512, 0, _depth);
			_verteces.push(0, 512, _depth);
			_verteces.push(512, 512, _depth);
			
			this.id = id;
			vertecesIndex = id * 12;
		}
		
		public function setSprite(textureName:String, spriteName:String = ""):void
		{
			//textureName = name;
			//atlasName = textureAtlas;
			
			SkyHardwareRender.instance.addObject(this, textureName, spriteName);
		}
		
		public function get x():Number
		{
			return localX;
		}
		
		public function updateChilds(child:SkyRenderObjectContainer):void
		{
			if (child.children != null)
			{
				for (var i:int = 0; i < child.children.length; i++) 
				{
					if(child.parent !=null) child.children[i].x += child.parent.x;
				}
			}
			
			/*child.localX = child.x + localX;
			
			if (_verteces)
			{
				
			}*/
		}
		
		public function set x(value:Number):void
		{
			globalX = parent ? parent.globalX + value : value;
			
			if (globalX != _verteces[vertecesIndex])
			{
				_verteces[vertecesIndex] = globalX;
				_verteces[vertecesIndex + 3] = globalX + _width;
				_verteces[vertecesIndex + 6] = globalX;
				_verteces[vertecesIndex + 9] = globalX + _width;
				
				if (children)
				{
					for (var i:int = 0; i < nChildren; i++) 
					{
						children[i].x = children[i].localX;
					}
				}
			}
			
			localX = value;
		}
		
		public function get y():Number
		{
			return localY;
		}
		
		public function set y(value:Number):void
		{
			globalY = parent ? parent.globalY + value : value;
			
			if (globalY != _verteces[vertecesIndex + 1])
			{
				_verteces[vertecesIndex + 1] = globalY;
				_verteces[vertecesIndex + 4] = globalY;
				_verteces[vertecesIndex + 7] = globalY + _height;
				_verteces[vertecesIndex + 10] = globalY + _height;
				
				if (children)
				{
					for (var i:int = 0; i < nChildren; i++) 
					{
						children[i].y = children[i].localY;
					}
				}
			}
			
			localY = value;
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			_scaleX = value;
		}
		
		public function get scaleY():Number 
		{
			return _scaleY;
		}
		
		public function set scaleY(value:Number):void 
		{
			_scaleY = value;
		}
		
		public function get rotation():Number 
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void 
		{
			value = SkyMath.toRadian(value);
			
			/*transformMatrix.identity();
			transformMatrix.tx = _verteces[0];
			transformMatrix.ty = _verteces[1];
			transformMatrix.rotate(value);
			
			_verteces[0] = transformMatrix.tx;
			_verteces[1] = transformMatrix.ty;
			
			transformMatrix.identity();
			transformMatrix.tx = _verteces[3];
			transformMatrix.ty = _verteces[4];
			transformMatrix.rotate(value);
			
			_verteces[3] = transformMatrix.tx;
			_verteces[4] = transformMatrix.ty;
			
			transformMatrix.identity();
			transformMatrix.tx = _verteces[6];
			transformMatrix.ty = _verteces[7];
			transformMatrix.rotate(value);
			
			_verteces[6] = transformMatrix.tx;
			_verteces[7] = transformMatrix.ty;
			
			transformMatrix.identity();
			transformMatrix.tx = _verteces[9];
			transformMatrix.ty = _verteces[10];
			transformMatrix.rotate(value);
			
			_verteces[9] = transformMatrix.tx;
			_verteces[10] = transformMatrix.ty;
			*/
			_rotation = value;
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function set width(value:Number):void 
		{
			//512
			//256
			//_verteces[id * 12] = value;
			_verteces[vertecesIndex + 3] = localX + value;
			//_verteces[id * 12 + 6] = value;
			_verteces[vertecesIndex + 9] = localX + value;
			
			_width = value;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
		public function set height(value:Number):void 
		{
			//_verteces[index + 1] = value;
			//_verteces[index + 4] = value;
			_verteces[vertecesIndex + 7] = localY + value;
			_verteces[vertecesIndex + 10] = localY + value;
			
			_height = value;
		}
		
		public function get verteces():Vector.<Number> 
		{
			return _verteces;
		}
		
		public function get depth():Number 
		{
			return _depth;
		}
		
		public function set depth(value:Number):void 
		{
			_verteces[2] = value;
			_verteces[5] = value;
			_verteces[8] = value;
			_verteces[11] = value;
			
			_depth = value;
		}
	}
}