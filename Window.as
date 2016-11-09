package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	//---------------------------------
	import BigTitle;
	//----------------------------
	public class Window extends Sprite {
		private var bigtitle:BigTitle = new BigTitle();	
		
	public function Window() {
			// constructor code
			addChild (bigtitle);
			//bigtitle.addEventListener(MouseEvent.CLICK, generate);
			
		}	
	private function generate(e:MouseEvent):void{
			trace(mouseX);
			trace(mouseY);
		}
	}

}