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
			//pLoader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			pLoader.load(new URLRequest("http://www.youtube.com/v/VIDEO_ID?version=3"));
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
			try 
			{
				player.destroy();
			}
			catch (err:Error)
			{
				trace(err.errorID,err.message);
			}
			player.loadVideoById("U0hJwl-PDL8", 0, "default");
		}
		
		private function loadProgress(e:ProgressEvent):void 
		{
			
		}
		
	}

}