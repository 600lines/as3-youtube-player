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
	import com.irzal.data.yt.Data;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	
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
		private var _data:Data;
		private var tArray:Array = [];
		private var detail:Tdetail;
		
		public function Tcontainer() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---
			_data = Data.getInstance();
			container = new Sprite();
			addChild(container);
			
			detail = new Tdetail();
		}
		
		public function setThumbnails():void
		{
			var dataLength:int = _data.getDataLength();
			var i:int;
			while (i < dataLength) 
			{
				var id:String = _data.getData(i, Data.VIDEO_ID);
				var url:String = _data.getData(i, Data.MEDIA_THUMBNAIL);
				tArray[i] = new Tloader();
				tArray[i].loadThumbs(id, url);
				tArray[i].duration = _data.getData(i, Data.VIDEO_DURATION);
				if (i > 0)
				{
					tArray[i].x = tArray[i - 1].x + tArray[i - 1].width +5;
				}
				container.addEventListener(MouseEvent.CLICK, onMouseEvent);
				container.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				container.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				container.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
				container.addChild(tArray[i]);
				i += 1;
			}
			detail.y = container.y + container.height + 5;
			trace(detail.y);
			addChild(detail);
			
		}
		
		private function onMouseEvent(e:MouseEvent):void 
		{
			var child:Object = e.target;
			var parent:Object = e.currentTarget;
			switch(e.type)
			{
				case MouseEvent.CLICK:
					dispatchEvent(new Event(Tevent.CLICK));
				break;
				case MouseEvent.MOUSE_OVER:
					//dispatchEvent(new Event(Tevent.OVER));
					trace(child.thumbId);
					trace(parent.getChildIndex(child));
					DisplayObject
					detail.title = _data.getData(parent.getChildIndex(child) , Data.MEDIA_TITLE);
					detail.description = _data.getData(parent.getChildIndex(child), Data.MEDIA_DESCRIPTION);
				break;
				case MouseEvent.MOUSE_OUT:
					//dispatchEvent(new Event(Tevent.OUT));
				break;
				case MouseEvent.DOUBLE_CLICK:
					//dispatchEvent(new Event(Tevent.DOUBLE_CLICK));
				break;
			}
		}
		
	}

}