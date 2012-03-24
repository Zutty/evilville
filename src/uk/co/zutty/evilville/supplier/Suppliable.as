package uk.co.zutty.evilville.supplier
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    
    public class Suppliable extends Entity {
        
        public function Suppliable(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) {
            super(x, y, graphic, mask);
            despawn();
        }
        
        public function spawn(x:Number, y:Number):void {
            visible = true;
            active = true;
            collidable = true;
            this.x = x;
            this.y = y;
        }
        
        public function despawn():void {
            visible = false;
            active = false;
            collidable = false;
        }
    }
}