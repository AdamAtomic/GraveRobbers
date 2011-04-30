package
{
	import org.flixel.*;
	
	public class FloodTrap extends Trap
	{
		public var leftDoor:FlxSprite;
		public var rightDoor:FlxSprite;
		public var filling:Boolean;
		
		public function FloodTrap(X:Number, Y:Number, Key:String)
		{
			super(X, Y, Key);
			x += 16;
			makeGraphic(128,96,0x7f007fff);
			origin.x = 0;
			origin.y = height;
			scale.y = 0;
			solid = true;
			activeTime = 6;
			reloadTime = 1;
			filling = false;
			
			leftDoor = new FlxSprite(x - 8,y-32);
			leftDoor.makeGraphic(16,64,0xff7f7f7f);
			leftDoor.path = new FlxPath([	new FlxPoint(leftDoor.x + 8,leftDoor.y + 32),
											new FlxPoint(leftDoor.x + 8,leftDoor.y + 96)]);
			
			rightDoor = new FlxSprite(x + 160 - 40,y-32);
			rightDoor.makeGraphic(16,64,0xff7f7f7f);
			rightDoor.path = new FlxPath([	new FlxPoint(rightDoor.x + 8,rightDoor.y + 32),
											new FlxPoint(rightDoor.x + 8,rightDoor.y + 96)]);
		}
		
		override public function preUpdate():void
		{
			super.preUpdate();
			leftDoor.preUpdate();
			rightDoor.preUpdate();
		}
		
		override public function update():void
		{
			if(leftDoor.pathSpeed == 0)
				leftDoor.velocity.x = leftDoor.velocity.y = 0;
			if(rightDoor.pathSpeed == 0)
				rightDoor.velocity.x = rightDoor.velocity.y = 0;
			
			super.update();
			
			if(filling && (scale.y < 1))
			{
				scale.y += FlxG.elapsed/(activeTime-2);
				if(scale.y >= 1)
					filling = false;
			}
			else if(_activeTimer.finished && scale.y > 0)
			{
				scale.y -= FlxG.elapsed/(reloadTime);
				if(scale.y <= 0)
				{
					leftDoor.followPath(leftDoor.path,300,PATH_BACKWARD);
					rightDoor.followPath(rightDoor.path,300,PATH_BACKWARD);
					_map.setTile(_tile.x,_tile.y+1,0);
					_map.setTile(_tile.x,_tile.y+2,0);
					_map.setTile(_tile.x+4,_tile.y+1,0);
					_map.setTile(_tile.x+4,_tile.y+2,0);
					Trap.changed = true;
				}
			}
			
			leftDoor.update();
			rightDoor.update();
		}
		
		override public function postUpdate():void
		{
			super.postUpdate();
			leftDoor.postUpdate();
			rightDoor.postUpdate();
		}
		
		override public function draw():void
		{
			super.draw();
			leftDoor.draw();
			rightDoor.draw();
		}
		
		override public function activate():void
		{
			leftDoor.followPath(leftDoor.path,500,PATH_FORWARD);
			rightDoor.followPath(rightDoor.path,500,PATH_FORWARD);
			_map.setTile(_tile.x,_tile.y+1,1);
			_map.setTile(_tile.x,_tile.y+2,1);
			_map.setTile(_tile.x+4,_tile.y+1,1);
			_map.setTile(_tile.x+4,_tile.y+2,1);
			Trap.changed = true;
			filling = true;
			super.activate();
		}
	}
}