package uk.co.zutty.evilville.entities
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Spritemap;
    
    import uk.co.zutty.evilville.EvilVille;
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
            _state = STATE_AGGRO;//WANDER;
        } 
        
        public override function update():void {
            switch(_state) {
                case STATE_WANDER:
                    updateWander();
                    break;
                case STATE_AGGRO:
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
        
        private function updateAggro():void {
            // Check target
            if(_target == null || !_target.active) {
                _state = STATE_WANDER;
                return;
            }
            
            // Move towards target
            if(_target != null) {
                setMovement(EvilVille.POINT.set(_target.x, _target.y), SPEED);
            }
        }
    }
}