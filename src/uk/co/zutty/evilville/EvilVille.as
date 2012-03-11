package uk.co.zutty.evilville
{
	import flash.display.Sprite;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	public class EvilVille extends Engine {
		
		public function EvilVille() {
			super(640, 480, 60, false);
			FP.screen.scale = 1;
			FP.screen.color = 0xffffff;
			//FP.console.enable();
			
			FP.world = new GameWorld();
		}
	}
}