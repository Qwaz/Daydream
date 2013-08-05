package game.core {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import game.event.GameEvent;
	
	import textbaker.core.TextBaker;
	import textbaker.core.TextBakerState;
	import textbaker.events.StateChangeEvent;
	import textbaker.events.TextBakerEvent;
	
	public class TextBox extends Sprite {
		
		private var _textBaker:TextBaker;

		public function TextBox() {
			this.visible = false;
			
			Game.currentGame.addEventListener(GameEvent.INITED, initedHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function stateChangeHandler(e:StateChangeEvent):void {
			if(e.prevState == TextBakerState.WAIT){
				this.visible = true;
				Game.currentGame.character.startInteract();
			} else if(e.nextState == TextBakerState.WAIT){
				this.visible = false;
				Game.currentGame.character.endInteract();
			}
		}
		
		public function get textBaker():TextBaker {
			return _textBaker;
		}
		
		private function textPushedHandler(e:TextBakerEvent):void {
			_textBaker.next();
		}
		
		private function nextHandler(e:Event):void {
			if(this.visible == true){
				_textBaker.next();
			}
		}
		
		private function initedHandler(e:GameEvent):void {
			_textBaker = new TextBaker(textField);
			_textBaker.addEventListener(StateChangeEvent.STATE_CHANGE, stateChangeHandler);
			_textBaker.addEventListener(TextBakerEvent.TEXT_PUSHED, textPushedHandler);
			
			stage.addEventListener(MouseEvent.CLICK, nextHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, nextHandler);
			
			Game.currentGame.removeEventListener(GameEvent.INITED, initedHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			Game.currentGame.textBox = this;
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function removedFromStageHandler(e:Event):void {
			_textBaker.removeEventListener(StateChangeEvent.STATE_CHANGE, stateChangeHandler);
			_textBaker.removeEventListener(TextBakerEvent.TEXT_PUSHED, textPushedHandler);
			
			stage.removeEventListener(MouseEvent.CLICK, nextHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, nextHandler);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

	}
	
}
