package game.map {
	import flash.events.Event;
	import game.core.Game;
	
	public class InteractiveObject extends MapObject {
		
		public var check:Function;

		public function InteractiveObject() {
			this.visible = true;
		}
		
		public function available():Boolean {
			return true;
		}
		
		public function interact():void {
			if(check == null || check()){
				Game.currentGame.character.endInteraction();
			}
		}
		
		public function emphasize(selected:Boolean):void {
			if(selected){
				this.alpha = 0.7;
			} else {
				this.alpha = 1;
			}
		}
		
		override protected function addedToStageHandler(e:Event):void {
			Game.currentGame.mapManager.map::interactiveVector.push(this);
		}
		
		override protected function removedFromStageHandler(e:Event):void {
			var interactiveVector:Vector.<InteractiveObject> = Game.currentGame.mapManager.map::interactiveVector;
			interactiveVector.splice(interactiveVector.indexOf(this), 1);
		}

	}
	
}
