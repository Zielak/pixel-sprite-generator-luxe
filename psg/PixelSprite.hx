
package psg;

import luxe.Color;
import luxe.Component;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture;
import snow.utils.UInt8Array;

class PixelSprite extends Component
{
  var _sprite:Sprite;

  public var data:Array<Int>;

  public var mask:Mask;

  public var isColored:Bool;
  public var edgeBrightness:Float;
  public var colorVariations:Float;
  public var brightnessNoise:Float;
  public var saturation:Float;

  public var width(get, null):Int;
  public var height(get, null):Int;

  @:isVar public var rendered(default, null):Bool = false;

  var pixelsData2D:Array<Array<Color>>;
  var pixelsInt:Array<Int>;
  var pixelsIntSplit:Array<Int>;
  var pixelsUInt8:UInt8Array;


  /**
  *   The Sprite class makes use of a Mask instance to generate a 2D sprite.
  *   {
  *       colored         : true,   // boolean
  *       edgeBrightness  : 0.3,    // value from 0 to 1
  *       colorVariations : 0.2,    // value from 0 to 1
  *       brightnessNoise : 0.3,    // value from 0 to 1
  *       saturation      : 0.5     // value from 0 to 1
  *   }
  *   @class PixelSprite
  *   @param {_options} 
  *   @constructor
  */
 
  override public function new( _options:PixelSpriteOptions ):Void
  {
    _options.name = 'psg';
    super(_options);

    mask = _options.mask; // cast(_options.mask, Mask);

      // Default values
    isColored       = (_options.isColored == null) ? false : _options.isColored;
    edgeBrightness  = (_options.edgeBrightness == null) ? 0.3 : _options.edgeBrightness;
    colorVariations = (_options.colorVariations == null) ? 0.2 : _options.colorVariations;
    brightnessNoise = (_options.brightnessNoise == null) ? 0.3 : _options.brightnessNoise;
    saturation      = (_options.saturation == null) ? 0.5 : _options.saturation;

    data = new Array<Int>();

    pixelsInt = new Array<Int>();
    pixelsIntSplit = new Array<Int>();


    pixelsData2D = new Array<Array<psg.Color>>();
    for(i in 0...height)
    {
      pixelsData2D[i] = new Array<psg.Color>();
    }
  }


  /**
   * The init method calls all functions required to generate the sprite.
   */
  override function onadded():Void
  {
    _sprite = cast entity;
    // _sprite.texture = new Texture(Luxe.resources, texture);

    initSprite();
    initData();

    applyMask();
    generateRandomSample();

    if (mask.mirrorX) {
      mirrorX();
    }

    if (mask.mirrorY) {
      mirrorY();
    }

    generateEdges();
  }


  function initSprite():Void
  {
    _sprite.size.x = Std.int( mask.width * (mask.mirrorX ? 2 : 1) );
    _sprite.size.y = Std.int( mask.height * (mask.mirrorY ? 2 : 1) );
  }
  
  /**
   * The getData method returns the sprite template data at location (x, y)
   * 
   *    -1 = Always border (black)
   *     0 = Empty
   *     1 = Randomly chosen Empty/Body
   *     2 = Randomly chosen Border/Body
   *     
   * @param  x X position of pixel
   * @param  y Y position of pixel
   * @return   Value of pixel at position
   */
  function getData(x, y):Int
  {
    return data[y * width + x];
  };

  /**
  *   The setData method sets the sprite template data at location (x, y)
  *
  *      -1 = Always border (black)
  *       0 = Empty
  *       1 = Randomly chosen Empty/Body
  *       2 = Randomly chosen Border/Body
  *
  *   @method setData
  *   @param {x}
  *   @param {y}
  *   @param {value}
  *   @returns {undefined}
  */
  function setData(x, y, value):Void
  {
    data[y * width + x] = value;
  };

  /**
  *   The initData method initializes the sprite data to completely solid.
  *
  *   @method initData
  *   @returns {undefined}
  */
  function initData():Void
  {
    var h:Int = height;
    var w:Int = width;
    var x:Int = 0;
    var y:Int = 0;

    for (y in 0...h)
    {
      for (x in 0...w)
      {
        setData(x, y, -1);
      }
    }
  };

