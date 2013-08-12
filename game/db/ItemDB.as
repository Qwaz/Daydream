package game.db {
	
	public class ItemDB {
		
		private static var i:int;
		private static var itemArray:Vector.<ItemData>;
		
		{
			itemArray = new Vector.<ItemData>;
			
			for(i=0; i<20; i++)
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
			
			itemArray[6]._name = '교무실 열쇠';
			itemArray[6]._exp = "열쇠에 조그맣게 '교무실'이라는 글자가 쓰여 있다.";
			itemArray[6]._scale = 0.5;
			
			itemArray[7]._name = '낙하산';
			itemArray[7]._exp = "높은 곳에서 안전하게 내려갈 때 필요하다.";
			itemArray[7]._scale = 1;
			
			itemArray[8]._name = '녹슨 열쇠';
			itemArray[8]._exp = "심하게 녹이 슬어 사용할 수 없을 것 같다.";
			itemArray[8]._scale = 0.5;
			
			itemArray[9]._name = '녹이 제거된 열쇠';
			itemArray[9]._exp = "열쇠의 녹을 제거했다.";
			itemArray[9]._scale = 0.5;
			
			itemArray[10]._name = '염산';
			itemArray[10]._exp = "강력한 산이다. 녹을 제거할 수 있을 것 같다.";
			itemArray[10]._scale = 0.5;
			
			itemArray[11]._name = '일자 드라이버';
			itemArray[11]._exp = "일자 드라이버다. 끝을 어딘가에 끼워 넣을 수 있을 것 같다.";
			itemArray[11]._scale = 0.5;
			
			itemArray[12]._name = '망치';
			itemArray[12]._exp = "못을 박는데 사용되는 망치다.";
			itemArray[12]._scale = 0.5;
			
			itemArray[13]._name = '열쇠뭉치';
			itemArray[13]._exp = "수위아저씨의 열쇠뭉치다. 양호실, 1학년 교실, 지하창고라는 문구가 보인다.";
			itemArray[13]._scale = 0.5;
			
			itemArray[14]._name = '천막용 천';
			itemArray[14]._exp = "천막을 치는데 사용되는 천이다. 가볍고 튼튼하다.";
			itemArray[14]._scale = 1;
			
			itemArray[15]._name = '검은색 열쇠';
			itemArray[15]._exp = "손잡이 부분이 검은 열쇠다.";
			itemArray[15]._scale = 0.5;
			
			itemArray[16]._name = '도끼';
			itemArray[16]._exp = "나무 뿌리 등을 자를 수 있을 것 같다.";
			itemArray[16]._scale = 0.5;
		}
		
		public static function getItemData(index:int):ItemData {
			return itemArray[index];
		}
		
		public static function initData(data:Object):void {
			data.slot1 = 0;
			data.slot2 = 0;
			data.slotUpgrade = false;
			
			data.itemPosition = new Array();
			
			data.itemPosition.push({mapCode:4, itemCode:6, x:324, y:287});
			data.itemPosition.push({mapCode:4, itemCode:8, x:1035, y:434});
			data.itemPosition.push({mapCode:13, itemCode:10, x:385, y:443});
			data.itemPosition.push({mapCode:26, itemCode:14, x:767, y:542});
		}

	}
	
}
