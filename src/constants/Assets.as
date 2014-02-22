package constants
{
	/**
	 * ...
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class Assets 
	{
		[Embed(source = "../../assets/tiles.png")] public static const MAP_TILES:Class;
		[Embed(source = "../../assets/characters.png")] public static const CHARACTER_SPRITES:Class;
		
		public static const SPRITE_RED:uint = 0;
		public static const SPRITE_REDBIKE:uint = 1;
		public static const SPRITE_BLUE:uint = 2;
	}

}