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
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.AntiAliasType;
	
	/**
	 * ...
	 * @author dedet
	 */
	internal class Tdetail extends Sprite 
	{
		private static var instance:Tdetail;
		private var tField:TextField;
		private var tFormat:TextFormat
		
		public function Tdetail()
		{
			formatText();
		}
		public function formatText():void
		{
			tFormat 					= new TextFormat();
			tFormat.color 				= 0xFFFFFF;
			tFormat.font				= "MS Sans Serif";
			tFormat.size 				= 5;
			
			tField 						= new TextField();
			tField.background			= true;
			tField.backgroundColor		= 0x666666;
			tField.multiline 			= true;
			tField.mouseWheelEnabled 	= true;
			tField.width				= 370;
			tField.height				= 100;
			tField.wordWrap				= true;
			tField.defaultTextFormat	= tFormat;
			
			addChild(tField);
		}
		
		public function description(title:String,longDescription:String):void
		{
			//tField.setTextFormat(tFormat);
			tField.htmlText = "<b>" + title + "</b>\n";
			tField.htmlText += longDescription;
		}
		
		public function getTextHeight():int
		{
			return tField.textHeight;
		}
	}
}