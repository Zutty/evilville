package uk.co.zutty.evilville.entities
{
	import net.flashpunk.graphics.Anim;
	import net.flashpunk.graphics.Spritemap;
	
	import uk.co.zutty.evilville.util.IPoint;

	public class MobSprite extends Spritemap {
		
		public const FACING_UP:String = "u";
		public const FACING_DOWN:String = "d";
		public const FACING_LEFT:String = "l";
		public const FACING_RIGHT:String = "r";
		
		private var _facing:String;
		
		public function MobSprite(img:Class, frameWidth:uint = 0, frameHeight:uint = 0) {
			super(img, frameWidth, frameHeight);
			_facing = FACING_DOWN;
		}
		
		public function get facing():String {
			return _facing;
		}
		
		public function set facing(f:String):void {
			_facing = f;
		}
		
		public function set facingVector(f:IPoint):void {
			if(Math.abs(f.x) >= Math.abs(f.y)) {
				if(f.x < 0) {
					_facing = FACING_LEFT;
				} else {
					_facing = FACING_RIGHT;
				}
			} else {
				if(f.y < 0) {
					_facing = FACING_UP;
				} else {
					_facing = FACING_DOWN;
				}
			}
		}
		
		public function playFacing(name:String = "", reset:Boolean = false, frame:int = 0):Anim {
			return play(name + "_" + _facing, reset, frame);
		}
		
		// Sequences
		public function spawn(onSpawn:Function = null):void {
			callback = function():void {
				callback = null;
				stand();
				if(onSpawn != null) {
					onSpawn();
				}
			};
			play("spawn", true);
		}

		public function stand():void {
			playFacing("stand");
		}

		public function walk():void {
			playFacing("walk");
		}
		
		public function attack():void {
			playFacing("attack");
		}
		
		public function die(onDie:Function = null):void {
			if(onDie != null) {
				callback = function():void {
					callback = null;
					onDie();
				};
			}
			playFacing("die");
		}
	}
}