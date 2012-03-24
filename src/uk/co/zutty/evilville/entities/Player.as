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
        private const REACH:Number = 12;
        private const HEALTH:Number = 10;
        
        private var _move:IPoint;

		public function Player() {
            super(PLAYER_IMAGE, HEALTH);
            
            type = "player";
            _move = new IPoint(0, 0);
			
			Input.define("up", Key.UP, Key.W);
			Input.define("down", Key.DOWN, Key.S);
			Input.define("left", Key.LEFT, Key.A);
			Input.define("right", Key.RIGHT, Key.D);
            Input.define("attack", Key.X);
		}
		
		override public function update():void {
			FP.camera.x = x - 320;
			FP.camera.y = y - 240;
				
            velocity.set(0, 0);
            
			if(Input.check("up")) {
                velocity.y = -SPEED;
			} else if(Input.check("down")) {
                velocity.y = SPEED;
			}
			if(Input.check("left")) {
                velocity.x = -SPEED;
			} else if(Input.check("right")) {
                velocity.x = SPEED;
			}
            
            if(Input.pressed("attack")) {
                var mob:Mob = collide("mob", x + (facing.x * REACH), y + (facing.y * REACH)) as Mob;
                if(mob) {
                    mob.hit(2);
                }
            }
            
            super.update();
		}
	}
}