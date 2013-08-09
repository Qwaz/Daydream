package game.core {
	import flash.display.Sprite;
	import com.greensock.TweenNano;
	
	public class CollectionNotify extends Sprite {

		public function CollectionNotify() {
			this.alpha = 0;
			this.mouseEnabled = false;
			
			CollectionViewer.collectionNotify = this;
		}
		
		public function notify():void {
			this.alpha = 1;
			
			TweenNano.to(this, 0.7, {alpha:0, delay:2});
		}

	}
	
}
