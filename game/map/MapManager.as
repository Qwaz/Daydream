package game.map {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class MapManager {
		
		internal var wallVector:Vector.<Wall>;
		internal var panelVector:Vector.<Panel>;
		internal var doorVector:Vector.<Door>;
		internal var ladderVector:Vector.<Ladder>;
		public var itemVector:Vector.<MovieClip>;
		
		internal var holdPoints:Vector.<Point>;

		public function MapManager() {
			wallVector = new Vector.<Wall>;
			panelVector = new Vector.<Panel>;
			doorVector = new Vector.<Door>;
			ladderVector = new Vector.<Ladder>;
			itemVector = new Vector.<MovieClip>;
			
			holdPoints = new Vector.<Point>;
		}
		
		public function hitTestWall(target:Point):Boolean {
			for each (var wall:Wall in wallVector){
				if(wall.hitTestPoint(target.x, target.y, true)){
					return true;
				}
			}
			
			return false;
		}
		
		public function hitTestPanel(target:Point):Boolean {
			for each (var panel:Panel in panelVector){
				if(panel.hitTestPoint(target.x, target.y, false)){
					return true;
				}
			}
			
			return false;
		}
		
		public function hitTestDoor(target:Point):Door {
			for each (var door:Door in doorVector){
				if(door.hitTestPoint(target.x, target.y, false)){
					return door;
				}
			}
			
			return null;
		}
		
		public function hitTestLadder(target:Point):Boolean {
			for each (var ladder:Ladder in ladderVector){
				if(ladder.hitTestPoint(target.x, target.y, false)){
					return true;
				}
			}
			
			return false;
		}
		
		public function hitTestItem(target:MovieClip):int {
			for (var i=0; i<itemVector.length; i++){
				if(itemVector[i].hitTestObject(target)){
					return i;
				}
			}
			
			return -1;
		}
		
		public function hitTestPoint(rect:DisplayObject):Point {
			for each (var point:Point in holdPoints){
				if(rect.hitTestPoint(point.x, point.y)){
					return point;
				}
			}
			
			return null;
		}
	}
}
