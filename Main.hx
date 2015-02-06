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
import luxe.Input;
import psg.PixelSprite;


class Main extends luxe.Game {
  
  var spaceship:psg.Mask;
  var humanoid:psg.Mask;
  var dragon:psg.Mask;
  var robot:psg.Mask;

  // var testSprite:Sprite;

  public static inline var SPRITE_COUNT:Int = 2;
  public static inline var SPRITE_XMAX:Int = 500;
  public static inline var SPRITE_SPACING:Int = 10;
  public static inline var SPRITE_SCALE:Float = 3;
  
  var _y:Int;
  var _x:Int;


  override function config(config:luxe.AppConfig):luxe.AppConfig
  {
    config.window.width = 600;
    config.window.height = 800;
    config.window.resizable = false;
            
    return config;
  }
  
  override function ready () {
    Luxe.renderer.clear_color = new Color().rgb(0xDDDDDD);

    initTestMasks();
    showExamples();
  }


  override function onkeydown(e:KeyEvent):Void
  {
    if(e.keycode == Key.space)
    {
      Luxe.scene.empty();
      showExamples();
    }
  }

  override function ontouchdown(e:TouchEvent):Void
  {
    Luxe.scene.empty();
    showExamples();
  }




  function initTestMasks():Void
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
        0, 0, 0, 0, 0, 1, 1, 1,
        0, 0, 0, 0, 1, 1, 2,-1,
        0, 0, 0, 0, 1, 1, 2,-1,
        0, 0, 0, 0, 0, 0, 2,-1,
        0, 0, 1, 1, 1, 1, 2,-1,
        0, 1, 1, 2, 2, 1, 2,-1,
        0, 1, 1, 1, 0, 1, 1, 2,
        0, 1, 1, 0, 0, 1, 1, 2,
        0, 0, 1, 0, 1, 1, 2, 2,
        0, 0, 0, 0, 1, 2, 0, 0,
        0, 0, 0, 0, 1, 1, 0, 0,
        0, 0, 0, 0, 2, 1, 0, 0,
        0, 0, 0, 1, 2, 1, 1, 0,
        0, 0, 0, 1, 2, 2, 1, 0
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
  }

  function test1():Void
  {    
    // if(testSprite != null)
    // {
    //   testSprite.destroy(true);
    // }

    Luxe.scene.empty();
    
    var i:Int = 0;
    for(i in 0...3)
    {
      placeNewSprite();      
    }
  }

  function placeNewSprite():Void
  {
    var newPos:Vector = new Vector();
    newPos.x = Math.random()*Luxe.screen.w/2 + Luxe.screen.w/4;
    newPos.y = Math.random()*Luxe.screen.h/2 + Luxe.screen.h/4;

    var newSprite:PixelSprite = new PixelSprite({
      mask: spaceship,
      isColored: true,  
      colorVariations: 0.6,
      saturation: 0.8
    });

    var mover:components.Mover = new components.Mover({
      name: 'mover'
    });

    var testSprite:Sprite = new Sprite({
      name: 'generatedSprite',
      name_unique: true,
      size: new Vector(newSprite.mask.width, newSprite.mask.height),
      scale: new Vector(SPRITE_SCALE,SPRITE_SCALE),
      color: new Color(),
      pos: new Vector().copy_from(newPos)
    });

    testSprite.add(mover);
    testSprite.add(newSprite);
  }


  function showExamples():Void
  {
    var i:Int = 0;
    _y = SPRITE_SPACING;
    _x = SPRITE_SPACING;

    placeText("Tap or [SPACE] generate new sprites");
    
    // Example 1

    placeText("Colored ship sprites");

    for (i in 0...SPRITE_COUNT)
    {
      placeSprite({
        mask: spaceship,
        isColored: true
      });
    }
    prepareForNextExample();


    // Example 2

    placeText("Colored humanoids (with low saturation)");

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

    placeText("Colored ship sprites (with many color variations per ship)");

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

    placeText("Colored dragon sprites");

    for (i in 0...SPRITE_COUNT)
    {
      placeSprite({
        mask: dragon,
        isColored: true
      });
    }
    prepareForNextExample();



    // Example 5

    placeText("Black & white robot sprites");

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
      align: center,
      align_vertical: center,
      point_size: 16,
      color: new Color().rgb(0x000000),
    });

    _y += 60;
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
      _y += Math.floor( (newSprite.height*SPRITE_SCALE) + SPRITE_SPACING );
    }
    _x += Math.floor( (newSprite.width*SPRITE_SCALE) + SPRITE_SPACING );

    spr.pos = new Vector(_x, _y);
  }


  private function prepareForNextExample():Void
  {
    _x = SPRITE_SPACING;
    _y += 50;
  }
  
  
}
