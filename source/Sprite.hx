
package ;

import openfl.display.BitmapData;

class Sprite 
{

  public var width:Int;
  public var height:Int;
  public var data:Vector<Vector<Int>>;
  public var mask:Mask;
  public var isColored:Bool;

  private var canvas:BitmapData;


  /**
  *   The Sprite class makes use of a Mask instance to generate a 2D sprite on a
  *   HTML canvas.
  *
  *   @class Sprite
  *   @param {mask}
  *   @constructor
  */
  public function new( mask_:Mask, ?isColored_:Bool = true ):Void
  {
    mask      = mask_;
    width     = mask.width * (mask.mirrorX ? 2 : 1);
    height    = mask.height * (mask.mirrorY ? 2 : 1);
    data      = new Vector<Vector<Int>(width)>(height);
    isColored = isColored_;

    init();
  }

  /**
  *   The init method calls all functions required to generate the sprite.
  *
  *   @method init
  *   @returns {undefined}
  */
  private function init():Void
  {
    initCanvas();
    // initContext();
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
    renderPixelData();
  }

  /**
  *   The initCanvas method creates a HTML canvas element for internal use.
  *
  *   (note: the canvas element is not added to the DOM)
  *
  *   @method initCanvas
  *   @returns {undefined}
  */
  private function initCanvas():Void
  {
    canvas = new BitmapData(width, height);
  };

  /**
  *   The initContext method requests a CanvasRenderingContext2D from the
  *   internal canvas object.
  *
  *   @method 
  *   @returns {undefined}
  */
  // Guess Haxe doesn't need it. - @Zielakpl
  // private function initContext():Void
  // {
  //   this.ctx    = this.canvas.getContext('2d');
  //   this.pixels = this.ctx.createImageData(this.width, this.height);
  // };


