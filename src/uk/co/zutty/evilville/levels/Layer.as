package uk.co.zutty.evilville.levels
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	public class Layer extends Entity {
		
		private var _tilemap:Tilemap;
		private var _grid:Grid;
		private var _solid:Boolean;
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		
		public function Layer(tiles:Class, width:Number, height:Number, tileWidth:Number, tileHeight:Number, solid:Boolean = false) {
			super();

			_tilemap = new Tilemap(tiles, width, height, tileWidth, tileHeight);
			graphic = _tilemap;
			
			_solid = solid;
			_tileWidth = tileWidth;
			_tileHeight = tileHeight;
			
			if(solid) {
				_grid = new Grid(width, height, tileWidth, tileHeight);
				mask = _grid;
				type = "solid";
			}
		}
		
		public function get solid():Boolean {
			return _solid;
		}
		
		public function setTile(x:uint, y:uint, tx:uint, ty:uint):void {
			var idx:uint = _tilemap.getIndex(tx, ty);
			_tilemap.setTile(x, y, idx);

			if(_solid) {
				_grid.setTile(x, y);
			}
		}
	}
}