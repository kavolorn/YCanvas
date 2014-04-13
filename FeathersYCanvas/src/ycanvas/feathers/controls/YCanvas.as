package ycanvas.feathers.controls
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.core.FeathersControl;
	import feathers.system.DeviceCapabilities;
	
	import sk.yoz.ycanvas.interfaces.ILayer;
	import sk.yoz.ycanvas.interfaces.IPartition;
	import sk.yoz.ycanvas.utils.ILayerUtils;
	import sk.yoz.ycanvas.utils.IPartitionUtils;
	
	import starling.core.Starling;
	
	import ycanvas.feathers.components.Layer;
	import ycanvas.feathers.components.LayerFactory;
	import ycanvas.feathers.components.Marker;
	import ycanvas.feathers.components.Partition;
	import ycanvas.feathers.components.PartitionFactory;
	import ycanvas.feathers.core.AbstractYCanvas;
	import ycanvas.feathers.display.YCanvasRoot;
	
	public class YCanvas extends FeathersControl
	{
		private var _starling:Starling = null;
		
		public var baseLine:Number = 0;
		public var paddingLeft:Number = 0;
		
		private var _root:YCanvasRoot;
		private var _base:AbstractYCanvas;
		
		public function YCanvas(marginOffset:uint = 0, starling:Starling = null):void
		{
			if (starling == null) {
				starling = Starling.current;
			}
			_starling = starling;
			
			_root = new YCanvasRoot();
			_base = new AbstractYCanvas(new Rectangle(0, 0, 100, 100), _root, this._starling, marginOffset);
			_base.partitionFactory = new PartitionFactory();
			_base.layerFactory = new LayerFactory(this._base.partitionFactory);
		}
		
		public function get ycanvasbase():AbstractYCanvas
		{
			return _base;
		}
		
		public function set ycanvasbase(value:AbstractYCanvas):void
		{
			_base = value;
		}
		
		override public function dispose():void
		{
			_base.dispose();
			_root.dispose();
			super.dispose();
		}
		
		override protected function initialize():void
		{
			this.addChild(_root);
		}
		
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			
			if (sizeInvalid)
			{
				this.layout();
			}
		}
		
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if (!needsWidth && !needsHeight)
			{
				return false;
			}
			
			var newWidth:Number = this.explicitWidth;
			if (needsWidth)
			{
				newWidth = 100;
			}
			
			var newHeight:Number = this.explicitHeight;
			if (needsHeight)
			{
				newHeight = 100;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		protected function layout():void
		{
			this._base.viewPort = new Rectangle(0, 0, width, height);
			this.renderMap();
			this.clipRect = new Rectangle(0, 0, width, height);
		}
		
		public function long2tile(lon, zoom):Number 
		{ 
			return (lon+180)/360*Math.pow(2,zoom)*256; 
		}
		
		public function lat2tile(lat, zoom):Number  
		{ 
			return (1-Math.log(Math.tan(lat*Math.PI/180) + 1/Math.cos(lat*Math.PI/180))/Math.PI)/2 *Math.pow(2,zoom)*256; 
		}
		
		public function center(latitude:Number, longitude:Number, zoom:uint):void
		{
			this._base.center = new Point(long2tile(longitude,18), lat2tile(latitude,18));
			this._base.scale = 1 / (1 << ((18 - zoom) - Math.floor(DeviceCapabilities.dpi / 326)));
			validate();
			renderMap();
		}
		
		public function renderMap():void
		{
			this._base.render();
			IPartitionUtils.disposeInvisible(this._base);
			ILayerUtils.disposeEmpty(this._base);
			
			var main:Layer = this._base.layers[this._base.layers.length - 1] as Layer;
			for each (var layer:Layer in this._base.layers)
			{
				(layer == main) ? startLoading(layer) : stopLoading(layer);
			}
		}
		
		private function startLoading(layer:Layer):void
		{
			var partition:Partition;
			var list:Vector.<IPartition> = layer.partitions;
			list.sort(sortByDistanceFromCenter);
			for(var i:uint = 0, length:uint = list.length; i < length; i++)
			{
				partition = list[i] as Partition;
				if(!partition.loading && !partition.loaded)
					partition.load();
			}
		}
		
		private function sortByDistanceFromCenter(partition1:Partition, partition2:Partition):Number
		{
			var x1:Number = partition1.x + partition1.expectedWidth * .5 - ycanvasbase.center.x;
			var y1:Number = partition1.y + partition1.expectedHeight * .5 - ycanvasbase.center.y;
			var x2:Number = partition2.x + partition2.expectedWidth * .5 - ycanvasbase.center.x;
			var y2:Number = partition2.y + partition2.expectedHeight * .5 - ycanvasbase.center.y;
			return (x1 * x1 + y1 * y1) - (x2 * x2 + y2 * y2);
		}
		
		private function stopLoading(layer:Layer):void
		{
			var partition:Partition;
			var list:Vector.<IPartition> = layer.partitions;
			for (var i:uint = 0, length:uint = list.length; i < length; i++)
			{
				partition = list[i] as Partition;
				if (partition.loading) 
				{
					partition.stopLoading();
				}
			}
		}
		
		public function addMarker(marker:Marker):void
		{
			_base.addMarker(marker)
		}
		
		public function removeMarker(marker:Marker):void
		{
			_base.removeMarker(marker);
		}

		public function removeMarkers():void
		{
			_base.removeMarkers();
		}
		
		public function addLayer(layer:ILayer):void
		{
			_root.addLayer(layer);
		}
		
		public function removeLayer(layer:ILayer):void
		{
			_root.removeLayer(layer);
		}
	}
}