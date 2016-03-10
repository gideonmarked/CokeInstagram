package states
{
	import aze.motion.easing.Bounce;
	import aze.motion.eaze;
	
	import com.adobe.images.JPGEncoder;
	import com.grinkomeda.interactive.CameraView;
	
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import org.ascollada.namespaces.collada;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class CameraState extends Sprite
	{
		private var cameraButton:Sprite;
		private var cameraView:CameraView;
		private var topQuad:Quad;
		private var bottomQuad:Quad;
		private var backQuad:Quad;
		private var count:Number = 5;
		private var timer:Timer;
		private var countWrapper:Sprite;
		private var countLabel:TextField;
		public function CameraState()
		{
			this.addEventListener( Event.ADDED_TO_STAGE , initialize );
		}
		
		private function initialize( event:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE , initialize )
			
			createArt();
		}
		
		private function createArt():void
		{
			var bottomColor:uint = 0xcccccc; // blue
			var topColor:uint    = 0x444444; // red
			
			backQuad = new Quad( 1080 * Assets.aspect, 1920 * Assets.aspect, 0xffffff );
			addChild( backQuad );
			Assets.centerDisplay( backQuad, stage );
			
			
			setupCamera();
			
			
//			topQuad = new Quad( 1080 * Assets.aspect,  130 * Assets.aspect);
//			topQuad.setVertexColor(0, topColor);
//			topQuad.setVertexColor(1, topColor);
//			topQuad.setVertexColor(2, bottomColor);
//			topQuad.setVertexColor(3, bottomColor);
//			addChild( topQuad );
//			topQuad.alpha = 0.9;
//			Assets.centerDisplay( topQuad, stage );
			
			bottomQuad = new Quad( 1080 * Assets.aspect, ( 1920 - 1620 ) * Assets.aspect );
			bottomQuad.setVertexColor(0, topColor);
			bottomQuad.setVertexColor(1, topColor);
			bottomQuad.setVertexColor(2, bottomColor);
			bottomQuad.setVertexColor(3, bottomColor);
			bottomQuad.alpha = 0.7;
			Assets.centerDisplay( bottomQuad, stage );
			bottomQuad.y = 1920 * Assets.aspect - bottomQuad.height;
			addChild( bottomQuad );
			
			cameraButton = new Sprite();
			cameraButton.addChild( new Image( Assets.assetsManager.getTexture( "capture_button" ) ) );
			Assets.fixScale( cameraButton.getChildAt(0) );
			cameraButton.getChildAt(0).x -= cameraButton.getChildAt(0).width / 2;
			cameraButton.getChildAt(0).y -= cameraButton.getChildAt(0).height / 2;
			cameraButton.scaleX = cameraButton.scaleY = 0.8;
			cameraButton.x = stage.stageWidth / 2;
			cameraButton.y = bottomQuad.y + 300 / 2 * Assets.aspect;
			addChild(cameraButton);
			startInteractive();
		}
		
		private function setupCamera():void
		{
			cameraView = new CameraView(); // Get default camera.
			cameraView.init(new Rectangle(0, 0, 1620 * Assets.aspect, 1620 * Assets.aspect), 60, 1, false);
			cameraView.reflect();
			cameraView.x = stage.stageWidth / 2 - 1620 * Assets.aspect / 2;
			addChild(cameraView);
			cameraView.selectCamera(0);
		}
		
		private function startInteractive():void
		{
			cameraButton.addEventListener( TouchEvent.TOUCH , onTouch );
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch( this );
			if( touch )
			{
				switch( touch.phase  )
				{
					case TouchPhase.BEGAN:
					{
						cameraButton.removeEventListener( TouchEvent.TOUCH , onTouch );
						
						timer = new Timer(1000,5);
						timer.start();
						timer.addEventListener( TimerEvent.TIMER , onTimer );
						timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
						countWrapper = new Sprite();
						countWrapper.addChild( new Image( Assets.assetsManager.getTexture( "countdown_bg" ) ) );
						Assets.fixScale( countWrapper.getChildAt(0) );
						countWrapper.getChildAt(0).x -= countWrapper.getChildAt(0).width / 2;
						countWrapper.getChildAt(0).y -= countWrapper.getChildAt(0).height / 2;
						countWrapper.x = stage.stageWidth / 2;
						countWrapper.y = 622 * Assets.aspect + countWrapper.getChildAt(0).height / 2;
						countLabel = new TextField( countWrapper.getChildAt(0).width , countWrapper.getChildAt(0).height, "" + count, "Verdana", 200 * Assets.aspect,0xdd0519, true );
						countLabel.x = countWrapper.getChildAt(0).x;
						countLabel.y = countWrapper.getChildAt(0).y;
						countLabel.hAlign = HAlign.CENTER;
						countLabel.vAlign = VAlign.CENTER;
						countWrapper.addChild( countLabel );
						addChild(countWrapper);
						eaze( countWrapper ).from( 0.2, {scaleX: 0.1,scaleY: 0.1 }).to( 0.3, {scaleX: scaleX, scaleY: scaleY})
							.chain( countWrapper ).to( 0.3, {scaleX: 0.1, scaleY: 0.1});
						break;
					}
				}
			}
		}
		
		private function onTimerComplete(event:TimerEvent):void
		{
			timer.removeEventListener( TimerEvent.TIMER , onTimer );
			timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			removeChild( cameraButton );
			removeChild( topQuad );
			removeChild( bottomQuad );
			removeChild( backQuad );
			removeChild( countWrapper );
			saveImage();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			if(count > 1) {
				count--;
				countLabel.text = "" + count;
				eaze( countWrapper ).from( 0.2, {scaleX: 0.1,scaleY: 0.1 }).to( 0.3, {scaleX: 1, scaleY:1})
					.chain( countWrapper ).to( 0.3, {scaleX: 0.1, scaleY: 0.1});
			}
		}
		
		private function saveImage():void
		{		
			var jpg:JPGEncoder = new JPGEncoder(100);
//			var ba:ByteArray  = jpg.encode( Starling.current.stage.drawToBitmapData( new BitmapData( 1080*Assets.aspect,1920*Assets.aspect ) ) );
			
//			var file:File = File.desktopDirectory.resolvePath("CokePhoto");
//			var now:Date = new Date();
//			var timestamp:String = now.valueOf().toString();
//			file = File.desktopDirectory.resolvePath("CokePhoto/" + " " + timestamp + "_image.png");
//			Assets.imageFile = timestamp + "_image.png";
//			var stream:FileStream = new FileStream();
//			stream.open(file, FileMode.WRITE);
//			stream.writeBytes(ba,0,ba.length);
//			stream.close();
			
			Assets.imageFile = Starling.current.stage.drawToBitmapData( new BitmapData( 1080*Assets.aspect,1620*Assets.aspect ) );
			removeChild( cameraView );
			StatesMaster(parent).NEXT_STATE = "selection";
			dispatchEvent( new Event( StatesMaster.SWITCH ) );
		}
	}
}