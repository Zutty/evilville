package uk.co.zutty.evilville.entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import uk.co.zutty.evilville.EvilVille;
	import uk.co.zutty.evilville.util.IPoint;
	
	public class Player extends Mob {

		[Embed(source = 'assets/player.png')]
		private const PLAYER_IMAGE:Class;
		
		private const SPEED:Number = 3;
        private const REACH:Number = 12;
        private const HEALTH:Number = 10;
        
		public function Player() {
            super(PLAYER_IMAGE, HEALTH);
            
            type = "mob";
            
            gfx.add("stand_l", [0], FRAME_RATE, false);
            gfx.add("stand_r", [5], FRAME_RATE, false);
            gfx.add("stand_d", [10], FRAME_RATE, false);
            gfx.add("stand_u", [15], FRAME_RATE, false);
            gfx.add("walk_l", [1,2,3,4], FRAME_RATE, true);
            gfx.add("walk_r", [6,7,8,9], FRAME_RATE, true);
            gfx.add("walk_d", [11,12,13,14], FRAME_RATE, true);
            gfx.add("walk_u", [16,17,18,19], FRAME_RATE, true);
			
			Input.define("up", Key.UP, Key.W);
			Input.define("down", Key.DOWN, Key.S);
			Input.define("left", Key.LEFT, Key.A);
			Input.define("right", Key.RIGHT, Key.D);
            Input.define("attack", Key.X);
		}
        
        override protected function die():void {
            super.die();
            if(EvilVille.world) {
                EvilVille.world.showDeadMsg();
            }
        }
		
		override public function update():void {
			FP.camera.x = x - 320;
			FP.camera.y = y - 240;
				
            move.zero();
            
			if(Input.check("up")) {
                move.y = -SPEED;
			} else if(Input.check("down")) {
                move.y = SPEED;
			}
			if(Input.check("left")) {
                move.x = -SPEED;
			} else if(Input.check("right")) {
                move.x = SPEED;
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