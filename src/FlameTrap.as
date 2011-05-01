package
{
	import org.flixel.*;
	
	public class FlameTrap extends Trap
	{
		public var flames:FlxGroup;
		public var speed:Number;
		public var on:Boolean;
		
		protected var _flameTick:Number;
		
		public function FlameTrap(X:Number,Y:Number,Key:String)
		{
			super(X, Y, Key);
			makeGraphic(32,32,0xffffff00); //DEBUG
			solid = false;
			moves = false;
			visible = false;
			flames = (FlxG.state as PlayState).flames;
			getMidpoint(_point);
			_point.x -= 32;
			if(_map.overlapsPoint(_point))
				speed = 150;
			else
				speed = -150;
			on = false;
			activeTime = 1;
			reloadTime = 4;
		}
		
		override public function update():void
		{
			if(on)
			{
				_flameTick += FlxG.elapsed;
				while(_flameTick > 0.1)
				{
					_flameTick -= 0.1;
					var flame:Flame = flames.recycle(Flame) as Flame;
					getMidpoint(_point);
					flame.reset(_point.x - flame.width/2,_point.y - flame.height/2);
					flame.velocity.x = speed + FlxG.random()*20-10;
				}
			}
			super.update();
		}
		
		override public function activate():void
		{
			on = true;
			_flameTick = 0;
			super.activate();
		}
		
		override public function reload(Timer:FlxTimer=null):void
		{
			on = false;
			super.reload(Timer);
		}
	}
}