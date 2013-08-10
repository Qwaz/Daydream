package game.db {
	
	public class MapDB {
		
		private static var i:int;
		private static var mapArray:Vector.<String>;
		private static var doorData:Object;
		
		{
			mapArray = new Vector.<String>;
			
			for(i=0; i<10; i++)
				mapArray[i] = "";
				
			mapArray[2] = "운동장";
			mapArray[3] = "1층 복도";
			mapArray[4] = "수위실";
			mapArray[5] = "3-1반 교실";
			mapArray[6] = "1층 화장실";
			mapArray[7] = "중앙 교무실";
			
			
			doorData = new Object();
			
			doorData.m3d1 = new DoorData(4, 468, 396);
			doorData.m3d2 = new DoorData(5, -124, 392);
			doorData.m3d3 = new DoorData(5, 1084, 392);
			doorData.m3d4 = new DoorData(6, 212, 456);
			
			doorData.m4d1 = new DoorData(3, -1464, 492);
			
			doorData.m5d1 = new DoorData(3, -1056, 478);
			doorData.m5d2 = new DoorData(3, 184, 478);
		}
		
		public static function getMapName(index:int):String {
			return mapArray[index];
		}
		
		public static function getDoorData(name:String):DoorData {
			return doorData[name];
		}
		
		public static function initData(data:Object):void {
			data.mapCode = 3;
			data.charX = 1052;
			data.charY = 454;
		}

	}
	
}
