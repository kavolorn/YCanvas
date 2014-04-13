package 
{
	import flash.geom.Point;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;
	import feathers.themes.MetalWorksMobileTheme;
	
	import sk.yoz.ycanvas.utils.TransformationUtils;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import ycanvas.feathers.components.Marker;
	import ycanvas.feathers.controls.YCanvas;
	
	public class ApplicationView extends LayoutGroup
	{
		[Embed(source="/images/marker.png")]
		private const MARKER_IMAGE:Class;
		
		private var _theme:MetalWorksMobileTheme;
		
		override protected function initialize():void
		{
			_theme = new MetalWorksMobileTheme();
			
			layout = new VerticalLayout();
			(layout as VerticalLayout).horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			(layout as VerticalLayout).verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			
			var position:Point;
			var zoom:uint = 14;
			var coordinates:Array = [62.2447465,25.7472184];
			
			var map:YCanvas = new YCanvas();
			map.width = map.height = 300 * DeviceCapabilities.dpi / 163;
			map.center(coordinates[0], coordinates[1], zoom);
			map.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
			{
				var touch:Touch = event.getTouch(map, TouchPhase.BEGAN);
				if (touch)
				{
					position = new Point(touch.globalX, touch.globalY);
				}
				touch = event.getTouch(map, TouchPhase.MOVED);
				if (touch)
				{
					var current:Point = new Point(touch.globalX, touch.globalY);
					var delta:Point = map.ycanvasbase.globalToCanvas(current).subtract(map.ycanvasbase.globalToCanvas(position));
					var center:Point = new Point(
						map.ycanvasbase.center.x - delta.x, 
						map.ycanvasbase.center.y - delta.y
					);
					TransformationUtils.moveTo(map.ycanvasbase, center);
					map.renderMap();
					position = new Point(touch.globalX, touch.globalY);
				}
			});
			addChild(map);
			
			var marker:Marker = new Marker(
				Texture.fromBitmap(new MARKER_IMAGE(), true, false, 326 / DeviceCapabilities.dpi), 
				new Point(map.long2tile(coordinates[1], 18), map.lat2tile(coordinates[0], 18))
			);
			map.addMarker(marker);
		}
		
		protected override function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			if (sizeInvalid)
			{
				width = stage.stageWidth;
				height = stage.stageHeight;
			}
			
			super.draw();
		}
	}
}