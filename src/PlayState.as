package
{

	import Entities.Dog;
	import Entities.dogBone;
	import Entities.Door;
	import Entities.OneWay;
	import Entities.Pedestal;
	import Entities.PileofBones;
	import Entities.Player;
	import Entities.Recepticle;
	import Entities.Tablet;
	import Entities.Tree;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxFlod;

	public class PlayState extends FlxState
	{
		private var collisionGroup:FlxGroup;
		private var treesGroup:FlxGroup;
		private var pedestalsGroup:FlxGroup;
		private var doorsGroup:FlxGroup;
		private var platformsGroup:FlxGroup;
		private var sky:FlxSprite = new FlxSprite(0, 0, Registry.skiPNG);
		private var level:FlxTilemap;
		private var player:Player;
		private var dog:Dog;
		private var recepticle:Recepticle;
		private var sparklyEmitter:FlxEmitter;
		private var sparklyEmitter2:FlxEmitter;
		private var tablet:Tablet;
		private var tree:Tree;
		private var hasTablet:Boolean = false;
		private var dogOut:Boolean = false;
		private var initOpen:Boolean = false;
		private var hoildingRoom:FlxRect = new FlxRect(1120, 432, 64, 76);
		private var camScrolling:Boolean = false;
		private var camTarget:FlxObject;
		private var cameraTimer:Number = 0;
		private var endStatus:String = "none";
		private var dogbone:dogBone;
		private var ending:int = 0;
		
		override public function create():void
		{
			FlxFlod.flectrum = null;
			FlxFlod.playMod(Registry.forestMOD);
			FlxG.bgColor = 0xFF666666;
			
			sky.scrollFactor.make(0, 0);
			
			level = new FlxTilemap();
			level.loadMap(new Registry.stupidShit, Registry.grassTiles, 16, 16, FlxTilemap.OFF, 0, 1, 4);
			
			collisionGroup = new FlxGroup();
			
			Registry.thePlayer = new Player();
			player = Registry.thePlayer;
			player.acceleration.y = 400;
			player.x = 30;
			player.y = 200;
			collisionGroup.add(player);
			
			
			dog = new Dog(20, 0);
			dog.acceleration.y = 400;
			dog.x = 50;
			dog.y = 200;
			collisionGroup.add(dog);
			
			tablet = new Tablet(1328, 480);
			sparklyEmitter = new FlxEmitter();
			sparklyEmitter.makeParticles(Registry.shinePNG, 40, 0, false, 0);
			sparklyEmitter.width = 20;
			sparklyEmitter.height = 20;
			sparklyEmitter.at(tablet);
			sparklyEmitter.setYSpeed( -20, -50);
			sparklyEmitter.setXSpeed( -10, 10);
			sparklyEmitter.setRotation(0, 0);
			sparklyEmitter.start(false, 1, .05);
			
			sparklyEmitter2 = new FlxEmitter();
			sparklyEmitter2.makeParticles(Registry.shinePNG, 20, 0, false, 0);
			sparklyEmitter2.width = 20;
			sparklyEmitter2.height = 20;
			sparklyEmitter2.at(tablet);
			sparklyEmitter2.setYSpeed( -20, -50);
			sparklyEmitter2.setXSpeed( -10, 10);
			sparklyEmitter2.setRotation(0, 0);
			sparklyEmitter2.start(false, 1, .2);
			
			FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			FlxG.worldBounds.make(0, 0, level.width, level.height);
			FlxG.camera.bounds = new FlxRect(16, 0, level.width - 32, level.height);
			
			pedestalsGroup = new FlxGroup();
			//pedestalsGroup.add(new Pedestal(1312, 504, tabletPedestal));
			pedestalsGroup.add(new Pedestal(864, 248, entrancePedestal));
			pedestalsGroup.add(new Pedestal(994, 152, roofPedestal));
			pedestalsGroup.add(new Pedestal(2384, 504, basementPedestal));
			pedestalsGroup.add(new Pedestal(2384, 280, backroomPedestal));
			
			doorsGroup = new FlxGroup();
			var tmpDoor:Door = new Door(944, 192, 0);
			doorsGroup.add(tmpDoor);
			tmpDoor = new Door(1456, 192, 1);
			doorsGroup.add(tmpDoor);
			tmpDoor = new Door(1056, 448, 2)
			tmpDoor.open = true;
			doorsGroup.add(tmpDoor);
			tmpDoor = new Door(1248, 448, 2)
			tmpDoor.open = true;
			doorsGroup.add(tmpDoor);
			tmpDoor = new Door(1408, 448, 3)
			doorsGroup.add(tmpDoor);
			tmpDoor = new Door(2272, 352, 4)
			doorsGroup.add(tmpDoor);
			tmpDoor = new Door(2176, 224, 5)
			doorsGroup.add(tmpDoor);
			tmpDoor = new Door(1648, 320, 6)
			//tmpDoor.open = true; //Testing purposes, lock the final door open.
			doorsGroup.add(tmpDoor);
			
			platformsGroup = new FlxGroup();
			Registry.platformsRef = platformsGroup;
			platformsGroup.add(new OneWay(1344, 256));
			platformsGroup.add(new OneWay(1344, 208));
			platformsGroup.add(new OneWay(1344, 160));
			platformsGroup.add(new OneWay(1344, 304));
			platformsGroup.add(new OneWay(960, 368));
			platformsGroup.add(new OneWay(960, 416));
			platformsGroup.add(new OneWay(960, 464));
			platformsGroup.add(new OneWay(1856, 416));
			platformsGroup.add(new OneWay(1856, 464));
			platformsGroup.add(new OneWay(2080, 416));
			platformsGroup.add(new OneWay(2080, 464));
			platformsGroup.add(new OneWay(2080, 464));
			platformsGroup.add(new OneWay(2080, 368));
			platformsGroup.add(new OneWay(2080, 320));
			platformsGroup.add(new OneWay(2080, 288));
			platformsGroup.add(new OneWay(2304, 416));
			platformsGroup.add(new OneWay(2304, 464));
			
			
			add(sky);
			add(new Tree(64, 150));
			add(new Tree(164, 150));
			add(new Tree(264, 150));
			add(new Tree(364, 150));
			add(new Tree(464, 150));
			add(new Tree(564, 150));
			add(level);
			
			add(doorsGroup);
			
			add(new PileofBones(1072, 496));
			add(new PileofBones(1120, 496));
			add(new PileofBones(1184, 496));
			add(new PileofBones(1216, 496));
			add(new PileofBones(1568, 496));
			add(new PileofBones(1840, 496));
			add(new PileofBones(1424, 400));
			add(new PileofBones(1616, 400));
			add(new PileofBones(1824, 272));
			add(new PileofBones(1904, 272));
			add(new PileofBones(2160, 496));
			add(new PileofBones(2304, 496));
			add(new PileofBones(2272, 272));
			
			add(new FlxSprite(1083, 493, Registry.skullPNG));
			add(new FlxSprite(1192, 490, Registry.skullPNG));
			add(new FlxSprite(1118, 495, Registry.skullPNG));
			add(new FlxSprite(1217, 494, Registry.skullPNG));
			add(new FlxSprite(1137, 242, Registry.skullPNG));
			add(new FlxSprite(1435, 395, Registry.skullPNG));
			add(new FlxSprite(1631, 397, Registry.skullPNG));
			add(new FlxSprite(1563, 498, Registry.skullPNG));
			add(new FlxSprite(1856, 498, Registry.skullPNG));
			add(new FlxSprite(2032, 498, Registry.skullPNG));
			add(new FlxSprite(2168, 496, Registry.skullPNG));
			add(new FlxSprite(2309, 494, Registry.skullPNG));
			add(new FlxSprite(2272, 274, Registry.skullPNG));
			add(new FlxSprite(1829, 274, Registry.skullPNG));
			add(new FlxSprite(1915, 274, Registry.skullPNG));
			
			add(new FlxSprite(800, 224, Registry.statuePNG));
			add(new FlxSprite(832, 224, Registry.statuePNG));
			add(new FlxSprite(864, 224, Registry.statuePNG));
			add(new FlxSprite(896, 224, Registry.statuePNG));
			add(new FlxSprite(928, 224, Registry.statuePNG));
			add(new FlxSprite(1136, 128, Registry.statuePNG));
			add(new FlxSprite(1296, 128, Registry.statuePNG));
			add(new FlxSprite(1424, 128, Registry.statuePNG));
			add(new FlxSprite(1280, 480, Registry.statuePNG));
			add(new FlxSprite(1376, 480, Registry.statuePNG));
			add(new FlxSprite(1456, 384, Registry.statuePNG));
			add(new FlxSprite(1472, 384, Registry.statuePNG));
			add(new FlxSprite(1488, 384, Registry.statuePNG));
			add(new FlxSprite(1568, 384, Registry.statuePNG));
			add(new FlxSprite(1584, 384, Registry.statuePNG));
			add(new FlxSprite(1600, 384, Registry.statuePNG));
			add(new FlxSprite(1680, 480, Registry.statuePNG));
			add(new FlxSprite(1680, 480, Registry.statuePNG));
			add(new FlxSprite(1792, 256, Registry.statuePNG));
			add(new FlxSprite(1984, 256, Registry.statuePNG));
			add(new FlxSprite(2208, 256, Registry.statuePNG));
			add(new FlxSprite(2304, 256, Registry.statuePNG));
			add(new FlxSprite(2048, 384, Registry.statuePNG));
			add(new FlxSprite(2160, 384, Registry.statuePNG));
			add(new FlxSprite(2384, 384, Registry.statuePNG));
			
			dogbone = new dogBone(1146, 504);
			add(dogbone);
			add(pedestalsGroup);
			
			recepticle = new Recepticle(1520, 384);
			add(recepticle);
			add(sparklyEmitter);
			
			
			add(collisionGroup);
			add(platformsGroup);
			add(tablet);
			
			
			add(sparklyEmitter2);
		}
		private function blah(o1:FlxObject, o2:FlxObject):void {
			if(!recepticle.isOn){
				activateRecepticle(recepticle);
			}
		}
		override public function update():void
		{
			cameraTimer -= FlxG.elapsed;
			super.update();
			FlxG.collide(collisionGroup, doorsGroup);
			if(!player.requestDrop){
				FlxG.collide(player, platformsGroup);
			}
			if(!dog.requestDrop){
				FlxG.collide(dog, platformsGroup);
			}
			FlxG.collide(collisionGroup, level);
			FlxG.collide(player, pedestalsGroup, triggerPedestals);
			FlxG.overlap(player, tablet, grabTablet);
			FlxG.overlap(player, recepticle, blah);
			
			checkWinCondition();
			checkDogTrapRoom();
			if (camScrolling){
				FlxG.camera.scroll.x -= ((FlxG.camera.scroll.x+FlxG.width/2) - camTarget.getMidpoint().x) * .1;
				FlxG.camera.scroll.y -= ((FlxG.camera.scroll.y+FlxG.height/2) - camTarget.getMidpoint().y) * .1;
				if (Math.abs(camTarget.getMidpoint().x - (FlxG.camera.scroll.x+FlxG.width/2)) < 2) {
					camScrolling = false;
					FlxG.camera.follow(camTarget, FlxCamera.STYLE_PLATFORMER);
				}
			}
			if (FlxG.keys.justPressed("M")) {
				if (FlxFlod.isPlaying) {
					FlxFlod.pause();
				}else {
					FlxFlod.resume();
					FlxFlod.volume = FlxG.volume;
				}
			}
		}
		private function triggerPedestals(obj1:FlxObject, obj2:FlxObject):void {
			if (obj1 is Pedestal)
				Pedestal(obj1).trigger();
			else if(obj2 is Pedestal)
				Pedestal(obj2).trigger();
				
			if (obj1 is Recepticle) {
				if(!Recepticle(obj1).isOn){
					activateRecepticle(Recepticle(obj1));
				}
			}else if (obj2 is Recepticle) {
				if(!Recepticle(obj2).isOn){
					activateRecepticle(Recepticle(obj2));
				}
			}
			
		}
		private function tabletPedestal():Boolean {
			
			return true;
		}
		private function entrancePedestal():Boolean {
			doorsGroup.members[0].play("Opening");
			Registry.doorSound.play(true);
			initOpen = true;
			return true;
		}
		private function roofPedestal():Boolean {
			for each(var a:Door in doorsGroup.members) {
				if (a.doorID == 2)
					if (a.open == true)
						return false;
				if (a.doorID == 4) {
					a.play("Opening");
				}
			}
			Registry.doorSound.play(true);
			return true;
		}
		private function basementPedestal():Boolean {
			for each(var a:Door in doorsGroup.members) {
				if (a.doorID == 5){
					a.play("Opening");
				}
			}
			Registry.doorSound.play(true);
			return true;
		}
		private function backroomPedestal():Boolean {
			for each(var a:Door in doorsGroup.members) {
				if (a.doorID == 0){
					a.play("Opening");
				}
				if (a.doorID == 6){
					a.play("Opening");
				}
			}
			Registry.doorSound.play(true);
			return true;
		}
		private function grabTablet(obj1:FlxObject, obj2:FlxObject):void {
			sparklyEmitter.setXSpeed( -100, 100);
			sparklyEmitter.setYSpeed(0, -100);
			sparklyEmitter2.setXSpeed( -100, 100);
			sparklyEmitter2.setYSpeed(0, -100);
			sparklyEmitter.start(true, .5);
			sparklyEmitter2.start(true, .7);
			tablet.exists = false;
			hasTablet = true;
			FlxFlod.playMod(Registry.ruinsMOD2);
			if(dog.status != "sniffing"){
				dog.x = dogbone.x - dog.width;
				dog.y = dogbone.y - dog.height +7;
			}
			for each(var a:Door in doorsGroup.members) {
				if (a.doorID == 1) {
					a.play("Opening");
				}
				if (a.doorID == 2) {
					a.play("Closing");
				}
				if (a.doorID == 3) {
					a.play("Opening");
				}
				if (a.doorID == 0) {
					a.play("Closing");
				}
			}
			Registry.doorSound.play(true);
			Registry.collectSound.play();
		}
		private function activateRecepticle(theRec:Recepticle):void {
			if(hasTablet){
				Registry.doorSound.play(true);
				sparklyEmitter.at(theRec);
				sparklyEmitter2.at(theRec);
				sparklyEmitter.start(false, 1, .05);
				sparklyEmitter2.start(false, 1, .2);
				theRec.play("raging");
				theRec.isOn = true;
				dog.exists = false;
				dogbone.exists = false;
				dogOut = true;
				
				for each(var a:Door in doorsGroup.members) {
					if (a.doorID == 2) {
						a.play("Opening");
					}
					if (a.doorID == 1) {
						a.play("Closing");
					}
				}
			}
		}
		private function checkWinCondition():void {
			if (dogOut && dog.exists == false) {
				if (player.x > hoildingRoom.x && player.x < hoildingRoom.x + hoildingRoom.width) {
					if (player.y > hoildingRoom.y && player.y < hoildingRoom.y + hoildingRoom.height) {
						for each(var a:Door in doorsGroup.members) {
							if (a.doorID == 2) {
								a.play("Closing");
								Registry.doorSound.play(true);
								dog.exists = true;
								dog.x = 912;
								dog.y = 240;
								dogbone.angle = 90;
								dogbone.stickTo(dog);
								dogbone.exists = true;
								dog.dontMove();
								cameraTimer = 1;
								endStatus = "lookDog";
								player.revokeControl();
								FlxFlod.playMod(Registry.sadMOD);
							}
						}
					}
				}
			}
			if (endStatus == "lookDog") {
				if(cameraTimer < 0){
					scrollCameraTo(dog);
					dog.walkLeft();
					FlxG.camera.follow(null);
					cameraTimer = 3;
					endStatus = "lookHuman";
				}
			}
			if (endStatus == "lookHuman") {
				if (cameraTimer < 0) {
					scrollCameraTo(player);
					FlxG.camera.follow(null);
					cameraTimer = 3;
					endStatus = "fade";
					player.x = 1232;
					player.slump();
					ending = 1;
				}
			}
			
			if (player.x < 600 && hasTablet && endStatus == "none") {
				player.revokeControl();
				player.walkLeft();
				FlxG.flash(0xFFFFFFFF, .1);
				FlxFlod.playMod(Registry.sadMOD);
				Registry.escapeSound.play();
				cameraTimer = 3;
				endStatus = "lookDog2";
				dog.x = 1072;
				dog.status = "dontMove";
				dogbone.exists = false;
			}
			if (endStatus == "lookDog2") {
				if(cameraTimer < 0){
					scrollCameraTo(dog);
					FlxG.camera.follow(null);
					cameraTimer = 3;
					endStatus = "fade";
					dog.status = "slump";
					ending = 2;
				}
			}
			
			if (endStatus == "fade") {
				if (cameraTimer < 0) {
					FlxG.camera.fade(0xFF000000, 5, onComplete);
				}
			}
		}
		private function scrollCameraTo(target:FlxObject):void {
			camScrolling = true;
			camTarget = target;
		}
		private function checkDogTrapRoom():void {
			if (dog.x > hoildingRoom.x && dog.x < hoildingRoom.x + hoildingRoom.width) {
				if (dog.y > hoildingRoom.y && dog.y < hoildingRoom.y + hoildingRoom.height) {
					dog.target = dogbone;
					dog.status = "sniffing";
				}
			}
		}
		private function onComplete():void {
			FlxFlod.stopMod();
			FlxG.switchState(new EndState(ending));
		}
	}
}

