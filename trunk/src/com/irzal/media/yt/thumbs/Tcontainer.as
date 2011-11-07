package com.irzal.media.yt.thumbs 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author dedet
	 */
	public class Tcontainer extends Sprite 
	{
		//private var title:TextField;
		//private var detail:TextField;
		//private var tFormat:TextFormat;
		
		private var container:Sprite;
		
		public function Tcontainer() 
		{
			if (stage) init;
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---
			addChild(container);
			container.y = (stage.stageHeight / 2) + 45;
			container.x = (stage.stageWidth / 2) + 60;
			
			//tFormat = new TextFormat();
			//tFormat.font = "Verdana";			
		}
		
		public function setThumbnails(arr:Array):void
		{
			var i:int;
			
			while (i < arr.length)
			{
				
			}
		}
		
	}

}