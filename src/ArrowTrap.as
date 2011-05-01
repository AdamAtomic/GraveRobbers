package
{
	import org.flixel.*;
	
	public class ArrowTrap extends Trap
	{
		public var arrows:FlxGroup;
		public var speed:Number;
		
		public function ArrowTrap(X:Number, Y:Number, Key:String)
		{
			super(X, Y, Key);
			makeGraphic(32,32,0xffff00ff); //DEBUG
			solid = false;
			moves = false;
			visible = false;
			arrows = (FlxG.state as PlayState).arrows;
			getMidpoint(_point);
			_point.x -= 32;
			if(_map.overlapsPoint(_point))
				speed = 300;
			else
				speed = -300;
			activeTime = 1;
			reloadTime = 2;
		}
		
		override public function activate():void
		{
			var arrow:Arrow = arrows.recycle(Arrow) as Arrow;
			getMidpoint(_point);
			arrow.reset(_point.x - arrow.width/2, _point.y - arrow.height/2);
			arrow.velocity.x = speed;
			if(speed < 0)
				arrow.facing = LEFT;
			else
				arrow.facing = RIGHT;
			super.activate();
		}
	}
}