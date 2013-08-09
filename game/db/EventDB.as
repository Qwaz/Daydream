package game.db {
	
	public class EventDB {
		
		private static var eventData:Object;
		
		{
			eventData = new Object();
			
			eventData.m4CheckPaper = true; //수위실 종이 체크했는지
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
