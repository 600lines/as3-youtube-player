package  
{
	import com.irzal.yt.data.Data;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.irzal.yt.events.DataEvents
	import flash.events.MouseEvent;
	import com.irzal.yt.data.DataFeeds;
	import com.irzal.yt.data.DataType;
	
	/**
	 * ...
	 * @author Dedet
	 */
	public class DataTest extends Sprite 
	{
		private var data:Data;
		public function DataTest() 
		{
			data = Data.getInstance();
			data.loadSetup();
			data.addEventListener(DataEvents.DATA_COMPLETE, onDataComplete);
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			trace("stage click");
			trace(data.nextPage);
			if (data.nextPage)
			{
				data.youtubeUser();
				data.addEventListener(DataEvents.DATA_COMPLETE, onDataComplete);
			} else trace("end of data");
			
		}
		
		private function onDataComplete(e:Event):void 
		{
			data.removeEventListener(DataEvents.DATA_COMPLETE, onDataComplete);
			//---
			var dataLength:int = data.getDataLength();
			trace(data.getCurrentPage);
			trace(data.getPageLength);
			for (var i:int; i < dataLength; i += 1)
			{
				trace(i,data.getData(i, DataType.VIDEO_ID));
			}
		}
		
	}

}