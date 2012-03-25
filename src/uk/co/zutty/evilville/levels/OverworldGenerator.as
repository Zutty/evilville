package uk.co.zutty.evilville.levels
{
    import flash.geom.Rectangle;
    
    import net.flashpunk.FP;
    import net.flashpunk.World;
    
    import uk.co.zutty.evilville.entities.Terrain;
    import uk.co.zutty.evilville.util.IPoint;
    import uk.co.zutty.evilville.util.IRect;

    public class OverworldGenerator {
        
        private var _tilesImg:Class;
        private var _groundLayer:Layer;
        private var _backLayer:Layer;
        private var _solidLayer:Layer;
        private var _frontLayer:Layer;
        private var _terrain:Vector.<Terrain>;
        private var _tileWidth:Number;
        private var _tileHeight:Number;
        private var _spawnPoints:Vector.<IPoint>;
        
        public function OverworldGenerator(tilesImg:Class, tileWidth:Number, tileHeight:Number) {
            _tilesImg = tilesImg;
            _tileWidth = tileWidth;
            _tileHeight = tileHeight;
            _terrain = new Vector.<Terrain>();
            
            _groundLayer = new Layer(tilesImg, 640, 480, tileWidth, tileHeight);
            _groundLayer.layer = 65536;
            _backLayer = new Layer(tilesImg, 640, 480, tileWidth, tileHeight);
            _backLayer.layer = 32768;
            _solidLayer = new Layer(tilesImg, 640, 480, tileWidth, tileHeight, true);
            _solidLayer.layer = 0;
            _frontLayer = new Layer(tilesImg, 640, 480, tileWidth, tileHeight);
            _frontLayer.layer = -65536;

            _spawnPoints = new Vector.<IPoint>();
            
            // Draw grass
            _groundLayer.fill(1);
            
            makeTallGrass();
            makeTrees();
            makeGrave(9,8);
            makeGrave(10,8);
            makeGrave(11,8);
            makeOpenGrave(12,8);
        }
        
        public function addTo(world:World):void {
            world.add(_groundLayer);
            world.add(_backLayer);
            world.add(_solidLayer);
            world.add(_frontLayer);
            for each(var t:Terrain in _terrain) {
                world.add(t);
            }
        }
        
        public function get spawnPoints():Vector.<IPoint> {
            return _spawnPoints;
        }

        public function makeTerrain(x:uint, y:uint, tRect:IRect):void {
            var rect:Rectangle = new Rectangle(tRect.x * _tileWidth, tRect.y * _tileHeight, tRect.width * _tileWidth, tRect.height * _tileHeight);
            _terrain[_terrain.length] = new Terrain(x * 48, y * 48, _tilesImg, rect);            
        }

        private static const GRASS1:IRect = new IRect(2, 0, 1, 1);
        private static const GRASS2:IRect = new IRect(3, 0, 1, 1);
        public function makeTallGrass():void {
            for(var i:int = 0; i < 20; i++) {
                makeTerrain(FP.rand(13), FP.rand(10), FP.choose(GRASS1, GRASS2));
            }
        }
        
        public function makeTrees():void {
            for(var i:int = 0; i < 4; i++) {
                makeTree(FP.rand(13), FP.rand(10));
            }
        }
        
        private static const TREE1:IRect = new IRect(0, 1, 3, 3);
        private static const TREE2:IRect = new IRect(3, 1, 3, 3);
        public function makeTree(x:int, y:int):void {
            makeTerrain(x-1, y-2, FP.choose(TREE1, TREE2));
        }
        
        private static const GRAVE_STONE1:IRect = new IRect(0, 5, 1, 1);
        private static const GRAVE_STONE2:IRect = new IRect(1, 5, 1, 1);
        private static const GRAVE_STONE3:IRect = new IRect(2, 5, 1, 1);
        private static const GRAVE_SHOVEL:IRect = new IRect(3, 5, 1, 1);
        public function makeGrave(x:int, y:int):void {
            makeTerrain(x, y-1, FP.choose(GRAVE_STONE1, GRAVE_STONE2, GRAVE_STONE3));
            var grnd:int = 48 + FP.rand(2);
            _backLayer.setTile(x, y-1, grnd);
            _backLayer.setTile(x, y, grnd + 8);
            if(Math.random() < 0.02) {
                makeTerrain(x, y, GRAVE_SHOVEL);
            }
            addSpawnPoint(x, y);
        }

        public function makeOpenGrave(x:int, y:int):void {
            makeTerrain(x, y-1, FP.choose(GRAVE_STONE1, GRAVE_STONE2, GRAVE_STONE3));
            _backLayer.setTile(x, y-1, 51);
            _backLayer.setTile(x, y, 59);
        }
        
        private function addSpawnPoint(x:int, y:int):void {
            var sx:int = (x * _tileWidth) + (_tileWidth / 2);
            var sy:int = (y * _tileHeight) + (_tileHeight / 4);
            _spawnPoints[_spawnPoints.length] = new IPoint(sx, sy);
        }
    }
}