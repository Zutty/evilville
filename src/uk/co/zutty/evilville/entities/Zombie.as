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
    
    public class Zombie extends Mob {

        [Embed(source = 'assets/zombie.png')]
        private static const ZOMBIE_IMAGE:Class;
        
        private const STATE_IDLE:uint = 0;
        private const STATE_WANDER:uint = 1;
        private const STATE_AGGRO:uint = 2;
        
        private const SPEED:Number = 1;
        private const HEALTH:Number = 8;
        
        private var _waypoint:IPoint;
        private var _state:uint;

        public function Zombie() {
            super(ZOMBIE_IMAGE, HEALTH);
        }
        
        override public function spawn(x:Number, y:Number):void {
            super.spawn(x, y);
            _state = STATE_WANDER;
        } 
        
        public override function update():void {
            switch(_state) {
                case STATE_WANDER:
                    if(_waypoint == null && Math.random() < 0.02) {
                        var theta:Number = Math.random() * Math.PI * 2;
                        _waypoint = IPoint.polarUnitVector(theta).multiply(FP.rand(3) * 48).add(x, y);
                    }
                    break;
                case STATE_AGGRO:
                    //var move:Vector2D = VectorMath.unitVector(x, y, target.x, target.y);
                    //x += move.x * SPEED;
                    //y += move.y * SPEED;
                    break;
            }
            
            if(_waypoint != null) {
                var dist:Number = VectorMath.distance(_waypoint.x, _waypoint.y, x, y);
                
                if(dist <= SPEED) {
                    x = _waypoint.x;
                    y = _waypoint.y;
                    _waypoint = null;
                    velocity.x = 0;
                    velocity.y = 0;
                } else {
                    var move2:Point = VectorMath.unitVector(x, y, _waypoint.x, _waypoint.y);
                    velocity.x = Math.round(move2.x * SPEED);
                    velocity.y = Math.round(move2.y * SPEED);
                }
            }

            super.update();
        }
    }
}