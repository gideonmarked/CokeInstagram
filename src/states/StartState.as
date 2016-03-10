package states
{

	
	import aze.motion.easing.Bounce;
	import aze.motion.eaze;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class StartState extends Sprite
	{
		private var background:Image;
		private var startButton:Sprite;
		public function StartState()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, initialize );
		}
		
		private function initialize():void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, initialize );
			this.addEventListener( Event.ADDED_TO_STAGE, destroy );
			createArt();
		}
		
		private function destroy(event:Event):void
		{
			while(numChildren > 0){
				removeChild( getChildAt(0) );
			}
		}
		
		private function createArt():void
		{
			background = new Image( Assets.assetsManager.getTexture("cokestart") );
			addChild(background);
			Assets.fixScale( background );
			
			Assets.fixScale( background );
			Assets.centerDisplay( background, stage );
			
			startButton = new Sprite();
			startButton.addChild( new Image( Assets.assetsManager.getTexture( "start_button" ) ) );
			Assets.fixScale( startButton.getChildAt(0) );
			startButton.getChildAt(0).x -= startButton.getChildAt(0).width / 2;
			startButton.getChildAt(0).y -= startButton.getChildAt(0).height / 2;
			startButton.x = stage.stageWidth / 2;
			startButton.y = 1451 * Assets.aspect + startButton.getChildAt(0).height / 2;
			addChild(startButton);
			startButton.addEventListener( TouchEvent.TOUCH , onTouch );
		}
		
		private function onTouch( event:TouchEvent ):void
		{
			var touch:Touch = event.getTouch( this );
			if( touch )
			{
				switch( touch.phase  )
				{
					case TouchPhase.BEGAN:
					{
						startButton.removeEventListener( TouchEvent.TOUCH , onTouch );
						eaze( startButton ).from(0.0, {scaleX: scaleX, scaleY: scaleY}).to( 0.5, {scaleX: 0.2, scaleY: 0.2, alpha: 0} ).easing( Bounce.easeIn ).onComplete( nextScreen );
						break;
					}
				}
			}
		}
		
		private function nextScreen():void
		{
			StatesMaster(parent).NEXT_STATE = "camera";
			dispatchEvent( new Event( StatesMaster.SWITCH ) );
		}
	}
}