package
{
	import org.flixel.*;

	public class TrapDoor extends Trap
	{
		public function TrapDoor(X:Number, Y:Number, Key:String)
		{
			super(X, Y, Key);
			makeGraphic(32,16,0xffb05f29);
			activeTime = 1;
			reloadTime = 1;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function activate():void
		{
			solid = false;
			alpha = 0;
			_map.setTile(_tile.x,_tile.y,0);
			//Trap.changed = true;

			super.activate();
		}
		
		override public function reload(Timer:FlxTimer=null):void
		{
			solid = true;
			alpha = 1;
			_map.setTile(_tile.x,_tile.y,1);
			Trap.changed = true;
			
			super.reload();
		}
	}
}