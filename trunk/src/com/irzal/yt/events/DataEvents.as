package com.irzal.yt.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Dedet
	 */
	public class DataEvents extends Event
	{
		public static const DATA_COMPLETE:String = "dataComplete";
		public static const DATA_PROGRESS:String	= "dataProgress";
		
		public var data:*;
		public function DataEvents(type:String, _data:*=null) 
		{
			data = _data;
			super(type);
		}
		
		override public function clone():Event
		{
			return new DataEvents(type, data);
		}
		
	}

}