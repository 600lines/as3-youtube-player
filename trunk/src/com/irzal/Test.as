package com.irzal 
{
	import com.irzal.data.yt.Data;
	import com.irzal.media.yt.thumbs.Tcontainer;
	import com.irzal.media.yt.thumbs.Tloader;
	import com.irzal.media.yt.VideoPlayer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.filters.BlurFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import com.irzal.media.yt.thumbs.Tevent;
	import flash.display.StageScaleMode;
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
			data.addEventListener(Data.COMPLETE, onData);
			container = new Tcontainer();
			container.addEventListener(Tevent.CLICK , onContainerClick);
			//container.mouseEnabled = false;
			vidPlayer = new VideoPlayer();
			vidPlayer.addEventListener("playerReady", vidReady);
			addChild(vidPlayer);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
		}
		
		private function onContainerClick(e:Event):void 
		{
			vidPlayer.playVideo(container.vidId);
			container.visible = false;
			vidPlayer.enable();
		}
		
		private function vidReady(e:Event):void 
		{
			trace("player ready");
			vidPlayer.disable();
		}
		
		private function onData(e:Event):void 
		{
			addChild(container);
			container.y = 10;
			//container.x = 5;
			container.setThumbnails();
			container.addEventListener(Tevent.CLICK, onContainer);
		}
		
		private function onContainer(e:Event):void 
		{
			trace("over");
		}
	}

}