package com.irzal.media.yt.thumbs 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author dedet
	 */
	public class TdetailBar extends Sprite
	{
		private var bar:Sprite;
		
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
			guide();
			createBar();
			//bar.scaleY = 1.2;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
		}
		
		private function bg():void 
		{
			graphics.beginFill(0x666666, 1);
			graphics.drawRect(0, 0, 9, 100);
			graphics.endFill();
		}
		
		private function onMouseEvent(e:MouseEvent):void 
		{
			barScaleY = 5;
			var child:Object 	= e.target;
			var parent:Object 	= e.currentTarget;
			var rect:Rectangle = new Rectangle(7, (bar.height * 0.5), 0, 93);
			
			
			trace(bar.height);
			bar.y = 35;
			trace(bar.height);
			trace(bar.y);
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
				break;
				case MouseEvent.MOUSE_MOVE:
					//child.startDrag(false, rect);
					trace(bar.y);
					trace("lalala");
					e.updateAfterEvent();
				break;
			}
		}
		
		private function createBar():void 
		{
			bar = new Sprite();
			bar.buttonMode = true;
			bar.graphics.beginFill(0x000000, 1);
			bar.graphics.drawRect( -7, -7, 7, 7);
			bar.graphics.endFill();
			bar.y = 7;
			bar.x = 7;
			addChild(bar);
		}
		
		private function guide():void
		{
			graphics.beginFill(0x000000,1);
			graphics.drawRect(3, 0, 1, 100);
			graphics.endFill();
		}
		
		public function get barHeight():int
		{
			bar.height = 7;
			return bar.height;
		}
		
		public function  set barScaleY(scale:Number):void
		{
			bar.scaleY = scale;
		}
	}

}