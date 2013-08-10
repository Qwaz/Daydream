package game.core {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import game.core.MapManager;
	import game.db.EventDB;
	import game.db.ItemDB;
	import game.db.MapDB;
	import game.event.GameEvent;
	import game.event.MapEvent;
	import game.map.World;
	
	public class Game extends EventDispatcher {
		private static const NO_DATA:int = -1;
		
		public static var currentGame:Game;
		public static var slotSelector:SlotSelector, collectionViewer:CollectionViewer;
		
		private var _data:Object, _event:Object;
		
		private var _character:Character;
		private var _textBox:TextBox;
		private var _world:World;
		private var _frontWorld:Sprite;
		
		private var _mapManager:MapManager;
		private var _itemManager:ItemManager;

		public function Game(root:MovieClip, loadData:Object=null) {
			currentGame = this;
			_data = loadData;
			
			_mapManager = new MapManager();
			
			root.gotoAndStop("play");
			Object(root).shade.gotoAndPlay(2);
		}
		
		private function checkInit():void {
			if(_character && _world && _frontWorld && _itemManager && _textBox){
				Key.init();
				
				if(_data == null){
					_data = new Object();
					//DB에 _data 객체 넘겨 초기화
					MapDB.initData(_data);
					ItemDB.initData(_data);
				}
				EventDB.initData(_data);
				//초기화된 객체를 바탕으로 화면 세팅
				
				_world.gotoAndStop(_data.mapCode);
				_character.relX = _data.charX;
				_character.relY = _data.charY;
				
				_event = new Object();
				
				var name:String;
				for(name in _data.event){
					_event[name] = _data.event[name];
				}
				
				this.dispatchEvent(new GameEvent(GameEvent.INITED));
				
				_world.dispatchEvent(new MapEvent(MapEvent.MOVE_MAP));
				
				_data = null;
			}
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function get event():Object {
			return _event;
		}
		
		public function get character():Character {
			return _character;
		}
		
		public function set character(character:Character):void {
			if(_character == null){
				_character = character;
				checkInit();
			} else {
				throw new IllegalOperationError("이미 캐릭터가 초기화되었습니다");
			}
		}
		
		public function get world():World {
			return _world;
		}
		
		public function set world(world:World):void {
			if(_world == null){
				_world = world;
				checkInit();
			} else {
				throw new IllegalOperationError("이미 월드가 초기화되었습니다");
			}
		}
		
		public function get frontWorld():Sprite {
			return _frontWorld;
		}
		
		public function set frontWorld(frontWorld:Sprite):void {
			if(_frontWorld == null){
				_frontWorld = frontWorld;
				checkInit();
			} else {
				throw new IllegalOperationError("이미 앞쪽 월드가 초기화되었습니다.");
			}
		}
		
		public function get textBox():TextBox {
			return _textBox;
		}
		
		public function set textBox(textBox:TextBox):void {
			if(_textBox == null){
				_textBox = textBox;
				checkInit();
			} else {
				throw new IllegalOperationError("이미 텍스트박스가 초기화되었습니다.");
			}
		}
		
		public function get itemManager():ItemManager {
			return _itemManager;
		}
		
		public function set itemManager(itemManager:ItemManager):void {
			if(_itemManager == null){
				_itemManager = itemManager;
				checkInit();
			} else {
				throw new IllegalOperationError("이미 아이템 슬롯이 초기화되었습니다");
			}
		}
		
		public function get mapManager():MapManager {
			return _mapManager;
		}
	}
}
