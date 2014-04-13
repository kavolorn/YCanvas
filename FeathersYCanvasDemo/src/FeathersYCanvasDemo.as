package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60")]
	public class FeathersYCanvasDemo extends Sprite
	{
		private var _starling:Starling;
		
		public function FeathersYCanvasDemo()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.loaderInfo.addEventListener(flash.events.Event.COMPLETE, completeHandler);
		}
		
		protected function completeHandler(event:flash.events.Event):void
		{
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			
			_starling = new Starling(ApplicationView, stage);
			Starling.current.enableErrorChecking = false;
			Starling.current.start();
			
			this.stage.addEventListener(flash.events.Event.RESIZE, resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(flash.events.Event.DEACTIVATE, deactivateHandler, false, 0, true);
		}
		
		protected function resizeHandler(event:flash.events.Event):void
		{
			Starling.current.stage.stageWidth = this.stage.fullScreenWidth;
			Starling.current.stage.stageHeight = this.stage.fullScreenHeight;
			
			const viewPort:Rectangle = _starling.viewPort;
			viewPort.width = this.stage.fullScreenWidth;
			viewPort.height = this.stage.fullScreenHeight;
			
			try {
				Starling.current.viewPort = viewPort; 
			} 
			catch(error:Error) {}
		}
		
		protected function deactivateHandler(event:flash.events.Event):void
		{
			if (this.stage) {
				Starling.current.stop();
				this.stage.addEventListener(flash.events.Event.ACTIVATE, activateHandler, false, 0, true);
			}
		}
		
		private function activateHandler(event:flash.events.Event):void
		{
			if (this.stage) {
				this.stage.removeEventListener(flash.events.Event.ACTIVATE, activateHandler);
				Starling.current.start();
			}
		}
	}
}