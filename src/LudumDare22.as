package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#666666")]
	[Frame(factoryClass="Preloader")]

	public class LudumDare22 extends FlxGame
	{
		public function LudumDare22()
		{
			super(320,240,MenuState,2, 60, 60);
			forceDebugger = true;
		}
	}
}

