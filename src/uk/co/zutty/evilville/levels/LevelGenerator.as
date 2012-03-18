package uk.co.zutty.evilville.levels
{
	import flash.utils.Dictionary;
	
	import net.flashpunk.FP;
	
	import uk.co.zutty.evilville.path.PathNode;
	import uk.co.zutty.evilville.path.Pathfinder;
	import uk.co.zutty.evilville.util.IPoint;
	import uk.co.zutty.evilville.util.IRect;

	public class LevelGenerator {
		
		[Embed(source = 'assets/tiles.png')]
		private static const TILES_IMAGE:Class;
		private static const TILE_SIZE:Number = 32;
		
		private static const MARGIN:int = 3;
		private static const MAX_RADIUS:int = 8;
		private static const MIN_RADIUS:int = 3;

		private var _bounds:IRect;
		private var _layer:Layer;
		
		public function LevelGenerator() {
			_bounds = new IRect(0, 0, 80, 60);
			_layer = new Layer(TILES_IMAGE, _bounds.width * TILE_SIZE, _bounds.height * TILE_SIZE, TILE_SIZE, TILE_SIZE);
			
			walkFrom(3, 15);
			//_layer.setTile(20, 14, 1);
			//_layer.setTile(20, 15, 1);
			//_layer.setTile(20, 16, 1);
			
			//pathFrom(3, 15);
		}
		
		public function placeNode(bounds:IRect, otherNodes:Array):IPoint {
			var p:IPoint = new IPoint(0, 0);
			
			// TODO: this could loop forever!
			do {
				p.x = FP.rand(bounds.width) + bounds.x;
				p.y = FP.rand(bounds.height) + bounds.y;
			} while(!checkNode(p, otherNodes));
			
			return p;
		}
		
		private function checkNode(node:IPoint, otherNodes:Array):Boolean {
			for each(var p:IPoint in otherNodes) {
				if(p.distFromManhattan(node) <= MAX_RADIUS) {
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Generate a room CENTRED at x,y.
		 */
		public function generateRoom(p:IPoint):Room {
			var w:int = FP.rand(MAX_RADIUS - MIN_RADIUS) + MIN_RADIUS;
			var h:int = FP.rand(MAX_RADIUS - MIN_RADIUS) + MIN_RADIUS;
			var r:Room = new Room(p.x - (w/2), p.y - (h/2), w, h);
			
			if(w > h) {
				r.addExit(new IPoint(r.x, r.y + (h/2)));
				r.addExit(new IPoint(r.x + w, r.y + (h/2)));
			} else {
				r.addExit(new IPoint(r.x + (w/2), r.y));
				r.addExit(new IPoint(r.x + (w/2), r.y + h));
			}
			return r;
		}

		public function drawRoom(room:Room):void {
			for(var i:uint = 0; i < room.width; i++) {
				for(var j:uint = 0; j < room.height; j++) {
					//var tidx:uint = (i == 0 || i == room.width-1 || j == 0 || j == room.height-1) ? 0 : 1;
					_layer.setTile(room.x + i, room.y + j, 2);
				}
			}
		}
		
		public function drawExit(p:IPoint):void {
			_layer.setTile(p.x, p.y, 3);
		}
		
		public function pathBetween(a:IPoint, b:IPoint):void {
			var pf:Pathfinder = new Pathfinder(function (p:IPoint):Boolean {
				return p.x >= 0 && p.x <= 40 && p.y >= 0 && p.y <= 30 && _layer.tileAt(p.x, p.y) <= 0;
			});
			var path:Vector.<IPoint> = pf.findPath(a, b);
			
			for each(var p:IPoint in path) {
				_layer.setTile(p.x, p.y, 2);
			}
		}
		
		public function walkFrom(startX:uint, startY:uint):void {
			var TARGET_NODES:uint = 1;
			var distSinceTurn:uint = 0;
			
			var nodes:Array = [];
			
			var entrance:IPoint = new IPoint(startX, startY);
			drawExit(entrance);
			nodes.push(entrance);

			// Walk
			for(var n:uint = 1; n <= TARGET_NODES; n++) {
				var p:IPoint = placeNode(_bounds.inset(MARGIN + MAX_RADIUS), nodes);
				nodes.push(p);
				
				// Path between the nodes
				var prev:IPoint = nodes[n - 1];
				pathBetween(prev, p);
				
				// Draw the node itself
				if(n == TARGET_NODES - 1) {
					drawExit(p);
				} else {
					drawRoom(generateRoom(p));
				}
			}
		}
		
		public function get layer():Layer {
			return _layer;
		}
	}
}