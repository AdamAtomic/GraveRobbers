package
{
	import org.flixel.FlxSprite;
	
	public class Trap extends FlxSprite
	{
		public var key:String;
		
		public function Trap(X:Number,Y:Number)
		{
			super(X*32, Y*32);
		}
	}
}