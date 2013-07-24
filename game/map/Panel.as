package game.map {
	import flash.events.Event;
	import game.core.Game;
	
	public class Panel extends MapObject {

		public function Panel() {
		}
		
		override protected function addedToStageHandler(e:Event):void {
			Game.currentGame.mapManager.panelVector.push(this);
		}
		
		override protected function removedFromStageHandler(e:Event):void {
			var targetVector:Vector.<Panel> = Game.currentGame.mapManager.panelVector;
			targetVector.splice(targetVector.indexOf(this), 1);
		}
	}
}
