package uk.co.zutty.evilville.entities
{
    import flash.geom.Rectangle;
    
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    
    public class Terrain extends Entity {
        
        public function Terrain(x:Number, y:Number, img:Class, rect:Rectangle) {
            super(x, y, new Image(img, rect), mask);
            layer = -y - rect.height;
        }
    }
}