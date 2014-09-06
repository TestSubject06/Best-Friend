package  
{
	import Entities.Player;
	import mx.core.MovieClipAsset;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Registry 
	{
		[Embed(source = "data/Dog.png")]public static var dogPNG:Class;
		[Embed(source = "data/GrassyTiles.png")]public static var grassTiles:Class;
		[Embed(source = "data/MainCharacter.png")]public static var characterPNG:Class;
		[Embed(source = "data/mapCSV_Group1_Map1.csv", mimeType = "application/octet-stream")]public static var stupidShit:Class;
		[Embed(source = "data/Sky.png")]public static var skiPNG:Class;
		[Embed(source = "data/Shiney.png")]public static var shinePNG:Class;
		[Embed(source = "data/shiney2.png")]public static var shine2PNG:Class;
		[Embed(source = "data/Tablet.png")]public static var tabletPNG:Class;
		[Embed(source = "data/Tree.png")]public static var treePNG:Class;
		[Embed(source = "data/Statue.png")]public static var statuePNG:Class;
		[Embed(source = "data/Skull.png")] public static var skullPNG:Class;
		[Embed(source = "data/Pile of Bones.png")] public static var bonesPNG:Class;
		[Embed(source = "data/Pedestal.png")] public static var pedestalPNG:Class;
		[Embed(source = "data/Door.png")]public static var doorPNG:Class;
		[Embed(source = "data/OneWay.png")]public static var oneWayPNG:Class;
		[Embed(source = "data/Recepticle.png")] public static var recepticlePNG:Class;
		[Embed(source = "data/DogBone.png")] public static var dogbonePNG:Class;
		[Embed(source = "data/Collect.mp3")]public static var collectSND:Class;
		[Embed(source = "data/door.mp3")]public static var doorSND:Class;
		[Embed(source = "data/land.mp3")]public static var landSND:Class;
		[Embed(source = "data/jump.mp3")]public static var jumpSND:Class;
		[Embed(source = "data/runAway.mp3")]public static var runAwaySND:Class;
		[Embed(source = "data/bark.mp3")]public static var barkSND:Class;
		[Embed(source = "data/sniff.mp3")]public static var sniffSND:Class;
		
		[Embed(source = "data/Ruins2.mod", mimeType = "application/octet-stream")]public static var ruinsMOD2:Class;
		[Embed(source = "data/Sad.mod", mimeType = "application/octet-stream")]public static var sadMOD:Class;
		[Embed(source = "data/Forest.mod", mimeType = "application/octet-stream")]public static var forestMOD:Class;
		
		public static var jumpSound:FlxSound;
		public static var collectSound:FlxSound;
		public static var landSound:FlxSound;
		public static var doorSound:FlxSound;
		public static var escapeSound:FlxSound;
		public static var barkSound:FlxSound;
		public static var sniffSound:FlxSound;
		public static var thePlayer:Player;
		public static var platformsRef:FlxGroup;
		public static function initializeSounds():void {
			jumpSound = new FlxSound();
			jumpSound.loadEmbedded(jumpSND);
			
			doorSound = new FlxSound();
			doorSound.loadEmbedded(doorSND);
			
			landSound = new FlxSound();
			landSound.loadEmbedded(landSND);
			
			collectSound = new FlxSound();
			collectSound.loadEmbedded(collectSND);
			
			escapeSound = new FlxSound();
			escapeSound.loadEmbedded(runAwaySND);
			
			barkSound = new FlxSound();
			barkSound.loadEmbedded(barkSND);
			
			sniffSound = new FlxSound();
			sniffSound.loadEmbedded(sniffSND);
		}
	}
}