  /**
  *   The mirrorX method mirrors the template data horizontally.
  *
  *   @method mirrorX
  *   @returns {undefined}
  */
  function mirrorX():Void
  {
    var h:Int = height;
    var w:Int = Math.floor(width/2);
    var x:Int = 0;
    var y:Int = 0;

    for (y in 0...h)
    {
      for (x in 0...w)
      {
        setData(width - x - 1, y, getData(x, y));
      }
    }
  };


  /**
  *   The mirrorY method mirrors the template data vertically.
  *
  *   @method 
  *   @returns {undefined}
  */
  function mirrorY():Void
  {
    var h:Int = Math.floor(height/2);
    var w:Int = width;
    var x:Int = 0;
    var y:Int = 0;

    for (y in 0...h)
    {
      for (x in 0...w)
      {
        setData(x, height - y - 1, getData(x, y));
      }
    }
  };


  /**
  *   The applyMask method copies the mask data into the template data array at
  *   location (0, 0).
  *
  *   (note: the mask may be smaller than the template data array)
  *
  *   @method applyMask
  *   @returns {undefined}
  */
  function applyMask():Void
  {
    var h:Int = mask.height;
    var w:Int = mask.width;
    var x:Int = 0;
    var y:Int = 0;

    for (y in 0...h)
    {
      for (x in 0...w)
      {
        setData(x, y, mask.data[y * w + x]);
      }
    }
  };



  /**
  *   Apply a random sample to the sprite template.
  *
  *   If the template contains a 1 (internal body part) at location (x, y), then
  *   there is a 50% chance it will be turned empty. If there is a 2, then there
  *   is a 50% chance it will be turned into a body or border.
  *
  *   (feel free to play with this logic for interesting results)
  *
  *   @method generateRandomSample
  *   @returns {undefined}
  */
  function generateRandomSample():Void
  {
    var h:Int = height;
    var w:Int = width;
    var x:Int = 0;
    var y:Int = 0;
    var val:Int = 0;

    for (y in 0...h)
    {
      for (x in 0...w)
      {
        val = getData(x, y);

        if (val == 1)
        {
          val = val * Math.round( Math.random() );
        }
        else if (val == 2)
        {
          if (Math.random() > 0.5)
          {
            val = 1;
          }
          else
          {
            val = -1;
          }
        } 

        setData(x, y, val);
      }
    }
  };


  /**
  *   This method applies edges to any template location that is positive in
  *   value and is surrounded by empty (0) pixels.
  *
  *   @method generateEdges
  *   @returns {undefined}
  */
  function generateEdges():Void
  {
    var h:Int = height;
    var w:Int = width;
    var x:Int = 0;
    var y:Int = 0;

    for (y in 0...h)
    {
      for (x in 0...w)
      {
        if (getData(x, y) > 0)
        {
          if (y - 1 >= 0 && getData(x, y-1) == 0)
          {
            setData(x, y-1, -1);
          }
          if (y + 1 < height && getData(x, y+1) == 0)
          {
            setData(x, y+1, -1);
          }
          if (x - 1 >= 0 && getData(x-1, y) == 0)
          {
            setData(x-1, y, -1);
          }
          if (x + 1 < width && getData(x+1, y) == 0)
          {
            setData(x+1, y, -1);
          }
        }
      }
    }
  };

