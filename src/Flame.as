package
{
	import org.flixel.*;
	
	public class Flame extends FlxSprite
	{
		//[Embed(source="data/arrow.png")] protected var ImgArrow:Class;
		
		public function Flame()
		{
			super();
			makeGraphic(20,20,0x7fffff00);
			//loadGraphic(ImgArrow,false,true);
			drag.x = 200;
		}
		
		override public function update():void
		{
			if(FlxU.abs(velocity.x) < 10)
				kill();
		}
		
		override public function kill():void
		{
			super.kill();
		}
		
		override public function reset(X:Number,Y:Number):void
		{
			super.reset(X,Y);
			acceleration.y = -30;
		}
	}
}