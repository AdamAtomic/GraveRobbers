package
{
	import org.flixel.*;
	
	public class Robber extends FlxSprite
	{
		public static var changeToggle:Boolean;
		public static var goal:FlxPoint;
		
		protected var _map:FlxTilemap;
		protected var _localToggle:Boolean;
		protected var _lastY:Number;
		protected var _speed:Number;
		
		public function Robber()
		{
			super(13*32+8, -32);
			makeGraphic(16,24);
			_map = (FlxG.state as PlayState).map;
			_localToggle = !changeToggle;
			_lastY = y;
			_speed = 100;
			
			acceleration.y = 800;
		}
		
		override public function destroy():void
		{
			_map = null;
			super.destroy();
		}
		
		override public function update():void
		{
			//kill the robber if he falls too far
			if(justTouched(FLOOR) && (y - _lastY > 32*7) && alive)
			{
				kill();
				return;
			}
			if(isTouching(FLOOR))
				_lastY = y;
			
			if((path != null) && (path.nodes.length > 0))
			{
				var node:FlxPoint = path.nodes[_pathNodeIndex];
				var realPathAngle:Number = FlxU.getAngle(getMidpoint(_point),node);
				
				//toggle back and forth between free-follow and walk-style follow
				if(isTouching(FLOOR) && (node.y < y) && (FlxU.getDistance(_point,node) > 64))
				{
					_pathMode = PATH_FORWARD;
					pathSpeed = _speed*0.5;
				}
				else if(((realPathAngle < -45) || (realPathAngle > 45)) && (FlxU.getDistance(_point,node) < 16))
				{
					_pathMode = PATH_FORWARD|PATH_HORIZONTAL_ONLY;
					if(isTouching(FLOOR))
						pathSpeed = _speed;
					else
						pathSpeed = 0;
				}
			}
			
			if(_pathMode == uint(PATH_FORWARD|PATH_HORIZONTAL_ONLY))
			{
				if(isTouching(FLOOR))
					pathSpeed = _speed;
				else
					pathSpeed = 0;
			}
			
			//decide if we need to find a new path
			if(((y > 0) && (_localToggle != changeToggle)) || justTouched(FLOOR))
			{
				_localToggle = changeToggle;
				findPath();
			}
		}
		
		public function findPath(Timer:FlxTimer=null):void
		{
			if(path != null)
				path.destroy();
			path = _map.findPath(getMidpoint(_point),goal,false);
			if(path != null)
				followPath(path,_speed,PATH_FORWARD|PATH_HORIZONTAL_ONLY);
		}
		
		override public function kill():void
		{
			velocity.x = 0;
			alive = false;
			alpha = 0.5;
			stopFollowingPath(true);
		}
	}
}