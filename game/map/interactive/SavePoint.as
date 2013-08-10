package game.map.interactive {
	import game.core.SlotSelector;
	import game.core.Game;
	
	public class SavePoint extends InteractiveObject {
		override public function interact(item:int=0):void {
			if(item == 0){
				SlotSelector.slotSelector.open(SlotSelector.SAVE);
			}
		}

	}
	
}
