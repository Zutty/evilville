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
        
        private var _waypoint:IPoint;
        private var _state:uint;

        public function Zombie(x:Number=0, y:Number=0) {
            super(ZOMBIE_IMAGE, x, y);

            _state = STATE_WANDER;
        }
        
        public override function update():void {
            super.update();
            
            switch(_state) {
                case STATE_WANDER:
                    if(Math.random() > 0.98) {
                        _waypoint = new IPoint(x, y);
                        _waypoint.x = Math.random() * 120;
                        _waypoint.y = Math.random() * 120;
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
                    stand();
                } else {
                    var move2:Point = VectorMath.unitVector(x, y, _waypoint.x, _waypoint.y);
                    x += move2.x * SPEED;
                    y += move2.y * SPEED;
                    walk(move2.x, move2.y);
                }
            }
        }
    }
}