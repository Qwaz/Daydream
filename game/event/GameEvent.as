package game.event {
	import flash.events.Event;
	
	public class GameEvent extends Event {
		public static const INITED:String = "inited";
		
		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
