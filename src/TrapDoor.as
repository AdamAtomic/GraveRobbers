package
{
	import org.flixel.*;

	public class TrapDoor extends Trap
	{
		public function TrapDoor(X:Number, Y:Number)
		{
			super(X, Y);
			makeGraphic(32,16,0xff00ff00);
			immovable = true;
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
			alpha = 0.5;
			_map.setTile(_tile.x,_tile.y,0);

			super.activate();
		}
		
		override public function reload(Timer:FlxTimer=null):void
		{
			solid = true;
			alpha = 1;
			_map.setTile(_tile.x,_tile.y,1);
			
			super.reload();
		}
	}
}