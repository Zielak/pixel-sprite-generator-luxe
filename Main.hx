/**
 * Pixel Sprite Generator v0.0.3
 *
 * This is a Haxe version of David Bollinger's pixelrobots and
 * pixelspaceships algorithm.
 *
 * More info:
 * http://www.davebollinger.com/works/pixelrobots/
 * http://www.davebollinger.com/works/pixelspaceships/
 *
 * Archived website (links above are down):
 * http://web.archive.org/web/20080228054405/http://www.davebollinger.com/works/pixelrobots/
 * http://web.archive.org/web/20080228054410/http://www.davebollinger.com/works/pixelspaceships/
 *
 */

package;

import luxe.Color;
import luxe.Text;
import luxe.Vector;


class Main extends luxe.Game {
  
  var spaceship:psg.Mask;
  var humanoid:psg.Mask;
  var dragon:psg.Mask;
  var robot:psg.Mask;

  public static inline var SPRITE_COUNT:Int = 40; //116;
  public static inline var SPRITE_XMAX:Int = 700;
  public static inline var SPRITE_SPACING:Int = 10;
  public static inline var SPRITE_SCALE:Float = 3;
  
  var sprite:psg.PixelSprite;
  var _y:Int;
  var _x:Int;

  
  public function new () {
    
    super ();
    
    spaceship = new psg.Mask({
      data: [
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 1, 1,
        0, 0, 0, 0, 1,-1,
        0, 0, 0, 1, 1,-1,
        0, 0, 0, 1, 1,-1,
        0, 0, 1, 1, 1,-1,
        0, 1, 1, 1, 2, 2,
        0, 1, 1, 1, 2, 2,
        0, 1, 1, 1, 2, 2,
        0, 1, 1, 1, 1,-1,
        0, 0, 0, 1, 1, 1,
        0, 0, 0, 0, 0, 0
      ],
      width: 6,
      height: 12,
      mirrorX: true,
      mirrorY: false
    });

    humanoid = new psg.Mask({
      data: [
        0, 0, 0, 0, 1, 1, 1, 1,
        0, 0, 0, 0, 1, 1, 2,-1,
        0, 0, 0, 0, 1, 1, 2,-1,
        0, 0, 0, 0, 0, 0, 2,-1,
        0, 0, 1, 1, 1, 1, 2,-1,
        0, 1, 1, 2, 2, 1, 2,-1,
        0, 0, 1, 1, 0, 1, 1, 2,
        0, 0, 0, 0, 1, 1, 1, 2,
        0, 0, 0, 0, 1, 1, 1, 2,
        0, 0, 0, 0, 1, 1, 0, 0,
        0, 0, 0, 1, 1, 1, 0, 0,
        0, 0, 0, 1, 2, 1, 0, 0,
        0, 0, 0, 1, 2, 1, 0, 0,
        0, 0, 0, 1, 2, 2, 0, 0
      ],
      width: 8,
      height: 14,
      mirrorX: true,
      mirrorY: false
    });

    dragon = new psg.Mask({
      data: [
        0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,1,1,1,1,0,0,0,0,
        0,0,0,1,1,2,2,1,1,0,0,0,
        0,0,1,1,1,2,2,1,1,1,0,0,
        0,0,0,0,1,1,1,1,1,1,1,0,
        0,0,0,0,0,0,1,1,1,1,1,0,
        0,0,0,0,0,0,1,1,1,1,1,0,
        0,0,0,0,1,1,1,1,1,1,1,0,
        0,0,1,1,1,1,1,1,1,1,0,0,
        0,0,0,1,1,1,1,1,1,0,0,0,
        0,0,0,0,1,1,1,1,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0
      ],
      width: 12,
      height: 12,
      mirrorX: false,
      mirrorY: false
    }); 
                    
    robot = new psg.Mask({
      data: [
        0, 0, 0, 0,
        0, 1, 1, 1,
        0, 1, 2, 2,
        0, 0, 1, 2,
        0, 0, 0, 2,
        1, 1, 1, 2,
        0, 1, 1, 2,
        0, 0, 0, 2,
        0, 0, 0, 2,
        0, 1, 2, 2,
        1, 1, 0, 0
      ],
      width: 4,
      height: 11,
      mirrorX: true,
      mirrorY: false
    });


    // removeChildren(0, numChildren);


    showExamples();
  }


  function showExamples():Void
  {
    var i:Int = 0;
    _y = SPRITE_SPACING;
    _x = SPRITE_SPACING;
    
    // Example 1

    placeText( "Colored ship sprites");

    for (i in 0...SPRITE_COUNT)
    {
      sprite = new psg.PixelSprite({
        mask: spaceship,
        isColored: true
      });
      placeSprite( sprite );
    }
    prepareForNextExample();


    // Example 2

    placeText( "Colored humanoids (with low saturation)");

    for (i in 0...SPRITE_COUNT)
    {
      sprite = new psg.PixelSprite({
        mask: humanoid,
        isColored: true,
        saturation: 0.1
      });
      placeSprite( sprite );
    }
    prepareForNextExample();


    // Example 3

    placeText( "Colored ship sprites (with many color variations per ship)");

    for (i in 0...SPRITE_COUNT)
    {
      sprite = new psg.PixelSprite({
        mask: spaceship,
        isColored: true, 
        colorVariations: 0.9,
        saturation: 0.8
      });
      placeSprite( sprite );
    }
    prepareForNextExample();


    // Example 4

    placeText( "Colored dragon sprites");

    for (i in 0...SPRITE_COUNT)
    {
      sprite = new psg.PixelSprite({
        mask: dragon,
        isColored: true
      });
      placeSprite( sprite );
    }
    prepareForNextExample();



    // Example 5

    placeText( "Black & white robot sprites");

    for (i in 0...SPRITE_COUNT)
    {
      sprite = new psg.PixelSprite({
        mask: robot
      });
      placeSprite( sprite );
    }
    prepareForNextExample();


  }


  private function placeText( str:String ):Void
  {
    var text:Text = new Text({
      text: str,
      pos: new Vector(SPRITE_SPACING, _y),
      point_size: 16,
      color: new Color().rgb(0x000000),
      size: new Vector(600, 40),
      batcher: Luxe.renderer.batcher
    });

    _y += 30;
  }

  /**
   * Enlarges and places sprite to the view.
   * @return
   */
  private function placeSprite( sprite:psg.PixelSprite ):Void
  {
    sprite.scale.x = SPRITE_SCALE;
    sprite.scale.y = SPRITE_SCALE;

    if( _x >= SPRITE_XMAX )
    {
      _x = SPRITE_SPACING;
      _y += Math.floor( sprite.height + SPRITE_SPACING );
    }
    sprite.pos.x = _x;

    _x += Math.floor( (sprite.width + SPRITE_SPACING) );

    sprite.pos.y = _y;
  }


  private function prepareForNextExample():Void
  {
    _x = SPRITE_SPACING;
    _y += 50;
  }
  
  
}
