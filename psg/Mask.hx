package psg;

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

