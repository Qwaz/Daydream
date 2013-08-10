package game.map.interactive {
	import flash.events.Event;
	
	import game.core.Game;
	import game.map.map;
	import game.map.MapObject;
	
	public class InteractiveObject extends MapObject {
		
		public var check:Function;

		public function InteractiveObject() {
			this.visible = true;
		}
		
		public function available():Boolean {
			return true;
		}
		
		public function interact(item:int=0):void {
			if((check == null && item == 0) || check(item)){
			} else {
				Game.currentGame.textBox.textBaker.push("아이템을 사용하기 적합한 장소가 아닌 것 같다.");
			}
			Game.currentGame.character.endInteraction();
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
