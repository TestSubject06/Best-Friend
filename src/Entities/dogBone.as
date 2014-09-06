package Entities 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class dogBone extends FlxSprite 
	{
		private var stickTarget:FlxObject;
		public function dogBone(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, Registry.dogbonePNG);
		}
		public function stickTo(dog:FlxObject):void {
			stickTarget = dog;
			if(stickTarget){
				x = stickTarget.x-10;
				y = stickTarget.y+4;
			}
		}
		override public function update():void 
		{
			if(stickTarget){
				x = stickTarget.x-10;
				y = stickTarget.y+4;
			}
			super.update();
		}
	}
}