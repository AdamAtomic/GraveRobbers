package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source="data/map.png")] protected var ImgMap:Class;
		
		//just temporary, will paint or hand-draw actual level once its finalized i think?
		[Embed(source="data/temp_tiles.png")] protected var ImgTempTiles:Class;
		
		public var map:FlxTilemap;
		public var crushers:FlxGroup;
		
		override public function create():void
		{
			var l:int;
			
			var solidColor:uint = 0xffffffff;
			var openColor:uint = 0xff000000;
			var crusherColor:uint = 0xffff0000;
			var flameColor:uint = 0xffffd400;
			var arrowColor:uint = 0xffff00f2;
			var trapColor:uint = 0xff15ff00;
			var floodColor:uint = 0xff2659ff;
			
			var mapSprite:FlxSprite = new FlxSprite(0,0,ImgMap);
			var crusherLocations:Array = mapSprite.replaceColor(crusherColor,solidColor,true);
			var flameLocations:Array = mapSprite.replaceColor(flameColor,solidColor,true);
			var arrowLocations:Array = mapSprite.replaceColor(arrowColor,solidColor,true);
			var trapLocations:Array = mapSprite.replaceColor(trapColor,openColor,true);
			var floodLocations:Array = mapSprite.replaceColor(floodColor,solidColor,true);
			map = new FlxTilemap().loadMap(FlxTilemap.bitmapToCSV(mapSprite.pixels,true),ImgTempTiles,0,0,FlxTilemap.OFF,0,0,1);
			add(map);

			crushers = new FlxGroup;
			l = crusherLocations.length;
			while(l--)
				crushers.add(new Crusher(crusherLocations[l].x,crusherLocations[l].y));
			add(crushers);

			//TODO: add actual traps with letter assignments and basic behavior?
			
			//TODO: add idiotic tomb raiders
		}
	}
}
