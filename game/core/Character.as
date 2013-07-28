package game.core {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	import game.core.MapManager;
	import game.core.ItemManager;
	import game.event.GameEvent;
	import game.map.Door;
	import game.map.Ladder;
	
	public class Character extends MovieClip {
		private static const
		INTERACT:String="interact",
		STAY:String="stay",
		WALK:String="walk",
		FALL:String="fall",
		HOLD:String="hold",
		CLIMB:String="climb",
		LADDER:String="ladder";
		
		private static const
		JUMP_KEY:uint = Keyboard.SPACE;
		
		private static const
		WALK_SPEED:Number = 5,
		SMOOTH_GAP:Number = 7,
		JUMP_POWER:Number = 10,
		FRICTION_X:Number = 1,
		GRAVITY:Number = 0.5;
		
		private var _state:String;
		
		private var headPoint:Point, upFootPoint:Point, downFootPoint:Point, leftPoint:Point, rightPoint:Point, holdPoint:Point;
		
		private var speedX:Number=0;
		private var speedY:Number=0;
		
		private var holding:Point;
		
		public function Character(){
			headPoint = new Point(head.x, head.y);
			upFootPoint = new Point(upFoot.x, upFoot.y);
			downFootPoint = new Point(downFoot.x, downFoot.y);
			holdPoint = new Point(holdRange.x*2, holdRange.y);
			
			leftPoint = new Point(-WALK_SPEED, downFootPoint.y-SMOOTH_GAP);
			rightPoint = new Point(WALK_SPEED, downFootPoint.y-SMOOTH_GAP);
			
			state = FALL;
			
			Game.currentGame.addEventListener(GameEvent.INITED, initedHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function get state():String {
			return _state;
		}
		
		private function set state(t:String):void {
			this.gotoAndPlay(t);
			_state = t;
		}
		
		private function enterFrameHandler(e:Event):void {
			var map:MapManager = Game.currentGame.mapManager;
			
			/********************
			가만히 서 있을 때
			********************/
			if(this.state == STAY){
				if(checkLadder()) return;
				
				if(Key.pressed(Keyboard.RIGHT) || Key.pressed(Keyboard.LEFT)){
					this.state = WALK;
				} else if(Key.pressed(JUMP_KEY)){
					speedX = 0;
					speedY = -JUMP_POWER;
					this.state = FALL;
				} else if(Key.pressed(Keyboard.E)){
					var door:Door = map.hitTestDoor(localToGlobal(downFootPoint));
					var itemIndex:int = map.hitTestItem(Game.currentGame.character);
					
					if(door != null){
						door.open();
					}
					
					if(itemIndex != -1){
						Game.currentGame.itemManager.getItem(itemIndex);
					}
					
				}
			/********************
			걸어다닐 때
			********************/
			} else if(this.state == WALK){
				if(checkLadder()) return;
				
				var prevX:Number = this.x;
				var prevY:Number = this.y;
				
				if(Key.pressed(Keyboard.RIGHT)){
					this.x += WALK_SPEED;
					if(map.hitTestWall(localToGlobal(rightPoint))){
						this.x -= WALK_SPEED;
					}
					this.scaleX = 1;
				} else if(Key.pressed(Keyboard.LEFT)){
					this.x -= WALK_SPEED;
					if(map.hitTestWall(localToGlobal(leftPoint))){
						this.x += WALK_SPEED;
					}
					this.scaleX = -1;
				}
				
				if(!map.hitTestWall(localToGlobal(downFootPoint)) && !map.hitTestPanel(localToGlobal(downFootPoint))){
					downFootPoint.y += SMOOTH_GAP;
					if(map.hitTestWall(localToGlobal(downFootPoint)) || map.hitTestPanel(localToGlobal(downFootPoint))){
						this.y += SMOOTH_GAP;
					} else {
						speedY = 0;
						speedX = this.x-prevX;
						this.state = FALL;
					}
					downFootPoint.y -= SMOOTH_GAP;
				} else if(!Key.pressed(Keyboard.LEFT) && !Key.pressed(Keyboard.RIGHT)){
					this.state = STAY;
				}
				
				while(map.hitTestWall(localToGlobal(upFootPoint)) || map.hitTestPanel(localToGlobal(upFootPoint))){
					this.y -= downFootPoint.y-upFootPoint.y;
					
					if(this.y < prevY-SMOOTH_GAP){
						this.y = prevY;
						this.x = prevX;
						break;
					}
				}
				
				if(this.y < prevY){
					this.x -= (this.x-prevX)*(prevY-this.y)/SMOOTH_GAP;
				}
				
				
				if(Key.pressed(JUMP_KEY)){
					speedX = this.x-prevX;
					speedY = -JUMP_POWER;
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
							this.y += SMOOTH_GAP/2;
							remainY -= SMOOTH_GAP/2;
						} else {
							this.y += remainY;
							remainY = 0;
						}
						
						if(map.hitTestWall(localToGlobal(downFootPoint)) || map.hitTestPanel(localToGlobal(downFootPoint))){
							speedY = 0;
							state = STAY;
							break;
						//벽잡기
						} else if(holding = map.hitTestPoint(this.holdRange)){
							tPoint = Game.currentGame.world.localToGlobal(holding);
							
							if(this.scaleX > 0){
								this.x = tPoint.x - holdPoint.x;
								this.y = tPoint.y - holdPoint.y;
							} else if(this.scaleX < 0){
								this.x = tPoint.x + holdPoint.x;
								this.y = tPoint.y - holdPoint.y;
							}
							this.state = HOLD;
						}
					} else {
						//점프중
						if(remainY < -SMOOTH_GAP/2){
							this.y -= SMOOTH_GAP/2;
							remainY += SMOOTH_GAP/2;
						} else {
							this.y += remainY;
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
						this.x -= WALK_SPEED/4;
					}
					
					if(leftCheck){
						this.x += WALK_SPEED/4;
					}
				}
				
				this.x += speedX;
				
				if(this.scaleX > 0){
					rightCheck = map.hitTestWall(localToGlobal(rightPoint));
					leftCheck = map.hitTestWall(localToGlobal(leftPoint));
				} else {
					leftCheck = map.hitTestWall(localToGlobal(rightPoint));
					rightCheck = map.hitTestWall(localToGlobal(leftPoint));
				}
				
				if((speedX > 0 && rightCheck) || (speedX < 0 && leftCheck)){
					this.x -= speedX;
				}
			/********************
			매달려 있을 때
			********************/
			} else if(this.state == HOLD){
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
				tPoint = Game.currentGame.world.localToGlobal(holding);
				this.x += (tPoint.x - this.x)*0.3;
				this.y += (tPoint.y - this.y)*0.3;
			/********************
			사다리를 타고 있을 때
			********************/
			} else if(this.state == LADDER){
				if(Key.pressed(JUMP_KEY)){
					this.speedX = 0;
					this.speedY = 0;
					this.state = FALL;
				} else if(Key.pressed(Keyboard.UP)){
					nextFrame();
					this.y -= SMOOTH_GAP;
					
					if(!map.hitTestLadder(localToGlobal(headPoint))){
						this.speedX = 0;
						this.speedY = 0;
						holding = Game.currentGame.world.globalToLocal(this.localToGlobal(headPoint));
						this.state = CLIMB;
					}
				} else if(Key.pressed(Keyboard.DOWN)){
					nextFrame();
					this.y += SMOOTH_GAP;
					
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
		
		private function initedHandler(e:GameEvent):void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
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
