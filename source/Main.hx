package;


class Main extends openfl.display.Sprite {
	
	private var spaceship:Mask;
	private var dragon:Mask;
	private var robot:Mask;
	
	public function new () {
		
		super ();

		var SPRITE_COUNT:Int = 14;
		var SPRITE_SPACING:Int = 20;
		var SPRITE_SCALE:Float = 4;
		
		spaceship = new Mask([
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
    ], 6, 12, true, false);

    dragon = new Mask([
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
    ], 12, 12, false, false); 
                    
    robot = new Mask([
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
    ], 4, 11, true, false);

    var i:Int = 0;
    var sprite:Sprite;

    for (i in 0...SPRITE_COUNT)
    {
      sprite = new Sprite(spaceship, true);
      sprite.bitmap.scaleX = SPRITE_SCALE;
      sprite.bitmap.scaleY = SPRITE_SCALE;
      sprite.bitmap.x = i * (sprite.width*sprite.bitmap.scaleX+SPRITE_SPACING) +10;
      sprite.bitmap.y = 10;
      addChild( sprite.bitmap );
    }


    for (i in 0...SPRITE_COUNT)
    {
      sprite = new Sprite(dragon, true);
      sprite.bitmap.scaleX = SPRITE_SCALE;
      sprite.bitmap.scaleY = SPRITE_SCALE;
      sprite.bitmap.x = i * (sprite.width*sprite.bitmap.scaleX+SPRITE_SPACING) +10;
      sprite.bitmap.y = 80;
      addChild( sprite.bitmap );
    }


    for (i in 0...SPRITE_COUNT)
    {
      sprite = new Sprite(robot, true);
      sprite.bitmap.scaleX = SPRITE_SCALE;
      sprite.bitmap.scaleY = SPRITE_SCALE;
      sprite.bitmap.x = i * (sprite.width*sprite.bitmap.scaleX+SPRITE_SPACING) +10;
      sprite.bitmap.y = 150;
      addChild( sprite.bitmap );
    }
		
	}
	
	
}