  /**
  *   The getData method returns the sprite template data at location (x, y)
  *
  *      -1 = Always border (black)
  *       0 = Empty
  *       1 = Randomly chosen Empty/Body
  *       2 = Randomly chosen Border/Body
  *
  *   @method getData
  *   @param {x}
  *   @param {y}
  *   @returns {undefined}
  */
  private function getData(x, y):Int
  {
    return data[x][y];
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
  private function setData(x, y, value):Void
  {
    data[x][y] = value;
  };

  /**
  *   The initData method initializes the sprite data to completely solid.
  *
  *   @method initData
  *   @returns {undefined}
  */
  private function initData():Void
  {
    var x:Int = 0;
    var y:Int = 0;

    for (y in 0...height)
    {
      for (x in 0...width)
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
  private function mirrorX():Void
  {
    var w:Int = Math.floor(width/2);
    var x:Int = 0;
    var y:Int = 0;

    for (y in 0...height)
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
  private function mirrorY():Void
  {
    var h:Int = Math.floor(height/2);
    var w:Int = width;
    var x:Int;
    var y:Int;

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
  private function applyMask():Void
  {
      var h = mask.height;
      var w = mask.width;

      var x, y;
      for (y = 0; y < h; y++) {
        for (x = 0; x < w; x++) {
              this.setData(x, y, this.mask.data[y * w + x]);
         }
      }
  };

}



























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
private function generateRandomSample():Void
{
    var h = this.height;
    var w = this.width;

    var x, y;
    for (y = 0; y < h; y++) {
        for (x = 0; x < w; x++) {
            var val = this.getData(x, y);

            if (val === 1) {
                val = val * Math.round(Math.random());
            } else if (val === 2) {
                if (Math.random() > 0.5) {
                    val = 1;
                } else {
                    val = -1;
                }
            } 

            this.setData(x, y, val);
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
private function generateEdges():Void
{
    var h = this.height;
    var w = this.width;

    var x, y;
    for (y = 0; y < h; y++) {
        for (x = 0; x < w; x++) {
            if (this.getData(x, y) > 0) {
                if (y - 1 >= 0 && this.getData(x, y-1) === 0) {
                    this.setData(x, y-1, -1);
                }
                if (y + 1 < this.height && this.getData(x, y+1) === 0) {
                    this.setData(x, y+1, -1);
                }
                if (x - 1 >= 0 && this.getData(x-1, y) === 0) {
                    this.setData(x-1, y, -1);
                }
                if (x + 1 < this.width && this.getData(x+1, y) === 0) {
                    this.setData(x+1, y, -1);
                }
            }
        }
    }
};

/**
*   This method renders out the template data to a HTML canvas to finally
*   create the sprite.
*
*   (note: only template locations with the values of -1 (border) are rendered)
*
*   @method renderPixelData
*   @returns {undefined}
*/
private function renderPixelData():Void
{
    var isVerticalGradient = Math.random() > 0.5;
    var saturation         = Math.random() * 0.5;
    var hue                = Math.random();

    var u, v, ulen, vlen;
    if (isVerticalGradient) {
        ulen = this.height;
        vlen = this.width;
    } else {
        ulen = this.width;
        vlen = this.height;
    }

    for (u = 0; u < ulen; u++) {
        // Create a non-uniform random number between 0 and 1 (lower numbers more likely)
        var isNewColor = Math.abs(((Math.random() * 2 - 1) 
                                 + (Math.random() * 2 - 1) 
                                 + (Math.random() * 2 - 1)) / 3);

        // Only change the color sometimes (values above 0.8 are less likely than others)
        if (isNewColor > 0.8) {
            hue = Math.random();
        }

        for (v = 0; v < vlen; v++) {
            var val, index;
            if (isVerticalGradient) {
                val   = this.getData(v, u);
                index = (u * vlen + v) * 4;
            } else {
                val   = this.getData(u, v);
                index = (v * ulen + u) * 4;
            }

            var rgb = { r: 1, g: 1, b: 1 };

            if (val !== 0) {
                if (this.isColored) {
                    // Fade brightness away towards the edges
                    var brightness = Math.sin((u / ulen) * Math.PI) * 0.7 + Math.random() * 0.3;

                    // Get the RGB color value
                    this.hslToRgb(hue, saturation, brightness, /*out*/ rgb);

                    // If this is an edge, then darken the pixel
                    if (val === -1) {
                        rgb.r *= 0.3;
                        rgb.g *= 0.3;
                        rgb.b *= 0.3;
                    }

                }  else {
                    // Not colored, simply output black
                    if (val === -1) {
                        rgb.r = 0;
                        rgb.g = 0;
                        rgb.b = 0;
                    }
                }
            }

            this.pixels.data[index + 0] = rgb.r * 255;
            this.pixels.data[index + 1] = rgb.g * 255;
            this.pixels.data[index + 2] = rgb.b * 255;
            this.pixels.data[index + 3] = 255;
        }
    }

    this.ctx.putImageData(this.pixels, 0, 0);
};


/**
*   This method converts HSL color values to RGB color values.
*
*   @method hslToRgb
*   @param {h}
*   @param {s}
*   @param {l}
*   @param {result}
*   @returns {result}
*/
private function hslToRgb(h, s, l, result):Void
{
    if (typeof result === 'undefined') {
        result = { r: 0, g: 0, b: 0 };
    }

    var i, f, p, q, t;
    i = Math.floor(h * 6);
    f = h * 6 - i;
    p = l * (1 - s);
    q = l * (1 - f * s);
    t = l * (1 - (1 - f) * s);
    
    switch (i % 6) {
        case 0: result.r = l, result.g = t, result.b = p; break;
        case 1: result.r = q, result.g = l, result.b = p; break;
        case 2: result.r = p, result.g = l, result.b = t; break;
        case 3: result.r = p, result.g = q, result.b = l; break;
        case 4: result.r = t, result.g = p, result.b = l; break;
        case 5: result.r = l, result.g = p, result.b = q; break;
    }

    return result;
}

/**
*   This method converts the template data to a string value for debugging
*   purposes.
*
*   @method toString
*   @returns {undefined}
*/
private function toString():Void
{
    var h = this.height;
    var w = this.width;
    var x, y, output = '';
    for (y = 0; y < h; y++) {
        for (x = 0; x < w; x++) {
            var val = this.getData(x, y);
            output += val >= 0 ? ' ' + val : '' + val;
        }
        output += '\n';
    }
    return output;
};
