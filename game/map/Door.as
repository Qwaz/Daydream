package game.map {
	import flash.events.Event;
	
	import game.core.Game;
	import game.db.MapDB;
	
	public class Door extends InteractiveObject {
		
		public function Door() {
		}
		
		override public function interact():void {
			if(check == null || check()){
				this.play();
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		private function enterFrameHandler(e:Event):void {
			if(this.currentFrame == this.totalFrames){
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				
				Game.currentGame.character.endInteraction();
				Game.currentGame.mapManager.moveMap(MapDB.getDoorData(this.name));
			}
		}
	}
	
}
