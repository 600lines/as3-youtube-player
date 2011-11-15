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
		//mouse event
		public static const CLICK:String 		= "thumbClick";
		public static const OVER:String 		= "thumbOver";
		public static const OUT:String 			= "thumbOut";
		public static const DOUBLE_CLICK:String = "thumbDoubleClick";
		public static const MOVE:String			= "mMove";
		public static const DOWN:String			= "mDown";
		public static const UP:String			= "mUp";
		public static const WHEEL:String		= "mWheel";
		
		public var data:*;
		
		/**
		 * 
		 * @param	type
		 * @param	data
		 */
		public function Tevent(type:String, _data:*= null)
		{
			data = _data;
			super(type);
		}
		
		override public function clone():Event
		{
			return new Tevent(type, data);
		}
	}

}