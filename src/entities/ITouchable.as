package entities 
{
	
	/**
	 * An interface for objects that trigger on touch, such as
	 * doors, stairs, tall grass and healing pads.
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public interface ITouchable 
	{
		public function touch():void;
	}
	
}