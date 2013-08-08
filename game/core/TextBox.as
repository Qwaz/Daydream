package game.core {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
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
				Game.currentGame.character.startInteraction();
			} else if(e.nextState == TextBakerState.WAIT){
				this.visible = false;
				Game.currentGame.character.endInteraction();
			}
		}
		
		public function get textBaker():TextBaker {
			return _textBaker;
		}
		
		private function textPushedHandler(e:TextBakerEvent):void {
			_textBaker.next();
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			if(this.visible == true && e.keyCode == Keyboard.SPACE){
				_textBaker.next();
			}
		}
		
		private function initedHandler(e:GameEvent):void {
			textField.text = "";
			
			_textBaker = new TextBaker(textField);
			_textBaker.addEventListener(StateChangeEvent.STATE_CHANGE, stateChangeHandler);
			_textBaker.addEventListener(TextBakerEvent.TEXT_PUSHED, textPushedHandler);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			Game.currentGame.removeEventListener(GameEvent.INITED, initedHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			Game.currentGame.textBox = this;
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function removedFromStageHandler(e:Event):void {
			_textBaker.removeEventListener(StateChangeEvent.STATE_CHANGE, stateChangeHandler);
			_textBaker.removeEventListener(TextBakerEvent.TEXT_PUSHED, textPushedHandler);
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

	}
	
}
