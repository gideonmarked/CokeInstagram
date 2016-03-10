package states
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ResultState extends Sprite
	{
		private var background:Image;
		public function ResultState()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, initialize );
		}
		
		private function initialize():void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, initialize );
			createArt();
		}
		
		private function createArt():void
		{
			background = new Image( Assets.assetsManager.getTexture("result") );
			addChild(background);
			background.scaleX = background.scaleY = stage.stageHeight / background.height;
			Assets.centerDisplay( background, stage );
			stage.addEventListener( TouchEvent.TOUCH, onTouch );
		}
		
		private function onTouch( event:TouchEvent ):void
		{
			var touch:Touch = event.getTouch( this, TouchPhase.BEGAN );
			if( touch )
			{
				StatesMaster(parent).NEXT_STATE = "start";
				dispatchEvent( new Event( StatesMaster.SWITCH ) );
			}
		}
		
	}
}