﻿package game.map {
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class MapObject extends MovieClip {

		public function MapObject() {
			this.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		protected function addedToStageHandler(e:Event):void {
			
		}
		
		protected function removedFromStageHandler(e:Event):void {
			
		}
	}
}
