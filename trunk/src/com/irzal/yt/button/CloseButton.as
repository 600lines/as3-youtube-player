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
package com.irzal.yt.button 
{
	import com.irzal.yt.events.Tevent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * Create close button
	 * @author dedet
	 */
	public class CloseButton extends Sprite
	{
		[Embed(source = "../../../../../lib/noSmall.png")]
		private var CloseButt:Class;
		
		private var bitmap:Bitmap;
		public function CloseButton() 
		{
			init();
		}
		
		private function init():void 
		{
			this.buttonMode = true;
			this.mouseChildren = false;
			
			bitmap = new CloseButt();
			addChild(bitmap);
			
			graphics.beginFill(0x666666, 0.8);
			graphics.drawRect(0, 0, this.width, this.height);
			graphics.endFill();
			
			this.addEventListener(MouseEvent.CLICK, onMouseEvent);
		}
		
		private function onMouseEvent(e:MouseEvent):void 
		{
			dispatchEvent(new Tevent(Tevent.CLICK));
		}
		
	}

}