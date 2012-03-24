package uk.co.zutty.evilville.entities
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Spritemap;
    
    import uk.co.zutty.evilville.util.IPoint;
    import uk.co.zutty.evilville.util.IRect;
    import uk.co.zutty.evilville.util.VectorMath;
    
    public class Mob extends Entity {
        
        private static const FRAME_RATE:Number = 16;
        
        private var _gfx:Spritemap;
        private var _hurtTick:uint = 0;
        protected var velocity:IPoint;
        public var facing:IPoint;
        
        public function Mob(img:Class, x:Number=0, y:Number=0) {
            super(x, y);
            
            type = "mob";
            collidable = true;
            facing = new IPoint(0, 1);
            setHitbox(32, 48, -16, -24);

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
        
        private function setAnim(moving:Boolean):void {
            var anim:String = moving ? "walk" : "stand";
            
            if(Math.abs(facing.x) > Math.abs(facing.y)) {
                if(facing.x < 0) {
                    anim += "_l";
                } else {
                    anim += "_r";
                }
            } else {
                if(facing.y < 0) {
                    anim += "_u";
                } else {
                    anim += "_d";
                }
            }
            
            _gfx.play(anim);
        }
        
        public function hit():void {
            _gfx.color = 0xFF0000;
            _hurtTick = 4;
        }
        
        override public function update():void {
            var moving:Boolean = velocity.x != 0 || velocity.y != 0;
            if(moving) {
                facing.setTo(velocity).normalise();
            }
            setAnim(moving);
            
            x += velocity.x;
            y += velocity.y;
            
            if(_hurtTick > 0) {
                --_hurtTick;
                if(_hurtTick == 0) {
                    _gfx.color = 0xFFFFFF;
                }
            }

            layer = -y - 24;

            super.update();
        }
    }
}