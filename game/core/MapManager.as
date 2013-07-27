package game.core {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import game.item.item;
	import game.map.*;
	
	public class MapManager {
		
		map var wallVector:Vector.<Wall>;
		map var panelVector:Vector.<Panel>;
		map var doorVector:Vector.<Door>;
		map var ladderVector:Vector.<Ladder>;
		item var itemVector:Vector.<MovieClip>;
		
		map var holdPoints:Vector.<Point>;

		public function MapManager() {
			map::wallVector = new Vector.<Wall>;
			map::panelVector = new Vector.<Panel>;
			map::doorVector = new Vector.<Door>;
			map::ladderVector = new Vector.<Ladder>;
			item::itemVector = new Vector.<MovieClip>;
			
			map::holdPoints = new Vector.<Point>;
		}
		
		public function hitTestWall(target:Point):Boolean {
			for each (var wall:Wall in map::wallVector){
				if(wall.hitTestPoint(target.x, target.y, true)){
					return true;
				}
			}
			
			return false;
		}
		
		public function hitTestPanel(target:Point):Boolean {
			for each (var panel:Panel in map::panelVector){
				if(panel.hitTestPoint(target.x, target.y, false)){
					return true;
				}
			}
			
			return false;
		}
		
		public function hitTestDoor(target:Point):Door {
			for each (var door:Door in map::doorVector){
				if(door.hitTestPoint(target.x, target.y, false)){
					return door;
				}
			}
			
			return null;
		}
		
		public function hitTestLadder(target:Point):Boolean {
			for each (var ladder:Ladder in map::ladderVector){
				if(ladder.hitTestPoint(target.x, target.y, false)){
					return true;
				}
			}
			
			return false;
		}
		
		public function hitTestItem(target:MovieClip):int {
			for (var i=0; i<item::itemVector.length; i++){
				if(item::itemVector[i].hitTestObject(target)){
					return i;
				}
			}
			
			return -1;
		}
		
		public function hitTestPoint(rect:DisplayObject):Point {
			for each (var point:Point in map::holdPoints){
				if(rect.hitTestPoint(point.x, point.y)){
					return point;
				}
			}
			
			return null;
		}
	}
}
