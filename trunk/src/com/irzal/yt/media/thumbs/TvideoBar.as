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
	public class TvideoBar extends Sprite
	{
		private var bar:Sprite;
		
		/**
		 * 
		 */
		public function TvideoBar() 
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
			graphics.drawRect(0, 0, 200, 10);
			graphics.endFill();
		}
		
		private function onMouseEventBar(e:MouseEvent):void 
		{
			var rect:Rectangle = new Rectangle(0, 0, 200-Math.round(bar.width),0);
			//var rect:Rectangle = new Rectangle(0, 0, 190,0);
			
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
			bar.graphics.beginFill(0xf6f6f6, 1);
			bar.graphics.drawRect( 0, 0, 50, 10);
			bar.graphics.endFill();
			addChild(bar);
		}
		
		/**
		 * 
		 */
		public function get barWidthReset():Number
		{
			bar.width = 50;
			return bar.width;
		}
		
		/**
		 * 
		 */
		public function get barWidthScaled():Number
		{
			return bar.width;
		}
		
		/**
		 * 
		 */
		public function  set barScaleX(scale:Number):void
		{
			if (scale < 0.3)
			{
				bar.scaleX = 0.3
			} else bar.scaleX = scale;
		}
		
		/**
		 * 
		 */
		public function get barX():Number
		{
			return bar.x;
		}
		
		/**
		 * 
		 */
		public function set barX(x:Number):void
		{
			bar.x = x;
		}
	}
}