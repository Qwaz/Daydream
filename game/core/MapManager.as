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
		map var ladderVector:Vector.<Ladder>;
		
		map var holdPoints:Vector.<Point>;
			
		map var interactiveVector:Vector.<InteractiveObject>;

		public function MapManager() {
			map::wallVector = new Vector.<Wall>;
			map::panelVector = new Vector.<Panel>;
			map::ladderVector = new Vector.<Ladder>;
			
			map::holdPoints = new Vector.<Point>;
			
			map::interactiveVector = new Vector.<InteractiveObject>;
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
		
		public function hitTestLadder(target:Point):Boolean {
			for each (var ladder:Ladder in map::ladderVector){
				if(ladder.hitTestPoint(target.x, target.y, false)){
					return true;
				}
			}
			
			return false;
		}
		
		public function hitTestPoint(rect:DisplayObject):Point {
			for each (var point:Point in map::holdPoints){
				var tPoint:Point = Game.currentGame.world.localToGlobal(point);
				if(rect.hitTestPoint(tPoint.x, tPoint.y)){
					return point;
				}
			}
			
			return null;
		}
		
		public function hitTestInteractive(rect:DisplayObject):InteractiveObject {
			var nearest:InteractiveObject;
			
			var character:Character = Game.currentGame.character;
			var charPoint:Point = new Point(character.x, character.y);
			charPoint = Game.currentGame.world.globalToLocal(charPoint);
			
			for each (var interactive:InteractiveObject in map::interactiveVector){
				interactive.emphasize(false);
				if(interactive.available() && rect.hitTestObject(interactive)){
					if(nearest == null || Math.abs(nearest.x-charPoint.x) > Math.abs(interactive.x-charPoint.x)){
						nearest = interactive;
					}
				}
			}
			
			if(nearest){
				nearest.emphasize(true);
			}
			
			return nearest;
		}
	}
}
