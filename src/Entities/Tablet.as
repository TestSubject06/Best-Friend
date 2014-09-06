package Entities 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Tablet extends FlxSprite 
	{
		private var yoffset:Number = 0;
		private var time:Number = 0;
		public function Tablet(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y);
			loadGraphic(Registry.tabletPNG, true, false, 16, 16);
			addAnimation("glow", [0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 5, 5, 4, 3, 2, 1], 10);
			play("glow");
			yoffset = Y;
		}
		override public function update():void 
		{
			time += FlxG.elapsed;
			y = yoffset + (Math.sin(time*4) * 3);
			super.update();
		}
	}

}