package
{
	public class TrapDoor extends Trap
	{
		public function TrapDoor(X:Number, Y:Number)
		{
			super(X, Y);
			makeGraphic(32,16,0xff00ff00);
			immovable = true;
		}
	}
}