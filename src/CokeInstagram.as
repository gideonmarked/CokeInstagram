package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	import states.StatesMaster;
	
	[SWF(backgroundColor="0xdd0519",width="1080",height="1920")]
	public class CokeInstagram extends Sprite
	{
		private var mainStarling:Starling;
		public function CokeInstagram()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			Starling.multitouchEnabled = true;
			
			mainStarling = new Starling( StatesMaster , stage);
			mainStarling.antiAliasing = 1;
			mainStarling.start();
		}
	}
}