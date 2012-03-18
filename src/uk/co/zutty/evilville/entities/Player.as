package uk.co.zutty.evilville.entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import uk.co.zutty.evilville.util.IPoint;
	
	public class Player extends Mob {

		[Embed(source = 'assets/player.png')]
		private const PLAYER_IMAGE:Class;
		
		private const SPEED:Number = 3;
        
        private var _move:IPoint;

		public function Player(x:Number, y:Number) {
            super(PLAYER_IMAGE, x, y);
            
            _move = new IPoint(0, 0);
			
			Input.define("up", Key.UP, Key.W);
			Input.define("down", Key.DOWN, Key.S);
			Input.define("left", Key.LEFT, Key.A);
			Input.define("right", Key.RIGHT, Key.D);
		}
		
		override public function update():void {
			super.update();
			
			FP.camera.x = x - 320;
			FP.camera.y = y - 240;
				
            _move.x = 0;
            _move.y = 0;
			if(Input.check("up")) {
				_move.y = -SPEED;
			} else if(Input.check("down")) {
                _move.y = SPEED;
			}
			if(Input.check("left")) {
                _move.x = -SPEED;
			} else if(Input.check("right")) {
                _move.x = SPEED;
			}
            
            if(_move.x == 0 && _move.y == 0) {
                stand();
            } else {
                walk(_move.x, _move.y);
                x += _move.x;
                y += _move.y;
            }
		}
	}
}