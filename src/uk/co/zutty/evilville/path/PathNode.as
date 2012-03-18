package uk.co.zutty.evilville.path
{
	import uk.co.zutty.evilville.util.IPoint;

	public class PathNode extends IPoint {
		
		private var _pathLen:int;
		private var _cost:Number;
		private var _prev:PathNode;
		
		public function PathNode(x:int, y:int, pathLen:int, cost:Number, prev:PathNode) {
			super(x, y);
			_pathLen = pathLen;
			_cost = cost;
			_prev = prev;
		}
		
		public function get pathLen():int {
			return _pathLen;
		}

		public function get cost():Number {
			return _cost;
		}
		
		public function get prev():PathNode {
			return _prev;
		}
	}
}