package com.irzal.yt.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Dedet
	 * from Yogesh Puri blog
	 * http://flexcomps.wordpress.com/2008/04/29/dispatching-custom-events-in-as3-with-data-or-object/
	 */
	public class Tevent extends Event
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
		
		//mouse event
		public static const CLICK:String 		= "thumbClick";
		public static const OVER:String 		= "thumbOver";
		public static const OUT:String 			= "thumbOut";
		public static const DOUBLE_CLICK:String = "thumbDoubleClick";
		public static const MOVE:String			= "mMove";
		public static const DOWN:String			= "mDown";
		public static const UP:String			= "mUp";
		
		private var _data:*;
		
		/**
		 * 
		 * @param	type
		 * @param	data
		 */
		public function Tevent(type:String, data:*= null)
		{
			_data = data;
			super(type);
		}
		
		/**
		 * 
		 */
		public function get data():* 
		{
			return _data;
		}
		
	}

}