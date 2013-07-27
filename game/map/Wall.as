package game.map {
	import flash.events.Event;
	import game.core.Game;
	
	public class Wall extends MapObject {

		public function Wall() {
		}
		
		override protected function addedToStageHandler(e:Event):void {
			Game.currentGame.mapManager.map::wallVector.push(this);
		}
		
		override protected function removedFromStageHandler(e:Event):void {
			var targetVector:Vector.<Wall> = Game.currentGame.mapManager.map::wallVector;
			targetVector.splice(targetVector.indexOf(this), 1);
		}
	}
}
