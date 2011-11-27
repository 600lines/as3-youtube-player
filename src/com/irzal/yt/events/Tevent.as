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
	 * Thumbnail Event
	 * @author Dedet
	 * from Yogesh Puri blog
	 * http://flexcomps.wordpress.com/2008/04/29/dispatching-custom-events-in-as3-with-data-or-object/
	 */
	public class Tevent extends Event
	{
		//mouse event
		/**
		 * Dispatch on mouse click
		 */
		public static const CLICK:String 		= "thumbClick";
		
		/**
		 * Dispatch on mouse over
		 */
		public static const OVER:String 		= "thumbOver";
		
		/**
		 * Dispatch on mouse out
		 */
		public static const OUT:String 			= "thumbOut";
		
		/**
		 * Dispatch on mouse double click
		 */
		public static const DOUBLE_CLICK:String = "thumbDoubleClick";
		
		/**
		 * Dispatch on mouse move
		 */
		public static const MOVE:String			= "mMove";
		
		/**
		 * Dispatch on mouse down
		 */
		public static const DOWN:String			= "mDown";
		
		/**
		 * Dispatch on mouse up
		 */
		public static const UP:String			= "mUp";
		
		/**
		 * Dispatch on mouse wheel
		 */
		public static const WHEEL:String		= "mWheel";
		
		private var _data:*;
		
		/**
		 * Thumbnail event
		 * @param	type Thumbnail event type
		 * @param	$data Thumbnail additional data
		 */
		public function Tevent(type:String, $data:*= null)
		{
			_data = $data;
			super(type);
		}
		
		override public function clone():Event
		{
			return new Tevent(type, data);
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