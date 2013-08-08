package game.map {
	import flash.events.Event;
	import flash.display.MovieClip;
	
	import game.core.Game;
	
	public class Door extends InteractiveObject {
		
		private var opened:Boolean = false;
		private var locked:Boolean = false;
		
		public function Door() {
			this.visible = false;
		}
		
		private function unlock():void {
			this.locked = false;
		}
		
		override public function interact():void {
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
	}
	
}
