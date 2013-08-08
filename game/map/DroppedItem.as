package game.map {
	import flash.events.Event;
	
	import game.core.Game;
	import game.event.MapEvent;
	
	public class DroppedItem extends InteractiveObject {
		
		private var _mapCode:int, _itemCode:int;

		public function DroppedItem(mapCode:int, itemCode:int, placeX:Number, placeY:Number, scale:Number) {
			super();
			
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
		
		override public function interact():void {
			if(Game.currentGame.itemManager.getItem(_itemCode)){
				Game.currentGame.textBox.textBaker.pushArray(["아이템 획득했습니다", _itemCode+"번 아이템!!"]);
				this.parent.removeChild(this);
				Game.currentGame.world.removeEventListener(MapEvent.MOVE_MAP, moveMapHandler);
			}
		}
		
		private function moveMapHandler(e:MapEvent):void {
			this.visible = _mapCode == Game.currentGame.world.currentFrame;
		}

	}
	
}
