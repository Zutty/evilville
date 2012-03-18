package uk.co.zutty.evilville.levels
{
	import uk.co.zutty.evilville.util.IPoint;

	public class Room {
		
		private var _x:uint;
		private var _y:uint;
		private var _width:uint;
		private var _height:uint;
		private var _exits:Array;
		
		public function Room(x:uint, y:uint, w:uint, h:uint) {
			_x = x;
			_y = y;
			_width = w;
			_height = h;
			_exits = [];
		}
		
		public function get x():uint {
			return _x;
		}

		public function get y():uint {
			return _y;
		}
		
		public function get width():uint {
			return _width;
		}
		
		public function get height():uint {
			return _height;
		}
		
		public function addExit(exit:IPoint):void {
			_exits.push(exit);
		}
		
		public function get exits():Array {
			return _exits;
		}
		
		public function closestExit(p:IPoint):IPoint {
			var closest:IPoint;
			var closestDist:Number = Number.MAX_VALUE;
			
			var dist:Number;
			for each(var e:IPoint in exits) {
				dist = p.distFrom(e);
				if(dist < closestDist) {
					closestDist = dist;
					closest = e;
				}
			}
			
			return closest;
		}
	}
}