package uk.co.zutty.evilville.levels
{
    import net.flashpunk.FP;
    import net.flashpunk.World;

    public class OverworldGenerator {
        
        private var _backLayer:Layer;
        private var _solidLayer:Layer;
        private var _frontLayer:Layer;
        
        public function OverworldGenerator(tilesImg:Class) {
            _backLayer = new Layer(tilesImg, 640, 480, 48, 48);
            _backLayer.layer = 200;
            _solidLayer = new Layer(tilesImg, 640, 480, 48, 48, true);
            _solidLayer.layer = 90;
            _frontLayer = new Layer(tilesImg, 640, 480, 48, 48);
            _frontLayer.layer = 50;
            
            // Draw grass
            _backLayer.fill(1);
            
            drawTallGrass();
            drawTree(4,4);
        }
        
        public function addLayersTo(world:World):void {
            world.add(_backLayer);
            world.add(_solidLayer);
            world.add(_frontLayer);
        }
        
        public function drawTallGrass():void {
            for(var i:int = 0; i < 20; i++) {
                _backLayer.setTile(FP.rand(13), FP.rand(10), FP.choose(2,3));
            }
        }
        
        public function drawTree(x:int, y:int):void {
            _frontLayer.setTile(x-1, y-2, 4);
            _frontLayer.setTile(x, y-2, 5);
            _frontLayer.setTile(x+1, y-2, 6);
            _frontLayer.setTile(x-1, y-1, 8);
            _frontLayer.setTile(x, y-1, 9);
            _frontLayer.setTile(x+1, y-1, 10);
            _solidLayer.setTile(x, y, 13);
        }
    }
}