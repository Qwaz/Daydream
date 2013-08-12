package game.db {
	
	public class EventDB {
		
		private static var eventData:Object;
		
		{
			eventData = new Object();
			
			eventData.itemFirst = true; //아이템 최초 획득
			eventData.acidFirst = true; //염산 최초 획득
			
			eventData.m2m1 = true; //운동장 독백 1
			eventData.m2m2 = true; //운동장 독백 2
			
			eventData.m3stair = true; //계단 무너진 것 확인
			eventData.m3teacherDoor = true; //교무실 문 잠김
			eventData.m3down = true; //지하창고 문 열렸는지
			
			eventData.m4enter = true; //수위실 입장 이벤트
			eventData.m4CheckPaper = true; //수위실 종이 체크했는지
			
			eventData.m7enter = true; //교무실 입장 이벤트
			eventData.m7collapse = true; //교무실 독백
			
			eventData.m22window = true; //깨진 창문 확인 이벤트
			
			eventData.m25pillar = true; //기둥에 로프를 걸어놨는지
			
			eventData.m26toolbox = true; //지하창고에서 공구상자 획득
		}
		
		public static function initData(data:Object):void {
			if(!data.event){
				data.event = new Object();
			}
			
			var name:String;
			for(name in eventData){
				if(!data.event[name]){
					data.event[name] = false;
				}
			}
		}

	}
	
}
