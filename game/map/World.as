﻿package game.map {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import game.core.Character;
	import game.core.Game;
	import game.event.GameEvent;
	
	public class World extends MovieClip {

		public function World() {
			Game.currentGame.addEventListener(GameEvent.INITED, initedHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private function enterFrameHandler(e:Event):void {
			var character:Character = Game.currentGame.character;
			
			var dx:Number = character.x-stage.stageWidth/2;
			var dy:Number = character.y-stage.stageHeight/2;
			
			const MAP_SPEED:Number = 0.01;
			
			this.x -= dx*MAP_SPEED;
			this.y -= dy*MAP_SPEED;
			
			character.x -= dx*MAP_SPEED;
			character.y -= dy*MAP_SPEED;
		}
		
		private function initedHandler(e:GameEvent):void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			Game.currentGame.world = this;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function removedFromStageHandler(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

	}
	
}