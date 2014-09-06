package Entities 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Door extends FlxSprite 
	{
		public var open:Boolean = false;
		public var doorID:int = 0;
		public var closed:Boolean = false;
		public function Door(X:Number = 0, Y:Number = 0, doorid:int = 0 ) 
		{
			super(X, Y);
			doorID = doorid;
			loadGraphic(Registry.doorPNG, true, false, 16, 64);
			addAnimation("Closed", [0]);
			addAnimation("Open", [7]);
			addAnimation("Opening", [0, 1, 2, 3, 4, 5, 6, 7, 7], 15, false);
			addAnimation("Closing", [7, 6, 5, 4, 3, 2, 1, 0], 40, false);
			play("Closed");
			solid = true;
			immovable = true;
		}
		override public function update():void 
		{
			if (_curAnim.name == "Opening"){
				FlxG.camera.shake(0.01, 0.2, null, true, FlxCamera.SHAKE_VERTICAL_ONLY);
				open = true;
				closed = false;
				if (_curFrame == 8)
					play("Open");
			}
			if (_curAnim.name == "Closing") {
				FlxG.camera.shake(0.01, 0.2, null, true, FlxCamera.SHAKE_VERTICAL_ONLY);
				open = false;
				if (_curFrame == 7){
					play("Closed");
					closed = true;
				}
			}
			if (open) {
				solid = false;
				closed = false;
				if (_curAnim.name == "Closed")
					play("Open");
			}else {
				solid = true;
			}
			if (_curAnim.name == "Open")
				visible = false;
			else
				visible = true;
			super.update();
		}
	}

}