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
import luxe.Rectangle;
import luxe.Sprite;
import luxe.Vector;
import psg.PixelSprite;


class Main extends luxe.Game {
  
  var spaceship:psg.Mask;
  var humanoid:psg.Mask;
  var dragon:psg.Mask;
  var robot:psg.Mask;

  public static inline var SPRITE_COUNT:Int = 1; //116;
  public static inline var SPRITE_XMAX:Int = 700;
  public static inline var SPRITE_SPACING:Int = 10;
  public static inline var SPRITE_SCALE:Float = 8;
  
  var _y:Int;
  var _x:Int;


  override function config(config:luxe.AppConfig):luxe.AppConfig
  {
    config.window.width = 300;
    config.window.height = 300;
    config.window.resizable = false;
            
    return config;
  }
  
  override function ready () {
    
    test1();

    // removeChildren(0, numChildren);

    // showExamples();
  }


  function test1():Void
  {
    var newMask = new psg.Mask({
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
    var newSprite:PixelSprite = new PixelSprite({
      mask: newMask,
      isColored: true, 
      colorVariations: 0.9,
      saturation: 0.8
    });

    var spr:Sprite = new Sprite({
      name: 'generatedSprite',
      name_unique: true,
      size: new Vector(newSprite.mask.width, newSprite.mask.height),
      scale: new Vector(SPRITE_SCALE,SPRITE_SCALE),
      color: new Color().rgb(0xFFFFFFFF),
    });
    spr.add(newSprite);
  }


  function showExamples():Void
  {
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


    var i:Int = 0;
    _y = SPRITE_SPACING;
    _x = SPRITE_SPACING;
    
    // Example 1

    placeText( "Colored ship sprites");

    for (i in 0...SPRITE_COUNT)
    {
      placeSprite({
        mask: spaceship,
        isColored: true
      });
    }
    prepareForNextExample();


    // Example 2

    placeText( "Colored humanoids (with low saturation)");

    for (i in 0...SPRITE_COUNT)
    {
      placeSprite({
        mask: humanoid,
        isColored: true,
        saturation: 0.1
      });
    }
    prepareForNextExample();


    // Example 3

    placeText( "Colored ship sprites (with many color variations per ship)");

    for (i in 0...SPRITE_COUNT)
    {
      placeSprite({
        mask: spaceship,
        isColored: true, 
        colorVariations: 0.9,
        saturation: 0.8
      });
    }
    prepareForNextExample();


    // Example 4

    placeText( "Colored dragon sprites");

    for (i in 0...SPRITE_COUNT)
    {
      placeSprite({
        mask: dragon,
        isColored: true
      });
    }
    prepareForNextExample();



    // Example 5

    placeText( "Black & white robot sprites");

    for (i in 0...SPRITE_COUNT)
    {
      placeSprite({
        mask: robot
      });
    }
    prepareForNextExample();


  }


  private function placeText( str:String ):Void
  {
    var text:Text = new Text({
      text: str,
      bounds: new Rectangle(SPRITE_SPACING, _y, 600, 40),
      align: left,
      align_vertical: center,
      point_size: 16,
      color: new Color().rgb(0xFFFFFF),
    });

    _y += 50;
  }

  /**
   * Enlarges and places sprite to the view.
   * @return
   */
  private function placeSprite( _options:psg.PixelSpriteOptions ):Void
  {
    var newSprite:PixelSprite = new PixelSprite(_options);
    var spr:Sprite = new Sprite({
      name: 'generatedSprite',
      name_unique: true,
      size: new Vector(newSprite.mask.width, newSprite.mask.height),
      scale: new Vector(SPRITE_SCALE,SPRITE_SCALE),
      color: new Color().rgb(0xFFFFFF),
    });
    spr.add(newSprite);

    if( _x >= SPRITE_XMAX )
    {
      _x = SPRITE_SPACING;
      _y += Math.floor( (newSprite.mask.height*SPRITE_SCALE) + SPRITE_SPACING );
    }
    _x += Math.floor( (newSprite.mask.width*SPRITE_SCALE) + SPRITE_SPACING );

    spr.pos = new Vector(_x, _y);
  }


  private function prepareForNextExample():Void
  {
    _x = SPRITE_SPACING;
    _y += 50;
  }
  
  
}
