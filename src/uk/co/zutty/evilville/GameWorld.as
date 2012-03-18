package uk.co.zutty.evilville
{
	import net.flashpunk.World;
	
	import uk.co.zutty.evilville.levels.Layer;
	import uk.co.zutty.evilville.levels.LevelGenerator;
	
	public class GameWorld extends World {

		private var _player:Player;
		
		public function GameWorld() {
			super();

			var gen:LevelGenerator = new LevelGenerator();
			add(gen.layer);
			
			_player = new Player();
			_player.x = 320;
			_player.y = 240;
			add(_player);
		}
	}
}