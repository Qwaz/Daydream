package game.db {
	
	public class CollectionDB {
		
		private static var i:int;
		private static var storyCollection:Vector.<String>;
		private static var extraCollection:Vector.<String>;
		
		private static var collectionData:Object;
		
		{
			storyCollection = new Vector.<String>;
			extraCollection = new Vector.<String>;
			
			collectionData = new Object();
			
			addStoryCollection("sTimeCapsule",
							   "타임 캡슐",
							   "10년 전에 옥상에 숨겨 둔 타임 캡슐을 찾기 위해 폐교가 된지 꽤 된 모교로 돌아오게 되었다.",
							   1);
			
			addStoryCollection("sSchool",
							   "폐교",
							   "내가 속한 학년을 마지막으로 우리 학교는 폐교되었다.",
							   1);
			
			addStoryCollection("sStair",
							   "무너진 계단",
							   "1층에서 2층으로 이동하는 계단이 무너져 있다. 이곳으로 올라가는 것은 불가능해 보인다.",
							   1);
			
			addStoryCollection("sSecurity",
							   "수위실",
							   "1층 복도 왼쪽 끝에는 수위실이 있다. 학교 곳곳의 열쇠를 가지고 계신다.",
							   1);
			
			addStoryCollection("sDanger",
							   "붕괴 위험",
							   "수위실에서 다음과 같은 내용이 적힌 종이를 보았다.\n- 지반 조사 결과 위험 판정\n- 벽의 균열 위험 수준",
							   1);
			
			addStoryCollection("sLockedTeacherRoom",
							   "잠긴 교무실 문",
							   "교무실 문이 잠겨 있다. 어딘가에 열쇠가 없을까?",
							   1);
			
			addStoryCollection("sLockedCabinet",
							   "견고한 캐비넷",
							   "수위실의 캐비넷은 녹이 슬어 열리지 않는 것 같다. 틈 사이로 뭔가를 끼워 넣어 힘으로 여는 수 밖에 없는 듯 하다.",
							   1);
			
			addStoryCollection("sTeacherRoom",
							   "교무실",
							   "1층 복도 오른쪽 끝에는 교무실이 있다. 교실 두 개 정도의 크기로, 선생님들의 근무처다.",
							   1);
			
			addStoryCollection("sCollapsion",
							   "붕괴 (1)",
							   "그리 견고하지 못했던 학교 건물이 시간이 지나며 붕괴되었다. 붕괴로 인해 위층과 연결되어버렸다.",
							   1);
			
			addStoryCollection("sRottenKey",
							   "녹슨 열쇠",
							   "녹슨 열쇠를 지하창고로 가는 문에 사용해 보았다. 잠금 장치에는 딱 맞았지만, 심하게 녹이 슬어 문을 열 수는 없었다. 녹을 제거할 방법이 없을까?",
							   1);
			
			addStoryCollection("sScience",
							   "과학실",
							   "여러가지 실험을 할 수 있는 공간이다. 폐교가 되며 많은 기자재들이 사라졌지만 몇몇 약품은 남아있는 듯 하다.",
							   1);
			
			addStoryCollection("sRoot",
							   "나무 뿌리",
							   "지하 창고의 중앙에 나무뿌리가 벽을 뚫고 들어와 통행이 제한되었다.",
							   1);
			
			addStoryCollection("sBallPlay",
							   "공놀이",
							   "1학년때 공을 가지고 놀다가 창문을 깨뜨렸었다. 그때 아마 내가 공을 주워왔던 것 같다.",
							   1);
			
			addExtraCollection("eCollection",
							   "수집가",
							   "콜렉션 페이지를 5회 열어본다.",
							   5);
			
			addExtraCollection("eItemFirst",
							   "아이템 획득",
							   "최초로 아이템을 획득한다.",
							   1);
			
			addExtraCollection("eItemFail",
							   "호기심",
							   "아이템 조합에 실패한다.",
							   1);
			
			addExtraCollection("eItemDrop",
							   "분리수거",
							   "아이템을 100번 내려놓는다.",
							   100);
		}
		
		private static function addStoryCollection(name:String, title:String, description:String, num:int):void {
			addCollection(name, title, description, num);
			
			storyCollection.push(name);
		}
		
		private static function addExtraCollection(name:String, title:String, description:String, num:int):void {
			addCollection(name, title, description, num);
			
			extraCollection.push(name);
		}
		
		private static function addCollection(name:String, title:String, description:String, num:int):void {
			var data:CollectionData = new CollectionData();
			data._title = title;
			data._description = description;
			data._num = num;
			
			collectionData[name] = data;
		}
		
		public static function initData(data:Object):void {
			var name:String;
			for(name in collectionData){
				if(data[name]){
					if(data[name] > collectionData[name].num){
						data[name] = collectionData[name].num;
					}
				} else {
					data[name] = 0;
				}
			}
		}
		
		public static function storyLength():uint {
			return storyCollection.length;
		}
		
		public static function extraLength():uint {
			return extraCollection.length;
		}
		
		public static function getStoryCollection(index:int):String {
			if(storyCollection.length > index) return storyCollection[index];
			else return "";
		}
		
		public static function getExtraCollection(index:int):String {
			if(extraCollection.length > index) return extraCollection[index];
			else return "";
		}
		
		public static function getCollection(name:String):CollectionData {
			return collectionData[name];
		}
	}
	
}
