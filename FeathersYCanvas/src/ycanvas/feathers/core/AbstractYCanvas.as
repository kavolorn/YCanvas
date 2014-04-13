package ycanvas.feathers.core
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sk.yoz.ycanvas.AbstractYCanvas;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Stage;
	
	import ycanvas.feathers.components.Marker;
	import ycanvas.feathers.display.interfaces.IYCanvasRoot;
	
	public class AbstractYCanvas extends sk.yoz.ycanvas.AbstractYCanvas
	{
		private var _markers:Vector.<Marker> = new Vector.<Marker>;
		private var _starling:Starling;
		
		public function AbstractYCanvas(viewPort:Rectangle, root:IYCanvasRoot, starling:Starling, marginOffset:uint)
		{
			this._starling = starling;
			this._root = root;
			super(viewPort);
			this.marginOffset = marginOffset;
			centerRoot();
		}
		
		public function get markers():Vector.<Marker>
		{
			return _markers;
		}
		
		public function disposeLayers():void
		{
			while(layers.length)
				disposeLayer(layers[0]);
			while(markers.length)
				removeMarker(markers[0]);
		}
		
		public function addMarker(marker:Marker):void
		{
			(root as IYCanvasRoot).addMarker(marker);
			marker.canvasCenter = center;
			marker.canvasScale = scale;
			marker.canvasRotation = rotation;
			markers.push(marker);
		}
		
		public function removeMarkers():void
		{
			_markers = new Vector.<Marker>;
			(root as IYCanvasRoot).removeMarkers();
		}
		
		public function removeMarker(marker:Marker):void
		{
			(root as IYCanvasRoot).removeMarker(marker);
			markers.splice(markers.indexOf(marker), 1);
		}
		
		override public function set center(value:Point):void
		{
			for(var i:uint = markers.length; i--;)
				markers[i].canvasCenter = value;
			super.center = value;
		}
		
		override public function set scale(value:Number):void
		{
			for(var i:uint = markers.length; i--;)
				markers[i].canvasScale = value;
			super.scale = value;
		}
		
		override public function set rotation(value:Number):void
		{
			for(var i:uint = markers.length; i--;)
				markers[i].canvasRotation = value;
			super.rotation = value;
		}
		
		/**
		 * Returns screenshot
		 */
		override public function get bitmapData():BitmapData
		{
			var width:uint = viewPort.width;
			var height:uint = viewPort.height;
			
			var stage:Stage = _starling.stage;
			var support:RenderSupport = new RenderSupport();
			
			RenderSupport.clear(stage.color, 1.0);
			support.setOrthographicProjection(0, 0, width, height);
			_starling.stage.render(support, 1);
			support.finishQuadBatch();
			
			var result:BitmapData = new BitmapData(width, height, true);
			_starling.context.drawToBitmapData(result);
			
			return result;
		}
	}
}

