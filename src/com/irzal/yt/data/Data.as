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
	import flash.events.DataEvent;
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
		private static var instance:Data = null;
		
		private var _dataArray:Array;
		private var _youtubeUser:String;
		
		private var urLoader:URLLoader;
		private var setupLoader:URLLoader;
		private var userXML:XML;
		
		private var _feedIndexStart:int = 1;
		
		/**
		 * Maximum number of feed result, from 1-50
		 */
		public var maxFeedResult:int = 25;
		
		/**
		 * Your Setup.xml file path
		 */
		public var setupPath:String = "xml/";// "/swfs/youtube/";
		
		//manual name space
		private var ns:Namespace 		= new Namespace("http://www.w3.org/2005/Atom");
		private var nsMedia:Namespace 	= new Namespace("http://search.yahoo.com/mrss/");
		private var nsGd:Namespace		= new Namespace("http://schemas.google.com/g/2005");
		private var nsOs:Namespace		= new Namespace("http://a9.com/-/spec/opensearch/1.1/");
		private var nsYt:Namespace		= new Namespace("http://gdata.youtube.com/schemas/2007");
		
		/**
		 * Use Data.getInstance() instead of new
		 * @param	data
		 */
		public function Data(data:NewDataBlocker=null) 
		{
			if (data == null)
			{
				throw new Error("Instantiation failed: Use Data.getInstance() instead of new.");
			}
			
			if (instance == null)
			{
				_dataArray = [];
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
				//_dataArray = [];
			}
			return instance;
		}
		
		/**
		 * Load Setup.xml file
		 */
		public function loadSetup():void
		{
			setupLoader = new URLLoader();
			setupLoader.load(new URLRequest(setupPath + "Setup.xml"));
			setupLoader.addEventListener(Event.COMPLETE, setupComplete);
		}
		
		private function setupComplete(e:Event):void 
		{
			setupLoader.removeEventListener(Event.COMPLETE, setupComplete);
			userXML = XML (setupLoader.data);
			youtubeUser(userXML.user, maxFeedResult, _feedIndexStart);
		}
		
		/**
		 * Load YouTube feed data
		 * @param	userId YouTube user ID
		 * @param	maxResult maximum number of feed
		 * @param	feedIndex feed index start
		 */
		public function youtubeUser(userId:String = "", maxResult:int = 0, feedIndex:int = 0):void
		{
			urLoader = new URLLoader();
			
			if (userId != "")
			{
				_youtubeUser = userId;
			}
			
			if (maxResult == 0)
			{
				maxResult = maxFeedResult;
			}
			
			if (feedIndex == 0)
			{
				feedIndex = _feedIndexStart;
			}
			
			urLoader.addEventListener(ProgressEvent.PROGRESS, urLoaderProg);
			urLoader.addEventListener(Event.COMPLETE, urLoaderComplete);
			
			//dynamic feed types
			//urLoader.load(new URLRequest("http://gdata.youtube.com/feeds/api/users/" + _youtubeUser + "/" + feedType + "?v=2"));
			//old grep data
			//urLoader.load(new URLRequest("http://gdata.youtube.com/feeds/api/users/" + _youtubeUser + "/" + Data.FEED_UPLOADS + "?v=2"));
			
			//new grep data up to 50 per feed
			urLoader.load(new URLRequest(
				"http://gdata.youtube.com/feeds/api/users/" + 
				_youtubeUser + "/" + 
				DataFeeds.FEED_UPLOADS + 
				"?start-index=" + 
				feedIndex + 
				"&max-results=" +
				maxResult + 
				"&v=2"));
		}
		
		private function urLoaderProg(e:ProgressEvent):void 
		{
			var progress:Number = e.bytesLoaded / e.bytesTotal;
			dispatchEvent(new DataEvents(DataEvents.DATA_PROGRESS, progress));
		}
		
		private function urLoaderComplete(e:Event):void 
		{
			urLoader.removeEventListener(Event.COMPLETE, urLoaderComplete);
			urLoader.removeEventListener(ProgressEvent.PROGRESS, urLoaderProg);
			//---
			userXML = XML(urLoader.data);
			setData(DataFeeds.FEED_UPLOADS);
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
		
		/**
		 * Use DataFeeds
		 * @param	feedType
		 */
		private function setData(feedType:String):void
		{
			var regEx:RegExp = new RegExp("(http(s)?://[a-zA-Z0-9/@?#!&+._=-]*)", "gi");
			
			var entryLength:int 	= userXML.ns::entry.length();
			var startIndex:int 		= int(userXML.nsOs::startIndex);
			var itemsPerPage:int 	= int(userXML.nsOs::itemsPerPage);
			var i:int;
			var j:int;
			
			j = startIndex - 1;
			_feedIndexStart = startIndex + itemsPerPage;
			
			if (_dataArray["" + feedType + ""] == null)
			{
				_dataArray["" + feedType + ""] = [];
			}
			
			while (i < entryLength)
			{
				var _id:String 				= userXML.ns::entry[i].nsMedia::group.nsYt::videoid;
				var _duration:String		= userXML.ns::entry[i].nsMedia::group.nsYt::duration.@seconds;
				var _date:String			= userXML.ns::entry[i].nsMedia::group.nsYt::uploaded;
				var _title:String 			= userXML.ns::entry[i].nsMedia::group.nsMedia::title;
				var _description:String 	= userXML.ns::entry[i].nsMedia::group.nsMedia::description;
				var _thumbnail:String 		= userXML.ns::entry[i].nsMedia::group.nsMedia::thumbnail[0].@url;
				_dataArray["" + feedType + ""][j]	= { 
					id:_id,
					date:_date.slice(0, 10), 
					duration:_duration, 
					title:"<span class='title'>"+_title+"</span>", 
					description:_description.replace(regEx, "<a href='$1' target='_blank'>$1</a>"), 
					thumbnail:_thumbnail
					};
				j+=1;
				i+=1;
			}
			dispatchEvent(new DataEvent(DataEvents.DATA_COMPLETE));
		}
		
		/**
		 * Return an array of feed
		 * @param	feedType Use DataFeed public static const properties
		 * @return an Array of data feed
		 */
		public function getFeedArray(feedType:String):Array 
		{
			return _dataArray["" + feedType + ""];
		}
		
		/**
		 * Get individual data
		 * @param	index
		 * @param	dataType
		 * @return 
		 */
		public function getData(index:int, dataType:String):String
		{
			return _dataArray[DataFeeds.FEED_UPLOADS][index][dataType];
		}
		
		/**
		 * Get data length
		 * @return
		 */
		public function getDataLength(feedType:String=null):int
		{
			if (feedType == null) feedType = DataFeeds.FEED_UPLOADS;
			return _dataArray[feedType].length;
		}
		
		/**
		 * Get current page number
		 */
		public function get getCurrentPage():Number
		{
			var startIndex:Number 	= int(userXML.nsOs::startIndex);
			var itemsPerPage:Number = Number(userXML.nsOs::itemsPerPage);
			return Math.ceil(startIndex/itemsPerPage);
			//return 100%3;
		}
		
		/**
		 * Get current page length
		 */
		public function get getPageLength():Number
		{
			var totalResults:Number = Number(userXML.nsOs::totalResults);
			var itemsPerPage:Number = Number(userXML.nsOs::itemsPerPage);
			return Math.ceil(totalResults / itemsPerPage);
		}
		
		/**
		 * Get YouTube user ID
		 */
		public function get getUserId():String
		{
			return _youtubeUser;
		}
		
		/**
		 * Get feed index start on current page
		 */
		public function get getFeedIndexStart():int 
		{
			return _feedIndexStart;
		}
		
		/**
		 * Check if next data feed if available
		 */
		public function get nextPage():Boolean
		{
			return (getCurrentPage != getPageLength);
		}
		
		/**
		 * Start index number in YouTube feed data
		 */
		public function get startIndex():int
		{
			return int(userXML.nsOs::startIndex);
		}
		
		/**
		 * Number entry element in YouTube feed data
		 * @return
		 */
		public function entryLength():int
		{
			return userXML.ns::entry.length();
		}
	}
}
internal class NewDataBlocker 
{
	//do nothing
}