  /**
  *   
  *
  *   (note: only template locations with the values of -1 (border) are rendered)
  *
  *   @method renderPixelData
  *   @returns {undefined}
  */
  function renderPixelData():Void
  {
    // Prepare all the variables first
    var isVerticalGradient:Bool = Math.random() > 0.5;
    var saturation:Float        = Math.max( Math.min( Math.random() * saturation, 1 ), 0);
    var hue:Float               = Math.random();

    var u:Int = 0;
    var v:Int = 0;
    var ulen:Int = 0;
    var vlen:Int = 0;

    var isNewColor:Float = 0;

    var val:Int = 0;
    var index:Int = 0;

    var color:Color;
    var colorHSL:ColorHSL;

    var brightness:Float = 0;

    // Target XY of BitmapData pixels
    var x:Int = 0;
    var y:Int = 0;


    if (isVerticalGradient)
    {
      ulen = height;
      vlen = width;
    }
    else
    {
      ulen = width;
      vlen = height;
    }

    // _sprite.texture.lock();

    for (u in 0...ulen)
    {
      // Create a non-uniform random number between 0 and 1 (lower numbers more likely)
      isNewColor = Math.abs(((Math.random() * 2 - 1) 
                           + (Math.random() * 2 - 1) 
                           + (Math.random() * 2 - 1)) / 3);

      // Only change the color sometimes (values above 0.8 are less likely than others)
      if (isNewColor > (1 - colorVariations))
      {
        hue = Math.random();
      }

      for (v in 0...vlen)
      {
        if (isVerticalGradient)
        {
          val   = getData(v, u);
          index = (u * vlen + v) * 4;
          x     = v;
          y     = u;
        }
        else
        {
          val   = getData(u, v);
          index = (v * ulen + u) * 4;
          x     = u;
          y     = v;
        }

        color = new Color(1,1,1,1);

        if (val != 0)
        {
          if (isColored)
          {
            // Fade brightness away towards the edges
            brightness = Math.sin((u / ulen) * Math.PI) * (1 - brightnessNoise) + Math.random() * brightnessNoise;

            // Get the RGB color value
            colorHSL = new ColorHSL(hue, saturation, brightness);
            color.fromColorHSV( colorHSL );

            // If this is an edge, then darken the pixel
            if (val == -1)
            {
              color.r *= edgeBrightness;
              color.g *= edgeBrightness;
              color.b *= edgeBrightness;
            }

          }
          else
          {
            // Not colored, simply output black
            if (val == -1)
            {
              color.set(0,0,0,1);
            }
          }
        }
        else
        {
          // transparent pixel plz
          color.a = 0;
        }
        pixelsData2D[y][x] = color;
      }
    }
    render();
  };

  function render():Void
  {
      // First, get all pixels to 1D array
    for (i in 0...pixelsData2D.length)
    {
      for (j in 0...pixelsData2D[i].length)
      {
        pixelsIntSplit.push( Math.round(pixelsData2D[i][j].r*0xff) );
        pixelsIntSplit.push( Math.round(pixelsData2D[i][j].g*0xff) );
        pixelsIntSplit.push( Math.round(pixelsData2D[i][j].b*0xff) );
        pixelsIntSplit.push( Math.round(pixelsData2D[i][j].a*0xff) );
      }
    };

    // trace('pixelsIntSplit.length = ${pixelsIntSplit.length}');

      // Now pass it over to UInt8Array thing
    pixelsUInt8 = new UInt8Array(data.length*4);
    pixelsUInt8.set(pixelsIntSplit);

    // trace('data.length*4 = ${data.length*4}');
    // trace('pixelsUInt8.length = ${pixelsUInt8.length}');

    // trace('pixelsUInt8' + pixelsUInt8);

    // trace(' ## Texture.load_from_pixels(${name+'.pixels'}, ${width}, ${height}, ...)');
    _sprite.texture = Texture.load_from_pixels(_sprite.name+name+'.pixels', width, height, pixelsUInt8, false);
    _sprite.texture.filter = nearest;

    rendered = true;

    // _sprite.texture.set_pixel( new Vector(x, y) , color );
    // pixelsInt.push(color.getARGB());

    // trace('render() Done');
  }

  override function update(_)
  {
    if(_sprite.inited && !rendered)
    {
      renderPixelData();
    }
  }


  function get_width():Int{
    return (mask.mirrorX) ? mask.width*2 : mask.width;
  }
  function get_height():Int{
    return (mask.mirrorY) ? mask.height*2 : mask.height;
  }

  /**
  *   This method converts the template data to a string value for debugging
  *   purposes.
  *
  *   @method toString
  *   @returns {undefined}
  */
  public function toString():String
  {
    var h:Int = height;
    var w:Int = width;
    var x:Int = 0;
    var y:Int = 0;
    var output:String = "";

    for (y in 0...h)
    {
      for (x in 0...w)
      {
        var val = getData(x, y);
        output += (val >= 0) ? " " + val : "" + val;
      }
      output += "\n";
    }
    return output;
  };

}

