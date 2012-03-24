package uk.co.zutty.evilville
{
	import flash.display.Sprite;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	import uk.co.zutty.evilville.util.IPoint;
	
	public class EvilVille extends Engine {
        
        public static const POINT:IPoint = new IPoint(0, 0);
		
		public function EvilVille() {
			super(640, 480, 60, false);
			FP.screen.scale = 1;
			FP.screen.color = 0xffffff;
			//FP.console.enable();
			
			FP.world = new GameWorld();
		}
	}
}