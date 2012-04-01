package uk.co.zutty.evilville.entities
{
    import flash.geom.Rectangle;
    
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.graphics.Image;
    
    public class Terrain extends Entity {
        
        public function Terrain(x:Number, y:Number, img:Class, rect:Rectangle, solid:Boolean = false) {
            super(x, y, new Image(img, rect));
            layer = -y - rect.height;
            collidable = solid;
			if(solid) {
                type = "terrain";
				setHitbox(48, 6, -((rect.width - 48) / 2), 6 - rect.height);
			}
        }
    }
}