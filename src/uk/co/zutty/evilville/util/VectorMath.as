package uk.co.zutty.evilville.util
{
    import flash.geom.Point;

    public class VectorMath {

        public function multiply(p:Point, scalar:Number):Point {
            p.x *= scalar;
            p.y *= scalar;
            return p;
        }
        
        public static function magnitude(p:Point):Number {
            return Math.sqrt(p.x*p.x + p.y*p.y);
        }

        public static function polar(angle:Number, mag:Number):Point {
            return new Point(Math.sin(angle) * mag, -Math.cos(angle) * mag);
        }

        public static function distance(ax:Number, ay:Number, bx:Number, by:Number):Number {
            var dx:Number = ax - bx;
            var dy:Number = ay - by;
            return Math.sqrt(dx*dx + dy*dy);
        }

        public static function unitVector(ax:Number, ay:Number, bx:Number, by:Number):Point {
            var x:Number = bx - ax;
            var y:Number = by - ay;
            var mag:Number = Math.sqrt(x*x + y*y);
            
            return new Point(x/mag, y/mag);
        }
        
        public static function intersect(ax1:Number, ay1:Number, ax2:Number, ay2:Number, bx1:Number, by1:Number, bx2:Number, by2:Number):Point {
            var a1:Number = ay2 - ay1;
            var b1:Number = ax1 - ax2;
            var c1:Number = a1*ax1 + b1*ay1;
            
            var a2:Number = by2 - by1;
            var b2:Number = bx1 - bx2;
            var c2:Number = a2*bx1 + b2*by1;
            
            var det:Number = a1*b2 - a2*b1;
            
            if(det == 0) {
                var mx:Number = (ax2 - ax1)/2 + ax1;
                var my:Number = (ay2 - ay1)/2 + ay1;
                
                return new Point(mx, my);
            } else {
                var x:Number = (b2*c1 - b1*c2) / det;
                var y:Number = (a1*c2 - a2*c1) / det;
                
                var onSegA:Boolean = pointInRect(x, y, ax1, ay1, ax2, ay2);
                var onSegB:Boolean = pointInRect(x, y, bx1, by1, bx2, by2);
                
                if(onSegA && onSegB) {
                    return new Point(x, y);
                } else {
                    return null;
                }
            }
        }
        
        public static function pointInRect(x:Number, y:Number, x1:Number, y1:Number, x2:Number, y2:Number):Boolean {
            var xMin:Number = Math.min(x1, x2); 
            var xMax:Number = Math.max(x1, x2);
            var yMin:Number = Math.min(y1, y2); 
            var yMax:Number = Math.max(y1, y2);
            
            return (xMin < x && x < xMax) && (yMin < y && y < yMax);
        }
    }
}