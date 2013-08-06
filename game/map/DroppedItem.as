package game.map {
	import flash.events.Event;
	
	import game.core.Game;
	import game.event.MapEvent;
	
	public class DroppedItem extends InteractiveObject {
		
		private var _mapCode:int, _itemCode:int;

		public function DroppedItem(mapCode:int, itemCode:int) {
			super();
			
			this.visible = true;
			
			_mapCode = mapCode;
			_itemCode = itemCode;
			
			var item:Items = new Items();
			item.gotoAndStop(itemCode+1);
			
			this.addChild(item);
			
			Game.currentGame.world.addEventListener(MapEvent.MOVE_MAP, moveMapHandler);
		}
		
		override public function available():Boolean {
			return this.visible;
		}
		
		override public function interact():void {
			if(Game.currentGame.itemManager.getItem(_itemCode)){
				Game.currentGame.textBox.textBaker.pushArray(["아이템 획득했습니다", _itemCode+"번 아이템!!"]);
				this.parent.removeChild(this);
				Game.currentGame.world.removeEventListener(MapEvent.MOVE_MAP, moveMapHandler);
			}
		}
		
		private function moveMapHandler(e:MapEvent):void {
			if(Game.currentGame.world.currentFrame == _mapCode){
				this.visible = true;
			} else {
				this.visible = false;
			}
		}

	}
	
}
