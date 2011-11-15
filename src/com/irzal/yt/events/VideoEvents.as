package com.irzal.yt.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dedet
	 */
	public class VideoEvents extends Event 
	{
		//video event
		public static const PAUSE:String 		= "vidPause";
		public static const PLAY:String			= "vidPlay";
		public static const STOP:String			= "vidStop";
		public static const ENDED:String		= "vidEnded";
		public static const READY:String		= "vidReady";
		public static const CUED:String			= "vidCued";
		public static const UNSTARTED:String	= "vidUnstarted";
		public static const BUFFERING:String	= "vidBuffering";
		
		public var data:*;
		
		public function VideoEvents(type:String, _data:*=null) 
		{
			data = _data;
			super(type);
		}
		
		override public function clone():Event
		{
			return new VideoEvents(type, data);
		}
		
	}

}