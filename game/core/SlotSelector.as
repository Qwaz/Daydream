package game.core {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import com.greensock.TweenNano;
	
	import game.map.DroppedItem;
	import game.map.InteractiveObject;
	import game.map.map;
	import game.db.MapDB;
	
	public class SlotSelector extends Sprite {
		
		public static const
		WAIT:int=0,
		SAVE:int=1,
		LOAD:int=2;
		
		private var mode:int = WAIT;
		
		public function SlotSelector() {
			Game.slotSelector = this;
			
			alpha = 0;
			this.visible = false;
			
			var i:int;
			for(i=1; i<=8; i++){
				this["slot"+i].descriptionText.text = "슬롯 "+i;
				this["slot"+i].slotNumber = i;
				this["slot"+i].so = SharedObject.getLocal("DaydreamSave"+i, "/");
				this["slot"+i].buttonMode = true;
				this["slot"+i].mouseChildren = false;
				this["slot"+i].addEventListener(MouseEvent.CLICK, slotClickHandler);
			}
			
			updateSlots();
			
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
		}
		
		private function updateSlots():void {
			var i:int;
			for(i=1; i<=8; i++){
				var now:Object = this["slot"+i];
				now.dataText.text = now.so.data.saved?"데이터 존재":"빈 슬롯";
				now.mapText.text = now.so.data.saved?MapDB.getMapName(now.so.data.mapCode):"";
			}
		}
		
		private function slotClickHandler(e:MouseEvent):void {
			if(mode == SAVE){
				saveGame(e.currentTarget.so);
			} else if(mode == LOAD){
				if(e.currentTarget.so.data.saved){
					loadGame(e.currentTarget.so);
				}
			}
		}
		
		private function saveGame(so:SharedObject):void {
			var target:Object = so.data;
			
			target.saved = true;
			
			target.mapCode = Game.currentGame.world.currentFrame;
			target.charX = Game.currentGame.character.relX;
			target.charY = Game.currentGame.character.relY;
			
			target.itemPosition = new Array();
			
			var io:InteractiveObject;
			for each(io in Game.currentGame.mapManager.map::interactiveVector){
				if(io is DroppedItem){
					var dropped:DroppedItem = io as DroppedItem;
					target.itemPosition.push({mapCode:dropped.mapCode, itemCode:dropped.itemCode, x:dropped.x, y:dropped.y, scale:dropped.scaleX});
				}
			}
			
			var name:String;
			for(name in Game.currentGame.event){
				target.event[name] = Game.currentGame.event[name];
			}
			
			target.slot1 = Game.currentGame.itemManager.item1;
			target.slot2 = Game.currentGame.itemManager.item2;
			target.slotUpgrade = Game.currentGame.itemManager.isUpgraded;
			
			so.flush();
			
			close();
		}
		
		private function loadGame(so:SharedObject):void {
			var target:Object = so.data;
			
			close();
			
			new Game(root as MovieClip, target);
		}
		
		public function open(mode:int):void {
			this.visible = true;
			this.mode = mode;
			TweenNano.to(this, 0.7, {alpha:1});
		}
		
		public function close():void {
			if(this.mode == SAVE) Game.currentGame.character.endInteraction();
			this.mode = WAIT;
			TweenNano.to(this, 0.7, {alpha:0, onComplete:invisible});
		}
		
		private function invisible():void {
			this.visible = false;
		}
		
		private function closeButtonClickHandler(e:MouseEvent):void {
			close();
		}

	}
	
}
