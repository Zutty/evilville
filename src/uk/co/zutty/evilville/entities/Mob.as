package uk.co.zutty.evilville.entities
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Spritemap;
    
    import uk.co.zutty.evilville.EvilVille;
    import uk.co.zutty.evilville.supplier.Suppliable;
    import uk.co.zutty.evilville.util.IPoint;
    import uk.co.zutty.evilville.util.IRect;
    import uk.co.zutty.evilville.util.VectorMath;
    
    public class Mob extends Suppliable {
        
        public static const FRAME_RATE:Number = 16;
        
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
            setHitbox(32, 32, -16, -16);

            _gfx = new Spritemap(img, 48, 48);
            _gfx.centerOrigin();
            graphic = _gfx;
            
            despawn();
        }
        
        protected function get gfx():Spritemap {
            return _gfx;
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

        protected function setAnim(moving:Boolean):void {
            if(_gfx.currentAnim == "spawn") {
                return;
            }
            
            var anim:String = moving ? "walk" : "stand";
            _gfx.play(facingAnim(anim));
        }
        
        protected function facingAnim(anim:String):String {
            if(Math.abs(_facing.x) > Math.abs(_facing.y)) {
                if(_facing.x < 0) {
                    return anim + "_l";
                } else {
                    return anim + "_r";
                }
            } else {
                if(_facing.y < 0) {
                    return anim + "_u";
                } else {
                    return anim + "_d";
                }
            }
        }
        
        override public function spawn(x:Number, y:Number):void {
            super.spawn(x, y);
            _health = _maxHealth;
            _facing.set(0, 1);
            _move.set(0, 0);
            _gfx.color = 0xFFFFFF;
            _hurtTick = 0;
        }

        public function hit(dmg:Number):void {
            _gfx.color = 0xFF0000;
            _hurtTick = 4;
            
            _health -= dmg;
            if(_health <= 0) {
                _health = 0;
                die();
            }
        }

        /**
         * Might want to override this, to do something before dying.
         */
        protected function die():void {
            despawn();
        }
        
        override public function update():void {
            // Set facing and animation
            EvilVille.POINT.setTo(_move).normalise();
            if(!_facing.equals(EvilVille.POINT)) {
                if(moving) {
                    _facing.setTo(EvilVille.POINT);
                }
                setAnim(moving);
            }
            
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