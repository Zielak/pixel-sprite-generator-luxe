
package components;

import luxe.Component;
import luxe.Vector;

class Mover extends Component
{

    public var r:Float;
    var t:Float;
    var speed:Float;
    var startPos:Vector;

    override function init():Void
    {
        r = 50;
        t = Math.random()*Math.PI;
        speed = 2;
    }

    override function onadded(){
        startPos = new Vector();
        startPos.copy_from(entity.pos);
    }

    override function onremoved(){
        entity.pos.copy_from(startPos);
    }

    override function update(dt:Float):Void
    {
        t += dt*speed;

        entity.pos.x = startPos.x + Math.sin(t)*r;
        // entity.pos.y = startPos.y + Math.cos(t)*r;
    }

}
