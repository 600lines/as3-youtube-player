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
	import com.irzal.yt.data.DataType;
	
	/**
	 * Create a container for thumbnail, video bar, and detail
	 * @author dedet
	 */
	public class Tcontainer extends Sprite 
	{
		private var _data:Data;
		private var container:Sprite;
		private var tArray:Array = [];
		private var detail:Tdetail;
		private var scrollBar:TdetailBar;
		private var vidBar:TvideoBar;
		private var thumbMask:Sprite;
		
		private var firstLoad:int;
		
		private var scrollUpper:Number;
		private var scrollLower:Number;
		
		private var objectUpper:Number;
		private var objectLower:Number;
		private var objectRange:Number;
		private var scrollLowerVid:Number;
		private var scrollUpperVid:Number;
		
		private var glow:GlowFilter = new GlowFilter(0xFF0000, 1, 20, 20, 1, 1);
		
		public function Tcontainer() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * instansiate
		 * @param	e
		 */
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
		 * Create thumbnail
		 */
		public function setThumbnails():void
		{
			var dataLength:int;
			var i:int;
			var j:int = _data.startIndex - 1;
			//remmove from stage last child in
			if (container.numChildren > 1)
			{
				container.removeChildAt(container.numChildren - 1);
			}
			
			//check for nextpage
			if (_data.nextPage)
			{
				dataLength = _data.maxFeedResult + 1;
			} else dataLength = _data.entryLength();
			
			while (i < dataLength) 
			{
				tArray[j] = new Tloader();
				switch(_data.nextPage && i==(dataLength-1))
				{
					case true:
						tArray[j].loadThumbs("more");
						tArray[j].duration("more");
					break;
					default:
						var id:String 	= _data.getData(j, DataType.VIDEO_ID);
						var url:String 	= _data.getData(j, DataType.MEDIA_THUMBNAIL);
						
						tArray[j].loadThumbs(id, url);
						tArray[j].duration(_data.getData(j, DataType.VIDEO_DURATION));
					
				}
				
				if (j > 0)
				{
					tArray[j].x = tArray[j - 1].x + tArray[j - 1].width +8;
				}
				container.addEventListener(MouseEvent.CLICK, onMouseEvent);
				container.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				container.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				//container.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
				container.addChild(tArray[j]);
				j += 1;
				i += 1;
			}
			if (firstLoad == 0)
			{
				firstLoad = 1;
				createDetailAndBars(true);
			}
			checkObjectDragHeight();
		}
		
		/**
		 * Create detail dan bar
		 * @param	$firstLoad check for first load
		 */
		private function createDetailAndBars($firstLoad:Boolean):void
		{
			if ($firstLoad)
			{
				vidBar.y = container.y + container.height + 15;
				vidBar.x = 100;
				addChild(vidBar);
				
				//chek vidBar visible
				if (!vidBar.visible)
				{
					detail.y 	= container.y + container.height + 10;
				} else
				{
					detail.y 	= vidBar.y + vidBar.height + 5;
				}
				detail.addEventListener(Tevent.WHEEL, onTevent);
				addChild(detail);
				
				scrollBar.x = detail.x + detail.width - scrollBar.width + 2;
				scrollBar.y = detail.y;
				addChild(scrollBar);
				
				scrollBar.visible = false;
				scrollBar.addEventListener(Tevent.MOVE, onTevent);
				
				vidBar.addEventListener(Tevent.MOVE, onVidTevent);
				
				createMask(this);
				createBg();
			}
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
			
			switch(e.type)
			{
				case MouseEvent.CLICK:
					if (child.name == "more")
					{
						dispatchEvent(new Tevent(Tevent.CLICK, _data.nextPage));
					}
					else {
						var vidId:String = _data.getData(parent.getChildIndex(child), DataType.VIDEO_ID);
						dispatchEvent(new Tevent(Tevent.CLICK, vidId));
					}
				break;
				case MouseEvent.MOUSE_OVER:
					//dispatchEvent(new Event(Tevent.OVER));
					if (child.name == "more")
					{
						detail.description("Load More playlist");
					}
					else {
						var title:String 		= _data.getData(parent.getChildIndex(child) , DataType.MEDIA_TITLE);
						var description:String 	= _data.getData(parent.getChildIndex(child), DataType.MEDIA_DESCRIPTION);
						detail.description(title, description);
						
					}
					checkTextFieldHeight();
					child.filters = [glow];
					
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
		
		/**
		 * Detail scrool button
		 */
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
		
		/**
		 * TextField scroll
		 */
		private function textFieldScroll():void
		{
			var moveDrag:Number 	= scrollBar.barY - scrollUpper;
			var procentDrag:Number 	= moveDrag / scrollLower;
			detail.scrollText		= procentDrag * detail.textMaxScroll;			
		}
		
		/**
		 * check container width
		 */
		private function checkObjectDragHeight():void
		{
			var percObjectHeight:Number = vidBar.width / container.width;
			var percSliderHeight:Number = vidBar.width / vidBar.barWidthReset;
			
			if(percObjectHeight>=1)
			{ 
				vidBar.visible=false;
			} else
			{
				vidBar.visible=true;
				vidBar.barScaleX = percObjectHeight * percSliderHeight;
			}
			scrollUpperVid = 0;
			scrollLowerVid = vidBar.width - vidBar.barWidthScaled;
			
			objectUpper = 0;
			objectLower = 0 + (380 - (container.width));
			objectRange = objectUpper - objectLower;
			
			var objectDrag:Number = objectUpper - container.x;
			var procentObj:Number = objectDrag / objectRange;
			vidBar.barX = vidBar.width*procentObj;
			
		}
		
		/**
		 * check container x position
		 */
		private function objectY():void
		{
			var moveDrag:Number 	= vidBar.barX - scrollUpperVid;
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
			graphics.beginFill(0x666666, 0.8);
			graphics.drawRect(0, 0, 380, 230);
			graphics.endFill();
		}
	}

}