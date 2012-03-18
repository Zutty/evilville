package uk.co.zutty.evilville.entities
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Spritemap;
    
    import uk.co.zutty.evilville.util.IPoint;
    import uk.co.zutty.evilville.util.VectorMath;
    
    public class Mob extends Entity {
        
        private static const FRAME_RATE:Number = 16;
        
        private var _gfx:Spritemap;
        protected var velocity:IPoint;
        
        public function Mob(img:Class, x:Number=0, y:Number=0) {
            super(x, y);
            
            layer = 100;
            
            _gfx = new Spritemap(img, 48, 48);
            _gfx.add("stand_l", [0], FRAME_RATE, false);
            _gfx.add("stand_r", [5], FRAME_RATE, false);
            _gfx.add("stand_d", [10], FRAME_RATE, false);
            _gfx.add("stand_u", [15], FRAME_RATE, false);
            _gfx.add("walk_l", [1,2,3,4], FRAME_RATE, true);
            _gfx.add("walk_r", [6,7,8,9], FRAME_RATE, true);
            _gfx.add("walk_d", [11,12,13,14], FRAME_RATE, true);
            _gfx.add("walk_u", [16,17,18,19], FRAME_RATE, true);
            _gfx.centerOrigin();
            graphic = _gfx;
            _gfx.play("stand_l");
            
            velocity = new IPoint(0, 0);
        }
        
        private function walk():void {
            if(Math.abs(velocity.x) > Math.abs(velocity.y)) {
                if(velocity.x < 0) {
                    _gfx.play("walk_l");
                } else {
                    _gfx.play("walk_r");
                }
            } else {
                if(velocity.y < 0) {
                    _gfx.play("walk_u");
                } else {
                    _gfx.play("walk_d");
                }
            }
        }
                
        private function stand():void {
            switch(_gfx.currentAnim) {
                case "walk_l":
                    _gfx.play("stand_l");
                    return;
                case "walk_r":
                    _gfx.play("stand_r");
                    return;
                case "walk_d":
                    _gfx.play("stand_d");
                    return;
                case "walk_u":
                    _gfx.play("stand_u");
                    return;
            }
        }
        
        override public function update():void {
            if(velocity.x == 0 && velocity.y == 0) {
                stand();
            } else {
                walk();
                x += velocity.x;
                y += velocity.y;
            }
            
            super.update();
        }
    }
}