package com.irzal.media.yt 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author dedet
	 */
	public class VideoPlayer extends Sprite
	{
		private var player:Object;
		private var pLoader:Loader;
		public function VideoPlayer() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---
		}
		
	}

}