package Entities 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Dog extends FlxSprite 
	{
		public var target:FlxObject;
		public var status:String = "falling";
		private var shouldJump:Boolean = false;
		private var lastPos:FlxPoint = new FlxPoint(0,0);
		private var lastPos2:FlxPoint = new FlxPoint(0, 0);
		private var toggle:Boolean = false;
		private var sniffTimer:Number = 0;
		private var platformjump:Number = 1;
		private var platformdrop:Number = 1;
		private var targetPlatform:FlxObject;
		public var requestDrop:Boolean = false;
		private var sniffSoundTimer:Number = 2;
		private var barkSoundTimer:Number = 2;
		public function Dog(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, Registry.dogPNG);
			loadGraphic(Registry.dogPNG, true, true, 32, 16);
			addAnimation("idle", [0, 1, 2, 1, 0, 1, 3, 1], 10);
			addAnimation("SPRINTLIKEAMOTHERFUCKER", [5, 4], 15);
			addAnimation("sniffStart", [10, 9], 15);
			addAnimation("sniff", [6, 7, 8, 7, 6, 7, 9, 7], 20);
			addAnimation("sniffEnd", [9, 10, 10], 15);
			addAnimation("falling", [4]);
			addAnimation("slump", [0, 1, 2, 1, 0, 1, 3, 1, 0, 0, 1, 1, 2, 2, 1, 1, 0, 0, 1, 1, 3, 3, 1, 1, 0, 0, 0, 1, 1, 1, 2, 2, 2, 1, 1, 1, 0, 0, 0, 1, 1, 1, 3, 3, 3, 1, 1, 1, 0, 0, 0, 10, 10, 11, 11, 12], 10, false);
			
			play("idle");
			target = Registry.thePlayer;
			drag.x = 1200;
			FlxG.watch(this, "status");
			FlxG.watch(this, "target");
		}
		override public function update():void 
		{
			sniffSoundTimer -= FlxG.elapsed;
			barkSoundTimer -= FlxG.elapsed;
			requestDrop = false;
			if (toggle) {
				lastPos2.make(x, y);
				toggle = false;
			}else {
				lastPos.make(x, y);
				toggle = true;
			}
			switch(status) {
				case "falling":
					play("idle");
					//Falling behavior
					break;
				case "sniffing":
					if(_curAnim.name != "sniff" && _curAnim.name != "sniffStart"){
						play("sniffStart");
					}
					if (_curAnim.name == "sniffStart" && _curFrame == 1) {
						play("sniff");
					}
					//Sniffing behavior
					break;
				case "standing":
					sniffTimer -= FlxG.elapsed;
					if (sniffTimer < 0) {
						var doSomethingRandom:int = Math.floor(Math.random() * 4);
						if (_curAnim.name == "sniff")
							doSomethingRandom = 3;
						if (doSomethingRandom == 1) {
							velocity.x = -200;
							facing = FlxObject.LEFT;
							play("SPRINTLIKEAMOTHERFUCKER");
							sniffTimer = Math.random() * 1;
						}
						if (doSomethingRandom == 2) {
							velocity.x = 200;
							facing = FlxObject.RIGHT;
							play("SPRINTLIKEAMOTHERFUCKER");
							sniffTimer = Math.random() * 1;
						}
						if (doSomethingRandom == 3) {
							velocity.x = 0;
							if(_curAnim.name != "sniff" && _curAnim.name != "sniffStart" && _curAnim.name != "sniffEnd"){
								play("sniffStart");
								sniffTimer = Math.random() * 3;
							}else {
								if(_curAnim.name == "sniff") {
								play("sniffEnd");
								sniffTimer = Math.random() * 10;
								}
							}
						}
						if (doSomethingRandom == 4) {
							velocity.x = 0;
							play("idle");
							sniffTimer = Math.random() * 5;
						}
					}
					if (_curAnim.name == "sniffStart" && _curFrame == 1) {
						play("sniff");
					}
					if (_curAnim.name == "sniffEnd" && _curFrame == 2) {
						play("idle");
					}
					if (_curAnim.name == "SPRINTLIKEAMOTHERFUCKER" && facing == LEFT)
						velocity.x = -100;
					if (_curAnim.name == "SPRINTLIKEAMOTHERFUCKER" && facing == RIGHT)
						velocity.x = 100;
					break;
				case "following":
					//follow the player
					if(isTouching(FLOOR)){
						play("SPRINTLIKEAMOTHERFUCKER");
					}else {
						play("falling");
					}
					if (target.x+target.width/2 < getMidpoint().x-8){
						velocity.x = -200;
						facing = FlxObject.LEFT;
					}
					if (target.x+target.width/2 > getMidpoint().x+8){
						velocity.x = 200
						facing = FlxObject.RIGHT;
					}
					if (FlxU.getDistance(target.getMidpoint(), getMidpoint()) < 12){
						status = "standing";
						play("idle");
						target = Registry.thePlayer;
					}
					break;
				case "walkLeft":
					if (barkSoundTimer < 0) {
						if(onScreen(FlxG.camera))
							Registry.barkSound.play();
						barkSoundTimer = Math.random() * .5 + .3;
					}
					velocity.x = -200;
					facing = FlxObject.LEFT;
					play("SPRINTLIKEAMOTHERFUCKER");
					break;
				case "walkRight":
					velocity.x = 200;
					facing = FlxObject.RIGHT;
					play("SPRINTLIKEAMOTHERFUCKER");
					break;
				case "dontMove":
					play("idle");
					break;
				case "slump":
					if(_curAnim.name != "slump")
						play("slump");
					facing = LEFT;
					break;
			}
			if (FlxU.getDistance(target.getMidpoint(), getMidpoint()) > 150 && status != "walkLeft" && status != "dontMove" && status != "sniffing" && status != "slump") {
				status = "following";
				lastPos.make(0, 0);
			}
			
			if (Registry.thePlayer.y < y - 50 && status != "walkLeft" && status != "dontMove" && status != "sniffing" && status != "slump") {
				platformjump -= FlxG.elapsed;
				status = "following";
				if (Math.abs(target.x+target.width/2 -getMidpoint().x) < 20 && isTouching(FLOOR)) {
					velocity.y = -200;
					Registry.jumpSound.play(true);
				}
				if (platformjump < 0) {
					var tmpPlatform:OneWay = null;
					var tmp1:Number = 10000;
					var tmp2:Number = 10000;
					var point:FlxPoint = new FlxPoint();
					var point2:FlxPoint = new FlxPoint();
					for each(var a:OneWay in Registry.platformsRef.members) {
						if(tmpPlatform){
							tmp2 = FlxU.getDistance(point.make(Registry.thePlayer.getMidpoint().x, Registry.thePlayer.getMidpoint().y+16), tmpPlatform.getMidpoint());
						}
						tmp1 = FlxU.getDistance(point2.make(Registry.thePlayer.getMidpoint().x, Registry.thePlayer.getMidpoint().y+16), a.getMidpoint());
						if (tmp1 < tmp2)
							tmpPlatform = a;
					}
					target = tmpPlatform;
					//tmpPlatform.flicker(1);
					platformjump = 1;
				}
			}else if (Registry.thePlayer.y > y+25 && status != "walkLeft" && status != "dontMove" && status != "sniffing" && status != "slump") {
				requestDrop = true;
				platformdrop -= FlxG.elapsed;
				status = "following";
				
				if (platformdrop < 0) {
					var tmpPlatform:OneWay = null;
					var tmp1:Number = 10000;
					var tmp2:Number = 10000;
					for each(var a:OneWay in Registry.platformsRef.members) {
						if(tmpPlatform){
							tmp2 = FlxU.getDistance(getMidpoint(), tmpPlatform.getMidpoint());
						}
						tmp1 = FlxU.getDistance(getMidpoint(), a.getMidpoint());
						if (tmp1 < tmp2)
							tmpPlatform = a;
					}
					target = tmpPlatform;
					//tmpPlatform.flicker(1);
					platformdrop = 1;
				}
			}else {
				platformdrop = 1;
				platformjump = 1;
			}
			
			super.update();
			if (wasTouching == NONE && isTouching(FLOOR)) {
				Registry.landSound.play(true);
			}
			if (_curAnim.name == "sniff") {
				if (sniffSoundTimer < 0) {
					if(onScreen(FlxG.camera))
						Registry.sniffSound.play();
					sniffSoundTimer = Math.random() * 1 +1;
				}
			}
			//if (lastPos.x == lastPos2.x && lastPos.y == lastPos2.y && status == "following") {
				//velocity.y = -200;
			//}
			
			//Dog needs to fall through platforms to stay with the player.
			
		}
		public function walkLeft():void {
			status = "walkLeft";
		}
		public function dontMove():void {
			status = "dontMove";
		}
	}
}