package
{
	import org.flixel.*;
	[SWF(width="1024", height="768", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class GraveRobbers extends FlxGame
	{
		public function GraveRobbers()
		{
			super(1024,768,PlayState,1,50,50);
		}
	}
}
