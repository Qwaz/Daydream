package game.map {
	import flash.geom.Point;
	import flash.events.Event;
	
	import game.core.Game;
	
	public class HoldPoint extends MapObject {
		
		private var thisPoint:Point;
		
		public function HoldPoint() {
		}
		
		override protected function addedToStageHandler(e:Event):void {
			thisPoint = Game.currentGame.world.globalToLocal(this.localToGlobal(new Point()));
			Game.currentGame.mapManager.map::holdPoints.push(thisPoint);
		}
		
		override protected function removedFromStageHandler(e:Event):void {
			var targetVector:Vector.<Point> = Game.currentGame.mapManager.map::holdPoints;
			targetVector.splice(targetVector.indexOf(thisPoint), 1);
			thisPoint = null;
		}
	}
}
