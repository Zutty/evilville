package uk.co.zutty.evilville.path
{
	import flash.utils.Dictionary;
	
	import uk.co.zutty.evilville.util.IPoint;

	public class Pathfinder {

		private var _pathableCallback:Function;
		private var _open:Array;
		private var _closed:Object;

		public function Pathfinder(pathableCallback:Function) {
			_pathableCallback = pathableCallback;
			_open = [];
			_closed = new Object();
		}
		
		public function reset():void {
			_open.length = 0;
			_closed.length = 0;
		}
		
		public function findPath(start:IPoint, goal:IPoint):Vector.<IPoint> {
			reset();
			openNode(start, goal);
			
			while(_open.length > 0) {
				var n:PathNode = _open.shift();
				trace("->"+n.x+","+n.y);
				
				if(n.x == goal.x && n.y == goal.y) {
					return walk(n);
				}

				// Close the node
				_closed[n.hash()] = 1;
				
				for each(var m:IPoint in getNeighbors(n)) {
					if(!_closed.hasOwnProperty(m.hash()) && _pathableCallback(m)) {
						openNode(m, goal, n);
					}
				}
				
				_open.sortOn("cost");
			}
			
			// No path found
			return null;
		}
		
		public function walk(node:PathNode):Vector.<IPoint> {
			var path:Vector.<IPoint> = new Vector.<IPoint>();
			var n:PathNode = node;

			do {
				path.unshift(n);
				n = n.prev;
			} while(n.prev != null);

			return path;
		}
		
		public function getNeighbors(n:IPoint):Array {
			return n.neighbors;
		}
		
		public function openNode(p:IPoint, goal:IPoint, prev:PathNode = null):void {
			var pathLen:int = (prev == null) ? 0 : prev.pathLen + 1;
			var cost:int = IPoint.distManhattan(p, goal);
			_open[_open.length] = new PathNode(p.x, p.y, pathLen, pathLen + cost, prev);
		}
	}
}