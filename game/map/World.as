package game.map {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import game.core.Character;
	import game.core.Game;
	import game.event.GameEvent;
	import game.event.MapEvent;
	
	public class World extends MovieClip {

		public function World() {
			Game.currentGame.addEventListener(GameEvent.INITED, initedHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private function enterFrameHandler(e:Event):void {
			var character:Character = Game.currentGame.character;
			
			var dx:Number = this.x+character.relX-stage.stageWidth/2;
			var dy:Number = this.y+character.relY-stage.stageHeight/2-150;
			
			const MAP_SPEED:Number = 0.03;
			
			this.x -= dx*MAP_SPEED;
			this.y -= dy*MAP_SPEED;
			
			updatePosition();
		}
		
		private function moveMapHandler(e:MapEvent):void {
			var character:Character = Game.currentGame.character;
			
			var dx:Number = this.x+character.relX-stage.stageWidth/2;
			var dy:Number = this.y+character.relY-stage.stageHeight/2-150;
			
			this.x -= dx;
			this.y -= dy;
			
			updatePosition();
		}
		
		private function updatePosition():void {
			Game.currentGame.frontWorld.x = this.x;
			Game.currentGame.frontWorld.y = this.y;
			
			Game.currentGame.character.updatePosition();
		}
		
		private function initedHandler(e:GameEvent):void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.addEventListener(MapEvent.MOVE_MAP, moveMapHandler);
			
			Game.currentGame.removeEventListener(GameEvent.INITED, initedHandler);
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
