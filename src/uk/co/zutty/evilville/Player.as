package uk.co.zutty.evilville
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Player extends Entity {

		[Embed(source = 'assets/guy.png')]
		private const GUY_IMAGE:Class;
		
		private const SPEED:Number = 3;

		public function Player() {
			graphic = new Image(GUY_IMAGE);
			
			Input.define("up", Key.UP, Key.W);
			Input.define("down", Key.DOWN, Key.S);
			Input.define("left", Key.LEFT, Key.A);
			Input.define("right", Key.RIGHT, Key.D);
		}
		
		override public function update():void {
			super.update();
			
			if(Input.check("up")) {
				y -= SPEED;
			} else if(Input.check("down")) {
				y += SPEED;
			}
			if(Input.check("left")) {
				x -= SPEED;
			} else if(Input.check("right")) {
				x += SPEED;
			}
		}
	}
}