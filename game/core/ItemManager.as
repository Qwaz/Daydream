package  game.core {
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flash.geom.Point;
	
	import game.event.GameEvent;
	import game.map.interactive.DroppedItem;
	import game.db.ItemDB;
	import game.db.ItemData;
	
	public class ItemManager extends MovieClip {
		private static const
		SWITCH_KEY:uint = Keyboard.C,
		THROW_KEY:uint = Keyboard.Q;
		
		private var _slot1:int = 0;
		private var _slot2:int = 0;
		private var _upgrade:Boolean = true;
		
		private var name_txt:TextField = new TextField();
		private var exp_txt:TextField = new TextField();
		private var name_format:TextFormat = new TextFormat();

		public function ItemManager(){
			name_format.align = TextFormatAlign.CENTER;
			name_format.size = 20;
			name_format.bold = true;
			
			name_txt.type = TextFieldType.DYNAMIC;
			name_txt.mouseEnabled = false;
			name_txt.autoSize = TextFieldAutoSize.CENTER;
			
			exp_txt.type = TextFieldType.DYNAMIC;
			exp_txt.mouseEnabled = false;
			exp_txt.wordWrap = true;
			
			Game.currentGame.addEventListener(GameEvent.INITED, initedHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function keydownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == SWITCH_KEY){
				if(this.currentFrame == 1) switchSlot();
			}
			else if(e.keyCode == THROW_KEY && Game.currentGame.character.getState() == Character.STAY){
				throwItem();
			}
		}
		
		private function mouseoverHandler(e:MouseEvent):void
		{
			explanation.visible = true;
			explanation.x = slot1.x;
			explanation.y = slot1.y + 25;
			
			var slot1Data:ItemData = ItemDB.getItemData(_slot1);
			
			name_txt.text = slot1Data.name;
			exp_txt.text = slot1Data.exp;
			
			if(slot1Data.exp.length > 15)
				explanation.width = 160+10;
			else if(slot1Data.exp.length > slot1Data.name.length)
				explanation.width = slot1Data.exp.length*11+10;
			else
				explanation.width = slot1Data.name.length*19;
			
			explanation.height = 17*(1+slot1Data.exp.length/15) + 40;
			
			exp_txt.width = explanation.width - 10;
			exp_txt.height = 17*(2+slot1Data.exp.length/15);
			
			name_txt.x = slot1.x - name_txt.width/2;
			name_txt.y = explanation.y + 10;
			
			exp_txt.x = slot1.x - explanation.width/2;
			exp_txt.y = name_txt.y + 25;
			name_txt.setTextFormat(name_format, 0, name_txt.length);
			
			addChild(name_txt);
			addChild(exp_txt);
		}
		
		private function mouseoutHandler(e:MouseEvent):void
		{
			removeChild(name_txt);
			removeChild(exp_txt);
			explanation.visible = false;
		}
		
		public function getItem(itemCode:int):Boolean
		{
			if(_slot1==0){
				_slot1 = itemCode;
			} else if(_upgrade && _slot2==0){
				_slot2 = itemCode;
			} else {
				//슬롯 부족
				return false;
			}
			refresh();
			
			return true;
		}
		
		public function useItem():void {
			_slot1 = 0;
			if(_upgrade && _slot2 != 0){
				switchSlot();
			}
			
			refresh();
		}
		
		private function throwItem():void
		{
			CollectionViewer.collectionViewer.collect("eItemDrop");
			
			var mapCode:int = Game.currentGame.world.currentFrame;
			
			if(_slot1 != 0){
				var charPoint:Point = new Point(Game.currentGame.character.x, Game.currentGame.character.y-10);
				charPoint = Game.currentGame.world.globalToLocal(charPoint);
				
				var dropped:DroppedItem = new DroppedItem(mapCode, _slot1, charPoint.x, charPoint.y);
				
				Game.currentGame.world.addChild(dropped);
				
				useItem();
			}
		}
		
		private function switchSlot():void
		{
			if(_slot2==0) return;
			else if(_upgrade)
			{
				var temp:int;
				temp = _slot1;
				_slot1 = _slot2;
				_slot2 = temp;
				refresh();
				this.play();
			}
		}
		
		public function upgrade():void
		{
			_upgrade = true;
			refresh();
		}
		
		private function refresh():void
		{
			if(_upgrade) slot2.visible = true;
			else slot2.visible = false;
			
			this.slot1.items.gotoAndStop(_slot1+1);
			this.slot2.items.gotoAndStop(_slot2+1);
		}
		
		public function get item1():int {
			return _slot1;
		}
		
		public function get item2():int {
			return _slot2;
		}
		
		public function get isUpgraded():Boolean {
			return _upgrade;
		}
		
		private function initedHandler(e:GameEvent):void {
			_upgrade = Game.currentGame.data.slotUpgrade;
			_slot1 = Game.currentGame.data.slot1;
			_slot2 = Game.currentGame.data.slot2;
			
			var itemData:Object;
			for each(itemData in Game.currentGame.data.itemPosition){
				var dropped:DroppedItem = new DroppedItem(itemData.mapCode, itemData.itemCode, itemData.x, itemData.y);
				Game.currentGame.world.addChild(dropped);
			}
			
			refresh();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keydownHandler);
			slot1.items.addEventListener(MouseEvent.MOUSE_OVER, mouseoverHandler);
			slot1.items.addEventListener(MouseEvent.MOUSE_OUT, mouseoutHandler);
			
			Game.currentGame.removeEventListener(GameEvent.INITED, initedHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			Game.currentGame.itemManager = this;
			
			explanation.mouseEnabled = false;
			explanation.visible = false;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function removedFromStageHandler(e:Event):void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keydownHandler);
			slot1.items.removeEventListener(MouseEvent.MOUSE_OVER, mouseoverHandler);
			slot1.items.removeEventListener(MouseEvent.MOUSE_OUT, mouseoutHandler);
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
	}
	
}
