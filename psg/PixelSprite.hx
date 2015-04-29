package psg;

import luxe.Color;
import luxe.Component;
import luxe.options.SpriteOptions;
import luxe.Rectangle;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Texture;
import snow.api.buffers.Uint8Array;

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

  var pixelsData2D:Array<Array<Color>>;
  var pixelsUInt8:Uint8Array;

// ##### STATIC ######

  static public var TEXTURE_W:Int = 128;
  static public var TEXTURE_H:Int = 128;
  
  static var _inited:Bool = false;
  static var count:Int = 0;
  
  // Static texture for all the sprites
  static public var texture:Texture;

  // Generated images in Uint8Array
  static var images:Array<Uint8Array>;

  // Remember UV of each generated texture
  static var uvs:Array<Rectangle>;

  static public function initGenerator()
  {
    if(_inited)
    {
      texture.destroy(true);

      images   = null;
      uvs      = null;
      count    = 0;
      _inited  = false;
    }

    // TODO: Manage bigger texture size
    texture = new Texture({
      id: 'pixel-sprite-generator',
      width: TEXTURE_W,
      height: TEXTURE_H
    });
    texture.filter_min = texture.filter_mag = FilterType.nearest;

    images   = new Array<Uint8Array>();
    uvs      = new Array<Rectangle>();

    _inited = true;
  }

  /**
   * Add new pixels to the texture and retrieve its UV
   * @param pixels generated pixels
   * @param width  sprite's width
   * @param height sprite's height
   * @return UV coords for the sprite
   */
  static public function addPixels(pixels:Array<Array<Color>>):Rectangle
  {
    var _w:Int = pixels[0].length;
    var _h:Int = pixels.length;

    var _imageU8:Uint8Array = new Uint8Array(_w * _h * 4);
    var _pixelsInt:Array<Int> = new Array<Int>();

    // Find empty spot
    var _uv:Rectangle = getSpace(_w, _h);

    var offset:Int;

    // Place new sprite to texture row by row
    for (_y in 0..._h)
    {
      // _pixelsInt = new Array<Int>();
      for (_x in 0..._w)
      {
        _pixelsInt.push( Math.round(pixels[_y][_x].r*0xff) );
        _pixelsInt.push( Math.round(pixels[_y][_x].g*0xff) );
        _pixelsInt.push( Math.round(pixels[_y][_x].b*0xff) );
        _pixelsInt.push( Math.round(pixels[_y][_x].a*0xff) );

      }

      // offset = Std.int( (_y * _w * 4) /*+ _uv.x * 4*/ );

    };

#if web
    _imageU8.set( _pixelsInt );
#else
    _imageU8.set( null, _pixelsInt );
#end

    images.push(_imageU8);
    uvs.push(_uv);

    // Submit whole updated pixels to texture
    // texture.submit(_imageU8);

    updateTexture();

    count ++;

    return _uv;
  }

  static function getSpace(width:Int, height:Int):Rectangle
  {
    var rect:Rectangle = new Rectangle(0,0,width,height);

    var found:Bool = false;
    var _x:Int = 0;
    var _y:Int = 0;

    while(!found)
    {
      rect.set(_x, _y);
      found = true;

      // Check if overlapping for each occupied space 
      for(_uv in uvs){
        found = found && ( !rect.overlaps(_uv) );
      }

      // Try with another space
      _x ++;
      if(_x + width >= texture.width){
        _x = 0;
        _y++;

        // Check Y value
        if(_y + height >= texture.height){
          // TODO: change texture size?
          throw "Can't place PixelSprite outside the texture";
        }
      }
    }
    // trace('found = ${found}; at (${rect.x}, ${rect.y}), size (${rect.w}, ${rect.h})');

    return rect;
  }

  /**
   * Merge all created images into one "atlas"
   */
  static function updateTexture()
  {
    // Main U8Array for the texture
    var _textureU8 = new Uint8Array(texture.width * texture.height * 4);

    var _imageU8:Uint8Array;
    var _pixelsInt:Array<Int>;

    var _uv:Rectangle;

    var _w:Int;
    var _h:Int;

    var offset:Int;

    // For every registered sprite
    for(i in 0...uvs.length)
    {
      _imageU8 = images[i];
      _uv = uvs[i];

      _w = Math.floor(_uv.w);
      _h = Math.floor(_uv.h);

      // Pass it to Int array so we can set it to main U8Array
      for(_y in 0..._h)
      {

        _pixelsInt = new Array<Int>();

        for (_x in 0..._w)
        {
          _pixelsInt.push( _imageU8[((_x*4)+_y*_w*4)] );
          _pixelsInt.push( _imageU8[((_x*4)+_y*_w*4)+1] );
          _pixelsInt.push( _imageU8[((_x*4)+_y*_w*4)+2] );
          _pixelsInt.push( _imageU8[((_x*4)+_y*_w*4)+3] );
        }

        // offset = Std.int( (_uv.x*4) + (texture.width*4*_y) + (_uv.y*4) +  );
        offset = Std.int( texture.width*_y*4 + _uv.x*4 + texture.width*_uv.y*4 );
        _textureU8.set(_pixelsInt, offset);

      }

    }

    texture.submit(_textureU8);

  }


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
    PixelSprite.initGenerator();

    _options.name = 'psg';
    super(_options);

    mask = _options.mask;

      // Default values
    isColored       = (_options.isColored == null) ? false : _options.isColored;
    edgeBrightness  = (_options.edgeBrightness == null) ? 0.3 : _options.edgeBrightness;
    colorVariations = (_options.colorVariations == null) ? 0.2 : _options.colorVariations;
    brightnessNoise = (_options.brightnessNoise == null) ? 0.3 : _options.brightnessNoise;
    saturation      = (_options.saturation == null) ? 0.5 : _options.saturation;

    data = new Array<Int>();

    pixelsData2D = new Array<Array<Color>>();
    for(i in 0...height)
    {
      pixelsData2D[i] = new Array<Color>();
    }
  }


  override function init():Void
  {
    renderPixelData();
  }


  override function onadded():Void
  {
    _sprite = cast entity;

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
    var hue:Float               = Math.random()*360;

    var u:Int = 0;
    var v:Int = 0;
    var ulen:Int = 0;
    var vlen:Int = 0;

    var isNewColor:Float = 0;

    var val:Int = 0;
    var index:Int = 0;

    var color:Color;

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

    for (u in 0...ulen)
    {
      // Create a non-uniform random number between 0 and 1 (lower numbers more likely)
      isNewColor = Math.abs(((Math.random() * 2 - 1) 
                           + (Math.random() * 2 - 1) 
                           + (Math.random() * 2 - 1)) / 3);

      // Only change the color sometimes (values above 0.8 are less likely than others)
      if (isNewColor > (1 - colorVariations))
      {
        hue = Math.random()*360;
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

        color = new Color();

        if (val != 0)
        {
          if (isColored)
          {
            // Fade brightness away towards the edges
            brightness = Math.sin((u / ulen) * Math.PI) * (1 - brightnessNoise) + Math.random() * brightnessNoise;

            color.fromColorHSL( new ColorHSL(hue, saturation, brightness) );

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
              color.r = 0;
              color.g = 0;
              color.b = 0;
              color.a = 1;
            }
          }
        }
        else
        {
          color.a = 0;
        }
        pixelsData2D[y][x] = color;
      }
    }
    render();
  };

  function render():Void
  {
    // TODO: Isn't this cache:false the reason why Chrome runs slower?
    // Shouldn't I use one big texture for all PSG,
    // instead of new texture per new sprite?

    // PixelSprite.addPixels(pixelsUInt8, width, height);
    _sprite.texture = PixelSprite.texture;
    _sprite.uv = PixelSprite.addPixels(pixelsData2D);
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
