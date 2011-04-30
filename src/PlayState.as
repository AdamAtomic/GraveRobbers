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
		public var flameTraps:FlxGroup;
		public var arrowTraps:FlxGroup;
		public var trapDoors:FlxGroup;
		public var floodTraps:FlxGroup;
		
		public var robbers:FlxGroup;
		
		override public function create():void
		{
			//Processing the map data to get trap locations before making a simple collision/pathfinding hull		
			var solidColor:uint = 0xffffffff;
			//var openColor:uint = 0xff000000;
			var crusherColor:uint = 0xffff0000;
			var flameColor:uint = 0xffffd400;
			var arrowColor:uint = 0xffff00f2;
			var trapColor:uint = 0xff15ff00;
			var floodColor:uint = 0xff2659ff;
			var mapSprite:FlxSprite = new FlxSprite(0,0,ImgMap);
			var crusherLocations:Array = mapSprite.replaceColor(crusherColor,solidColor,true);
			var flameLocations:Array = mapSprite.replaceColor(flameColor,solidColor,true);
			var arrowLocations:Array = mapSprite.replaceColor(arrowColor,solidColor,true);
			var trapLocations:Array = mapSprite.replaceColor(trapColor,solidColor,true);
			var floodLocations:Array = mapSprite.replaceColor(floodColor,solidColor,true);
			map = new FlxTilemap().loadMap(FlxTilemap.bitmapToCSV(mapSprite.pixels,true),ImgTempTiles,0,0,FlxTilemap.OFF,0,0,1);
			map.ignoreDrawDebug = true;
			//map.active = map.visible = false;
			add(map);
			
			Robber.goal = new FlxPoint(16*32,17*32);
			Robber.changeToggle = false;
			robbers = new FlxGroup();
			add(robbers);
			
			//debug
			add(new FlxSprite(Robber.goal.x-8,Robber.goal.y-8));
			
			Trap.changed = false;
			crushers = makeTraps(Crusher,crusherLocations,["E","F","K","X"]);
			//flameTraps = makeTraps(FlameTrap,flameLocations);
			//arrowTraps = makeTraps(ArrowTrap,arrowLocations);
			trapDoors = makeTraps(TrapDoor,trapLocations,["W","O","L","C","COMMA","Z"]);
			floodTraps = makeTraps(FloodTrap,floodLocations,["S","M"]);
			
			FlxG.visualDebug = true;
			FlxG.camera.focusOn(new FlxPoint(FlxG.width/2,FlxG.height/2-50));
		}
		
		override public function destroy():void
		{
			map.destroy();
			map = null;
			crushers.destroy();
			crushers = null;
			flameTraps.destroy();
			flameTraps = null;
			arrowTraps.destroy();
			arrowTraps = null;
			trapDoors.destroy();
			trapDoors = null;
			floodTraps.destroy();
			floodTraps = null;
			robbers.destroy();
			robbers = null;
			super.destroy();
		}
		
		override public function update():void
		{
			if(FlxG.keys.justPressed("SPACE"))
				robbers.add(new Robber());
			
			Trap.changed = false;
			super.update();
			if(Trap.changed)
			{
				Trap.changed = false;
				Robber.changeToggle = !Robber.changeToggle;
			}
			
			FlxG.collide(robbers,map);
		}
		
		public function makeTraps(TrapType:Class,TrapLocations:Array,TrapKeys:Array):FlxGroup
		{
			var traps:FlxGroup = new FlxGroup();
			var l:int = TrapLocations.length;
			while(l--)
				traps.add(new TrapType(TrapLocations[l].x,TrapLocations[l].y,TrapKeys[l]));
			add(traps);
			return traps;
		}
	}
}
