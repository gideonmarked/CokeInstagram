package states
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StatesMaster extends Sprite
	{
		private var currentState:Sprite;
		public var selectedItem:String;
		public var commentContent:String;
		public var satisfactionLevel:int;
		public var totalArray:Array;
		
		public var NEXT_STATE:String = "start";
		public static const SWITCH:String = "switch";
		private var soundChannel:SoundChannel;
		private var q:Quad;
		private var b:Button;
		private var s:flash.display.Sprite;
		
		public function StatesMaster()
		{
			selectedItem = "";
			satisfactionLevel = 0;
			totalArray = new Array();
			this.addEventListener( Event.ADDED_TO_STAGE, initialize );
		}
		
		private function initialize():void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, initialize );
			this.addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			Assets.loadAssets();
			Assets.assetsManager.loadQueue(function(ratio:Number):void
			{
				trace("Loading assets, progress:", ratio);
				
				// -> When the ratio equals '1', we are finished.
				if (ratio == 1.0)
				{
					//					soundChannel = Assets.assetsManager.getSound("background").play(0,99);
					Assets.aspect = stage.stageHeight / 1920;
					switchState( new StartState() );
					createHomeButton();
				}
				
			});
		}
		
		private function createHomeButton():void
		{
			s = new flash.display.Sprite();
			s.graphics.beginFill(0x000000, 0);
			s.graphics.drawRect( 0, 0, 100 * Assets.aspect, 100 * Assets.aspect );
			s.graphics.endFill();
			s.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			Starling.current.nativeStage.addChild(s);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			switchState( new StartState() );
		}
		
		private function destroy():void
		{
			this.removeEventListener( Event.REMOVED_FROM_STAGE, destroy );
		}
		
		public function switchState(state:Sprite):void
		{
			if(contains(currentState))
			{
				removeChild(currentState);
				currentState = null;
			}
			currentState = state;
			addChild(currentState);
			currentState.addEventListener( StatesMaster.SWITCH, onSwitchState );
		}
		
		private function onSwitchState(event:Event):void
		{
			switch(NEXT_STATE)
			{
				case "start":
				{
					//					soundChannel.soundTransform.volume = 0;
					switchState( new StartState() );
					break;
				}
					
				case "camera":
				{
					//					soundChannel.soundTransform.volume = 0;
					switchState( new CameraState() );
					break;
				}
					
				case "selection":
				{
					//					soundChannel.soundTransform.volume = 0;
					switchState( new SelectionState() );
					break;
				}
					
				case "result":
				{
					//					soundChannel.soundTransform.volume = 0;
					switchState( new ResultState() );
					break;
				}
			}
		}
	}
}