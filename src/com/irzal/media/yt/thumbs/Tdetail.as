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
	
	/**
	 * ...
	 * @author dedet
	 */
	internal class Tdetail extends Sprite 
	{
		private var tField:TextField;
		private var tFormat:TextFormat
		
		public function Tdetail()
		{
			formatText();
		}
		private function formatText():void
		{
			tFormat 					= new TextFormat();
			tFormat.color 				= 0xFFFFFF;
			tFormat.font				= "Verdana";
			tFormat.size 				= 10;
			
			tField 						= new TextField();
			tField.selectable 			= false;
			tField.multiline 			= true;
			tField.mouseWheelEnabled 	= true;
			tField.defaultTextFormat(tFormat);
			
			addChild(tField);
		}
		
		
	}

}