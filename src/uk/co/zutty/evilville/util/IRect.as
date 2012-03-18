package uk.co.zutty.evilville.util
{
	public class IRect extends IPoint {

		private var _width:int;
		private var _height:int;

		public function IRect(x:int, y:int, width:int, height:int) {
			super(x, y);
			_width = width;
			_height = height;
		}

		public function get width():int {
			return _width;
		}
		
		public function get height():int {
			return _height;
		}

		public function set width(width:int):void {
			_width = width;
		}
		
		public function set height(height:int):void {
			_height = height;
		}
		
		public function inset(amount:int):IRect {
			return new IRect(x + amount, y + amount, _width - (amount*2),  _height - (amount*2));
		}
	}
}