package com.irzal.media.yt 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	/**
	 * ...
	 * @author dedet
	 */
	public class VideoPlayer extends Sprite
	{
		private var player:Object;
		private var pLoader:Loader;
		private var chromeless:Boolean;
		
		public function VideoPlayer() 
		{
			Security.allowDomain("*");
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---
			
			pLoader = new Loader();
			pLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			pLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			switch
			pLoader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}
		
		private function loadComplete(e:Event):void 
		{
			pLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			pLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			//---
			addChild(pLoader);
			pLoader.content.addEventListener("onReady", onPlayerReady);
		}
		
		private function onPlayerReady(e:Event):void 
		{
			trace("player ready");
			stage.addEventListener(MouseEvent.CLICK, stageClick);
			player = pLoader.content;
		}
		
		private function stageClick(e:MouseEvent):void 
		{
			player.destroy();
			player.loadVideoById("U0hJwl-PDL8", 0, "default");
		}
		
		private function loadProgress(e:ProgressEvent):void 
		{
			
		}
		
	}

}