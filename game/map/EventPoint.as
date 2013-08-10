package game.map {
	import flash.events.Event;
	
	import game.core.Game;
	
	public class EventPoint extends MapObject {
		
		public var check:Function;
	
		private function enterFrameHandler(e:Event):void {
			if(this.hitTestObject(Game.currentGame.character)){
				if(check != null){
					check();
				}
			}
		}
	
		override protected function addedToStageHandler(e:Event):void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		override protected function removedFromStageHandler(e:Event):void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
	}
	
}
