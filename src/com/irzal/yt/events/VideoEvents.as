/*
    Copyright (C) 2011  Irzal Idris

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/> 
	
	http://irzal.com
 */
package com.irzal.yt.events 
{
	import flash.events.Event;
	
	/**
	 * Video Events
	 * @author Dedet
	 */
	public class VideoEvents extends Event 
	{
		//video event
		
		/**
		 * Dispatch event on vidoe pause
		 */
		public static const PAUSE:String 		= "vidPause";
		
		/**
		 * Dispatch event on video play
		 */
		public static const PLAY:String			= "vidPlay";
		
		/**
		 * Dispatch event on video stop
		 */
		public static const STOP:String			= "vidStop";
		
		/**
		 * Dispatch event on video ended
		 */
		public static const ENDED:String		= "vidEnded";
		
		/**
		 * Dispatch event on video ready
		 */
		public static const READY:String		= "vidReady";
		
		/**
		 * Dispatch event on video cuew
		 */
		public static const CUED:String			= "vidCued";
		
		/**
		 * Dispatch event on video unstarted
		 */
		public static const UNSTARTED:String	= "vidUnstarted";
		
		/**
		 * Dispatch event on video buffering
		 */
		public static const BUFFERING:String	= "vidBuffering";
		
		private var _data:*;
		
		/**
		 * Video events
		 * @param	type Video event type
		 * @param	$data Video event data
		 */
		public function VideoEvents(type:String, $data:*=null) 
		{
			_data = $data;
			super(type);
		}
		
		override public function clone():Event
		{
			return new VideoEvents(type, data);
		}
		
		/**
		 * Return event data
		 */
		public function get data():* 
		{
			return _data;
		}
		
	}

}