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
	import flash.filters.GlowFilter;
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
		private var container:Sprite;
		private var _data:Data;
		private var tArray:Array = [];
		private var detail:Tdetail;
		private var scrollBar:TdetailBar;
		private var vidBar:TdetailBar;
		
		private var scrollUpper:Number;
		private var scrollLower:Number;
		
		private var vidScrollUpper:int;
		private var vidScrollLower:int;
		private var vidObjectUpper:int;
		private var vidObjectLower:int;
		private var vidObjectRange:int;
		
		private var glow:GlowFilter = new GlowFilter(0xFF0000, 1, 20, 20, 1, 1);
		
		public function Tcontainer() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---
			_data 		= Data.getInstance();
			container 	= new Sprite();
			addChild(container);
			
			detail 		= new Tdetail();
			scrollBar 	= new TdetailBar();
			vidBar 		= new TdetailBar();
		}
		
		public function setThumbnails():void
		{
			var dataLength:int = _data.getDataLength();
			var i:int;
			
			while (i < dataLength) 
			{
				var id:String 	= _data.getData(i, Data.VIDEO_ID);
				var url:String 	= _data.getData(i, Data.MEDIA_THUMBNAIL);
				
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
				//container.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
				container.addChild(tArray[i]);
				i += 1;
			}
			
			vidBar.y = container.y + container.height + 15;
			vidBar.rotation = -90;
			vidBar.x = 150;
			//vidBar.visible = false;
			
			if (vidBar.visible == false)
			{
				detail.y 	= container.y + container.height + 10;
			} else
			{
				detail.y 	= vidBar.y + vidBar.height + 5;
			}
			
			scrollBar.x = detail.x + detail.width - scrollBar.width;
			scrollBar.y = detail.y;
			
			addChild(vidBar);
			addChild(detail);
			addChild(scrollBar);
			
			scrollBar.visible = false;
			scrollBar.addEventListener(Tevent.MOVE, onTevent);
		}
		
		private function onTevent(e:Event):void 
		{
			textFieldScroll();
		}
		
		private function onMouseEvent(e:MouseEvent):void 
		{
			var child:Object 		= e.target;
			var parent:Object 		= e.currentTarget;
			var title:String 		= _data.getData(parent.getChildIndex(child) , Data.MEDIA_TITLE);
			var description:String 	= _data.getData(parent.getChildIndex(child), Data.MEDIA_DESCRIPTION);
			
			switch(e.type)
			{
				case MouseEvent.CLICK:
					dispatchEvent(new Event(Tevent.CLICK));
				break;
				case MouseEvent.MOUSE_OVER:
					//dispatchEvent(new Event(Tevent.OVER));
					detail.description(title, description);
					child.filters = [glow];
					checkTextFieldHeight();
				break;
				case MouseEvent.MOUSE_OUT:
					//dispatchEvent(new Event(Tevent.OUT));
					child.filters = null;
				break;
				case MouseEvent.DOUBLE_CLICK:
					//dispatchEvent(new Event(Tevent.DOUBLE_CLICK));
				break;
			}
		}
		
		private function checkTextFieldHeight():void
		{
			var percObjectHeight:Number = scrollBar.height / detail.getTextHeight();
			var percSliderHeight:Number = scrollBar.height / scrollBar.barHeightReset;
			
			if(percObjectHeight>=1)
			{ 
				scrollBar.visible=false;
			} else
			{
				scrollBar.visible=true;
				scrollBar.barScaleY = percObjectHeight * percSliderHeight;
			}
			scrollUpper = 0;
			scrollLower = 100 - scrollBar.barHeightScaled;
			scrollBar.barY = scrollUpper;
		}
		
		private function textFieldScroll():void
		{
			var moveDrag:Number 	= scrollBar.barY - scrollUpper;
			var procentDrag:Number 	= moveDrag / scrollLower;
			detail.scrollText		= procentDrag * detail.textMaxScroll;
		}
		
		private function checkObjectDragHeight():void
		{
			var percObjectHeight:Number = vidBar.width/container.width;
			var percSliderHeight:Number = vidBar.height/_sliderBar._slider.height;
			
			if(percObjectHeight>=1)
			{ 
				vidBar.visible=false;
			} else
			{
				vidBar.visible=true;
				_sliderBar._slider.scaleY = percObjectHeight * percSliderHeight;
			}
			scrollUpper = _sliderBar._path.y + (_sliderBar._slider.height*0.5);
			scrollLower = _sliderBar._path.height - _sliderBar._slider.height;
			_sliderBar._slider.y = scrollUpper;
			
			objectUpper = dragObject.y;
			objectLower = dragObject.y + (_sliderBar._path.height - dragObject.height);
			objectRange = objectUpper-objectLower;
		}
	}

}