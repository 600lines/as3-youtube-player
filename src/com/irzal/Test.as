package com.irzal 
{
	import com.irzal.data.yt.Data;
	import com.irzal.media.yt.thumbs.Tloader;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author dedet
	 */
	public class Test extends Sprite 
	{
		private var data:Data;
		//private var thumb:Tloader;
		private var tArray:Array = [];
		public function Test() 
		{
			data = Data.getInstance();
			data.loadSetup();
			data.addEventListener(Data.COMPLETE, onData);
		}
		
		private function onData(e:Event):void 
		{
			var dataLength:int = data.getDataLength();
			var i:int;
			trace(dataLength);
			while (i < dataLength) 
			{
				var id:String = data.getData(i, Data.VIDEO_ID);
				var url:String = data.getData(i, Data.MEDIA_THUMBNAIL);
				tArray[i] = new Tloader();
				tArray[i].loadThumbs(id, url);
				tArray[i].duration = data.getData(i, Data.VIDEO_DURATION);
				if (i > 0)
				{
					tArray[i].x = tArray[i - 1].x + tArray[i - 1].width +5;
				}
				addChild(tArray[i]);
				i += 1;
			}
			
		}
	}

}