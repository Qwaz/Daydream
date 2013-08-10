
package game.core {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	import game.core.MapManager;
	import game.core.ItemManager;
	import game.event.GameEvent;
	import game.map.*;
	import game.map.interactive.InteractiveObject;
	
	public class Character extends MovieClip {
		public static const
		INTERACT:String="interact",
		STAY:String="stay",
		WALK:String="walk",
		FALL:String="fall",
		HOLD:String="hold",
		CLIMB:String="climb",
		LADDER:String="ladder";
		
		private static const
		JUMP_KEY:uint = Keyboard.SPACE,
		INTERACTION_KEY:uint = Keyboard.E;
		
		private static const
		WALK_SPEED:Number = 5,
		SMOOTH_GAP:Number = 7,
		JUMP_POWER:Number = 10,
		FRICTION_X:Number = 1,
		GRAVITY:Number = 0.5;
		
		private var _state:String;
		
		private var headPoint:Point, upFootPoint:Point, downFootPoint:Point, leftPoint:Point, rightPoint:Point, holdPoint:Point;
		
		private var lastState:String, interactionCount:int=0;
		private var _relX:Number, _relY:Number;
		
		private var speedX:Number=0;
		private var speedY:Number=0;
		
		private var lastHold:Point, lastPanel:Panel;
		
		public function Character(){
			headPoint = new Point(head.x, head.y);
			upFootPoint = new Point(upFoot.x, upFoot.y);
			downFootPoint = new Point(downFoot.x, downFoot.y);
			holdPoint = new Point(holdRange.x*2, holdRange.y);
			
			leftPoint = new Point(downFootPoint.x-WALK_SPEED, downFootPoint.y-SMOOTH_GAP);
			rightPoint = new Point(downFootPoint.y+WALK_SPEED, downFootPoint.y-SMOOTH_GAP);
			
			state = FALL;
			
			Game.currentGame.addEventListener(GameEvent.INITED, initedHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		public function getState():String {
			return _state;
		}
		
		private function get state():String {
			return _state;
		}
		
		private function set state(t:String):void {
			if(t == INTERACT){
				if(_state != INTERACT){
					lastState = _state;
					stop();
				}
			} else if(_state == INTERACT){
				play();
			} else {
				this.gotoAndPlay(t);
			}
			_state = t;
		}
		
		public function startInteraction():void {
			this.state = INTERACT;
			interactionCount++;
		}
		
		public function endInteraction():void {
			if(this.state == INTERACT){
				interactionCount--;
				if(interactionCount == 0){
					this.state = lastState;
				}
			}
		}
		
		public function startFall():void {
			this.state = FALL;
		}
		
		private function enterFrameHandler(e:Event):void {
			var map:MapManager = Game.currentGame.mapManager;
			var interactive:InteractiveObject = map.hitTestInteractive(this);
			
			/********************
			가만히 서 있을 때
			********************/
			if(this.state == STAY){
				if(checkLadder()) return;
				
				if(Key.pressed(Keyboard.RIGHT) || Key.pressed(Keyboard.LEFT)){
					this.state = WALK;
				} else if(Key.pressed(JUMP_KEY)){
					speedX = 0;
					if(Key.pressed(Keyboard.DOWN) && lastPanel){
						speedY = 0;
					} else {
						speedY = -JUMP_POWER;
						lastPanel = null;
					}
					this.state = FALL;
				} else if(Key.pressed(INTERACTION_KEY)){
					if(interactive != null){
						this.startInteraction();
						interactive.interact();
					}
				}
			/********************
			걸어다닐 때
			********************/
			} else if(this.state == WALK){
				if(checkLadder()) return;
				
				var prevX:Number = this.relX;
				var prevY:Number = this.relY;
				
				if(Key.pressed(Keyboard.RIGHT)){
					this.relX += WALK_SPEED;
					if(map.hitTestWall(localToGlobal(rightPoint))){
						this.relX -= WALK_SPEED;
					}
					this.scaleX = -1;
				} else if(Key.pressed(Keyboard.LEFT)){
					this.relX -= WALK_SPEED;
					if(map.hitTestWall(localToGlobal(leftPoint))){
						this.relX += WALK_SPEED;
					}
					this.scaleX = 1;
				}
				
				if(!map.hitTestWall(localToGlobal(downFootPoint)) && !map.hitTestPanel(localToGlobal(downFootPoint))){
					downFootPoint.y += SMOOTH_GAP;
					lastPanel = map.hitTestPanel(localToGlobal(downFootPoint));
					if(map.hitTestWall(localToGlobal(downFootPoint)) || lastPanel!=null){
						this.relY += SMOOTH_GAP;
					} else {
						speedY = 0;
						speedX = this.relX-prevX;
						this.state = FALL;
					}
					downFootPoint.y -= SMOOTH_GAP;
				} else if(!Key.pressed(Keyboard.LEFT) && !Key.pressed(Keyboard.RIGHT)){
					this.state = STAY;
				}
				
				while(map.hitTestWall(localToGlobal(upFootPoint)) || map.hitTestPanel(localToGlobal(upFootPoint))){
					this.relY -= downFootPoint.y-upFootPoint.y;
					
					if(this.relY < prevY-SMOOTH_GAP){
						this.relY = prevY;
						this.relX = prevX;
						break;
					}
				}
				
				if(this.relY < prevY){
					this.relX -= (this.relX-prevX)*(prevY-this.relY)/SMOOTH_GAP;
				}
				
				
				if(Key.pressed(JUMP_KEY)){
					speedX = this.relX-prevX;
					if(Key.pressed(Keyboard.DOWN) && lastPanel){
						speedY = 0;
					} else {
						speedY = -JUMP_POWER;
						lastPanel = null;
					}
					this.state = FALL;
				}
			/********************
			점프, 떨어질 때
			********************/
			} else if(this.state == FALL){
				if(checkLadder()) return;
				
				speedX *= FRICTION_X;
				speedY += GRAVITY;
				
				var rightCheck:Boolean, leftCheck:Boolean;
				var tPoint:Point;
				
				var remainY:Number = speedY;
				while(Math.abs(remainY) > 0){
					if(speedY > 0){
						//떨어질 때
						if(remainY > SMOOTH_GAP/2){
							this.relY += SMOOTH_GAP/2;
							remainY -= SMOOTH_GAP/2;
						} else {
							this.relY += remainY;
							remainY = 0;
						}
						
						var tmpLastPanel:Panel = map.hitTestPanel(localToGlobal(downFootPoint), lastPanel);
						if(map.hitTestWall(localToGlobal(downFootPoint)) || tmpLastPanel){
							speedY = 0;
							state = STAY;
							lastPanel = tmpLastPanel;
							break;
						//벽잡기
						} else if(lastHold = map.hitTestPoint(this.holdRange)){
							tPoint = Game.currentGame.world.localToGlobal(lastHold);
							
							if(this.scaleX > 0){
								this.relX = tPoint.x - holdPoint.x - Game.currentGame.world.x;
								this.relY = tPoint.y - holdPoint.y - Game.currentGame.world.y;
							} else if(this.scaleX < 0){
								this.relX = tPoint.x + holdPoint.x - Game.currentGame.world.x;
								this.relY = tPoint.y - holdPoint.y - Game.currentGame.world.y;
							}
							this.state = HOLD;
						}
					} else {
						//점프중
						if(remainY < -SMOOTH_GAP/2){
							this.relY -= SMOOTH_GAP/2;
							remainY += SMOOTH_GAP/2;
						} else {
							this.relY += remainY;
							remainY = 0;
						}
						if(map.hitTestWall(localToGlobal(headPoint))){
							speedY = 0;
							break;
						}
					}
					
				
					if(this.scaleX > 0){
						rightCheck = map.hitTestWall(localToGlobal(rightPoint));
						leftCheck = map.hitTestWall(localToGlobal(leftPoint));
					} else {
						leftCheck = map.hitTestWall(localToGlobal(rightPoint));
						rightCheck = map.hitTestWall(localToGlobal(leftPoint));
					}
					
					if(rightCheck){
						this.relX -= WALK_SPEED/4;
					}
					
					if(leftCheck){
						this.relX += WALK_SPEED/4;
					}
				}
				
				this.relX += speedX;
				
				if(this.scaleX > 0){
					rightCheck = map.hitTestWall(localToGlobal(rightPoint));
					leftCheck = map.hitTestWall(localToGlobal(leftPoint));
				} else {
					leftCheck = map.hitTestWall(localToGlobal(rightPoint));
					rightCheck = map.hitTestWall(localToGlobal(leftPoint));
				}
				
				if((speedX > 0 && rightCheck) || (speedX < 0 && leftCheck)){
					this.relX -= speedX;
				}
			/********************
			매달려 있을 때
			********************/
			} else if(this.state == HOLD){
				this.lastPanel = null;
				
				if(Key.pressed(JUMP_KEY)){
					this.state = CLIMB;
				}
				
				if(this.scaleX > 0 && Key.pressed(Keyboard.LEFT)){
					this.scaleX = -1;
					speedX = 0;
					speedY = 0;
					this.state = FALL;
				}
				if(this.scaleX < 0 && Key.pressed(Keyboard.RIGHT)){
					this.scaleX = 1;
					speedX = 0;
					speedY = 0;
					this.state = FALL;
				}
			/********************
			매달린 상태, 사다리 등에서 올라갈 때
			********************/
			} else if(this.state == CLIMB){
			/********************
			사다리를 타고 있을 때
			********************/
			} else if(this.state == LADDER){
				this.lastPanel = null;
				
				if(Key.pressed(JUMP_KEY)){
					this.speedX = 0;
					this.speedY = 0;
					this.state = FALL;
				} else if(Key.pressed(Keyboard.UP)){
					nextFrame();
					this.relY -= SMOOTH_GAP/2;
					
					if(!map.hitTestLadder(localToGlobal(headPoint))){
						this.speedX = 0;
						this.speedY = 0;
						lastHold = Game.currentGame.world.globalToLocal(this.localToGlobal(holdPoint));
						this.state = CLIMB;
					}
				} else if(Key.pressed(Keyboard.DOWN)){
					nextFrame();
					this.relY += SMOOTH_GAP/2;
					
					if(!map.hitTestLadder(localToGlobal(downFootPoint))){
						this.speedX = 0;
						this.speedY = 0;
						this.state = FALL;
					}
				}
			}
		}
		
		private function checkLadder():Boolean {
			//사다리 오르기 처리
			if(Key.pressed(Keyboard.UP) && Game.currentGame.mapManager.hitTestLadder(localToGlobal(headPoint))){
				this.state = LADDER;
				return true;
			}
			
			return false;
		}
		
		public function get relX():Number {
			return _relX;
		}
		
		public function get relY():Number {
			return _relY;
		}
		
		public function set relX(val:Number):void {
			_relX = val;
			updatePosition();
		}
		
		public function set relY(val:Number):void {
			_relY = val;
			updatePosition();
		}
		
		public function updatePosition():void {
			this.x = Game.currentGame.world.x+this.relX;
			this.y = Game.currentGame.world.y+this.relY;
		}
		
		private function initedHandler(e:GameEvent):void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			Game.currentGame.removeEventListener(GameEvent.INITED, initedHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			Game.currentGame.character = this;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function removedFromStageHandler(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
	}
}
