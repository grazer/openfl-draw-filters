package;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectShader;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.filters.*;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import openfl.utils.Assets;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		/**
		 * "Various Creatures" by GrafxKid is licensed under CC BY 3.0
		 * (https://opengameart.org/content/various-creatures)
		 * (https://creativecommons.org/licenses/by/3.0/)
		 */
		var bitmapData = Assets.getBitmapData ("assets/tileset.png");
		var tileset = new Tileset (bitmapData);
		
		var gumdropID = tileset.addRect (new Rectangle (0, 0, 32, 32));
		var balloonID = tileset.addRect (new Rectangle (0, 64, 32, 32));
		var robotID = tileset.addRect (new Rectangle (0, 96, 32, 32));
		var compyID = tileset.addRect (new Rectangle (0, 224, 32, 32));

        // glowfilter works        
        var blueGlow = new GlowFilter(0x0000FF, 1.0, 7, 7, 128, 4);
        var sprite = new Sprite();
        sprite.graphics.beginFill(0xCCCCCC);
        sprite.graphics.drawCircle(0,0,10);
        sprite.graphics.endFill();
        sprite.filters = [blueGlow];
        sprite.x = stage.stageWidth/2;
        sprite.y = stage.stageHeight/1.4;
        addChild(sprite);

		var tilemap = new Tilemap (stage.stageWidth, stage.stageHeight, tileset);
		tilemap.smoothing = false;
		tilemap.scaleX = 4;
		tilemap.scaleY = 4;
		addChild (tilemap);
		
        // shader does not show up in bitmap data
        var shader = new GrayScale();
		var gumdrop = new Tile (gumdropID);

        gumdrop.shader = shader;
		gumdrop.x = 12;
		gumdrop.y = 48;
		tilemap.addTile (gumdrop);
	
        // color xform does not show up in bitmap data    
        var colorXform = new ColorTransform();
        colorXform.color = 0xFF0000;

		var balloon = new Tile (balloonID);
        balloon.colorTransform = colorXform;
		balloon.x = 60;
		balloon.y = 48;
		tilemap.addTile (balloon);
		
		var robot = new Tile (robotID);
        robot.shader = shader;
		robot.x = 108;
		robot.y = 48;
		tilemap.addTile (robot);
		
		var compy = new Tile (compyID);
        compy.shader = shader;
		compy.x = 156;
		compy.y = 48;
		tilemap.addTile (compy);
	
        captureScreenShot();    
	}
	

    function captureScreenShot():Void {
        var bmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x0);
        bmapData.draw(stage, null, null, null, 
                new Rectangle(0, 0, stage.stageWidth, stage.stageWidth), true);
        var screenShot = new Bitmap(bmapData);
        addChild(screenShot);
        screenShot.scaleX = screenShot.scaleY = 0.5;
        screenShot.alpha = 0.6;
    }    
}

class GrayScale extends DisplayObjectShader {

    @:glFragmentSource("
		#pragma header
				
		void main(void) {
			#pragma body

			float mColor = 0.0;
			mColor += gl_FragColor.r + gl_FragColor.g + gl_FragColor.b;
			mColor = mColor/3.0;
			gl_FragColor.r = mColor;
			gl_FragColor.g = mColor;
			gl_FragColor.b = mColor;
			gl_FragColor *= openfl_Alphav;
		}
		
	")
    public function new(){
        super();
    }
}
