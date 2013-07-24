package  game.item {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	
	public class ItemManager extends MovieClip {
		
		private var _slot1:int = 3;
		private var _slot2:int = 4;
		private var _upgrade:Boolean = true
		private var name_txt:TextField = new TextField();
		private var exp_txt:TextField = new TextField();
		private var name_format:TextFormat = new TextFormat();
		
		private var itemArray:Array = new Array(10);

		public function ItemManager(){
			var i:int;
			for(i=0;i<10;i++)
				itemArray[i] = new Object();
			
			name_format.align = 'center';
			name_format.size = 20;
			name_format.bold = true;
			name_txt.type = 'dynamic';
			name_txt.mouseEnabled = false;
			name_txt.autoSize = 'center';
			exp_txt.type = 'dynamic';
			exp_txt.mouseEnabled = false;
			exp_txt.wordWrap = true;
			
			itemArray[1].name = '로프';
			itemArray[1].exp = '어딘가에 매달아 오르내릴 수 있다.';
			
			itemArray[2].name = '갈고리';
			itemArray[2].exp = '끝이 날카롭고 튼튼한 갈고리.';
			
			itemArray[3].name = '갈고리 묶은 로프';
			itemArray[3].exp = '던져서 어딘가에 고정시킬 수 있다.';
			
			itemArray[4].name = '손전등';
			itemArray[4].exp = '어두운 곳을 밝힐 수 있다.';
			
			itemArray[5].name = '건전지';
			itemArray[5].exp = '힘세고 오래가는 건전지!';
			
			itemArray[6].name = '전구';
			itemArray[6].exp = '220V에서 작동하는 전구이다.';
			
			itemArray[7].name = '낙하산';
			itemArray[7].exp = '공기저항을 크게 만들어 낙하시 종단속도를 작게 한다.';
			
			itemArray[8].name = '장난감 자동차';
			itemArray[8].exp = '무선으로 조종할 수 있는 조그만 자동차.';
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keydownHandler);
			slot1.items.addEventListener(MouseEvent.MOUSE_OVER, mouseoverHandler);
			slot1.items.addEventListener(MouseEvent.MOUSE_OUT, mouseoutHandler);
			
			item_refresh();
		}
		
		private function keydownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.C)
				if(this.currentFrame == 1) switchSlot();
		}
		
		private function mouseoverHandler(e:MouseEvent):void
		{
			explanation.visible = true;
			explanation.x = slot1.x;
			explanation.y = slot1.y + 25;
			name_txt.text = itemArray[_slot1].name;
			exp_txt.text = itemArray[_slot1].exp;
			if(itemArray[_slot1].exp.length > 15) explanation.width = 160+10;
			else if(itemArray[_slot1].exp.length > itemArray[_slot1].name.length) explanation.width = itemArray[_slot1].exp.length*11+10;
			else explanation.width = itemArray[_slot1].name.length*19;
			explanation.height = 17*(1+itemArray[_slot1].exp.length/15) + 40;
			exp_txt.width = explanation.width - 10;
			exp_txt.height = 17*(2+itemArray[_slot1].exp.length/15);
			name_txt.x = slot1.x - name_txt.width/2;
			name_txt.y = explanation.y + 10;
			exp_txt.x = slot1.x - explanation.width/2;
			exp_txt.y = name_txt.y + 25;
			name_txt.setTextFormat(name_format,0,name_txt.length);
			addChild(name_txt);
			addChild(exp_txt);
		}
		
		private function mouseoutHandler(e:MouseEvent):void
		{
			removeChild(name_txt);
			removeChild(exp_txt);
			explanation.visible = false;
		}
		
		public function getItem(code:int):void
		{
			if(_slot1==0){
				_slot1 = code;
			} else if(_slot1!=0 && _slot2!=0){
				return;   //슬롯이 부족
			} else if(_upgrade){
				_slot2 = code;
			}
			item_refresh();
		}
		
		public function throwItem():void
		{
			if(_slot1!=0){
				_slot1 = 0;
				item_refresh();
			} else if(_upgrade&&_slot2!=0){
				_slot2 = 0;
				item_refresh();
			}
		}
		
		public function switchSlot():void
		{
			if(_slot2==0) return;
			else if(_upgrade)
			{
				var temp:int;
				temp = _slot1;
				_slot1 = _slot2;
				_slot2 = temp;
				item_refresh();
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
			item_refresh();
		}
		
		private function item_refresh():void
		{
			if(_upgrade) slot2.visible = true;
			else slot2.visible = false;
			this.slot1.items.gotoAndStop(_slot1+1);
			this.slot2.items.gotoAndStop(_slot2+1);
		}

	}
	
}
