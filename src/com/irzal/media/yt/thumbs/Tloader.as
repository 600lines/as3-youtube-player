package com.irzal.media.yt.thumbs 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
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
		
		/**
		 * 
		 */
		public function Tloader() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---
			this.buttonMode 	= true;
			this.mouseChildren 	= false;
			
			createBg();
			createProgresBar();
			//loadThumbs("http://i.ytimg.com/vi/U0hJwl-PDL8/default.jpg", "1234");
		}
		
		private function createBg():void
		{
			bg = new Sprite();
			addChild(bg);
			bg.graphics.beginFill(0x000000);
			bg.graphics.lineStyle(1, 0x888888);
			bg.graphics.drawRect(0, 0, 119, 89);
			bg.graphics.endFill();
			bg.y = 10;
		}
		
		/**
		 * Load image for thumbnail
		 * @param	url URL for thumbnail image
		 * @param	id Video ID 
		 */
		public function loadThumbs(url:String, id:String):void
		{
			this.name 	= id;
			loader 		= new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
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
			addChild(loader);
			addEventListener(MouseEvent.CLICK, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			destroy();
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
		 * Return Tloader id
		 */
		public function get thumbId():String
		{
			return this.name;
		}
	}

}