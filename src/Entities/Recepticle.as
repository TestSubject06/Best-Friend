package Entities 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Recepticle extends FlxSprite 
	{
		public var isOn:Boolean = false;
		public function Recepticle(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y);
			loadGraphic(Registry.recepticlePNG, true, false, 32, 32);
			addAnimation("idle", [0]);
			addAnimation("raging", [1]);
			play("idle");
			//immovable = true;
		}
		
	}

}