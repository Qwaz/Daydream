package game.core {
	import flash.events.KeyboardEvent;
	
	public class Key {
		private static var keyArr:Vector.<Boolean>;
		
		public static function init():void {
			keyArr = new Vector.<Boolean>;
			
			Game.currentGame.world.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Game.currentGame.world.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		public static function dispose():void {
			keyArr = null;
			Game.currentGame.world.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Game.currentGame.world.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private static function keyDownHandler(e:KeyboardEvent):void {
			if(keyArr.length <= e.keyCode){
				keyArr.length = e.keyCode+1;
			}
			
			keyArr[e.keyCode] = 1;
		}
		
		private static function keyUpHandler(e:KeyboardEvent):void {
			if(keyArr.length > e.keyCode) keyArr[e.keyCode] = 0;
		}
		
		public static function pressed(keyCode:uint):Boolean {
			if(keyArr.length > keyCode) return keyArr[keyCode];
			else return false;
		}
	}
}
