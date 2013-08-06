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
	
	import flash.geom.Point;
	
	import game.event.GameEvent;
	import flash.text.TextFormatAlign;
	import game.map.DroppedItem;
	
	public class ItemManager extends MovieClip {
		private static const
		SWITCH_KEY:uint = Keyboard.C,
		THROW_KEY:uint = Keyboard.Q;
		
		private var _slot1:int = 2;
		private var _slot2:int = 3;
		private var _upgrade:Boolean = true;
		
		private var name_txt:TextField = new TextField();
		private var exp_txt:TextField = new TextField();
		private var name_format:TextFormat = new TextFormat();
		
		private var itemArray:Vector.<Object> = new Vector.<Object>;

		public function ItemManager(){
			var i:int;
			for(i=0;i<10;i++)
				itemArray[i] = new Object();
			
			name_format.align = TextFormatAlign.CENTER;
			name_format.size = 20;
			name_format.bold = true;
			
			name_txt.type = TextFieldType.DYNAMIC;
			name_txt.mouseEnabled = false;
			name_txt.autoSize = TextFieldAutoSize.CENTER;
			
			exp_txt.type = TextFieldType.DYNAMIC;
			exp_txt.mouseEnabled = false;
			exp_txt.wordWrap = true;
			
			itemArray[1].name = '로프';
			itemArray[1].exp = '어딘가에 매달아 오르내릴 수 있다.';
			itemArray[1].scale = 1;
			
			itemArray[2].name = '갈고리';
			itemArray[2].exp = '끝이 날카롭고 튼튼한 갈고리.';
			itemArray[2].scale = 0.5;
			
			itemArray[3].name = '갈고리 묶은 로프';
			itemArray[3].exp = '던져서 어딘가에 고정시킬 수 있다.';
			itemArray[3].scale = 1;
			
			itemArray[4].name = '손전등';
			itemArray[4].exp = '어두운 곳을 밝힐 수 있다.';
			itemArray[4].scale = 0.5;
			
			itemArray[5].name = '건전지';
			itemArray[5].exp = '힘세고 오래가는 건전지!';
			itemArray[5].scale = 0.5;
			
			itemArray[6].name = '전구';
			itemArray[6].exp = '220V에서 작동하는 전구이다.';
			itemArray[6].scale = 0.5;
			
			itemArray[7].name = '낙하산';
			itemArray[7].exp = '공기저항을 크게 만들어 낙하시 종단속도를 작게 한다.';
			itemArray[7].scale = 0.5;
			
			itemArray[8].name = '장난감 자동차';
			itemArray[8].exp = '무선으로 조종할 수 있는 조그만 자동차.';
			itemArray[8].scale = 0.5;
			
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
			
			name_txt.text = itemArray[_slot1].name;
			exp_txt.text = itemArray[_slot1].exp;
			
			if(itemArray[_slot1].exp.length > 15)
				explanation.width = 160+10;
			else if(itemArray[_slot1].exp.length > itemArray[_slot1].name.length)
				explanation.width = itemArray[_slot1].exp.length*11+10;
			else
				explanation.width = itemArray[_slot1].name.length*19;
			
			explanation.height = 17*(1+itemArray[_slot1].exp.length/15) + 40;
			
			exp_txt.width = explanation.width - 10;
			exp_txt.height = 17*(2+itemArray[_slot1].exp.length/15);
			
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
		
		private function throwItem():void
		{
			var mapCode:int = Game.currentGame.world.currentFrame;
			var itemCode:int = -1;
			
			if(_slot1 != 0){
				itemCode = _slot1;
				_slot1 = 0;
				
				if(_upgrade && _slot2 != 0)
					switchSlot();
			} else if(_upgrade && _slot2 != 0){
				itemCode = _slot2;
				_slot2 = 0;
			}
			
			if(itemCode != -1){
				var dropped:DroppedItem = new DroppedItem(mapCode, itemCode);
				var charPoint:Point = new Point(Game.currentGame.character.x, Game.currentGame.character.y-10);
				charPoint = Game.currentGame.world.globalToLocal(charPoint);
				
				dropped.x = charPoint.x;
				dropped.y = charPoint.y;
				
				dropped.scaleX = dropped.scaleY = itemArray[itemCode].scale;
				
				Game.currentGame.world.addChild(dropped);
				
				refresh();
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
		
		public function useItem():void
		{
			switch(_slot1)
			{
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
		
		private function initedHandler(e:GameEvent):void {
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
