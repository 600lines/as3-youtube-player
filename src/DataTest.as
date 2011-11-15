package  
{
	import com.irzal.yt.data.Data;
	import flash.display.Sprite;
	import flash.events.Event;
	
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
			data.addEventListener(Data.COMPLETE, onDataComplete);
		}
		
		private function onDataComplete(e:Event):void 
		{
			trace("load complete");
			trace(data.getCurrentPage);
			trace(data.getPageLength);
			trace(data.getUserId);
		}
		
	}

}