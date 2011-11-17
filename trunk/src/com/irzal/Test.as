package com.irzal 
{
	import com.irzal.yt.data.Data;
	import com.irzal.yt.media.thumbs.Tcontainer;
	import com.irzal.yt.media.thumbs.Tloader;
	import com.irzal.yt.media.VideoPlayer;
	import com.irzal.yt.events.DataEvents;
	import com.irzal.yt.events.VideoEvents
	import com.irzal.yt.data.DataType;
	import com.irzal.yt.events.Tevent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * ...
	 * @author dedet
	 */
	public class Test extends Sprite 
	{
		private var data:Data;
		private var vidPlayer:VideoPlayer;
		private var container:Tcontainer;
		private var blur:BlurFilter = new BlurFilter(5, 5, 1);
		private var currentPlay:String;
		
		public function Test() 
		{
			data = Data.getInstance();
			data.loadSetup();
			data.addEventListener(DataEvents.DATA_COMPLETE, onData);
			
			container = new Tcontainer();
			container.addEventListener(Tevent.CLICK , onContainerClick);
			//container.mouseEnabled = false;
			
			vidPlayer = new VideoPlayer();
			vidPlayer.addEventListener(VideoEvents.READY, onVideoEvent);
			vidPlayer.addEventListener(VideoEvents.ENDED, onVideoEvent);
			vidPlayer.addEventListener(VideoEvents.PAUSE, onVideoEvent);
			//addChild(vidPlayer);			
		}
		
		private function onContainerClick(e:Tevent):void 
		{
			switch(e.data)
			{
				case true:
					trace(e.data);
					data.youtubeUser();
					data.addEventListener(DataEvents.DATA_COMPLETE, onData);
				break;
			default:
				if (currentPlay == e.data) vidPlayer.resumeVideo()
				else 
				{
					vidPlayer.playVideo(e.data);
					currentPlay = e.data;
				}
				container.visible = false;
				vidPlayer.enable();
			}
			
		}
		
		private function onVideoEvent(e:Event):void 
		{
			switch (e.type) 
			{
				case VideoEvents.READY:
					//trace("player ready");
					vidPlayer.disable();
				break;
				case VideoEvents.ENDED:
					//trace("ended");
					vidPlayer.disable();
					container.visible = true;
				break;
				case VideoEvents.PAUSE:
					vidPlayer.disable();
					container.visible = true;
				break;
				default:
			}
			
		}
		
		private function onData(e:Event):void 
		{
			data.removeEventListener(DataEvents.DATA_COMPLETE, onData);
			//---
			if(!container.stage)
			{
				addChild(container);
				container.y = 80;
				container.x = 150;
			}
			container.setThumbnails();
			//container.addEventListener(Tevent.CLICK, onContainer);
			
			if (!vidPlayer.stage)
			{
				vidPlayer.videoFirsID = data.getData(0, DataType.VIDEO_ID);
				addChildAt(vidPlayer, 0);
			}
		}
	}

}