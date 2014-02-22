package constants 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class Direction 
	{
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		public static function GetDirectionValue(direction:String):Point
		{
			var p:Point = new Point();
			
			switch (direction)
			{
				case UP:
					p.y = -1;
					break;
				case DOWN:
					p.y = 1;
					break;
				case LEFT:
					p.x = -1;
					break;
				case RIGHT:
					p.x = 1;
					break;
				default:
					break;
			}
			
			return p;
		}
	}

}