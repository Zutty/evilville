package uk.co.zutty.evilville.levels
{
	public class Level {
		
		private var _tiles:Class;
		private var _width:Number;
		private var _height:Number;
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		
		public function Level(tiles:Class, width:Number, height:Number, tileWidth:Number, tileHeight:Number) {
			_tiles = tiles;
			_width = width;
			_height = height;
			_tileWidth = tileWidth;
			_tileHeight = tileHeight;
		}
		
		public function get width():Number {
			return _width;
		}

		public function get height():Number {
			return _height;
		}

		public function newLayer(solid:Boolean = false):Layer {
			return new Layer(tiles, _width, _height, _tileWidth, _tileHeight, solid);
		}
	}
}