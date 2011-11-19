package com.irzal.yt.button 
{
	import com.irzal.yt.events.Tevent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * Create playlist button
	 * @author dedet
	 */
	public class PlayListButton extends Sprite
	{
		[Embed(source = "../../../../../lib/playlistButton.png")]
		private var Pbutton:Class;
		
		private var bitmap:Bitmap;// = new Pbutton();
		private var butt:Sprite;
		
		public function PlayListButton() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xFF0000, 0);
			bg.graphics.drawRect(0, 0, 40, 200);
			bg.graphics.endFill();
			addChild(bg);
			
			butt = new Sprite();
			butt.buttonMode = true;
			butt.mouseChildren = false;
			butt.visible = false;
			addChild(butt);
			
			bitmap = new Pbutton();
			butt.addChild(bitmap);
			
			butt.x = this.width - butt.width;
			butt.y = this.height / 2;
			
			butt.addEventListener(MouseEvent.CLICK, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		}
		
		private function onMouseEvent(e:MouseEvent):void 
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					butt.visible = true;
				break;
				case MouseEvent.MOUSE_OUT:
					butt.visible = false;
				break;
				case MouseEvent.CLICK:
					dispatchEvent(new Tevent(Tevent.CLICK));
				break;
			}
		}
		
	}

}