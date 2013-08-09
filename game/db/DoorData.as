package game.db {
	
	public class DoorData {
		
		private var _destMap:int, _destX:Number, _destY:Number;
		
		public function DoorData(destMap:int, destX:Number, destY:Number){
			_destMap = destMap;
			_destX = destX;
			_destY = destY;
		}
		
		public function get destMap():int {
			return _destMap;
		}
		
		public function get destX():Number {
			return _destX;
		}
		
		public function get destY():Number {
			return _destY;
		}

	}
	
}
