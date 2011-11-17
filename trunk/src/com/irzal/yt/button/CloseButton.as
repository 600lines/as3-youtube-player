package com.irzal.yt.button 
{
	import com.irzal.yt.events.Tevent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
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