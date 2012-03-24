package uk.co.zutty.evilville
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	import uk.co.zutty.evilville.entities.Player;
	import uk.co.zutty.evilville.entities.Zombie;
	import uk.co.zutty.evilville.levels.Layer;
	import uk.co.zutty.evilville.levels.LevelGenerator;
	import uk.co.zutty.evilville.levels.OverworldGenerator;
	
	public class GameWorld extends World {

        [Embed(source = 'assets/outside_tiles.png')]
        private static const TILES_IMAGE:Class;
        private static const TILE_SIZE:Number = 48;

        private var _player:Player;
		
		public function GameWorld() {
			super();

			//var gen:LevelGenerator = new LevelGenerator();
			//add(gen.layer);
            
            var gen:OverworldGenerator = new OverworldGenerator(TILES_IMAGE, 48, 48);
            gen.addTo(this);

			_player = new Player(320, 240);
			add(_player);
            
            add(new Zombie(240, 160));
        }
	}
}