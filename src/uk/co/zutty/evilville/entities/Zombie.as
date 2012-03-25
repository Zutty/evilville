package uk.co.zutty.evilville.entities
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Spritemap;
    
    import uk.co.zutty.evilville.EvilVille;
    import uk.co.zutty.evilville.GameWorld;
    import uk.co.zutty.evilville.util.IPoint;
    import uk.co.zutty.evilville.util.VectorMath;
    
    public class Zombie extends Mob {

        [Embed(source = 'assets/zombie.png')]
        private static const ZOMBIE_IMAGE:Class;
        private static const ATTACK_FRAME_RATE:Number = 8;
        
        private const STATE_SPAWN:uint = 0;
        private const STATE_IDLE:uint = 1;
        private const STATE_WANDER:uint = 2;
        private const STATE_AGGRO:uint = 3;
        private const STATE_DEAD:uint = 4;
        
        private const SPEED:Number = 1;
        private const HEALTH:Number = 8;
        private const AGGRO_RANGE:Number = 200;
        private const ATTACK_RANGE:Number = 40;
        private const ATTACK_COOLDOWN:uint = 20;
        
        private var _waypoint:IPoint;
        private var _target:Mob;
        private var _state:uint;
        private var _attackTick:uint = 0;

        public function Zombie() {
            super(ZOMBIE_IMAGE, HEALTH);
            
            gfx.add("spawn", [0,1,2,3,4,5,6,7,8,9], FRAME_RATE, false);
            
            gfx.add("stand_l", [10], FRAME_RATE, false);
            gfx.add("walk_l", [11,12,13,14], FRAME_RATE, true);
            gfx.add("attack_l", [15,10], ATTACK_FRAME_RATE, true);
            gfx.add("die_l", [16,17,18,19], FRAME_RATE, false);

            gfx.add("stand_r", [20], FRAME_RATE, false);
            gfx.add("walk_r", [21,22,23,24], FRAME_RATE, true);
            gfx.add("attack_r", [25,20], ATTACK_FRAME_RATE, true);
            gfx.add("die_r", [26,27,28,29], FRAME_RATE, false);

            gfx.add("stand_d", [30], FRAME_RATE, false);
            gfx.add("walk_d", [31,32,33,34], FRAME_RATE, true);
            gfx.add("attack_d", [35,30], ATTACK_FRAME_RATE, true);
            gfx.add("die_d", [36,37,38,39], FRAME_RATE, false);

            gfx.add("stand_u", [40], FRAME_RATE, false);
            gfx.add("walk_u", [41,42,43,44], FRAME_RATE, true);
            gfx.add("attack_u", [45,40], ATTACK_FRAME_RATE, true);
            gfx.add("die_u", [46,47,48,49], FRAME_RATE, false);
        }
        
        public function get waypoint():IPoint {
            return _waypoint;
        }
        
        public function get target():Mob {
            return _target;
        }
        
        public function set target(t:Mob):void {
            _target = t;
        }
        
        override public function spawn(x:Number, y:Number):void {
            super.spawn(x, y);
            _state = STATE_SPAWN;
            gfx.callback = function():void {
                gfx.play("stand_d");
                gfx.callback = null;
                _state = STATE_WANDER;
            };
            gfx.play("spawn", true);
        } 
        
        override protected function die():void {
            _state = STATE_DEAD;
            gfx.callback = function():void {
                gfx.callback = null;
                despawn();
            }
            gfx.play(facingAnim("die"));
        }
        
        public override function update():void {
            if(_attackTick > 0) {
                --_attackTick;
            }
            
            switch(_state) {
                case STATE_WANDER:
                    checkAggro();
                    updateWander();
                    break;
                case STATE_AGGRO:
                    checkAggro();
                    updateAggro();
                    break;
            }

            super.update();
        }
        
        private function updateWander():void {
            // Find a new waypoint
            if(_waypoint == null && Math.random() < 0.02) {
                var theta:Number = Math.random() * Math.PI * 2;
                _waypoint = IPoint.polarUnitVector(theta).multiply(FP.rand(3) * 48).add(x, y);
            }
            
            // Move towards the waypoint
            if(_waypoint != null) {
                setMovement(_waypoint, SPEED);
                
                if(x == _waypoint.x && y == _waypoint.y) {
                    _waypoint = null;
                }
            }
        }
        
        private function checkAggro():void {
            // Transition into aggro
            if(_state != STATE_AGGRO) {
                if(FP.world is GameWorld) {
                    var gw:GameWorld = FP.world as GameWorld;
                    if(distanceFrom(gw.player) <= AGGRO_RANGE) {
                        _state = STATE_AGGRO;
                        _target = gw.player;
                    }
                }
            }

            // Transisiotn out of aggro
            if(_state == STATE_AGGRO && (_target == null || !_target.active || distanceFrom(_target) > AGGRO_RANGE)) {
                _state = STATE_WANDER;
                _target = null;
                return;
            }
        }
            
        private function updateAggro():void {
            // Move towards target
            if(_target != null) {
                setMovement(EvilVille.POINT.set(_target.x, _target.y), SPEED);
                
                // Attack if in range
                if(distanceFrom(_target) <= ATTACK_RANGE && _attackTick == 0) {
                    gfx.play(facingAnim("attack"));
                    _target.hit(1);
                    _attackTick = ATTACK_COOLDOWN;
                }
            }
        }
    }
}