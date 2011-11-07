package com.irzal 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author dedet
	 */
	public class Test extends Sprite 
	{
		private var uLoader:URLLoader;
		private var xml:XML;
		private var ns:Namespace = new Namespace("http://www.w3.org/2005/Atom");
		private var nsMedia:Namespace = new Namespace("http://search.yahoo.com/mrss/");
		private var nsOpenSearch:Namespace = new Namespace("http://a9.com/-/spec/opensearch/1.1/");
		private var nsGd:Namespace = new Namespace("http://schemas.google.com/g/2005");
		private var nsYt:Namespace = new Namespace("http://gdata.youtube.com/schemas/2007");
		public function Test() 
		{
			Security.loadPolicyFile("http://www.youtube.com/crossdomain.xml");
			uLoader = new URLLoader();
			//uLoader.load(new URLRequest("xmlNs.xml"));
			uLoader.load(new URLRequest("http://gdata.youtube.com/feeds/api/playlists/52BD5CBDE8FA80F4?v=2"));
			uLoader.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			//uLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
			xml = new XML(e.currentTarget.data);
			trace("load complete");
			//trace(xml.namespaceDeclarations());
			var loader2:Loader = new Loader();
			var urlL:String = xml.ns::entry[0].nsMedia::group.nsMedia::thumbnail[2].@url;
			loader2.load(new URLRequest(urlL));
			loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad2Complete);
			trace(xml.ns::entry[0].nsMedia::group.nsMedia::thumbnail[0].@url);
			function onLoad2Complete(e:Event):void 
			{
				addChild(loader2.content);
			}
		}
		
		
		
	}

}