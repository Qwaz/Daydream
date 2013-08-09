package game.db {
	
	public class MapDB {
		
		private static var i:int;
		private static var mapArray:Vector.<String>;
		private static var doorData:Object;
		
		{
			mapArray = new Vector.<String>;
			
			for(i=0; i<10; i++)
				mapArray[i] = "";
				
			mapArray[2] = "3-1반 교실";
			mapArray[3] = "테스트용 맵";
			
			doorData = new Object();
			
			doorData.m2d1 = new DoorData(3, 662, 548);
			doorData.m3d1 = new DoorData(2, 678, 434);
		}
		
		public static function getMapName(index:int):String {
			return mapArray[index];
		}
		
		public static function getDoorData(name:String):DoorData {
			return doorData[name];
		}
		
		public static function initData(data:Object):void {
			data.mapCode = 3;
			data.charX = 173;
			data.charY = 286;
		}

	}
	
}
