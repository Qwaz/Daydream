package game.db {
	
	public class MapDB {
		
		private static var i:int;
		private static var mapArray:Vector.<String>;
		private static var doorData:Object;
		
		{
			mapArray = new Vector.<String>;
			
			for(i=0; i<20; i++)
				mapArray[i] = "";
				
			mapArray[2] = "운동장";
			mapArray[3] = "1층 복도";
			mapArray[4] = "수위실";
			mapArray[5] = "3-1반 교실";
			mapArray[6] = "남자 화장실(1층)";
			mapArray[7] = "교무실";
			mapArray[8] = "2-4반 교실";
			mapArray[9] = "2층 복도";
			mapArray[10] = "3-3반 교실";
			mapArray[11] = "여자 화장실(2층)";
			mapArray[12] = "3-2반 교실";
			mapArray[13] = "과학실";
			mapArray[14] = "3층 복도";
			mapArray[15] = "양호실";
			mapArray[16] = "2-1반 교실";
			mapArray[17] = "남자 화장실(3층)";
			mapArray[18] = "2-2반 교실";
			mapArray[19] = "2-3반 교실";
			
			
			doorData = new Object();
			
			doorData.m3d1 = new DoorData(4, 468, 396);
			doorData.m3d2 = new DoorData(5, -124, 392);
			doorData.m3d3 = new DoorData(5, 1084, 392);
			doorData.m3d4 = new DoorData(6, 561, 472);
			doorData.m3d5 = new DoorData(7, 20, 346);
			doorData.m3d6 = new DoorData(7, 1449, 363);
			doorData.m3down = new DoorData(0, 0, 0);
			
			doorData.m4d1 = new DoorData(3, -1464, 492);
			
			doorData.m5d1 = new DoorData(3, -1056, 478);
			doorData.m5d2 = new DoorData(3, 184, 478);
			
			doorData.m6d1 = new DoorData(3, 619, 509);
			
			doorData.m7d1 = new DoorData(3, 1663, 489);
			doorData.m7d2 = new DoorData(3, 3166, 489);
			doorData.m7d3 = new DoorData(8, 805, 464);
			
			doorData.m8d1 = new DoorData(9, 3092, 440);
			doorData.m8d2 = new DoorData(7, 763, 164);
			
			doorData.m9d1 = new DoorData(8, 52, 454);
			doorData.m9d2 = new DoorData(10, 1128, 498);
			doorData.m9d3 = new DoorData(10, -8, 518);
			doorData.m9d4 = new DoorData(11, 701, 503);
			doorData.m9d5 = new DoorData(12, 1027, 526);
			doorData.m9d6 = new DoorData(12, 0, 523);
			doorData.m9d7 = new DoorData(13, 1275, 539);
			doorData.m9up = new DoorData(14, 883, 451);
			
			doorData.m10d1 = new DoorData(9, 1344, 462);
			doorData.m10d2 = new DoorData(9, 2644, 462);
			
			doorData.m11d1 = new DoorData(9, 281, 444);
			
			doorData.m12d1 = new DoorData(9, -1313, 457);
			doorData.m12d2 = new DoorData(9, -55, 448);
			
			doorData.m13d1 = new DoorData(9, -1733, 475);
			
			doorData.m14d1 = new DoorData(15, 453, 437);
			doorData.m14d2 = new DoorData(16, 84, 524);
			doorData.m14d3 = new DoorData(16, 1217, 535);
			doorData.m14d4 = new DoorData(17, 587, 566);
			doorData.m14d5 = new DoorData(18, -33, 550);
			doorData.m14d6 = new DoorData(19, -28, 545);
			doorData.m14down = new DoorData(9, 741, 476);
			
			doorData.m15d1 = new DoorData(14, -1889, 469);
			
			doorData.m16d1 = new DoorData(14, -1375, 469);
			doorData.m16d2 = new DoorData(14, -97, 467);
			
			doorData.m17d1 = new DoorData(14, 268, 481);
			
			doorData.m18d1 = new DoorData(14, 1263, 473);
			
			doorData.m19d1 = new DoorData(14, 3074, 466);
		}
		
		public static function getMapName(index:int):String {
			return mapArray[index];
		}
		
		public static function getDoorData(name:String):DoorData {
			return doorData[name];
		}
		
		public static function initData(data:Object):void {
			data.mapCode = 9;
			data.charX = 1052;
			data.charY = 454;
		}

	}
	
}
