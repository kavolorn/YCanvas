package ycanvas.feathers.display
{
	import sk.yoz.ycanvas.interfaces.ILayer;
	import sk.yoz.ycanvas.starling.interfaces.ILayerStarling;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	import ycanvas.feathers.components.Marker;
	import ycanvas.feathers.display.interfaces.IYCanvasRoot;

	public class YCanvasRoot extends Sprite implements IYCanvasRoot
	{
		private var _tilesContainer:Sprite = new Sprite;
		private var _markersContainer:Sprite = new Sprite;
		
		public function YCanvasRoot():void
		{
			addChild(_tilesContainer);
			addChild(_markersContainer);
		}
		
		/**
		 * An internal list of layers.
		 */
		private var _layers:Vector.<ILayer> = new Vector.<ILayer>;
		
		/**
		 * A list of available layers.
		 */
		public function get layers():Vector.<ILayer>
		{
			return _layers;
		}
		
		/**
		 * Indicates both horizontal and vertical scale (percentage) of the 
		 * object.
		 */
		public function set scale(value:Number):void
		{
			scaleX = scaleY = value;
		}
		
		public function addMarker(marker:Marker):void
		{
			_markersContainer.addChild(marker);
		}
		
		public function removeMarkers():void
		{
			while (_markersContainer.numChildren > 0) {
				_markersContainer.removeChildAt(_markersContainer.numChildren - 1);
			}
		}
		public function removeMarker(marker:Marker):void
		{
			_markersContainer.removeChild(marker);
		}
		
		protected function addLayerChild(child:DisplayObject):void
		{
			_tilesContainer.addChild(child);
		}
		
		protected function setLayerChildIndex(child:DisplayObject, index:int):void
		{
			_tilesContainer.setChildIndex(child, index);
		}
		
		protected function removeLayerChild(child:DisplayObject):void
		{
			_tilesContainer.removeChild(child);
		}
		
		/**
		 * A method for adding a layer. A Layer is added at the end of list, 
		 * and with a highest index so it appears on top.
		 */
		public function addLayer(layer:ILayer):void
		{
			var layerStarling:ILayerStarling = layer as ILayerStarling;
			var index:int = layers.indexOf(layer);
			if(index == -1)
			{
				addLayerChild(layerStarling.content);
				layers.push(layer);
			}
			else if(index != layers.length - 1)
			{
				setLayerChildIndex(layerStarling.content, layers.length - 1);
				layers.splice(index, 1);
				layers.push(layer);
			}
		}
		
		/**
		 * A method for removing a layer.
		 */
		public function removeLayer(layer:ILayer):void
		{
			var layerStarling:ILayerStarling = layer as ILayerStarling;
			removeLayerChild(layerStarling.content);
			
			var index:int = layers.indexOf(layer);
			layers.splice(index, 1);
		}
	}
}