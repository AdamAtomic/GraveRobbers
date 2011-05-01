package
{
	import org.flixel.*;
	
	public class Crusher extends Trap
	{
		//[Embed(source="data/temp_tiles.png")] protected var ImgTempTiles:Class;
		
		public var falling:Boolean;
		public var open:Boolean;
		
		public function Crusher(X:Number,Y:Number,Key:String)
		{
			super(X, Y, Key);
			makeGraphic(32,64,0xffb05f29); //DEBUG
			width = 28;
			height = 32;
			offset.x = 2;
			offset.y = 32;
			x += 2;
			path = new FlxPath([new FlxPoint(x+14,y+16),new FlxPoint(x+14,y+80)]);
			activeTime = 1;
			reloadTime = 4;
			open = true;
			falling = false;
		}
		
		override public function update():void
		{
			if(pathSpeed == 0)
				velocity.x = velocity.y = 0;

			super.update();
			
			if(falling && (pathSpeed == 0))
			{
				falling = false;
				FlxG.camera.shake(0.02,0.065);
			}
			if(!falling && !open && (y < (_tile.y+1.5)*32))
			{
				_map.setTile(_tile.x,_tile.y+1,0);
				_map.setTile(_tile.x,_tile.y+2,0);
				Trap.changed = true;
				open = true;
			}
		}
		
		override public function activate():void
		{
			followPath(path,320,PATH_FORWARD);
			_map.setTile(_tile.x,_tile.y+1,1);
			_map.setTile(_tile.x,_tile.y+2,1);
			Trap.changed = true;
			falling = true;
			open = false;
			super.activate();
		}
		
		override public function reload(Timer:FlxTimer=null):void
		{
			followPath(path,16,PATH_BACKWARD);
			super.reload();
		}
	}
}