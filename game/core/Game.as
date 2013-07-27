package game.core {
	import flash.display.MovieClip;
	
	import game.core.MapManager;
	
	public class Game {
		private static const NO_DATA:int = -1;
		
		public static var currentGame:Game;
		
		public var mapManager:MapManager;
		
		private var _world:MovieClip;
		
		public var character:Character;
		
		public var slot:ItemManager;

		public function Game(world:MovieClip, loadData:int=NO_DATA) {
			currentGame = this;
			_world = world;
			
			mapManager = new MapManager();
			
			world.gotoAndStop("play");
			
			if(loadData == NO_DATA){
				world.map.gotoAndStop(3);
			}
		}
		
		public function get world():MovieClip {
			return _world;
		}
	}
}
