package game.map {
	import flash.events.Event;
	import game.core.Game;
	
	public class Ladder extends MapObject {

		public function Ladder() {
		}
		
		override protected function addedToStageHandler(e:Event):void {
			Game.currentGame.mapManager.map::ladderVector.push(this);
		}
		
		override protected function removedFromStageHandler(e:Event):void {
			var targetVector:Vector.<Ladder> = Game.currentGame.mapManager.map::ladderVector;
			targetVector.splice(targetVector.indexOf(this), 1);
		}

	}
	
}
