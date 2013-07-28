package game.core {
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import game.core.MapManager;
	import game.map.World;
	import game.event.GameEvent;
	
	public class Game extends EventDispatcher {
		private static const NO_DATA:int = -1;
		
		public static var currentGame:Game;
		
		private var _character:Character;
		private var _world:World;
		
		private var _mapManager:MapManager;
		private var _itemManager:ItemManager;

		public function Game(root:MovieClip, loadData:int=NO_DATA) {
			currentGame = this;
			
			_mapManager = new MapManager();
			
			root.gotoAndStop("play");
		}
		
		private function checkInit():void {
			if(_character && _world && _itemManager){
				Key.init();
				_world.gotoAndStop(3);
				this.dispatchEvent(new GameEvent(GameEvent.INITED));
			}
		}
		
		public function set character(character:Character):void {
			if(_character == null){
				_character = character;
				checkInit();
			} else {
				throw new IllegalOperationError("이미 캐릭터가 초기화되었습니다");
			}
		}
		
		public function get character():Character {
			return _character;
		}
		
		public function set world(world:World):void {
			if(_world == null){
				_world = world;
				checkInit();
			} else {
				throw new IllegalOperationError("이미 월드가 초기화되었습니다");
			}
		}
		
		public function get world():World {
			return _world;
		}
		
		public function set itemManager(itemManager:ItemManager):void {
			if(_itemManager == null){
				_itemManager = itemManager;
				checkInit();
			} else {
				throw new IllegalOperationError("이미 아이템 슬롯이 초기화되었습니다");
			}
		}
		
		public function get itemManager():ItemManager {
			return _itemManager;
		}
		
		public function get mapManager():MapManager {
			return _mapManager;
		}
	}
}
