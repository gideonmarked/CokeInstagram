package
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.utils.AssetManager;
	
	public class Assets
	{
		public static var assetsManager:AssetManager;
		public static var aspect:Number = 0;
		public static var resolutionX:Number = 0;
		public static var resolutionY:Number = 0;
		private static var desktop:File;
		private static var graphicFiles:Array;
		private static var soundFiles:Array;
		public static var imageFile:BitmapData;
		public static var finalFile:String;
		public function Assets()
		{
		}
		
		public static function loadAssets():void
		{
			assetsManager = new AssetManager();
			desktop = File.applicationDirectory;
//			assetsManager.enqueue(desktop.resolvePath("assets/audio"));
			assetsManager.enqueue(desktop.resolvePath("assets/graphics"));
//			assetsManager.enqueue(desktop.resolvePath("assets/swfs"));
//			assetsManager.enqueue(desktop.resolvePath("options.xml"));
		}
		
		public static function fixScale( displayObject:DisplayObject ):void
		{
			displayObject.scaleX = displayObject.scaleY = aspect;
		}
		
		public static function centerDisplay( displayObject:DisplayObject, stage:Stage ):void
		{
			displayObject.x = stage.stageWidth / 2 - displayObject.width / 2;
		}
	}
}