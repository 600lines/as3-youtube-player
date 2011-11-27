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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.irzal.yt.events.Tevent;
	
	/**
	 * ...
	 * @author dedet
	 */
	internal class TdetailBar extends Sprite
	{
		private var bar:Sprite;
		
		/**
		 * 
		 */
		public function TdetailBar() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---
			bg();
			createBar();
			bar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEventBar);
		}
		
		private function bg():void 
		{
			graphics.beginFill(0x888888, 1);
			graphics.drawRect(0, 0, 7, 100);
			graphics.endFill();
		}
		
		private function onMouseEventBar(e:MouseEvent):void 
		{
			//var child:Object 	= e.target;
			//var parent:Object 	= e.currentTarget;
			var rect:Rectangle = new Rectangle(0, 0, 0, (this.height - Math.round(bar.height)));
			
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEventBar);
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseEventBar);
				break;
				case MouseEvent.MOUSE_MOVE:
					bar.startDrag(false, rect);
					dispatchEvent(new Event(Tevent.MOVE));
					e.updateAfterEvent();
				break;
				case MouseEvent.MOUSE_UP:
					bar.stopDrag()
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventBar);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEventBar);
				break;
			}
		}
		
		private function createBar():void 
		{
			bar = new Sprite();
			bar.buttonMode = true;
			bar.graphics.beginFill(0xFFFFFF, 1);
			bar.graphics.drawRect( 0, 0, 7, 7);
			bar.graphics.endFill();
			addChild(bar);
		}
		
		/**
		 * Return original bar height
		 */
		public function get barHeightReset():Number
		{
			bar.height = 7;
			return bar.height;
		}
		
		/**
		 * Return bar height scaled
		 */
		public function get barHeightScaled():Number
		{
			return bar.height;
		}
		
		/**
		 * Set bar scaleY
		 */
		public function  set barScaleY(scale:Number):void
		{
			bar.scaleY = scale;
		}
		
		/**
		 * Get bar y position
		 */
		public function get barY():Number
		{
			return bar.y;
		}
		
		/**
		 * Set bar y position
		 */
		public function set barY(y:Number):void
		{
			bar.y = y;
		}
	}
}