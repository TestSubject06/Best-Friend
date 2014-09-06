package Entities 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Player extends FlxSprite 
	{
		public var requestDrop:Boolean = false;
		private var canControl:Boolean = true;
		private var moveLeft:Boolean = false;
		public function Player(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y);
			loadGraphic(Registry.characterPNG, true, true, 16, 32);
			addAnimation("idle", [0]);
			addAnimation("SPRINTLIKEAMOTHERFUCKER", [1, 2, 3, 2], 10);
			addAnimation("jump", [4]);
			addAnimation("slump", [2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 6, 7], 5, false);
			
			play("idle");
			drag.x = 1200;
		}
		override public function update():void 
		{
			if(canControl){
				if (FlxG.keys.LEFT || FlxG.keys.A) {
					velocity.x = -150;
					facing = FlxObject.LEFT;
					play("SPRINTLIKEAMOTHERFUCKER");
				}
				if (FlxG.keys.RIGHT || FlxG.keys.D) {
					velocity.x = 150;
					facing = FlxObject.RIGHT;
					play("SPRINTLIKEAMOTHERFUCKER");
				}
				if ((FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("W"))&& isTouching(FlxObject.FLOOR)) {
					velocity.y = -200;
					Registry.jumpSound.play(true);
				}
				if (FlxG.keys.DOWN || FlxG.keys.S) {
					requestDrop = true;
				}else {
					requestDrop = false;
				}
				if (velocity.x < 10 && velocity.x > -10) {
					play("idle");
				}
				if (!isTouching(FLOOR)) {
					play("jump");
				}
				if (wasTouching == NONE && isTouching(FLOOR)) {
					Registry.landSound.play(true);
				}
			}
			if (moveLeft) {
				velocity.x = -150;
				facing = FlxObject.LEFT;
				play("SPRINTLIKEAMOTHERFUCKER");
			}
			super.update();
		}
		public function revokeControl():void {
			canControl = false;
			play("idle");
		}
		public function walkLeft():void {
			moveLeft = true;
		}
		public function slump():void {
			facing = FlxObject.LEFT;
			play("slump");
		}
	}
}