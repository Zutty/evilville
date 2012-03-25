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
        
        private const STATE_IDLE:uint = 0;
        private const STATE_WANDER:uint = 1;
        private const STATE_AGGRO:uint = 2;
        
        private const SPEED:Number = 1;
        private const HEALTH:Number = 8;
        private const AGGRO_RANGE:Number = 200;
        
        private var _waypoint:IPoint;
        private var _target:Mob;
        private var _state:uint;

        public function Zombie() {
            super(ZOMBIE_IMAGE, HEALTH);
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
            _state = STATE_WANDER;
        } 
        
        public override function update():void {
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
            }
        }
    }
}