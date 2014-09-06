package Entities 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Pedestal extends FlxSprite 
	{
		public var triggered:Boolean = false;
		public var pedestalCallback:Function = null;
		public function Pedestal(X:Number = 0, Y:Number = 0, pedCall:Function = null) 
		{
			super(X, Y);
			pedestalCallback = pedCall;
			loadGraphic(Registry.pedestalPNG, true, false, 48, 8);
			addAnimation("idle", [0]);
			addAnimation("trigger", [0, 1, 2], 10, false);
			play("idle");
			allowCollisions = UP;
			immovable = true;
		}
		public function trigger():void {
			if (triggered)
				return;
			if (pedestalCallback()){
			}else{
				return;
			}
			triggered = true;
			play("trigger");
			FlxG.camera.shake(.02, .2);
			solid = false;
		}
	}
}