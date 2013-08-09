package game.core {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import com.greensock.TweenNano;
	
	import game.db.CollectionData;
	import game.db.CollectionDB;
	
	public class CollectionViewer extends Sprite {
		
		private static const
		STORY:int = 0,
		EXTRA:int = 1;
		
		private static const
		PAGE:int = 4;
		
		public static var collectionNotify:CollectionNotify;
		
		private var _mode:int = STORY;
		
		private var storyPage:int, extraPage:int, storyMax:int, extraMax:int;
		
		private var so:SharedObject;

		public function CollectionViewer() {
			Game.collectionViewer = this;
			
			alpha = 0;
			this.visible = false;
			
			so = SharedObject.getLocal("DaydreamCollection", "/");
			
			CollectionDB.initData(so.data);
			
			storyButton.buttonMode = true;
			extraButton.buttonMode = true;
			
			storyPage = 1;
			extraPage = 1;
			
			storyMax = (CollectionDB.storyLength()-1)/PAGE+1;
			extraMax = (CollectionDB.extraLength()-1)/PAGE+1;
			
			storyButton.addEventListener(MouseEvent.CLICK, changeMode);
			extraButton.addEventListener(MouseEvent.CLICK, changeMode);
			
			prevButton.addEventListener(MouseEvent.CLICK, movePage);
			nextButton.addEventListener(MouseEvent.CLICK, movePage);
			
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
			
			updateCollections();
		}
		
		private function updateCollections():void {
			var i:int, nowPage:int, maxPage:int;
			
			if(_mode == STORY){
				storyButton.gotoAndStop(2);
				extraButton.gotoAndStop(1);
				
				nowPage = storyPage;
				maxPage = storyMax;
				
				for(i=0; i<PAGE; i++){
					displayCollections(this["collection"+i], CollectionDB.getStoryCollection((nowPage-1)*PAGE+i));
				}
			} else if(_mode == EXTRA){
				storyButton.gotoAndStop(1);
				extraButton.gotoAndStop(2);
				
				nowPage = extraPage;
				maxPage = extraMax;
				
				for(i=0; i<PAGE; i++){
					displayCollections(this["collection"+i], CollectionDB.getExtraCollection((nowPage-1)*PAGE+i));
				}
			}
			
			page.text = nowPage+" / "+maxPage;
		}
		
		private function displayCollections(target:Object, name:String):void {
			if(name == ""){
				target.visible = false;
			} else {
				target.visible = true;
				
				var data:CollectionData = CollectionDB.getCollection(name);
				
				var now:int=so.data[name], max:int=data.num;
				
				target.title.text = data.title;
				target.description.text = now==max?data.description:"아직 획득하지 못한 컬렉션입니다.";
				
				target.percent.text = now+" / "+max;
				target.percentBar.scaleX = Number(now)/max;
				if(now == max) target.percentBar.gotoAndStop(2);
				else target.percentBar.gotoAndStop(1);
			}
		}
		
		private function changeMode(e:MouseEvent):void {
			if(e.target == storyButton){
				_mode = STORY;
			} else if(e.target == extraButton){
				_mode = EXTRA;
			}
			
			updateCollections();
		}
		
		private function movePage(e:MouseEvent):void {
			if(e.target == prevButton){
				if(_mode == STORY){
					if(storyPage > 1) storyPage--;
				} else if(_mode == EXTRA){
					if(extraPage > 1) extraPage--;
				}
			} else if(e.target == nextButton){
				if(_mode == STORY){
					if(storyPage < storyMax) storyPage++;
				} else if(_mode == EXTRA){
					if(extraPage < extraMax) extraPage++;
				}
			}
			
			updateCollections();
		}
		
		public function collect(name:String):void {
			var data:CollectionData = CollectionDB.getCollection(name);
			
			var max:int=data.num;
			if(so.data[name] == max){
				//이미 얻은 콜렉션
			} else {
				so.data[name]++;
				if(so.data[name] == max){
					//콜렉션 획득
					collectionNotify.title.text = data.title;
					collectionNotify.notify();
				}
			}
			so.flush();
			
			updateCollections();
		}

		public function open():void {
			updateCollections();
			
			this.visible = true;
			TweenNano.to(this, 0.7, {alpha:1});
			
			collect("eCollection");
		}
		
		public function close():void {
			if(Game.currentGame) Game.currentGame.character.endInteraction();
			TweenNano.to(this, 0.7, {alpha:0, onComplete:invisible});
		}
		
		private function invisible():void {
			this.visible = false;
		}
		
		private function closeButtonClickHandler(e:MouseEvent):void {
			close();
		}
	}
	
}
