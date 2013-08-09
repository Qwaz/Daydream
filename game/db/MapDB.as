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
			
			doorData = new Object();
			
			//doorData.m2d1 = new DoorData(3, 662, 548);
			//doorData.m3d1 = new DoorData(2, 678, 434);
			doorData.m4d1 = new DoorData(3, 280, 286);
		}
		
		public static function getMapName(index:int):String {
			return mapArray[index];
		}
		
		public static function getDoorData(name:String):DoorData {
			return doorData[name];
		}
		
		public static function initData(data:Object):void {
			data.mapCode = 4;
			data.charX = 310;
			data.charY = 388;
		}

	}
	
}
