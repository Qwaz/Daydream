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
			
			addStoryCollection("sObject",
							   "목적",
							   "10년 전에 묻어둔 타임 캡슐을 찾기 위해 폐교가 된지 꽤 된 모교로 돌아오게 되었다.",
							   1);
			
			addStoryCollection("sTimeCapsule",
							   "타임캡슐",
							   "모두가 한 곳에 모여 각자 쓴 편지를 우체통에 넣어 본관 옥상에 숨겨두었다.",
							   1);
			
			addStoryCollection("sSchool",
							   "폐교",
							   "내가 속한 학년을 마지막으로 우리 학교는 폐교되었다.",
							   1);
			
			addStoryCollection("sSecurity",
							   "수위실",
							   "1층 복도 왼쪽 끝에는 수위실이 있다. 학교 곳곳의 열쇠를 가지고 계신다.",
							   1);
			
			addStoryCollection("sTeacherRoom",
							   "교무실",
							   "1층 복도 오른쪽 끝에는 교무실이 있다. 교실 두 개 정도의 크기로, 선생님들의 근무처다.",
							   1);
			
			addExtraCollection("eCollection",
							   "전리품 확인",
							   "콜렉션 페이지를 5회 열어본다.",
							   5);
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
