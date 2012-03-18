package uk.co.zutty.evilville.util
{
	public class IPoint {
		
		public static const p:IPoint = new IPoint(0, 0);
		
		public var x:int;
		public var y:int;
		
		public function IPoint(x:int, y:int) {
			setTo(x, y);
		}
		
		public function hash():String {
			return "["+x+","+y+"]";
		}
        
        public function add(x:int, y:int):IPoint {
            this.x += x;
            this.y += y;
            return this;
        }
        
        public function multiply(m:int):IPoint {
            x *= m;
            y *= m;
            return this;
        }
		
		public function setTo(x:int, y:int):void {
			this.x = x;
			this.y = y;
		}
		
		public function distFrom(p:IPoint):int {
			return dist(this, p);
		}
		
		public function distFromManhattan(p:IPoint):int {
			return distManhattan(this, p);
		}
		
		public function get neighbors():Array {
			return [_rel(0,-1), _rel(0,1), _rel(-1,0), _rel(1,0)];
		}
		
		private function _rel(dx:int, dy:int):IPoint {
			return new IPoint(x + dx, y + dy);
		}
		
		public static function set(x:int, y:int, point:IPoint = null):IPoint {
			if(point == null) {
				point = p;
			}
			point.setTo(x, y);
			return point;
		}
		
		public static function dist(a:IPoint, b:IPoint):int {
			var dx:Number = Number(b.x - a.x);
			var dy:Number = Number(b.y - a.y);
			return Math.sqrt(dx*dx + dy*dy);
		}
	
		public static function distManhattan(a:IPoint, b:IPoint):uint {
			return Math.abs(b.x - a.x) + Math.abs(b.y - a.y);
		}
        
        public static function polarUnitVector(angle:Number):IPoint {
            return new IPoint(Math.round(Math.sin(angle)), Math.round(-Math.cos(angle)));
        }
	}
}