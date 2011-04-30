package
{
	import org.flixel.FlxSprite;
	
	public class FlameTrap extends Trap
	{
		public function FlameTrap(X:Number,Y:Number)
		{
			super(X, Y);
			makeGraphic(32,32,0xffffff00); //DEBUG
			solid = false;
			moves = false;
		}
	}
}