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
	import com.irzal.yt.events.Tevent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author dedet
	 */
	internal class Tdetail extends Sprite 
	{
		public var tField:TextField;
		private var tFormat:TextFormat
		
		/**
		 * Constractor
		 */
		public function Tdetail()
		{
			formatText();
		}
		
		private function formatText():void
		{
			tFormat 					= new TextFormat();
			tFormat.color 				= 0xFFFFFF;
			tFormat.font				= "MS Sans Serif";
			tFormat.size 				= 5;
			
			tField 						= new TextField();
			//tField.background			= true;
			//tField.backgroundColor		= 0x666666;
			tField.multiline 			= true;
			tField.mouseWheelEnabled 	= true;
			tField.width				= 370;
			tField.height				= 100;
			tField.wordWrap				= true;
			tField.defaultTextFormat	= tFormat;
			
			addChild(tField);
			
			tField.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);
			//explenation text
			tField.htmlText = "Mouse over the thumbnail to get title dan description about the video.";
			tField.htmlText += "\nClick the thumbnail to play video"
		}
		
		private function onMouseEvent(e:MouseEvent):void 
		{
			dispatchEvent(new Tevent(Tevent.WHEEL));
		}
		
		/**
		 * 
		 * @param	title
		 * @param	longDescription
		 */
		public function description(title:String,longDescription:String):void
		{
			//tField.setTextFormat(tFormat);
			tField.htmlText = "<b>" + title + "</b>\n\r";
			tField.htmlText += longDescription.split("\r").join("");
		}
		
		/**
		 * Get text height
		 * @return tField.textHeight
		 */
		public function getTextHeight():Number
		{
			return tField.textHeight;
		}
		
		/**
		 * Set TextField.scrollV
		 */
		public function set scrollText(v:Number):void
		{
			tField.scrollV = v;
		}
		
		/**
		 * 
		 */
		public function get scrollText():Number
		{
			return tField.scrollV;
		}
		
		/**
		 * Return TextField.maxScroll
		 */
		public function get textMaxScroll():int
		{
			return tField.maxScrollV+7;
		}
	}
}