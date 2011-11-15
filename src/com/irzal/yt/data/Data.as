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
package com.irzal.yt.data 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import com.irzal.yt.events.DataEvents;
	/**
	 * Get Youtube user upload data, singleton type class. Use Data.getInstance() instead of new.
	 * @author dedet
	 */
	public class Data extends EventDispatcher
	{	
		//TODO create feed types class
		private static const FEED_UPLOADS:String 		= "uploads";
		
		public static const COMPLETE:String 			= "complete";
		
		//YOUTUBE DATA TYPE
		public static const VIDEO_ID:String				= "id";
		public static const VIDEO_DURATION:String		= "duration";
		public static const VIDEO_DATE:String			= "date";
		public static const MEDIA_TITLE:String			= "title";
		public static const MEDIA_DESCRIPTION:String 	= "description";
		public static const MEDIA_THUMBNAIL:String		= "thumbnail";
		//public static const TOTAL_VIDEO:String			= 
		
		private static var instance:Data = null;
		
		private var _feedIndexStart:int = 1;
		private var _dataArray:Array;
		private var _youtubeUser:String;
		private var _page:Object;
		private var _maxRestult:int;
		
		private var urLoader:URLLoader;
		private var setupLoader:URLLoader;
		private var userXML:XML;
		
		
		//manual name space
		private var ns:Namespace 		= new Namespace("http://www.w3.org/2005/Atom");
		private var nsMedia:Namespace 	= new Namespace("http://search.yahoo.com/mrss/");
		private var nsGd:Namespace		= new Namespace("http://schemas.google.com/g/2005");
		private var nsOs:Namespace		= new Namespace("http://a9.com/-/spec/opensearch/1.1/");
		private var nsYt:Namespace		= new Namespace("http://gdata.youtube.com/schemas/2007");
		
		/**
		 * Use Data.getInstance() instead of new
		 * @param	e
		 */
		public function Data(e:NewDataBlocker=null) 
		{
			if (e == null)
			{
				throw new Error("Instantiation failed: Use Data.getInstance() instead of new.");
			}
		}
		
		/**
		 * Create instance of Data
		 * @return
		 */
		public static function getInstance():Data
		{
			Security.loadPolicyFile("http://www.youtube.com/crossdomain.xml"); 
			Security.allowDomain("*");
			
			if (instance == null) 
			{
				instance = new Data(new NewDataBlocker());
			}
			return instance;
		}
		
		/**
		 * Load Setup.xml file
		 */
		public function loadSetup():void
		{
			setupLoader = new URLLoader();
			setupLoader.load(new URLRequest("Setup.xml"));
			setupLoader.addEventListener(Event.COMPLETE, setupComplete);
			if (_dataArray == null)
			{
				_dataArray = [];
			}
		}
		
		private function setupComplete(e:Event):void 
		{
			setupLoader.removeEventListener(Event.COMPLETE, setupComplete);
			userXML = XML (setupLoader.data);
			youtubeUser(_feedIndexStart, 50, userXML.user);
		}
		
		/**
		 * 
		 * @param	feedIndex
		 * @param	maxResult
		 * @param	userId
		 */
		public function youtubeUser(feedIndex:int = 1, maxResult:int = 50, userId:String = null):void		
		{
			if (maxResult > 50 || maxResult < 1) throw new Error("Error: maxResult:int cannot be 0 or negatif integer, start from 1 until 50");
			//---
			urLoader = new URLLoader();
			
			if (userId != null)
			{
				_youtubeUser = userId;
			}
			
			urLoader.addEventListener(ProgressEvent.PROGRESS, urLoaderProg);
			urLoader.addEventListener(Event.COMPLETE, urLoaderComplete);
			
			//dynamic feed types
			//urLoader.load(new URLRequest("http://gdata.youtube.com/feeds/api/users/" + _youtubeUser + "/" + feedType + "?v=2"));
			//old grep data
			//urLoader.load(new URLRequest("http://gdata.youtube.com/feeds/api/users/" + _youtubeUser + "/" + Data.FEED_UPLOADS + "?v=2"));
			
			//new grep data up to 50 per feed
			urLoader.load(new URLRequest("http://gdata.youtube.com/feeds/api/users/" + _youtubeUser + "/" + Data.FEED_UPLOADS + "?start-index=" + feedIndex + "&max-results=" + maxResult + "&v=2"));
		}
		
		private function urLoaderProg(e:ProgressEvent):void 
		{
			//put progress here
			//trace("getting youtube data");
		}
		
		private function urLoaderComplete(e:Event):void 
		{
			urLoader.removeEventListener(Event.COMPLETE, urLoaderComplete);
			//---
			userXML = XML(urLoader.data);
			setData(Data.FEED_UPLOADS);
			//nameSpace(userXML.namespaceDeclarations());
		}
		
		//disable for now because theres an addition XML name space in the next feed page
		//name space will be input manualy
		/*private function nameSpace(xmlNs:Array):void
		{
			var i:int;
			trace(xmlNs.length);
			
			while (i < xmlNs.length)
			{
				switch(i)
				{
					case 0: ns 		= xmlNs[i]; break;
					case 1: nsMedia = xmlNs[i]; break;
					case 2: nsOs 	= xmlNs[i]; break;
					case 3: nsGd 	= xmlNs[i]; break;
					case 4: nsYt 	= xmlNs[i]; break;
				}
				i+=1;
			}
			//setData(Data.FEED_UPLOADS);
		}*/
		
		private function setData(feedType:String):void
		{
			var entryLength:int 	= userXML.ns::entry.length();
			var startIndex:int 		= int(userXML.nsOs::startIndex);
			var itemsPerPage:int 	= int(userXML.nsOs::itemsPerPage);
			var i:int;
			var j:int;
			if (getCurrentPage != getPageLength && startIndex > 1)
			{
				j = startIndex - 1;
				_feedIndexStart = startIndex + itemsPerPage;
			}
			
			_dataArray[""+feedType+""]=[];
			
			while (i < entryLength)
			{
				var _id:String 				= userXML.ns::entry[j].nsMedia::group.nsYt::videoid;
				var _duration:String		= userXML.ns::entry[j].nsMedia::group.nsYt::duration.@seconds;
				var _date:String			= userXML.ns::entry[j].nsMedia::group.nsYt::uploaded;
				var _title:String 			= userXML.ns::entry[j].nsMedia::group.nsMedia::title;
				var _description:String 	= userXML.ns::entry[j].nsMedia::group.nsMedia::description;
				var _thumbnail:String 		= userXML.ns::entry[j].nsMedia::group.nsMedia::thumbnail[0].@url;
				_dataArray["" + feedType + ""][i]	= { 
					id:_id, date:_date.slice(0, 10), duration:_duration, title:_title, description:_description, thumbnail:_thumbnail
					};
				j+=1;
				i+=1;
			}
			dispatchEvent(new Event(DataEvents.DATA_COMPLETE));
		}
		
		/**
		 * 
		 * @param	feedType
		 * @return
		 */
		public function getFeedArray(feedType:String):Array 
		{
			return _dataArray["" + feedType + ""];
		}
		
		/**
		 * 
		 * @param	index
		 * @param	dataType
		 * @return
		 */
		public function getData(index:int, dataType:String):String
		{
			return _dataArray["" + Data.FEED_UPLOADS + ""][index]["" + dataType + ""];
		}
		
		/**
		 * 
		 * @return
		 */
		public function get getDataLength():int
		{
			return _dataArray["" + Data.FEED_UPLOADS + ""].length;
		}
		
		/**
		 * 
		 */
		public function get getCurrentPage():Number
		{
			var startIndex:Number 	= int(userXML.nsOs::startIndex);
			var itemsPerPage:Number = Number(userXML.nsOs::itemsPerPage);
			return Math.ceil(startIndex/itemsPerPage);
			//return 100%3;
		}
		
		/**
		 * 
		 */
		public function get getPageLength():Number
		{
			var totalResults:Number = Number(userXML.nsOs::totalResults);
			var itemsPerPage:Number = Number(userXML.nsOs::itemsPerPage);
			//return Math.ceil(totalResults / itemsPerPage);
			return totalResults / itemsPerPage;
		}
		
		/**
		 * 
		 */
		public function get getUserId():String
		{
			return _youtubeUser;
		}
		
		/**
		 * 
		 */
		public function get feedIndexStart():int 
		{
			return _feedIndexStart;
		}
		
		/**
		 * 
		 */
		public function get nextPage():Boolean
		{
			return (getCurrentPage != getPageLength && startIndex > 1);
		}
		
		/**
		 * 
		 */
		public function get startIndex():int
		{
			return int(userXML.nsOs::startIndex);
		}
	}
}
internal class NewDataBlocker 
{
	//do nothing
}