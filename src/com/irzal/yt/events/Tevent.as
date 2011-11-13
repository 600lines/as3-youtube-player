package com.irzal.yt.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Dedet
	 */
	public class Tevent extends Event
	{
		public static const CLICK:String 		= "thumbClick";
		public static const OVER:String 		= "thumbOver";
		public static const OUT:String 			= "thumbOut";
		public static const DOUBLE_CLICK:String = "thumbDoubleClick";
		public static const MOVE:String			= "mMove";
		public static const DOWN:String			= "mDown";
		public static const UP:String			= "mUp";
		
		private var _data:*;
		public function Tevent(type:String, data:*= null)
		{
			_data = data;
			super(type);
		}
		
		public function get data():* 
		{
			return _data;
		}
		
	}

}