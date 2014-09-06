package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class EndState extends FlxState 
	{
		private var end:int = 0;
		private var title:FlxText;
		private var caption:FlxText;
		private var playButton:FlxButton;
		public function EndState(ending:int) 
		{
			end = ending;
		}
		override public function create():void 
		{
			FlxG.bgColor = 0xFF000000
			switch(end) {
				case 1:
					title = new FlxText(0, FlxG.height / 3, FlxG.width, "You saved the dog and got the\n\"Dog Ending\"")
					title.alignment = "center";
					title.color = 0xFF303030;
					add(title);
					
					caption = new FlxText(0, 150, FlxG.width, "No one came to help you.\nNo one knew you were gone.\n\nYou died alone in those ruins.");
					caption.alignment = "center";
					caption.color = 0xFF151515;
					add(caption);
					
					playButton = new FlxButton(FlxG.width/2-40,FlxG.height / 3 + 130, "Leave Him", onPlay);
					playButton.soundOver = null;  //replace with mouseOver sound
					playButton.color = 0xffD4D943;
					playButton.label.color = 0xffD8EBA2;
					add(playButton);
					break
					
				case 2:
					title = new FlxText(0, FlxG.height / 3, FlxG.width, "You saved yourself and got the\n\"Kid Ending\"")
					title.alignment = "center";
					title.color = 0xFF303030;
					add(title);
					
					caption = new FlxText(0, 150, FlxG.width, "Did it feel good?\nLeaving that dog alone to die.\n\nWas the tablet really worth it?");
					caption.alignment = "center";
					caption.color = 0xFF151515;
					add(caption);
					
					playButton = new FlxButton(FlxG.width/2-40,FlxG.height / 3 + 130, "Save Him", onPlay);
					playButton.soundOver = null;  //replace with mouseOver sound
					playButton.color = 0xffD4D943;
					playButton.label.color = 0xffD8EBA2;
					add(playButton);
					break;
			}
			super.create();
		}
		private function onPlay():void
		{
			playButton.exists = false;
			FlxG.switchState(new PlayState());
		}
	}
}