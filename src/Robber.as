package
{
	import org.flixel.*;
	
	public class Robber extends FlxSprite
	{
		public static var changeToggle:Boolean;
		public static var goal:FlxPoint;
		
		protected var _map:FlxTilemap;
		protected var _localToggle:Boolean;
		
		public function Robber()
		{
			super(13*32+8, -32);
			makeGraphic(16,24);
			_map = (FlxG.state as PlayState).map;
			_localToggle = !changeToggle;
			
			acceleration.y = 400;
		}
		
		override public function destroy():void
		{
			_map = null;
			super.destroy();
		}
		
		override public function update():void
		{
			if((y > 0) && (_localToggle != changeToggle))
			{
				_localToggle = changeToggle;
				findPath();
			}
		}
		
		public function findPath(Timer:FlxTimer=null):void
		{
			if(path != null)
				path.destroy();
			path = _map.findPath(getMidpoint(_point),goal,true);
			if(path != null)
				followPath(path);
		}
	}
}