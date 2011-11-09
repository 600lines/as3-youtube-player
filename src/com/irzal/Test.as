package com.irzal 
{
	import com.irzal.data.yt.Data;
	import com.irzal.media.yt.thumbs.Tcontainer;
	import com.irzal.media.yt.thumbs.Tloader;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import com.irzal.media.yt.thumbs.Tevent;
	/**
	 * ...
	 * @author dedet
	 */
	public class Test extends Sprite 
	{
		private var data:Data;
		//private var thumb:Tloader;
		private var container:Tcontainer;
		public function Test() 
		{
			data = Data.getInstance();
			data.loadSetup();
			data.addEventListener(Data.COMPLETE, onData);
			container = new Tcontainer();
		}
		
		private function onData(e:Event):void 
		{
			addChild(container);
			container.setThumbnails();
			container.addEventListener(Tevent.CLICK, onContainer);
		}
		
		private function onContainer(e:Event):void 
		{
			trace("over");
		}
	}

}