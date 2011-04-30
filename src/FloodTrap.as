package
{
	public class FloodTrap extends Trap
	{
		public function FloodTrap(X:Number, Y:Number)
		{
			super(X, Y);
			makeGraphic(160,96,0x7f007fff);
			solid = false;
		}
	}
}