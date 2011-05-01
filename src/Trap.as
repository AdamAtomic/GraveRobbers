package
{
	import org.flixel.*;
	
	public class Trap extends FlxSprite
	{
		static public var changed:Boolean;
		
		public var key:String;
		public var activeTime:Number;
		public var reloadTime:Number;
		
		protected var _tile:FlxPoint;
		protected var _map:FlxTilemap;
		protected var _activeTimer:FlxTimer;
		protected var _reloadTimer:FlxTimer;
		
		public function Trap(X:Number,Y:Number,Key:String)
		{
			super(X*32, Y*32);
			key = Key;
			activeTime = 1;
			reloadTime = 1;
			_tile = new FlxPoint(X,Y);
			_map = (FlxG.state as PlayState).map;
			_activeTimer = new FlxTimer();
			_activeTimer.finished = true;
			_reloadTimer = new FlxTimer();
			_reloadTimer.finished = true;
		}
		
		override public function destroy():void
		{
			key = null;
			_tile = null;
			_map = null;
			_activeTimer.destroy();
			_activeTimer = null;
			_reloadTimer.destroy();
			_reloadTimer = null;
			super.destroy();
		}
		
		override public function update():void
		{
			if(FlxG.keys.justPressed(key) && _activeTimer.finished && _reloadTimer.finished)
				activate();
		}
		
		public function activate():void
		{
			_activeTimer.start(activeTime,1,reload);
		}
		
		public function reload(Timer:FlxTimer=null):void
		{
			_reloadTimer.start(reloadTime,1);
		}
	}
}