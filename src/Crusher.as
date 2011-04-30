package
{
	import org.flixel.*;
	
	public class Crusher extends FlxSprite
	{
		//[Embed(source="data/temp_tiles.png")] protected var ImgTempTiles:Class;
		
		public function Crusher(X:Number,Y:Number,Key:String="")
		{
			super(X*32, Y*32-32);
			makeGraphic(32,64,0xffff0000);
			path = new FlxPath([new FlxPoint(x+16,y+32),new FlxPoint(x+16,y+96)]);
			followPath(path,50,PATH_YOYO);
		}
	}
}