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
package  
{
	import com.irzal.yt.button.CloseButton;
	import com.irzal.yt.button.PlayListButton;
	import com.irzal.yt.data.Data;
	import com.irzal.yt.media.thumbs.Tcontainer;
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
	 * AS3 YouTube PLayer
	 * @author dedet
	 */
	public class AS3YouTubePlayer extends Sprite 
	{
		private var data:Data;
		private var vidPlayer:VideoPlayer;
		private var container:Tcontainer;
		private var currentPlay:String;
		private var listButton:PlayListButton;
		private var closeButton:CloseButton;
		public function AS3YouTubePlayer() 
		{
			init();
		}
		
		private function init():void
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
			
			listButton = new PlayListButton();
			addChild(listButton);
			listButton.x = stage.stageWidth - listButton.width;
			listButton.y = 70;
			listButton.addEventListener(Tevent.CLICK, onListButtonClick);
			
			closeButton = new CloseButton();
			closeButton.addEventListener(Tevent.CLICK, onCloseButtonClick);
		}
		
		private function onCloseButtonClick(e:Tevent):void 
		{
			closeButton.visible = false;
			container.visible = false;
			vidPlayer.enable();
		}
		
		private function onListButtonClick(e:Tevent):void 
		{
			container.visible = true;
			closeButton.visible = true;
		}
		
		private function onContainerClick(e:Tevent):void 
		{
			switch(e.data)
			{
				case true:
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
				closeButton.visible = false;
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
					closeButton.visible = true;
				break;
				case VideoEvents.PAUSE:
					/*vidPlayer.disable();
					container.visible = true;*/
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
			addChild(closeButton);
			closeButton.y = container.y;
			closeButton.x = container.x + 380;
		}
	}

}