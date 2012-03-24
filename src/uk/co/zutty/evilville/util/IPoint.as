package uk.co.zutty.evilville.util
{
    import flash.geom.Point;

	public class IPoint {
		
		public static const p:IPoint = new IPoint(0, 0);
		
		public var x:int;
		public var y:int;
		
		public function IPoint(x:int, y:int) {
			set(x, y);
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
        
        public function zero():IPoint {
            return set(0, 0);
        }
		
		public function set(x:int, y:int):IPoint {
			this.x = x;
			this.y = y;
            return this;
		}
        
        public function setTo(p:IPoint):IPoint {
            x = p.x;
            y = p.y;
            return this;
        }

        public function magnitude():int {
            return Math.round(Math.sqrt(x*x + y*y));
        }
            
        public function normalise():IPoint {
            var mag:Number = Math.sqrt(x*x + y*y);
            x = Math.round(Number(x) / mag);
            y = Math.round(Number(y) / mag);
            return this;
        }
		
		public function distTo(p:IPoint):int {
			return dist(this, p);
		}
		
		public function distManhattanTo(p:IPoint):int {
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
			point.set(x, y);
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