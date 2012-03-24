package uk.co.zutty.evilville.entities
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Spritemap;
    
    import uk.co.zutty.evilville.supplier.Suppliable;
    import uk.co.zutty.evilville.util.IPoint;
    import uk.co.zutty.evilville.util.IRect;
    import uk.co.zutty.evilville.util.VectorMath;
    
    public class Mob extends Suppliable {
        
        private static const FRAME_RATE:Number = 16;
        
        private var _gfx:Spritemap;
        private var _hurtTick:uint = 0;
        private var _move:IPoint;

        private var _facing:IPoint;
        private var _health:Number;
        private var _maxHealth:Number;
        
        public function Mob(img:Class, maxHealth:Number) {
            super();
            
            _maxHealth = maxHealth;
            _move = new IPoint(0, 0);
            _facing = new IPoint(0, 1);

            type = "mob";
            collidable = true;
            setHitbox(24, 32, -16, -24);

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
            
            despawn();
        }
        
        public function get move():IPoint {
            return _move;
        }
        
        public function get moving():Boolean {
            return _move.x != 0 || _move.y != 0;
        }
        
        public function setMovement(p:IPoint, speed:Number):void {
            var dist:Number = VectorMath.distance(p.x, p.y, x, y);
            
            if(dist <= speed) {
                x = p.x;
                y = p.y;
                move.zero();
            } else {
                move.set(p.x - x, p.y - y).normalise().multiply(speed);
            }
        }
        
        public function get facing():IPoint {
            return _facing;
        }
        
        public function get health():Number {
            return _health;
        }

        public function get maxHealth():Number {
            return _maxHealth;
        }

        private function setAnim(moving:Boolean):void {
            var anim:String = moving ? "walk" : "stand";
            
            if(Math.abs(_facing.x) > Math.abs(_facing.y)) {
                if(_facing.x < 0) {
                    anim += "_l";
                } else {
                    anim += "_r";
                }
            } else {
                if(_facing.y < 0) {
                    anim += "_u";
                } else {
                    anim += "_d";
                }
            }
            
            _gfx.play(anim);
        }
        
        override public function spawn(x:Number, y:Number):void {
            super.spawn(x, y);
            _health = _maxHealth;
            _facing.set(0, 1);
            _move.set(0, 0);
        }

        public function hit(dmg:Number):void {
            _gfx.color = 0xFF0000;
            _hurtTick = 4;
            
            _health -= dmg;
            if(_health <= 0) {
                _health = 0;
                despawn();
            }
        }
        
        override public function update():void {
            // Set facing and animation
            if(moving) {
                _facing.setTo(_move).normalise();
            }
            setAnim(moving);
            
            // Actually move
            var c:Entity = collide("mob", x + move.x, y + move.y);
            if(!c) {
                x += _move.x;
                y += _move.y;
            }
            
            // Update hurt animation
            if(_hurtTick > 0) {
                --_hurtTick;
                if(_hurtTick == 0) {
                    _gfx.color = 0xFFFFFF;
                }
            }

            // Set depth
            layer = -y - 24;

            super.update();
        }
    }
}