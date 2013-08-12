package game.map.interactive {
	import game.core.Game;
	import game.core.CollectionViewer;
	
	public class CollectionPoint extends InteractiveObject {
		override public function interact(item:int=0):void {
			if(item == 0){
				CollectionViewer.collectionViewer.open();
			} else {
				Game.currentGame.textBox.textBaker.push("아이템을 사용하기 적합한 장소가 아닌 것 같다.");
			}
			Game.currentGame.character.endInteraction();
		}

	}
	
}
