package uk.co.zutty.evilville.supplier
{
    import net.flashpunk.Entity;
    import net.flashpunk.World;
    
    import uk.co.zutty.evilville.entities.Mob;
    
    public class Supplier {
        
        private static const allSuppliers:Vector.<Supplier> = new Vector.<Supplier>();
        
        private var _poolSize:int;
        private var _callback:Function;
        private var _entities:Vector.<Suppliable>;
        private var _idx:int;
        
        public static function newSupplier(poolSize:int, callback:Function):Supplier {
            var s:Supplier = new Supplier(poolSize, callback);
            allSuppliers[allSuppliers.length] = s;
            return s;
        }
        
        public static function initAll():void {
            for each(var s:Supplier in allSuppliers) {
                s.init();
            }
        }
        
        public function Supplier(poolSize:int, callback:Function) {
            _poolSize = poolSize;
            _callback = callback;
            _entities = new Vector.<Suppliable>(poolSize);
        }
        
        public function addAll(world:World):void {
            for each(var b:Suppliable in entities) {
                world.add(b);
            }
        }
        
        public function get entities():Vector.<Suppliable> {
            return _entities;
        }
        
        public function init():void {
            for(var i:int = 0; i < _poolSize; i++) {
                _entities[i] = _callback();
            }
            _idx = -1;
        }
        
        public function next():Suppliable {
            var initIdx:int = _idx;
            do {
                _idx = (_idx + 1) % _poolSize;
                // Break if we wrap around, i.e. no active entities left
                if(_idx == initIdx) {
                    return null;
                }
            } while(_entities[_idx].active);
            
            return _entities[_idx];
        }
        
        public function spawnNext(x:Number, y:Number):void {
            var e:Suppliable = next();
            if(e != null) {
                e.spawn(x, y);
            }
        }
    }
}