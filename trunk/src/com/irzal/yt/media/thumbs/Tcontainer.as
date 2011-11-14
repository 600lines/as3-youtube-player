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
package com.irzal.yt.media.thumbs 
{
	import com.irzal.yt.data.Data;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import com.irzal.yt.events.Tevent;
	
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
		private var vidBar:TvideoBar;
		private var thumbMask:Sprite;
		
		private var scrollUpper:Number;
		private var scrollLower:Number;
		
		private var objectUpper:Number;
		private var objectLower:Number;
		private var objectRange:Number;
		private var scrollLowerVid:Number;
		private var scrollUpperVid:Number;
		
		private var glow:GlowFilter = new GlowFilter(0xFF0000, 1, 20, 20, 1, 1);
		
		private var vidIndex:int;
		
		/**
		 * 
		 */
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
			vidBar 		= new TvideoBar();
		}
		
		/**
		 * 
		 */
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
					tArray[i].x = tArray[i - 1].x + tArray[i - 1].width +8;
				}
				container.addEventListener(MouseEvent.CLICK, onMouseEvent);
				container.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				container.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				//container.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
				container.addChild(tArray[i]);
				i += 1;
			}
			
			vidBar.y = container.y + container.height + 15;
			vidBar.x = 100;
			addChild(vidBar);
			checkObjectDragHeight();
			vidBar.rotation = -90;
			
			//chek vidBar visible
			if (vidBar.visible == false)
			{
				detail.y 	= container.y + container.height + 10;
			} else
			{
				detail.y 	= vidBar.y + vidBar.height + 5;
			}
			detail.addEventListener(Tevent.WHEEL, onTevent);
			addChild(detail);
			
			scrollBar.x = detail.x + detail.width - scrollBar.width;
			scrollBar.y = detail.y;
			addChild(scrollBar);
			
			scrollBar.visible = false;
			scrollBar.addEventListener(Tevent.MOVE, onTevent);
			
			vidBar.addEventListener(Tevent.MOVE, onVidTevent);
			
			//createMask(detail);
			createMask(this);
			createBg();
		}
		
		private function onVidTevent(e:Event):void 
		{
			objectY();
		}
		
		private function onTevent(e:Event):void 
		{
			switch(e.type)
			{
				case Tevent.MOVE:
					textFieldScroll();
				break;
				case Tevent.WHEEL:
					scrollButton();
				break;
			}
			
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
					var vidId:String = _data.getData(parent.getChildIndex(child), Data.VIDEO_ID);
					dispatchEvent(new Tevent(Tevent.CLICK, vidId));
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
		
		private function scrollButton():void
		{
			scrollBar.barY = scrollUpper + (((detail.scrollText+7) * scrollLower) / detail.textMaxScroll);
			if ((detail.scrollText + 7) == detail.textMaxScroll)
			{
				scrollBar.barY = scrollLower;// + scrollBar.barHeightScaled;
			} else if (detail.scrollText == 1)
			{
				scrollBar.barY = scrollUpper;
			}
		}
		
		private function textFieldScroll():void
		{
			var moveDrag:Number 	= scrollBar.barY - scrollUpper;
			var procentDrag:Number 	= moveDrag / scrollLower;
			detail.scrollText		= procentDrag * detail.textMaxScroll;
		}
		
		private function checkObjectDragHeight():void
		{
			var percObjectHeight:Number = vidBar.height/container.width;
			var percSliderHeight:Number = vidBar.height / vidBar.barHeightReset;
			
			if(percObjectHeight>=1)
			{ 
				vidBar.visible=false;
			} else
			{
				vidBar.visible=true;
				vidBar.barScaleY = percObjectHeight * percSliderHeight;
			}
			scrollUpperVid = 0;
			scrollLowerVid = vidBar.height - vidBar.barHeightScaled;
			
			vidBar.barY = scrollUpperVid;
			
			objectUpper = container.x;
			objectLower = container.x + (373 - (container.width));
			objectRange = objectUpper - objectLower;
		}
		
		private function objectY():void
		{
			var moveDrag:Number 	= vidBar.barY - scrollUpperVid;
			var procentDrag:Number 	= moveDrag / scrollLowerVid;
			var objectMove:Number 	= procentDrag * objectRange;
			
			container.x = objectUpper - objectMove;
		}
		
		private function createMask(sprite:Sprite):void
		{
			thumbMask = new Sprite();
			thumbMask.graphics.beginFill(0xFFFFFF);
			thumbMask.graphics.drawRect(this.x, this.y, 380, 230);
			thumbMask.graphics.endFill();
			
			sprite.mask = thumbMask;
		}
		
		private function createBg():void
		{
			graphics.beginFill(0x666666, 0.5);
			graphics.drawRect(0, 0, 380, 230);
			graphics.endFill();
		}
	}

}