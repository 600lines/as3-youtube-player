package com.irzal 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author dedet
	 */
	public class Test extends Sprite 
	{
		public function Test() 
		{
			var email:String = "caaa.a@chrisaiv.us";
			var emailRegExp:RegExp = /^([a-zA-Z0-9_.-]+)@([a-zA-Z0-9.-]+)\.([a-zA-Z]{1,3})$/i;
			var catches:Object = emailRegExp.exec( email );
			for( var j:String in catches ) {
			trace( j + ": " + catches[j] );
			}
			trace( "This e-mail's validity is: " + emailRegExp.test( email ) );
		}
	}

}