package com.irzal 
{
	import flash.display.Sprite;
	import com.irzal.data.yt.Data;
	import com.irzal.media.yt.thumbs.Tloader;
	import flash.events.Event;
	/**
	 * ...
	 * @author dedet
	 */
	public class Main extends Sprite 
	{
		private var data:Data;
		private var thumbs:Array;
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---
			thumbs = [];
			data = Data.getInstance();
			
			//data1.youtubeUser("yayasankehati");
			data.loadSetup();
			data.addEventListener(Data.COMPLETE, dataLoaded);
			
		}
		
		private function dataLoaded(e:Event):void 
		{
			var i:int;
			var thumbsLength:int = data.getDataLength();
			
			
		}
		
	}

}