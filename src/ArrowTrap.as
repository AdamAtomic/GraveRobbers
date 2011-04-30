package
{
	public class ArrowTrap extends Trap
	{
		public function ArrowTrap(X:Number, Y:Number)
		{
			super(X, Y);
			makeGraphic(32,32,0xffff00ff); //DEBUG
			solid = false;
			moves = false;
		}
	}
}