package ycanvas.feathers.display.interfaces
{
	import sk.yoz.ycanvas.interfaces.IYCanvasRoot;
	
	import ycanvas.feathers.components.Marker;
	
	public interface IYCanvasRoot extends sk.yoz.ycanvas.interfaces.IYCanvasRoot
	{
		function addMarker(marker:Marker):void;
		function removeMarkers():void;
		function removeMarker(marker:Marker):void;
	}
}