package game.core {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	import game.map.MapManager;
	import game.map.Door;
	
	public class Character extends MovieClip {
		private static const
		INTERACT:String="interact",
		STAY:String="stay",
		WALK:String="walk",
		FALL:String="fall",
		HOLD:String="hold",
		CLIMB:String="climb";
		
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
		
		public function Character() {
			Key.init();
			
			headPoint = new Point(head.x, head.y);
			upFootPoint = new Point(upFoot.x, upFoot.y);
			downFootPoint = new Point(downFoot.x, downFoot.y);
			holdPoint = new Point(holdRange.x*2, holdRange.y);
			
			leftPoint = new Point(-WALK_SPEED, downFootPoint.y-SMOOTH_GAP);
			rightPoint = new Point(WALK_SPEED, downFootPoint.y-SMOOTH_GAP);
			
			state = FALL;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
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
			
			if(this.state == STAY){
				if(Key.pressed(Keyboard.RIGHT) || Key.pressed(Keyboard.LEFT)){
					this.state = WALK;
				} else if(Key.pressed(JUMP_KEY)){
					speedX = 0;
					speedY = -JUMP_POWER;
					this.state = FALL;
				} else if(Key.pressed(Keyboard.E)){
					var door:Door = map.hitTestDoor(localToGlobal(downFootPoint));
					if(door != null){
						door.open();
					}
				}
			} else if(this.state == WALK){
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
			} else if(this.state == FALL){
				speedX *= FRICTION_X;
				speedY += GRAVITY;
				
				var rightCheck:Boolean, leftCheck:Boolean;
				
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
						} else if(holding = map.hitTestPoint(this.holdRange)){
							if(this.scaleX > 0){
								this.x = holding.x - holdPoint.x;
								this.y = holding.y - holdPoint.y;
							} else if(this.scaleX < 0){
								this.x = holding.x + holdPoint.x;
								this.y = holding.y - holdPoint.y;
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
			} else if(this.state == CLIMB){
				this.x += (holding.x - this.x)*0.3;
				this.y += (holding.y - this.y)*0.3;
			}
		}
		
		private function removedFromStageHandler(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			Key.dispose();
		}
	}
}
