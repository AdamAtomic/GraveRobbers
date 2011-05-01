package
{
	import org.flixel.*;
	
	public class Robber extends FlxSprite
	{
		[Embed(source="data/dude.png")] protected var ImgDude:Class;
		
		public static var changeTracker:uint;
		public static var goal:FlxPoint;
		
		protected var _map:FlxTilemap;
		protected var _localTracker:uint;
		protected var _lastY:Number;
		protected var _speed:Number;
		
		protected var _jumpHelp1:FlxPoint;
		protected var _jumpHelp2:FlxPoint;
		protected var _jumpCount:Number;
		
		public function Robber()
		{
			super(0,0);
			loadGraphic(ImgDude,true,true,16,24);
			width = 12;
			height = 20;
			offset.x = 2;
			offset.y = 4;
			_map = (FlxG.state as PlayState).map;
			_localTracker = 0;
			_lastY = y;
			_speed = 50;
			
			_jumpHelp1 = new FlxPoint();
			_jumpHelp2 = new FlxPoint();
			_jumpCount = 1000;
			
			acceleration.y = 800;
		}
		
		override public function destroy():void
		{
			_map = null;
			_jumpHelp1 = null;
			_jumpHelp2 = null;
			super.destroy();
		}
		
		override public function update():void
		{
			//dampen bouncing
			if((elasticity != 0) && justTouched(FLOOR) && (velocity.y > -30))
			{
				velocity.y = 0;
				elasticity = 0;
				if(alive)
					kill();
				else
				{
					active = false;
					moves = false;
				}
			}
			
			//drop the drowned bodies
			if(alive && (acceleration.y == 0) && justTouched(CEILING))
			{
				kill();
				active = true;
				moves = true;
				elasticity = 0.5;
				acceleration.y = 200 + FlxG.random()*100;
			}
			
			//kill the robber if he falls too far
			if(alive && justTouched(FLOOR) && (y - _lastY > 32*7.5))
				kill();
			if(!alive)
				return;
			
			//toggle back and forth between free-follow (fake ladder behavior) and walk-style follow
			if((path != null) && (path.nodes.length > 0))
			{
				var node:FlxPoint = path.nodes[_pathNodeIndex];
				var realPathAngle:Number = FlxU.getAngle(getMidpoint(_point),node);
				if(isTouching(FLOOR) && (y - node.y > 32))
				{
					_pathMode = PATH_FORWARD;
					pathSpeed = _speed*0.8;
				}
				else if(((realPathAngle < -45) || (realPathAngle > 45)) && (FlxU.getDistance(_point,node) < 16))
				{
					_pathMode = PATH_FORWARD|PATH_HORIZONTAL_ONLY;
					pathSpeed = _speed;
				}
			}
			
			//falling and jumping behaviors
			if(_pathMode == uint(PATH_FORWARD|PATH_HORIZONTAL_ONLY))
			{
				if(isTouching(FLOOR))
				{
					pathSpeed = _speed;
					getMidpoint(_point);
					_jumpHelp1.copyFrom(_point);
					_jumpHelp2.copyFrom(_point);
					if(velocity.x <= -_speed)
					{
						_point.x -= 20;
						_jumpHelp1.x -= 52;
						_jumpHelp2.x -= 52;
					}
					else if(velocity.x >= _speed)
					{
						_point.x += 20;
						_jumpHelp1.x += 52;
						_jumpHelp2.x += 52;
					}
					_point.y += 24;
					_jumpHelp2.y += 24;
					_jumpCount += FlxG.elapsed;
					if((_jumpCount > 0.4) && !_map.overlapsPoint(_point) && !_map.overlapsPoint(_jumpHelp1) && _map.overlapsPoint(_jumpHelp2))
					{
						velocity.y = -200;
						pathSpeed = _speed*2.2;
						advancePath(false);
						advancePath(false);
						_jumpCount = 0;
					}
				}
				else
					pathSpeed = 0;
			}
			
			//decide if we need to find a new path
			if(angularVelocity == 0)
			{
				if( ((_jumpCount > 2) && isTouching(FLOOR) && (_localTracker != changeTracker)) ||
					(justTouched(FLOOR) && (y - _lastY > 16)) ||
					(isTouching(FLOOR) && isTouching(WALL)) )
				{
					_localTracker = changeTracker;
					findPath();
				}
			}
			
			//point the right way
			if(velocity.x < 0)
				facing = LEFT;
			else if(velocity.x > 0)
				facing = RIGHT;
			
			//tag last height
			if(isTouching(FLOOR))
				_lastY = y;
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
			alive = false;
			stopFollowingPath(true);
			frame = 1;
			moves = false;
			active = false;
			angle = 0;
			angularVelocity = 0;
			drag.x = 200;
			(FlxG.state as PlayState).souls++;
		}
		
		override public function reset(X:Number,Y:Number):void
		{
			super.reset(13*32+8,-32);
			moves = true;
			active = true;
			frame = 0;
		}
	}
}