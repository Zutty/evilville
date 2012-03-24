package uk.co.zutty.evilville
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import uk.co.zutty.evilville.entities.Player;
	import uk.co.zutty.evilville.entities.Zombie;
	import uk.co.zutty.evilville.levels.Layer;
	import uk.co.zutty.evilville.levels.LevelGenerator;
	import uk.co.zutty.evilville.levels.OverworldGenerator;
	import uk.co.zutty.evilville.supplier.Suppliable;
	import uk.co.zutty.evilville.supplier.Supplier;
	
	public class GameWorld extends World {

        [Embed(source = 'assets/outside_tiles.png')]
        private static const TILES_IMAGE:Class;
        private static const TILE_SIZE:Number = 48;

        private var _player:Player;
        private var _zombies:Supplier = Supplier.newSupplier(16, function():Suppliable {
            return new Zombie();
        });
		
		public function GameWorld() {
			super();

			//var gen:LevelGenerator = new LevelGenerator();
			//add(gen.layer);
            
            var gen:OverworldGenerator = new OverworldGenerator(TILES_IMAGE, 48, 48);
            gen.addTo(this);

			_player = new Player();
            _player.spawn(320, 240);
			add(_player);
            
            _zombies.init();
            _zombies.addAll(this);
            
            spawnZombie();
        }
        
        private function spawnZombie():void {
            _zombies.spawnNext(FP.rand(640), FP.rand(480));
        }
        
        override public function update():void {
            super.update();
            if(Input.pressed(Key.Z)) {
                spawnZombie();
            }
        }
	}
}