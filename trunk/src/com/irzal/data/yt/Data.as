package com.irzal.data.yt 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	/**
	 * Get Youtube user upload data, singleton class. User Data.getInstance() instead of new.
	 * @author dedet
	 */
	public class Data extends EventDispatcher
	{	
		private static const FEED_UPLOADS:String 		= "uploads";
		
		public static const COMPLETE:String 			= "complete";
		public static const MEDIA_ID:String				= "id";
		public static const MEDIA_TITLE:String			= "title";
		public static const MEDIA_DESCRIPTION:String 	= "description";
		public static const MEDIA_THUMBNAIL:String		= "thumbnail";
		
		private static var instance:Data = null;
		
		private var _dataArray:Array;
		private var _youtubeUser:String;
		
		private var urLoader:URLLoader;
		private var setupLoader:URLLoader;
		private var userXML:XML;
		
		private var ns:Namespace;
		private var nsMedia:Namespace;
		private var nsGd:Namespace;
		private var nsOs:Namespace;
		private var nsYt:Namespace;
		
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
		 * 
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
		
		public function loadSetup():void
		{
			setupLoader = new URLLoader();
			setupLoader.load(new URLRequest("Setup.xml"));
			setupLoader.addEventListener(Event.COMPLETE, setupComplete);
		}
		
		private function setupComplete(e:Event):void 
		{
			setupLoader.removeEventListener(Event.COMPLETE, setupComplete);
			userXML = XML (setupLoader.data);
			youtubeUser(userXML.user);
		}
		
		/**
		 * 
		 * @param	value
		 */
		public function youtubeUser(value:String):void 
		{
			urLoader = new URLLoader();
			_youtubeUser = value;
			
			//urLoader.load(new URLRequest("http://gdata.youtube.com/feeds/api/users/" + _youtubeUser + "/" + feedType + "?v=2"));
			urLoader.load(new URLRequest("http://gdata.youtube.com/feeds/api/users/" + _youtubeUser + "/" + Data.FEED_UPLOADS + "?v=2"));
			urLoader.addEventListener(Event.COMPLETE, urLoaderComplete);
		}
		
		/**
		 * 
		 * @param	feedType
		 * @return
		 */
		public function getThumbArray(feedType:String):Array 
		{
			return _dataArray["" + feedType + ""];
		}
		
		private function urLoaderComplete(e:Event):void 
		{
			urLoader.removeEventListener(Event.COMPLETE, urLoaderComplete);
			//---
			userXML = XML(urLoader.data);
			nameSpace(userXML.namespaceDeclarations());
		}
		
		private function nameSpace(xmlNs:Array):void
		{
			var i:int;
			
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
			setData(Data.FEED_UPLOADS);
		}
		
		private function setData(feedType:String):void
		{
			var entryLength:int = userXML.ns::entry.length();
			var i:int;
			_dataArray = [];
			_dataArray[""+feedType+""]=[];
			
			while (i < entryLength)
			{
				var _id:String 				= userXML.ns::entry[i].nsMedia::group.nsYt::videoid;
				var _title:String 			= userXML.ns::entry[i].nsMedia::group.nsMedia::title;
				var _description:String 	= userXML.ns::entry[i].nsMedia::group.nsMedia::description;
				var _thumbnail:String 		= userXML.ns::entry[i].nsMedia::group.nsMedia::thumbnail[0].@url;
				_dataArray[""+feedType+""][i]	= { id:_id, title:_title, description:_description, thumbnail:_thumbnail };
				//trace(_dataArray[""+feedType+""][i]["thumbnail"]);
				i++;
			}
			dispatchEvent(new Event(Data.COMPLETE));
		}
		
		/**
		 * 
		 * @param	media
		 * @param	index
		 * @return
		 */
		public function getData(media:String,index:int):String
		{
			return _dataArray["" + Data.FEED_UPLOADS + ""][index]["" + media + ""];
		}
		
		/**
		 * 
		 * @return
		 */
		public function getDataLength():int
		{
			return _dataArray["" + Data.FEED_UPLOADS + ""].length;
		}
	}
}
internal class NewDataBlocker {}