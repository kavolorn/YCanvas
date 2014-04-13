package ycanvas.feathers.components
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Marker extends Image
	{
		public static var markerScale:Number = 1;
		
		protected var location:Point;
		private var _canvasCenter:Point;
		
		public function Marker(texture:Texture, location:Point)
		{
			this.location = location;
			super(texture);
			alignPivot("center", "center");
		}
		
		public function set canvasCenter(value:Point):void
		{
			x = location.x - value.x;
			y = location.y - value.y;
		}
		
		public function set canvasScale(value:Number):void
		{
			scaleX = scaleY = 1 / value * markerScale;
		}
		
		public function set canvasRotation(value:Number):void
		{
			rotation = -value;
		}
	}
}