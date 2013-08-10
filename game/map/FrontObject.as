package game.map {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import game.core.Game;
	import game.event.MapEvent;
	
	public class FrontObject extends MovieClip {
		
		private var mapCode:int;
		
		public function FrontObject() {
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			Game.currentGame.world.addEventListener(MapEvent.MOVE_MAP, moveMapHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			mapCode = Game.currentGame.world.currentFrame;
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			Game.currentGame.frontWorld.addChild(this);
		}
		
		private function moveMapHandler(e:MapEvent):void {
			if(mapCode != Game.currentGame.world.currentFrame){
				Game.currentGame.world.removeEventListener(MapEvent.MOVE_MAP, moveMapHandler);
				
				Game.currentGame.frontWorld.removeChild(this);
			}
		}

	}
	
}
