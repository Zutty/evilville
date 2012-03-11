package uk.co.zutty.evilville
{
	import net.flashpunk.World;
	
	public class GameWorld extends World {
		
		private var _player:Player;
		
		public function GameWorld() {
			super();
			
			_player = new Player();
			_player.x = 320;
			_player.y = 240;
			add(_player);
		}
	}
}