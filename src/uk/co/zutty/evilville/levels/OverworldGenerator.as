package uk.co.zutty.evilville.levels
{
    import flash.geom.Rectangle;
    
    import net.flashpunk.FP;
    import net.flashpunk.World;
    
    import uk.co.zutty.evilville.entities.Terrain;
    import uk.co.zutty.evilville.util.IRect;

    public class OverworldGenerator {
        
        private var _tilesImg:Class;
        private var _backLayer:Layer;
        private var _solidLayer:Layer;
        private var _frontLayer:Layer;
        private var _terrain:Vector.<Terrain>;
        private var _tileWidth:Number;
        private var _tileHeight:Number;
        
        public function OverworldGenerator(tilesImg:Class, tileWidth:Number, tileHeight:Number) {
            _tilesImg = tilesImg;
            _tileWidth = tileWidth;
            _tileHeight = tileHeight;
            _terrain = new Vector.<Terrain>();
            
            _backLayer = new Layer(tilesImg, 640, 480, tileWidth, tileHeight);
            _backLayer.layer = 65536;
            _solidLayer = new Layer(tilesImg, 640, 480, tileWidth, tileHeight, true);
            _solidLayer.layer = 0;
            _frontLayer = new Layer(tilesImg, 640, 480, tileWidth, tileHeight);
            _frontLayer.layer = -65536;
            
            // Draw grass
            _backLayer.fill(1);
            
            makeTallGrass();
            makeTree(4,4);
        }
        
        public function addTo(world:World):void {
            world.add(_backLayer);
            world.add(_solidLayer);
            world.add(_frontLayer);
            for each(var t:Terrain in _terrain) {
                world.add(t);
            }
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
        
        private static const TREE1:IRect = new IRect(0, 1, 3, 3);
        public function makeTree(x:int, y:int):void {
            makeTerrain(x-1, y-2, TREE1);
        }
    }
}