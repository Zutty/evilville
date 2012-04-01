package uk.co.zutty.evilville
{
	import flash.display.Sprite;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	
	import uk.co.zutty.evilville.util.IPoint;
	
	public class EvilVille extends Engine {
        
        [Embed(source = 'assets/OpenComicFont.ttf', embedAsCFF="false", fontFamily = 'opencomic')]
        private static const OPENCOMIC_FONT:Class;

        public static const POINT:IPoint = new IPoint(0, 0);
		
		public function EvilVille() {
			super(640, 480, 60, false);
			FP.screen.scale = 1;
			FP.screen.color = 0xffffff;
			//FP.console.enable();
			
            Text.font = "opencomic";

            FP.world = new GameWorld();
		}
        
        public static function get world():GameWorld {
            return (FP.world is GameWorld) ? FP.world as GameWorld : null;
        }
	}
}