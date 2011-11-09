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
package com.irzal.media.yt.thumbs 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author dedet
	 */
	internal class Tloader extends Sprite
	{
		public static const CLICK:String 		= "thumbClick";
		public static const OVER:String 		= "thumbOver";
		public static const OUT:String 			= "thumbOut";
		public static const DOUBLE_CLICK:String = "thumbDoubleClick";
		
		private var bg:Sprite;
		private var progBar:Sprite;
		
		private var loader:Loader;
		
		private var durText:TextField;
		private var durFormat:TextFormat;
		
		private var _duration:String;
		/**
		 * 
		 */
		public function Tloader() 
		{
			this.buttonMode 	= true;
			this.mouseChildren 	= false;
		}
		
		private function createBg():void
		{
			bg = new Sprite();
			addChild(bg);
			bg.graphics.beginFill(0x000000);
			bg.graphics.lineStyle(1, 0x888888);
			bg.graphics.drawRect(0, 0, 119, 89);
			bg.graphics.endFill();
		}
		
		/**
		 * Load image for thumbnail
		 * @param	url URL for thumbnail image
		 * @param	id Video ID 
		 */
		public function loadThumbs(id:String, url:String):void
		{
			this.name 	= id;
			loader 		= new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			createBg();
			createProgresBar();
		}
		
		private function onLoadProgress(e:ProgressEvent):void 
		{
			var loaded:Number = e.bytesLoaded / e.bytesTotal
			progBar.scaleX = loaded;
		}
		
		private function onLoadComplete(e:Event):void 
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			//---
			addChildAt(loader,0);
			destroy();
			addEventListener(MouseEvent.CLICK, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);			
		}
		
		public function set duration(dur:String):void
		{
			var _dur:int = Number(dur);
			var strMinute:String;
			var strSecond:String;
			var mnt:Number = Math.floor(_dur / 60);
			var scd:Number = Math.floor(_dur % 60);
			(mnt < 10)? strMinute = "0" + mnt.toString():strMinute = mnt.toString();
			(scd < 10)? strSecond = "0" + scd.toString():strSecond = scd.toString();
			_duration = strMinute + ":" + strSecond;
			durationText();
		}
		
		private function durationText():void
		{
			durFormat = new TextFormat();
			durFormat.font = "Verdana";
			durFormat.size = 10;
			durFormat.color = 0xFFFFFF;
			
			durText = new TextField();
			durText.selectable = false;
			durText.autoSize = "left";
			durText.background = true;
			durText.backgroundColor = 0x666666;
			durText.defaultTextFormat = durFormat;
			durText.text = _duration;
			addChild(durText);
		}
		
		private function onMouseEvent(e:MouseEvent):void 
		{
			switch(e.type)
			{
				case MouseEvent.CLICK:
					dispatchEvent(new Event(Tloader.CLICK));
				break;
				case MouseEvent.MOUSE_OVER:
					dispatchEvent(new Event(Tloader.OVER));
				break;
				case MouseEvent.MOUSE_OUT:
					dispatchEvent(new Event(Tloader.OUT));
				break;
				case MouseEvent.DOUBLE_CLICK:
					dispatchEvent(new Event(Tloader.DOUBLE_CLICK));
				break;
			}
		}
		
		private function createProgresBar():void
		{
			progBar = new Sprite();
			addChild(progBar);
			progBar.graphics.beginFill(0x888888);
			progBar.graphics.drawRect(0, 0, 60, 3);
			progBar.graphics.endFill();
			progBar.x = (this.width / 2) - 30;
			progBar.y = (this.height / 2) - 3;
		}
		
		private function destroy():void
		{
			removeChild(progBar);
			removeChild(bg)
			progBar = null;
			bg = null;
		}
		/**
		 * Return YouTube video ID
		 */
		public function get thumbId():String
		{
			return this.name;
		}
	}

}