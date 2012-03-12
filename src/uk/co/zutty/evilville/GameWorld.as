package uk.co.zutty.evilville
{
	import net.flashpunk.World;
	
	import uk.co.zutty.evilville.levels.Layer;
	
	public class GameWorld extends World {

		[Embed(source = 'assets/tiles.png')]
		private const TILES_IMAGE:Class;
		
		private var _player:Player;
		
		public function GameWorld() {
			super();
			
			var layer:Layer = new Layer(TILES_IMAGE, 640, 480, 32, 32);
			layer.setTile(0, 0, 0, 0);
			layer.setTile(1, 0, 0, 0);
			layer.setTile(2, 0, 0, 0);
			
			layer.setTile(0, 1, 0, 0);
			layer.setTile(1, 1, 1, 0);
			layer.setTile(2, 1, 0, 0);

			layer.setTile(0, 2, 0, 0);
			layer.setTile(1, 2, 0, 0);
			layer.setTile(2, 2, 0, 0);
			add(layer);
			
			_player = new Player();
			_player.x = 320;
			_player.y = 240;
			add(_player);
		}
	}
}