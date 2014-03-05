package entities 
{
	import constants.GC;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Hitbox;
	import worlds.MapWorld;
	
	/**
	 * ...
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class Interaction extends Entity implements IInteractable 
	{
		protected var _dialogue:String;
		
		public function Interaction(dialogue:String, x:uint = 0, y:uint = 0) 
		{
			_dialogue = dialogue;
			type = "actor";
			
			super(x, y, null, new Hitbox(12, 12, 2, 2));
		}
		
		public function interact():void 
		{
			// If the world isn't a map world, this didn't even happen.
			if (MapWorld(world) != null)
			{
				// Spit some game.
				MapWorld(world).showDialogue(_dialogue);
			}
		}
		
	}

}