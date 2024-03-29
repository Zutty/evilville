package uk.co.zutty.evilville
{
	import flashx.textLayout.formats.TextAlign;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import uk.co.zutty.evilville.entities.Mob;
	import uk.co.zutty.evilville.entities.MobHitbox;
	import uk.co.zutty.evilville.entities.Player;
	import uk.co.zutty.evilville.entities.Zombie;
	import uk.co.zutty.evilville.levels.Layer;
	import uk.co.zutty.evilville.levels.LevelGenerator;
	import uk.co.zutty.evilville.levels.OverworldGenerator;
	import uk.co.zutty.evilville.supplier.Suppliable;
	import uk.co.zutty.evilville.supplier.Supplier;
	import uk.co.zutty.evilville.util.IPoint;
	
	public class GameWorld extends World {

        [Embed(source = 'assets/outside_tiles.png')]
        private static const TILES_IMAGE:Class;
        private static const TILE_SIZE:Number = 48;

        private var _player:Player;
        private var _zombies:Supplier = Supplier.newSupplier(16, function():Suppliable {
            return new Zombie();
        });
        private var _gen:OverworldGenerator;
        
        private var _deadMsg:Entity;
		
		public function GameWorld() {
			super();
            
			//var gen:LevelGenerator = new LevelGenerator();
			//add(gen.layer);
            
            _gen = new OverworldGenerator(TILES_IMAGE, 48, 48);
            _gen.addTo(this);

			_player = new Player();
            _player.spawn(320, 240);
			addMob(_player);
            
            _zombies.init();
            _zombies.addAll(this);
            spawnZombie();
            
            // HUD
            _deadMsg = new Entity();
            var t:Text = new Text("LOL YOU'RE DEAD", 320, 220);
            t.size = 36;
            t.color = 0x000000;
            t.centerOrigin();
            _deadMsg.addGraphic(t);
            var u:Text = new Text("Press SPACE to respawn", 320, 260);
            u.size = 24;
            u.color = 0x000000;
            u.centerOrigin();
            _deadMsg.addGraphic(u);
            _deadMsg.graphic.scrollX = 0;
            _deadMsg.graphic.scrollY = 0;
            _deadMsg.visible = false;
            _deadMsg.collidable = false;
            _deadMsg.layer = -131072;
            add(_deadMsg);
        }

        override public function add(e:Entity):Entity {
            if(e is Mob) {
                return addMob(e as Mob);
            } else {
                return super.add(e);
            }
        }

        public function addMob(mob:Mob):Mob {
            super.add(mob);
            add(mob.hitbox);
            return mob;
        }
        
        public function get player():Player {
            return _player;
        } 
        
        public function showDeadMsg():void {
            _deadMsg.visible = true;
        }
        
        private function spawnZombie():void {
            var p:IPoint = FP.choose(_gen.spawnPoints);
            _zombies.spawnNext(p.x, p.y);
        }
        
        override public function update():void {
            super.update();
            if(Input.pressed(Key.Z)) {
                spawnZombie();
            }
            
            if(!_player.active && Input.pressed(Key.SPACE)) {
                _deadMsg.visible = false;
                _player.spawn(320, 240);
            }
        }
	}
}