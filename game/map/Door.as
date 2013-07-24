package game.map {
	import flash.events.Event;
	import flash.display.MovieClip;
	
	import game.core.Game;
	
	public class Door extends MapObject {
		
		private var opened:Boolean = false;
		private var locked:Boolean = false;
		
		public function Door() {
		}
		
		private function unlock():void {
			this.locked = false;
		}
		
		public function open():void {
			if(locked){
				//if(/*잠금해제조건*/) unlock();
				return;
			} else if(opened){
				return;
			} else {
				opened = true;
				MovieClip(this.parent).play();
			}
		}
		
		override protected function addedToStageHandler(e:Event):void {
			Game.currentGame.mapManager.doorVector.push(this);
		}
		
		override protected function removedFromStageHandler(e:Event):void {
			var targetVector:Vector.<Door> = Game.currentGame.mapManager.doorVector;
			targetVector.splice(targetVector.indexOf(this), 1);
		}
	}
	
}
