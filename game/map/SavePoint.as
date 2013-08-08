package game.map {
	import game.core.SlotSelector;
	import game.core.Game;
	
	public class SavePoint extends InteractiveObject {
		override public function interact():void {
			Object(root).slotSelector.slotOpen(SlotSelector.SAVE);
		}

	}
	
}
