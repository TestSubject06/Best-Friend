package Entities 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class OneWay extends FlxSprite 
	{
		
		public function OneWay(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y);
			loadGraphic(Registry.oneWayPNG);
			allowCollisions = UP;
			immovable = true;
		}
		
		override public function update():void 
		{
			//if (Registry.thePlayer.requestDrop) {
				//allowCollisions = NONE;
			//}else {
				//allowCollisions  = UP;
			//}
			super.update();
		}
	}
}