typedef PixelSpriteOptions = {
  > SpriteOptions,

  var mask:psg.Mask;
  @:optional var isColored:Bool;
  @:optional var edgeBrightness:Float;
  @:optional var colorVariations:Float;
  @:optional var brightnessNoise:Float;
  @:optional var saturation:Float;
}





/**
 * MASK
 */
class Mask 
{

  public var data:Array<Int>;
  public var width:Int;
  public var height:Int;
  public var mirrorX:Bool;
  public var mirrorY:Bool;
  
  /**
   *   The Mask class defines a 2D template form which sprites can be generated.
   *
   *   @class Mask
   *   @constructor
   *   @param {data} Integer array describing which parts of the sprite should be
   *   empty, body, and border. The mask only defines a semi-ridgid stucture
   *   which might not strictly be followed based on randomly generated numbers.
   *
   *      -1 = Always border (black)
   *       0 = Empty
   *       1 = Randomly chosen Empty/Body
   *       2 = Randomly chosen Border/Body
   *
   *   @param {width} Width of the mask data array
   *   @param {height} Height of the mask data array
   *   @param {mirrorX} A boolean describing whether the mask should be mirrored on the x axis
   *   @param {mirrorY} A boolean describing whether the mask should be mirrored on the y axis
   */
  public function new( options:MaskOptions ):Void
  {
    data      = options.data;
    width     = options.width;
    height    = options.height;

    mirrorX   = (options.mirrorX == null) ? true : options.mirrorX;
    mirrorY   = (options.mirrorY == null) ? true : options.mirrorY;
  }

  public function toString():String
  {
    return 'size: [${width}, ${height}]; data: ${data}';
  }

}

typedef MaskOptions = {
  var data:Array<Int>;
  var width:Int;
  var height:Int;

  @:optional var mirrorX:Bool;
  @:optional var mirrorY:Bool;
}

/**
 * COLOR
 */
class Color 
{

  public var r:Float;
  public var g:Float;
  public var b:Float;
  public var a:Float;

  public function new(r_:Float, g_:Float, b_:Float, ?a_:Float = 1.0):Void
  {
    a = a_;
    r = r_;
    g = g_;
    b = b_;
  }


  /**
   * Update color with RGB values
   * @param r_ Red
   * @param g_ Green
   * @param b_ Blue
   */
  public function set(r_:Float, g_:Float, b_:Float, ?a_:Float = 1.0):Void
  {
    a = a_;
    r = r_;
    g = g_;
    b = b_;
  }


  /**
   * Get RGB color
   * @return Int in format 0xRRGGBB
   */
  public function getRGB():Int
  {
    var rgb:Int;

    rgb = (Math.round(r*0xff) << 16) | (Math.round(g*0xff) << 8) | (Math.round(b*0xff));
    return rgb;
  }

  /**
   * Get ARGB color
   * @return Int in format 0xAARRGGBB
   */
  public function getARGB():Int
  {
    var rgb:Int;

    rgb = (Math.round(a*0xff) << 24) | (Math.round(r*0xff) << 16) | (Math.round(g*0xff) << 8) | (Math.round(b*0xff));
    return rgb;
  }


  /**
   * Update color with HSL values
   * @param h Hue
   * @param s Saturation
   * @param l Light
   */
  public function setHSL(h:Float, s:Float, l:Float):Void
  {
    var i:Float;
    var f:Float;
    var p:Float;
    var q:Float;
    var t:Float;

    i = Math.floor(h * 6);
    f = h * 6 - i;
    p = l * (1 - s);
    q = l * (1 - f * s);
    t = l * (1 - (1 - f) * s);
    
    switch (i % 6) {
      case 0: r = l; g = t; b = p;
      case 1: r = q; g = l; b = p;
      case 2: r = p; g = l; b = t;
      case 3: r = p; g = q; b = l;
      case 4: r = t; g = p; b = l;
      case 5: r = l; g = p; b = q;
    }
  }
}

