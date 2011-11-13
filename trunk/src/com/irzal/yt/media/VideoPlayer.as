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
package com.irzal.yt.media 
{
	import com.irzal.yt.events.Tevent;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.filters.BlurFilter;
	/**
	 * ...
	 * @author dedet
	 */
	public class VideoPlayer extends Sprite
	{
		private var player:Object;
		private var pLoader:Loader;
		private var chromeless:Boolean;
		
		private var blur:BlurFilter = new BlurFilter(15,15,2);
		
		/**
		 * 
		 */
		public function VideoPlayer() 
		{
			Security.allowDomain("*");
			//this.mouseChildren = false;
			//this.filters = [blur];
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
			
			//for chromless player
			//pLoader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			//default youtube play bar
			pLoader.load(new URLRequest("http://www.youtube.com/v/6dM9rDTGs8c?version=3"));
		}
		
		private function loadComplete(e:Event):void 
		{
			pLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			pLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			//---
			addChild(pLoader);
			pLoader.content.addEventListener("onReady", onPlayerReady);
			pLoader.content.addEventListener("onStateChange", onPlayerState);
		}
		
		private function onPlayerState(e:Event):void 
		{
			//Object(e).data onStateChange
			//values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5)
			switch(Object(e).data)
			{
				case -1:
					//unstarted
				break;
				case 0:
					//ended
					dispatchEvent(new Tevent(Tevent.ENDED, Object(e).data));
				break;
				case 1:
					//playing
				break;
				case 2:
					//paused
					dispatchEvent(new Tevent(Tevent.PAUSE));
				break;
				case 3:
					//buffering
				break;
				case 4:
					//cued
				break;
			}
			
		}
		
		private function onPlayerReady(e:Event):void 
		{
			//stage.addEventListener(MouseEvent.CLICK, stageClick);
			player = pLoader.content;
			player.destroy();
			dispatchEvent(new Tevent(Tevent.READY));
		}
		
		/**
		 * 
		 * @param	id
		 */
		public function playVideo(id:String):void 
		{
			try 
			{
				player.destroy();
			}
			catch (err:Error)
			{
				trace(err.errorID,err.message);
			}
			player.loadVideoById(id, 0, "default");
			trace(id);
		}
		
		private function loadProgress(e:ProgressEvent):void 
		{
			
		}
		
		/**
		 * 
		 */
		public function disable():void
		{
			this.mouseChildren = false;
			this.filters = [blur];
		}
		
		/**
		 * 
		 */
		public function enable():void
		{
			this.mouseChildren = true;
			this.filters = null;
		}
		
		/**
		 * 
		 */
		public function resumeVideo():void
		{
			player.playVideo();
		}
	}

}