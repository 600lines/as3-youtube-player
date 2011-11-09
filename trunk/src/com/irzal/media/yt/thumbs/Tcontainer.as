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