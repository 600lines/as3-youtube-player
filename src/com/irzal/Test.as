package com.irzal 
{
	import com.irzal.data.yt.Data;
	import com.irzal.media.yt.thumbs.Tcontainer;
	import com.irzal.media.yt.thumbs.Tloader;
	import com.irzal.media.yt.VideoPlayer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
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
		private var vidPlayer:VideoPlayer;
		private var container:Tcontainer;
		private var blur:BlurFilter = new BlurFilter(10,10,1);
		
		public function Test() 
		{
			data = Data.getInstance();
			data.loadSetup();
			//data.addEventListener(Data.COMPLETE, onData);
			//container = new Tcontainer();
			//container.mouseEnabled = false;
			vidPlayer = new VideoPlayer();
			vidPlayer.addEventListener("playerReady", vidReady);
			addChild(vidPlayer);
			
		}
		
		private function vidReady(e:Event):void 
		{
			trace("player ready");
			vidPlayer.disable();
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