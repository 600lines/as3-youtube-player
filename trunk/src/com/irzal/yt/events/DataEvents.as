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
	 * Data events
	 * @author Dedet
	 */
	public class DataEvents extends Event
	{
		/**
		 * Dispatch on data complete
		 */
		public static const DATA_COMPLETE:String 	= "dataComplete";
		
		/**
		 * Dispatch on data progress
		 */
		public static const DATA_PROGRESS:String	= "dataProgress";
		
		private var _data:*;
		
		/**
		 * Data events
		 * @param	type data events type
		 * @param	$data additional data
		 */
		public function DataEvents(type:String, $data:*=null) 
		{
			_data = $data;
			super(type);
		}
		
		override public function clone():Event
		{
			return new DataEvents(type, data);
		}
		
		/**
		 * Return event data
		 */
		public function get data():* 
		{
			return _data
			;
		}
		
	}

}