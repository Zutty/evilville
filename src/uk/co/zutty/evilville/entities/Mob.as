package uk.co.zutty.evilville.entities
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.masks.Hitbox;
    
    import uk.co.zutty.evilville.EvilVille;
    import uk.co.zutty.evilville.supplier.Suppliable;
    import uk.co.zutty.evilville.util.IPoint;
    import uk.co.zutty.evilville.util.IRect;
    import uk.co.zutty.evilville.util.VectorMath;
    
    public class Mob extends Suppliable {
        
        public static const FRAME_RATE:Number = 16;
        
        private var _gfx:MobSprite;
        private var _hitbox:MobHitbox;
        private var _hurtTick:uint = 0;
        private var _move:IPoint;
		private var _oldMove:IPoint;

        private var _facing:IPoint;
        private var _health:Number;
        private var _maxHealth:Number;
        
        public function Mob(img:Class, maxHealth:Number) {
            super();
            
            _maxHealth = maxHealth;
            _move = new IPoint(0, 0);
			_oldMove = new IPoint(0, 0);
            _facing = new IPoint(0, 1);

            type = "mob";
            collidable = true;
            setHitbox(32, 4, 16, -20);

            _gfx = new MobSprite(img, 48, 48);
            _gfx.centerOrigin();
            graphic = _gfx;
            
            _hitbox = new MobHitbox(new Hitbox(32, 32, -16, -16), this, "mobhurt");
        }
        
        public function get hitbox():MobHitbox {
            return _hitbox;
        }
        
        public function collideHitbox(type:String, x:Number, y:Number):Entity {
            var e:Entity = _hitbox.collide(type, x, y);
            return (e != null && e is MobHitbox) ? (e as MobHitbox).parent : e;
        }
        
        protected function get gfx():MobSprite {
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

        protected function resetSprite():void {
            moving ? _gfx.walk() : _gfx.stand();
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
        
        protected function shiftHurtbox():void {
            _hitbox.x = x;
            _hitbox.y = y;
        }
        
        override public function update():void {
			var reset:Boolean = false;

			// Update facing
            EvilVille.POINT.setTo(_move).normalise();
            if(!_facing.equals(EvilVille.POINT) && moving) {
                _facing.setTo(EvilVille.POINT);
				_gfx.facingVector = _facing;
				reset = true;
            }

			// Check if motion has changed
			if(!_move.equals(_oldMove)) {
				_oldMove.setTo(_move);
				reset = true;
			}
			
			// Reset animation if necessary
			if(reset) {
				resetSprite();
			}
            
            // Actually move
            var c:Entity = collideTypes(["mob", "terrain"], x + move.x, y + move.y);
            if(!c) {
                x += _move.x;
                y += _move.y;
            }
            
            shiftHurtbox();
            
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