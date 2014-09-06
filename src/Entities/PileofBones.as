package Entities 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class PileofBones extends FlxSprite 
	{
		
		public function PileofBones(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, Registry.bonesPNG);
		}
	}
}