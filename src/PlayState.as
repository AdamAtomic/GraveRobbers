package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source="data/map.png")] protected var ImgMap:Class;
		[Embed(source="data/temp_tiles.png")] protected var ImgTempTiles:Class; //not actually displayed
		[Embed(source="data/bg.png")] protected var ImgBG:Class;
		[Embed(source="data/fg.png")] protected var ImgFG:Class;
		
		public var map:FlxTilemap;
		
		public var crushers:FlxGroup;
		public var flameTraps:FlxGroup;
		public var arrowTraps:FlxGroup;
		public var trapDoors:FlxGroup;
		public var floodTraps:FlxGroup;
		
		public var arrows:FlxGroup;
		public var flames:FlxGroup;
		
		public var hazards:FlxGroup;
		public var againstMap:FlxGroup;
		
		public var robbers:FlxGroup;
		
		override public function create():void
		{
			add(new FlxSprite(0,0,ImgBG));
			
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
			map.active = map.visible = false;
			add(map);
			
			Robber.goal = new FlxPoint(16*32,18*32+16);
			Robber.changeTracker = 1;
			robbers = new FlxGroup();
			add(robbers);
			
			Trap.changed = false;
			crushers = makeTraps(Crusher,crusherLocations,["E","F","K","X"]);
			flames = add(new FlxGroup()) as FlxGroup;
			flameTraps = makeTraps(FlameTrap,flameLocations,["U","D"]);
			arrows = add(new FlxGroup()) as FlxGroup;
			arrowTraps = makeTraps(ArrowTrap,arrowLocations,["R","I","V","N","PERIOD"]);
			trapDoors = makeTraps(TrapDoor,trapLocations,["J","L","C","COMMA","Z"]);
			floodTraps = makeTraps(FloodTrap,floodLocations,["S","M"]);
			
			//these are objects that can kill robbers
			hazards = new FlxGroup();
			hazards.add(flames);
			hazards.add(arrows);
			hazards.add(crushers);
			hazards.add(floodTraps);
			
			//these are things that hit the map
			againstMap = new FlxGroup();
			againstMap.add(robbers);
			againstMap.add(arrows);
			
			add(new FlxSprite(0,0,ImgFG));

			//FlxG.visualDebug = true;
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
				(robbers.recycle(Robber) as Robber).reset(0,0);

			super.update();
			if(Trap.changed)
			{
				Trap.changed = false;
				Robber.changeTracker++;
			}
			
			FlxG.collide(map,againstMap);
			FlxG.overlap(robbers,hazards,onTrap);
		}
		
		public function onTrap(Victim:Robber,Hazard:FlxSprite):void
		{
			if(Hazard is FloodTrap)
			{
				if(!(Hazard as FloodTrap).filling || (Victim.acceleration.y == 0) || !Victim.alive)
					return;
				Victim.acceleration.y = 0;
				Victim.velocity.y = -14;
				Victim.angularVelocity = FlxG.random()*60-30;
				Victim.velocity.x = FlxG.random()*20-10;
				Victim.stopFollowingPath(true);
				return;
			}
			
			if(Hazard is Arrow)
			{
				if(Victim.angularVelocity != 0)
					return;
				var arrow:Arrow = Hazard as Arrow;
				arrow.exists = false;
				Victim.stopFollowingPath(true);
				Victim.velocity.x = arrow.velocity.x*(0.3 + FlxG.random()*0.4);
				Victim.velocity.y = -200 - FlxG.random()*100;
				Victim.elasticity = 0.5;
				Victim.angularVelocity = FlxG.random()*360 - 180;
				return;
			}
			
			if(Victim.alive)
				Victim.kill();
		}
		
		public function makeTraps(TrapType:Class,TrapLocations:Array,TrapKeys:Array,AddToHazards:Boolean=false):FlxGroup
		{
			var traps:FlxGroup = new FlxGroup();
			var l:int = TrapLocations.length;
			while(l--)
				traps.add(new TrapType(TrapLocations[l].x,TrapLocations[l].y,TrapKeys[l]));
			if(AddToHazards)
				hazards.add(traps);
			add(traps);
			return traps;
		}
	}
}
