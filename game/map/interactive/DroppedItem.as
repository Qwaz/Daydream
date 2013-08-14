package game.map.interactive {
	import flash.events.Event;
	
	import game.core.CollectionViewer;
	import game.core.Game;
	import game.event.MapEvent;
	import game.db.ItemDB;
	
	public class DroppedItem extends InteractiveObject {
		
		private var _mapCode:int, _itemCode:int;

		public function DroppedItem(mapCode:int, itemCode:int, placeX:Number, placeY:Number) {
			super();
			
			var scale:Number = ItemDB.getItemData(itemCode).scale;
			
			x = placeX;
			y = placeY;
			scaleX = scaleY = scale;
			
			_mapCode = mapCode;
			_itemCode = itemCode;
			
			this.visible = _mapCode == Game.currentGame.world.currentFrame;
			
			var item:Items = new Items();
			item.gotoAndStop(itemCode+1);
			
			this.addChild(item);
			
			Game.currentGame.world.addEventListener(MapEvent.MOVE_MAP, moveMapHandler);
		}
		
		public function get mapCode():int {
			return _mapCode;
		}
		
		public function get itemCode():int {
			return _itemCode;
		}
		
		override public function available():Boolean {
			return this.visible;
		}
		
		override public function interact(item:int=0):void {
			if(item == 0){
				if(Game.currentGame.itemManager.getItem(_itemCode)){
					Game.currentGame.textBox.textBaker.pushArray(["아이템을 획득했습니다.\n"+ItemDB.getItemData(_itemCode).name]);
					if(Game.currentGame.event.itemFirst == false){
						Game.currentGame.event.itemFirst = true;
						Game.currentGame.textBox.textBaker.pushArray(
						["아이템은 W키로 사용할 수 있습니다.",
						"한 번에 하나의 아이템밖에 들고 다닐 수 없습니다. Q키를 눌러 아이템을 내려 놓을 수 있습니다.",
						"오른쪽 위의 아이템창에 마우스를 올려 놓아 아이템의 정보를 확인할 수 있습니다."]);
						CollectionViewer.collectionViewer.collect("eItemFirst");
					}
					this.parent.removeChild(this);
					Game.currentGame.world.removeEventListener(MapEvent.MOVE_MAP, moveMapHandler);
				}
			} else {
				if(_itemCode == 8 && item == 10){
					Game.currentGame.textBox.textBaker.pushArray(
					["염산을 바로 사용할 경우 다칠 수도 있다. 염산을 옮겨 담을 곳이 없을까?"]);
					CollectionViewer.collectionViewer.collect("sDangerAcid");
				} else {
					Game.currentGame.textBox.textBaker.push("아이템 조합에 실패했습니다.");
					CollectionViewer.collectionViewer.collect("eItemFail");
				}
			}
			Game.currentGame.character.endInteraction();
		}
		
		private function moveMapHandler(e:MapEvent):void {
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			this.visible = _mapCode == Game.currentGame.world.currentFrame;
		}

	}
	
}
