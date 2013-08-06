package game.map {
	import game.core.Game;
	
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
		}
		
		override public function interact():void {
			if(Game.currentGame.itemManager.getItem(_itemCode)){
				Game.currentGame.textBox.textBaker.pushArray(["아이템 획득했습니다", _itemCode+"번 아이템!!"]);
				this.parent.removeChild(this);
			}
		}

	}
	
}
