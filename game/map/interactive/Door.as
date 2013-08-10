package game.map.interactive {
	import flash.events.Event;
	
	import game.core.Game;
	import game.db.MapDB;
	
	public class Door extends InteractiveObject {
		
		public function Door() {
		}
		
		override public function interact(item:int=0):void {
			if((check == null && item == 0) || check(item)){
				this.play();
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			} else {
				if(item != 0){
					Game.currentGame.textBox.textBaker.push("아이템을 사용하기 적합한 장소가 아닌 것 같다.");
				}
				Game.currentGame.character.endInteraction();
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
