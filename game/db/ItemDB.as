package game.db {
	
	public class ItemDB {
		
		private static var i:int;
		private static var itemArray:Vector.<ItemData>;
		
		{
			itemArray = new Vector.<ItemData>;
			
			for(i=0; i<10; i++)
				itemArray[i] = new ItemData();
			
			itemArray[1]._name = '로프';
			itemArray[1]._exp = '어딘가에 매달아 오르내릴 수 있다.';
			itemArray[1]._scale = 1;
			
			itemArray[2]._name = '갈고리';
			itemArray[2]._exp = '끝이 날카롭고 튼튼한 갈고리.';
			itemArray[2]._scale = 0.5;
			
			itemArray[3]._name = '갈고리 묶은 로프';
			itemArray[3]._exp = '던져서 어딘가에 고정시킬 수 있다.';
			itemArray[3]._scale = 1;
			
			itemArray[4]._name = '손전등';
			itemArray[4]._exp = '어두운 곳을 밝힐 수 있다.';
			itemArray[4]._scale = 0.5;
			
			itemArray[5]._name = '건전지';
			itemArray[5]._exp = '힘세고 오래가는 건전지!';
			itemArray[5]._scale = 0.5;
			
			itemArray[6]._name = '전구';
			itemArray[6]._exp = '220V에서 작동하는 전구이다.';
			itemArray[6]._scale = 0.5;
			
			itemArray[7]._name = '낙하산';
			itemArray[7]._exp = '공기저항을 크게 만들어 낙하시 종단속도를 작게 한다.';
			itemArray[7]._scale = 0.5;
			
			itemArray[8]._name = '장난감 자동차';
			itemArray[8]._exp = '무선으로 조종할 수 있는 조그만 자동차.';
			itemArray[8]._scale = 0.5;
		}
		
		public static function getItemData(index:int):ItemData {
			return itemArray[index];
		}
		
		public static function initData(data:Object):void {
			data.slot1 = 0;
			data.slot2 = 0;
			data.slotUpgrade = false;
			
			data.itemPosition = new Array();
			
			data.itemPosition.push({mapCode:2, itemCode:5, x:362, y:361, scale:itemArray[5].scale});
		}

	}
	
}
