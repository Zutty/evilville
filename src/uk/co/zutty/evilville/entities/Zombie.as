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
    
    public class Zombie extends Entity {

        [Embed(source = 'assets/zombie.png')]
        private static const ZOMBIE_IMAGE:Class;
        private static const FRAME_RATE:Number = 10;
        
        private const STATE_IDLE:uint = 0;
        private const STATE_WANDER:uint = 1;
        private const STATE_AGGRO:uint = 2;
        private const SPEED:Number = 1;
        
        private var _gfx:Spritemap;
        private var _waypoint:IPoint;
        private var _state:uint;

        public function Zombie(x:Number=0, y:Number=0) {
            super(x, y);
            
            layer = 100;
            
            _gfx = new Spritemap(ZOMBIE_IMAGE, 48, 48);
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

            _state = STATE_WANDER;
            _gfx.play("stand_l");
        }
        
        private function walk(x:Number, y:Number):void {
            if(Math.abs(x) > Math.abs(y)) {
                if(x < 0) {
                    _gfx.play("walk_l");
                } else {
                    _gfx.play("walk_r");
                }
            } else {
                if(y < 0) {
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