package game.map {
	import game.core.SlotSelector;
	import game.core.Game;
	
	public class SavePoint extends InteractiveObject {
		override public function interact():void {
			SlotSelector.slotSelector.open(SlotSelector.SAVE);
		}

	}
	
}
