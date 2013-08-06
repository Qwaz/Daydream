package game.core {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import game.core.Character;
	import game.event.MapEvent;
	import game.map.*;
	
	public class MapManager {
		
		private var _wallVector:Vector.<Wall>;
		private var _panelVector:Vector.<Panel>;
		private var _ladderVector:Vector.<Ladder>;
		
		private var _holdPoints:Vector.<Point>;
			
		private var _interactiveVector:Vector.<InteractiveObject>;

		public function MapManager() {
			_wallVector = new Vector.<Wall>;
			_panelVector = new Vector.<Panel>;
			_ladderVector = new Vector.<Ladder>;
			
			_holdPoints = new Vector.<Point>;
			
			_interactiveVector = new Vector.<InteractiveObject>;
		}
		
		public function moveMap(destMap:int, destX:Number, destY:Number){
			Game.currentGame.world.gotoAndStop(destMap);
			Object(Game.currentGame.world.parent).shade.gotoAndPlay(2);
			
			var character:Character = Game.currentGame.character;
			character.relX = destX;
			character.relY = destY;
			
			character.startFall();
			
			var mapEvent:MapEvent = new MapEvent(MapEvent.MOVE_MAP);
			Game.currentGame.world.dispatchEvent(mapEvent);
		}
		
		public function hitTestWall(target:Point):Boolean {
			for each (var wall:Wall in _wallVector){
				if(wall.hitTestPoint(target.x, target.y, true)){
					return true;
				}
			}
			
			return false;
		}
		
		public function hitTestPanel(target:Point, ignore:Panel=null):Panel {
			for each (var panel:Panel in _panelVector){
				if(panel != ignore && panel.hitTestPoint(target.x, target.y, false)){
					return panel;
				}
			}
			
			return null;
		}
		
		public function hitTestLadder(target:Point):Boolean {
			for each (var ladder:Ladder in _ladderVector){
				if(ladder.hitTestPoint(target.x, target.y, false)){
					return true;
				}
			}
			
			return false;
		}
		
		public function hitTestPoint(rect:DisplayObject):Point {
			for each (var point:Point in _holdPoints){
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
			
			for each (var interactive:InteractiveObject in _interactiveVector){
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
		
		map function get wallVector():Vector.<Wall> {
			return _wallVector;
		}
		
		map function get panelVector():Vector.<Panel> {
			return _panelVector;
		}
		
		map function get ladderVector():Vector.<Ladder> {
			return _ladderVector;
		}
		
		map function get holdPoints():Vector.<Point> {
			return _holdPoints;
		}
		
		map function get interactiveVector():Vector.<InteractiveObject> {
			return _interactiveVector;
		}
	}
}
