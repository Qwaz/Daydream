package game.event {
	import flash.events.Event;
	
	public class MapEvent extends Event {
		
		public static const
		MOVE_MAP:String = "moveMap";

		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}

	}
	
}
