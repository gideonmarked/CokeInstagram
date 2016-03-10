package states
{

	import aze.motion.eaze;
	
	import com.adobe.images.JPGEncoder;
	import com.facebook.graph.FacebookDesktop;
	import com.facebook.graph.controls.Distractor;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.LocationChangeEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import isle.susisu.twitter.Twitter;
	import isle.susisu.twitter.TwitterRequest;
	import isle.susisu.twitter.events.TwitterErrorEvent;
	import isle.susisu.twitter.events.TwitterRequestEvent;
	
	import org.bytearray.smtp.events.SMTPEvent;
	import org.bytearray.smtp.mailer.SMTPMailer;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class SelectionState extends Sprite
	{
		private var topQuad:Quad;
		private var bottomQuad:Quad;
		private var lineQuad:Quad;
		private var frameFestiveButton:Sprite;
		private var frameConnectedButton:Sprite;
		private var framePumpedButton:Sprite;
		private var frameCoolButton:Sprite;
		private var frameWrapper:Sprite;
		private var effectAmaro:Sprite;
		private var effectClarendon:Sprite;
		private var effectGingham:Sprite;
		private var effectHefe:Sprite;
		private var effectNashville:Sprite;
		private var imageWrapper:Sprite;
		private var mailIcon:Sprite;
		private var mailBox:Sprite;
		private var emailField:flash.text.TextField;
		private var emailFormat:TextFormat;
		private var sendButton:Sprite;
		private var myMailer:SMTPMailer;
		private var imageByteArray:ByteArray;
		private var timestamp:String;
		private var framePumped2Button:Sprite;
		private var effectWrapper:Sprite;
		private var effectViolet:Sprite;
		private var effectSepia:Sprite;
		private var effectRed:Sprite;
		private var effectDarkGreen:Sprite;
		private var festiveLabel:starling.text.TextField;
		private var connectedLabel:starling.text.TextField;
		private var pumpedLabel:starling.text.TextField;
		private var coolLabel:starling.text.TextField;
		private var leftButton:Sprite;
		private var rightButton:Sprite;
		private var sendEmailStatus:starling.text.TextField;
		private var shareIcon:Sprite;
		private var fbIcon:Sprite;
		private var isUploaded:Boolean;
		private var frameFantasticButton:Sprite;
		private var fantasticLabel:starling.text.TextField;
		private var filenumber:uint;
		private var frameAnticipatoryButton:Sprite;
		private var anticipatoryLabel:starling.text.TextField;
		private var amaroLabel:starling.text.TextField;
		private var twitterIcon:Sprite;
		private var twitter:Twitter;
		private var twitterRequest:TwitterRequest;
		private var webView:StageWebView;
		private var twitterUploadEnabled:Boolean;
		public function SelectionState()
		{
			this.addEventListener( starling.events.Event.ADDED_TO_STAGE, initialize );
		}
		
		private function initialize(event:starling.events.Event):void
		{
			this.removeEventListener( starling.events.Event.ADDED_TO_STAGE, initialize );
			twitterUploadEnabled = false;
			createArt();
			createIcons();
		}
		
		private function createArt():void
		{
			imageWrapper = new Sprite();
			var image:Image = new Image( Texture.fromBitmapData( Assets.imageFile ) );
			image.scaleX *= -1;
			image.x += image.width;
			imageWrapper.addChild( image );
			
			addChild(imageWrapper);
			
			imageWrapper.scaleY = imageWrapper.scaleX = ( 1230 / imageWrapper.height ) * Assets.aspect;
			imageWrapper.y = 131 * Assets.aspect;
			Assets.centerDisplay( imageWrapper, stage );
			
			frameWrapper = new Sprite();
			frameWrapper.addChild( new Image( Assets.assetsManager.getTexture( "frame_festive" ) ) );
			Assets.fixScale( frameWrapper.getChildAt(0) );
			frameWrapper.scaleY = frameWrapper.scaleX = ( 1230 / frameWrapper.height ) * Assets.aspect;
			frameWrapper.y = 131 * Assets.aspect;
			Assets.centerDisplay( frameWrapper, stage );
			addChild(frameWrapper);
			
			topQuad = new Quad( 1080 * Assets.aspect , 131 * Assets.aspect, 0xdd0519 );
			Assets.centerDisplay( topQuad, stage );
			topQuad.alpha = 0.75;
			addChild(topQuad);
			
			bottomQuad = new Quad( 1080 * Assets.aspect , 560 * Assets.aspect, 0xdd0519 );
			Assets.centerDisplay( bottomQuad, stage );
			bottomQuad.y = 1950 * Assets.aspect - bottomQuad.height;
			bottomQuad.alpha = 0.75;
			addChild(bottomQuad);
			
			lineQuad = new Quad( 1080 * Assets.aspect, 7 * Assets.aspect, 0xFFFFFF );
			Assets.centerDisplay( lineQuad, stage );
			lineQuad.y = 1636 * Assets.aspect;
			addChild(lineQuad);
			
			createFrames();
			
			createEffects();
			
			createArrows();
		}
		
		private function createFrames():void
		{
			frameFestiveButton = new Sprite();
			frameFestiveButton.addChild( new Image( Assets.assetsManager.getTexture( "frame_festive_thumb" ) ) );
			Assets.fixScale( frameFestiveButton.getChildAt(0) );
			frameFestiveButton.getChildAt(0).name = "frame_festive";
			festiveLabel = new starling.text.TextField( frameFestiveButton.getChildAt(0).width + 30 * Assets.aspect, 30 * Assets.aspect, "FESTIVE", "Verdana", 18 * Assets.aspect, 0xFFFFFF, true );
			festiveLabel.x = frameFestiveButton.getChildAt(0).width / 2 - festiveLabel.width / 2;
			festiveLabel.y = 140 * Assets.aspect;
			frameFestiveButton.addChild( festiveLabel );
			frameFestiveButton.x = frameWrapper.x;
			frameFestiveButton.y = 1400 *  Assets.aspect;
			frameFestiveButton.addEventListener( TouchEvent.TOUCH, onTouch );
			addChild( frameFestiveButton );
			
			frameConnectedButton = new Sprite();
			frameConnectedButton.addChild( new Image( Assets.assetsManager.getTexture( "frame_connected_thumb" ) ) );
			Assets.fixScale( frameConnectedButton.getChildAt(0) );
			frameConnectedButton.getChildAt(0).name = "frame_connected";
			connectedLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 50 * Assets.aspect, 30 * Assets.aspect, "CONNECTED", "Verdana", 18 * Assets.aspect, 0xFFFFFF, true );
			connectedLabel.x = frameConnectedButton.getChildAt(0).width / 2 - connectedLabel.width / 2;
			connectedLabel.y = 140 * Assets.aspect;
			frameConnectedButton.addChild( connectedLabel );
			frameConnectedButton.x =  (frameWrapper.width - frameConnectedButton.getChildAt(0).width * 6) / 5 * 1 + frameWrapper.x+ frameConnectedButton.getChildAt(0).width;
			frameConnectedButton.y = 1400 *  Assets.aspect;
			frameConnectedButton.addEventListener( TouchEvent.TOUCH, onTouch );
			addChild( frameConnectedButton );
			
			framePumpedButton = new Sprite();
			framePumpedButton.addChild( new Image( Assets.assetsManager.getTexture( "frame_pumped_thumb" ) ) );
			Assets.fixScale( framePumpedButton.getChildAt(0) );
			framePumpedButton.getChildAt(0).name = "frame_pumped";
			pumpedLabel = new starling.text.TextField( framePumpedButton.getChildAt(0).width + 30 * Assets.aspect, 30 * Assets.aspect, "PUMPED", "Verdana", 18 * Assets.aspect, 0xFFFFFF, true );
			pumpedLabel.x = framePumpedButton.getChildAt(0).width / 2 - pumpedLabel.width / 2;
			pumpedLabel.y = 140 * Assets.aspect;
			framePumpedButton.addChild( pumpedLabel );
			framePumpedButton.x = (frameWrapper.width - framePumpedButton.getChildAt(0).width * 6) / 5 * 2 + frameWrapper.x + framePumpedButton.getChildAt(0).width * 2;
			framePumpedButton.y = 1400 *  Assets.aspect;
			framePumpedButton.addEventListener( TouchEvent.TOUCH, onTouch );
			addChild( framePumpedButton );
			
			frameFantasticButton = new Sprite();
			frameFantasticButton.addChild( new Image( Assets.assetsManager.getTexture( "frame_fantastic_thumb" ) ) );
			Assets.fixScale( frameFantasticButton.getChildAt(0) );
			frameFantasticButton.getChildAt(0).name = "frame_fantastic";
			fantasticLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 50 * Assets.aspect, 30 * Assets.aspect, "FANTASTIC", "Verdana", 18 * Assets.aspect, 0xFFFFFF, true );
			fantasticLabel.x = frameFantasticButton.getChildAt(0).width / 2 - fantasticLabel.width / 2;
			fantasticLabel.y = 140 * Assets.aspect;
			frameFantasticButton.addChild( fantasticLabel );
			frameFantasticButton.x = (frameWrapper.width - frameFantasticButton.getChildAt(0).width * 6) / 5 * 3 + frameWrapper.x + frameFantasticButton.getChildAt(0).width * 3;
			frameFantasticButton.y = 1400 *  Assets.aspect;
			frameFantasticButton.addEventListener( TouchEvent.TOUCH, onTouch );
			addChild( frameFantasticButton );
			
			frameCoolButton = new Sprite();
			frameCoolButton.addChild( new Image( Assets.assetsManager.getTexture( "frame_cool_thumb" ) ) );
			Assets.fixScale( frameCoolButton.getChildAt(0) );
			frameCoolButton.getChildAt(0).name = "frame_cool";
			coolLabel = new starling.text.TextField( frameCoolButton.getChildAt(0).width + 30 * Assets.aspect, 30 * Assets.aspect, "COOL", "Verdana", 18 * Assets.aspect, 0xFFFFFF, true );
			coolLabel.x = frameCoolButton.getChildAt(0).width / 2 - coolLabel.width / 2;
			coolLabel.y = 140 * Assets.aspect;
			frameCoolButton.addChild( coolLabel );
			frameCoolButton.x = (frameWrapper.width - frameFantasticButton.getChildAt(0).width * 6) / 5 * 4 + frameWrapper.x + frameFantasticButton.getChildAt(0).width * 4;
			frameCoolButton.y = 1400 *  Assets.aspect;
			frameCoolButton.addEventListener( TouchEvent.TOUCH, onTouch );
			addChild( frameCoolButton );
			
			frameAnticipatoryButton = new Sprite();
			frameAnticipatoryButton.addChild( new Image( Assets.assetsManager.getTexture( "frame_anticipatory_thumb" ) ) );
			Assets.fixScale( frameAnticipatoryButton.getChildAt(0) );
			frameAnticipatoryButton.getChildAt(0).name = "frame_anticipatory";
			anticipatoryLabel = new starling.text.TextField( frameAnticipatoryButton.getChildAt(0).width + 70 * Assets.aspect, 30 * Assets.aspect, "ANTICIPATORY", "Verdana", 18 * Assets.aspect, 0xFFFFFF, true );
			anticipatoryLabel.x = frameAnticipatoryButton.getChildAt(0).width / 2 - anticipatoryLabel.width / 2;
			anticipatoryLabel.y = 140 * Assets.aspect;
			frameAnticipatoryButton.addChild( anticipatoryLabel );
			frameAnticipatoryButton.x = frameWrapper.x + frameWrapper.width - frameAnticipatoryButton.getChildAt(0).width;
			frameAnticipatoryButton.y = 1400 *  Assets.aspect;
			frameAnticipatoryButton.addEventListener( TouchEvent.TOUCH, onTouch );
			addChild( frameAnticipatoryButton );
		}
		
		private function createEffects():void
		{
			//create effects
			
			effectWrapper = new Sprite();
			effectWrapper.x = topQuad.x + 66 * Assets.aspect;
			effectWrapper.y = 1690 * Assets.aspect;
			
			//amaro
			effectAmaro = new Sprite();
			effectAmaro.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectAmaro.addChild( new Image( Assets.assetsManager.getTexture( "effect_amaro" ) ) );
			effectAmaro.getChildAt(1).blendMode = BlendMode.ADD;
			effectAmaro.getChildAt(1).alpha = 0.5;
			effectAmaro.getChildAt(1).name = "effect_amaro";
			effectAmaro.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectAmaro.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "AMARO", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectAmaro.addChild( amaroLabel );
			Assets.fixScale( effectAmaro );
			effectAmaro.x = 20 * 1 * Assets.aspect + effectAmaro.width * 0;
			effectAmaro.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectAmaro );
			
			
			//clarendon
			effectClarendon = new Sprite();
			effectClarendon.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectClarendon.addChild( new Image( Assets.assetsManager.getTexture( "effect_clarendon" ) ) );
			effectClarendon.getChildAt(1).blendMode = BlendMode.SCREEN;
			effectClarendon.getChildAt(1).alpha = 0.5;
			effectClarendon.getChildAt(1).name = "effect_clarendon";
			effectClarendon.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectClarendon.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 100, 30, "CLARENDON", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectClarendon.addChild( amaroLabel );
			Assets.fixScale( effectClarendon );
			effectClarendon.x = 20 * 2 * Assets.aspect + effectAmaro.width * 1;
			effectClarendon.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectClarendon );
			
			//nashville
			effectNashville = new Sprite();
			effectNashville.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectNashville.addChild( new Image( Assets.assetsManager.getTexture( "effect_nashville" ) ) );
			effectNashville.getChildAt(1).blendMode = BlendMode.ADD;
			effectNashville.getChildAt(1).alpha = 0.5;
			effectNashville.getChildAt(1).name = "effect_nashville";
			effectNashville.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectNashville.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 80, 30, "NASHVILLE", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectNashville.addChild( amaroLabel );
			Assets.fixScale( effectNashville );
			effectNashville.x = 20 * 3 * Assets.aspect + effectAmaro.width * 2;
			effectNashville.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectNashville );
			
			
			
			//hefe
			effectHefe = new Sprite();
			effectHefe.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectHefe.addChild( new Image( Assets.assetsManager.getTexture( "effect_hefe" ) ) );
			effectHefe.getChildAt(1).blendMode = BlendMode.MULTIPLY;
			effectHefe.getChildAt(1).alpha = 0.5;
			effectHefe.getChildAt(1).name = "effect_hefe";
			effectHefe.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectHefe.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "HEFE", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectHefe.addChild( amaroLabel );
			Assets.fixScale( effectHefe );
			effectHefe.x = 20 * 4 * Assets.aspect + effectAmaro.width * 3;
			effectHefe.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectHefe );
			
			//gingham
			effectGingham = new Sprite();
			effectGingham.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectGingham.addChild( new Image( Assets.assetsManager.getTexture( "effect_gingham" ) ) );
			effectGingham.getChildAt(1).blendMode = BlendMode.ADD;
			effectGingham.getChildAt(1).alpha = 0.5;
			effectGingham.getChildAt(1).name = "effect_gingham";
			effectGingham.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectGingham.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "GINGHAM", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectGingham.addChild( amaroLabel );
			Assets.fixScale( effectGingham );
			effectGingham.x = 20 * 5 * Assets.aspect + effectAmaro.width * 4;
			effectGingham.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectGingham );
			
			
			
			//violet
			effectViolet = new Sprite();
			effectViolet.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectViolet.addChild( new Image( Assets.assetsManager.getTexture( "effect_sepia" ) ) );
			effectViolet.getChildAt(1).blendMode = BlendMode.SCREEN;
			effectViolet.getChildAt(1).alpha = 0.5;
			effectViolet.getChildAt(1).name = "effect_sepia";
			effectViolet.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectViolet.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "HUDSON", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectViolet.addChild( amaroLabel );
			Assets.fixScale( effectViolet );
			effectViolet.x = 20 * 6 * Assets.aspect + effectAmaro.width * 5;
			effectViolet.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectViolet );
			
			//sepia
			effectSepia = new Sprite();
			effectSepia.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectSepia.addChild( new Image( Assets.assetsManager.getTexture( "effect_violet" ) ) );
			effectSepia.getChildAt(1).blendMode = BlendMode.SCREEN;
			effectSepia.getChildAt(1).alpha = 0.5;
			effectSepia.getChildAt(1).name = "effect_violet";
			effectSepia.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectSepia.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "RISE", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectSepia.addChild( amaroLabel );
			Assets.fixScale( effectSepia );
			effectSepia.x = 20 * 7 * Assets.aspect + effectAmaro.width * 6;
			effectSepia.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectSepia );
			
			//red
			effectRed = new Sprite();
			effectRed.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectRed.addChild( new Image( Assets.assetsManager.getTexture( "effect_red" ) ) );
			effectRed.getChildAt(1).blendMode = BlendMode.SCREEN;
			effectRed.getChildAt(1).alpha = 0.5;
			effectRed.getChildAt(1).name = "effect_red";
			effectRed.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectRed.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "REYES", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectRed.addChild( amaroLabel );
			Assets.fixScale( effectRed );
			effectRed.x = 20 * 8 * Assets.aspect + effectAmaro.width * 7;
			effectRed.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectRed );
			
			//Dark Green
			effectDarkGreen = new Sprite();
			effectDarkGreen.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectDarkGreen.addChild( new Image( Assets.assetsManager.getTexture( "effect_darkgreen" ) ) );
			effectDarkGreen.getChildAt(1).blendMode = BlendMode.MULTIPLY;
			effectDarkGreen.getChildAt(1).alpha = 0.5;
			effectDarkGreen.getChildAt(1).name = "effect_darkgreen";
			effectDarkGreen.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectDarkGreen.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "LARK", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectDarkGreen.addChild( amaroLabel );
			Assets.fixScale( effectDarkGreen );
			effectDarkGreen.x = 20 * 9 * Assets.aspect + effectAmaro.width * 8;
			effectDarkGreen.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectDarkGreen );
			
			
			//repeat *******************
			//amaro
			effectAmaro = new Sprite();
			effectAmaro.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectAmaro.addChild( new Image( Assets.assetsManager.getTexture( "effect_amaro" ) ) );
			effectAmaro.getChildAt(1).blendMode = BlendMode.ADD;
			effectAmaro.getChildAt(1).alpha = 0.5;
			effectAmaro.getChildAt(1).name = "effect_amaro";
			effectAmaro.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectAmaro.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "AMARO", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectAmaro.addChild( amaroLabel );
			Assets.fixScale( effectAmaro );
			effectAmaro.x = 20 * 10 * Assets.aspect + effectAmaro.width * 9;
			effectAmaro.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectAmaro );
			
			
			//clarendon
			effectClarendon = new Sprite();
			effectClarendon.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectClarendon.addChild( new Image( Assets.assetsManager.getTexture( "effect_clarendon" ) ) );
			effectClarendon.getChildAt(1).blendMode = BlendMode.SCREEN;
			effectClarendon.getChildAt(1).alpha = 0.5;
			effectClarendon.getChildAt(1).name = "effect_clarendon";
			effectClarendon.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectClarendon.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 100, 30, "CLARENDON", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectClarendon.addChild( amaroLabel );
			Assets.fixScale( effectClarendon );
			effectClarendon.x = 20 * 11 * Assets.aspect + effectAmaro.width * 10;
			effectClarendon.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectClarendon );
			
			//nashville
			effectNashville = new Sprite();
			effectNashville.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectNashville.addChild( new Image( Assets.assetsManager.getTexture( "effect_nashville" ) ) );
			effectNashville.getChildAt(1).blendMode = BlendMode.ADD;
			effectNashville.getChildAt(1).alpha = 0.5;
			effectNashville.getChildAt(1).name = "effect_nashville";
			effectNashville.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectNashville.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 80, 30, "NASHVILLE", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectNashville.addChild( amaroLabel );
			Assets.fixScale( effectNashville );
			effectNashville.x = 20 * 12 * Assets.aspect + effectAmaro.width * 11;
			effectNashville.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectNashville );
			
			
			
			//hefe
			effectHefe = new Sprite();
			effectHefe.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectHefe.addChild( new Image( Assets.assetsManager.getTexture( "effect_hefe" ) ) );
			effectHefe.getChildAt(1).blendMode = BlendMode.MULTIPLY;
			effectHefe.getChildAt(1).alpha = 0.5;
			effectHefe.getChildAt(1).name = "effect_hefe";
			effectHefe.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectHefe.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "HEFE", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectHefe.addChild( amaroLabel );
			Assets.fixScale( effectHefe );
			effectHefe.x = 20 * 13 * Assets.aspect + effectAmaro.width * 12;
			effectHefe.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectHefe );
			
			//gingham
			effectGingham = new Sprite();
			effectGingham.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectGingham.addChild( new Image( Assets.assetsManager.getTexture( "effect_gingham" ) ) );
			effectGingham.getChildAt(1).blendMode = BlendMode.ADD;
			effectGingham.getChildAt(1).alpha = 0.5;
			effectGingham.getChildAt(1).name = "effect_gingham";
			effectGingham.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectGingham.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "GINGHAM", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectGingham.addChild( amaroLabel );
			Assets.fixScale( effectGingham );
			effectGingham.x = 20 * 14 * Assets.aspect + effectAmaro.width * 13;
			effectGingham.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectGingham );
			
			
			
			//violet
			effectViolet = new Sprite();
			effectViolet.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectViolet.addChild( new Image( Assets.assetsManager.getTexture( "effect_sepia" ) ) );
			effectViolet.getChildAt(1).blendMode = BlendMode.SCREEN;
			effectViolet.getChildAt(1).alpha = 0.5;
			effectViolet.getChildAt(1).name = "effect_sepia";
			effectViolet.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectViolet.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "HUDSON", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectViolet.addChild( amaroLabel );
			Assets.fixScale( effectViolet );
			effectViolet.x = 20 * 15 * Assets.aspect + effectAmaro.width * 14;
			effectViolet.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectViolet );
			
			//sepia
			effectSepia = new Sprite();
			effectSepia.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectSepia.addChild( new Image( Assets.assetsManager.getTexture( "effect_violet" ) ) );
			effectSepia.getChildAt(1).blendMode = BlendMode.SCREEN;
			effectSepia.getChildAt(1).alpha = 0.5;
			effectSepia.getChildAt(1).name = "effect_violet";
			effectSepia.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectSepia.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "RISE", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectSepia.addChild( amaroLabel );
			Assets.fixScale( effectSepia );
			effectSepia.x = 20 * 16 * Assets.aspect + effectAmaro.width * 15;
			effectSepia.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectSepia );
			
			//red
			effectRed = new Sprite();
			effectRed.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectRed.addChild( new Image( Assets.assetsManager.getTexture( "effect_red" ) ) );
			effectRed.getChildAt(1).blendMode = BlendMode.SCREEN;
			effectRed.getChildAt(1).alpha = 0.5;
			effectRed.getChildAt(1).name = "effect_red";
			effectRed.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectRed.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "REYES", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectRed.addChild( amaroLabel );
			Assets.fixScale( effectRed );
			effectRed.x = 20 * 17 * Assets.aspect + effectAmaro.width * 16;
			effectRed.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectRed );
			
			//Dark Green
			effectDarkGreen = new Sprite();
			effectDarkGreen.addChild( new Image( Assets.assetsManager.getTexture( "test" ) ) ) ;
			effectDarkGreen.addChild( new Image( Assets.assetsManager.getTexture( "effect_darkgreen" ) ) );
			effectDarkGreen.getChildAt(1).blendMode = BlendMode.MULTIPLY;
			effectDarkGreen.getChildAt(1).alpha = 0.5;
			effectDarkGreen.getChildAt(1).name = "effect_darkgreen";
			effectDarkGreen.getChildAt(1).width = effectAmaro.getChildAt(0).width;
			effectDarkGreen.getChildAt(1).height = effectAmaro.getChildAt(0).height;
			amaroLabel = new starling.text.TextField( frameConnectedButton.getChildAt(0).width + 70, 30, "LARK", "Verdana", 18, 0xFFFFFF, true );
			amaroLabel.x = effectAmaro.getChildAt(0).width / 2 - amaroLabel.width / 2;
			amaroLabel.y = effectAmaro.getChildAt(0).height;
			effectDarkGreen.addChild( amaroLabel );
			Assets.fixScale( effectDarkGreen );
			effectDarkGreen.x = 20 * 18 * Assets.aspect + effectAmaro.width * 17;
			effectDarkGreen.addEventListener( TouchEvent.TOUCH, onTouchEffect );
			effectWrapper.addChild( effectDarkGreen );
			
			
			addChild(effectWrapper);
		}
		
		private function createIcons():void
		{
			shareIcon = new Sprite();
			var shareQuad:Quad = new Quad( 130, 130, 0xdd0519 );
			shareIcon.addChild( shareQuad );
			shareIcon.addChild( new Image( Assets.assetsManager.getTexture( "share_icon" ) ) );
			Assets.fixScale( shareIcon );
			shareIcon.getChildAt(1).x = shareQuad.width / 2 - shareIcon.getChildAt(1).width / 2;
			shareIcon.getChildAt(1).y = shareQuad.height / 2 - shareIcon.getChildAt(1).height / 2;
			addChild( shareIcon );
			shareIcon.getChildAt(0).name = "share";
			shareIcon.getChildAt(1).name = "share";
			shareIcon.x = frameWrapper.x + frameWrapper.width - shareIcon.width;
			shareIcon.addEventListener( TouchEvent.TOUCH, onShareTouch );
			
			
			mailIcon = new Sprite();
			var mailQuad:Quad = new Quad( 130, 130, 0xdd0519 );
			mailIcon.addChild( mailQuad );
			mailIcon.addChild( new Image( Assets.assetsManager.getTexture( "mail_icon" ) ) );
			Assets.fixScale( mailIcon );
			mailIcon.getChildAt(1).x = mailQuad.width / 2 - mailIcon.getChildAt(1).width / 2;
			mailIcon.getChildAt(1).y = mailQuad.height / 2 - mailIcon.getChildAt(1).height / 2;
			mailIcon.getChildAt(0).name = "email";
			mailIcon.getChildAt(1).name = "email";
			mailIcon.x = shareIcon.x;
			mailIcon.y = shareIcon.height;
			mailIcon.addEventListener( TouchEvent.TOUCH, onShareTouch );
			
			fbIcon = new Sprite();
			var fbQuad:Quad = new Quad( 130, 130, 0xdd0519 );
			fbIcon.addChild( fbQuad );
			fbIcon.addChild( new Image( Assets.assetsManager.getTexture( "facebook_icon" ) ) );
			Assets.fixScale( fbIcon );
			fbIcon.getChildAt(1).x = fbQuad.width / 2 - fbIcon.getChildAt(1).width / 2;
			fbIcon.getChildAt(1).y = fbQuad.height / 2 - fbIcon.getChildAt(1).height / 2;
			fbIcon.getChildAt(0).name = "facebook";
			fbIcon.getChildAt(1).name = "facebook";
			fbIcon.x = mailIcon.x;
			fbIcon.y = mailIcon.height + mailIcon.y;
			fbIcon.addEventListener( TouchEvent.TOUCH, onShareTouch );
			
			twitterIcon = new Sprite();
			var twitterQuad:Quad = new Quad( 130, 130, 0xdd0519 );
			twitterIcon.addChild( twitterQuad );
			twitterIcon.addChild( new Image( Assets.assetsManager.getTexture( "twitter_icon" ) ) );
			Assets.fixScale( twitterIcon );
			twitterIcon.getChildAt(1).x = twitterQuad.width / 2 - twitterIcon.getChildAt(1).width / 2;
			twitterIcon.getChildAt(1).y = twitterQuad.height / 2 - twitterIcon.getChildAt(1).height / 2;
			twitterIcon.getChildAt(0).name = "twitter";
			twitterIcon.getChildAt(1).name = "twitter";
			twitterIcon.x = fbIcon.x;
			twitterIcon.y = fbIcon.height + fbIcon.y;
			twitterIcon.addEventListener( TouchEvent.TOUCH, onShareTouch );
		}
		
		private function createArrows():void
		{
			leftButton = new Sprite();
			var leftQuad:Quad = new Quad( 66 * Assets.aspect, 277 * Assets.aspect, 0xdd0519 );
			leftButton.addChild( leftQuad );
			leftButton.addChild( new Image( Assets.assetsManager.getTexture( "arrow_icon" ) ) );
			leftButton.getChildAt( 1 ).scaleX = leftButton.getChildAt( 1 ).scaleY = Assets.aspect;
			leftButton.getChildAt( 1 ).x = leftQuad.width / 2 - leftButton.getChildAt( 1 ).width / 2;
			leftButton.getChildAt( 1 ).y = leftQuad.height / 2 - leftButton.getChildAt( 1 ).height / 2;
			leftButton.getChildAt( 1 ).name = "left";
			leftButton.x = topQuad.x;
			leftButton.y = stage.stageHeight - leftQuad.height;
			leftButton.addEventListener( TouchEvent.TOUCH , onTouchArrow );
			addChild( leftButton );
			
			rightButton = new Sprite();
			var rightQuad:Quad = new Quad( 66 * Assets.aspect, 277 * Assets.aspect, 0xdd0519 );
			rightButton.addChild( rightQuad );
			rightButton.addChild( new Image( Assets.assetsManager.getTexture( "arrow_icon" ) ) );
			rightButton.getChildAt( 1 ).scaleX = rightButton.getChildAt( 1 ).scaleY = Assets.aspect;
			rightButton.getChildAt( 1 ).scaleX *= -1;
			rightButton.getChildAt( 1 ).x = rightQuad.width / 2 - rightButton.getChildAt( 1 ).width / 2 + rightButton.getChildAt( 1 ).width;
			rightButton.getChildAt( 1 ).y = rightQuad.height / 2 - rightButton.getChildAt( 1 ).height / 2;
			rightButton.getChildAt( 1 ).name = "right";
			rightButton.x = topQuad.width + topQuad.x - rightQuad.width;
			rightButton.y = stage.stageHeight - rightQuad.height;
			rightButton.addEventListener( TouchEvent.TOUCH , onTouchArrow );
			addChild( rightButton );
		}
		
		private function onTouchArrow(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch( this , TouchPhase.BEGAN );
			if(touch){
				switch( touch.target.name )
				{
					case "left":
					{
						effectWrapper.x += 30;
						if(effectWrapper.x > topQuad.x+66*Assets.aspect) {
							effectWrapper.x = topQuad.x+66*Assets.aspect;
						}
						break;
					}
						
					case "right":
					{
						effectWrapper.x -= 30;
						if(effectWrapper.x <  topQuad.x - 66 * Assets.aspect * 2 - (effectWrapper.width - topQuad.width)) {
							effectWrapper.x = topQuad.x - 66 * Assets.aspect * 2 - (effectWrapper.width - topQuad.width);
						}
						break;
					}
				}
			}
		}
		
		private function onTouchEffect(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch( this, TouchPhase.BEGAN );
			if( touch )
			{
				if(imageWrapper.numChildren > 1) {
					imageWrapper.removeChildAt(1);
				}
				imageWrapper.addChild( new Image( Assets.assetsManager.getTexture( touch.target.name ) ) );
				imageWrapper.getChildAt(1).alpha = 0.3;
				imageWrapper.getChildAt(1).width = imageWrapper.getChildAt(0).width;
				imageWrapper.getChildAt(1).height = imageWrapper.getChildAt(0).height;
				imageWrapper.filter = null;
				if( touch.target.name == "effect_willow" ) {
					var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
					colorMatrixFilter.adjustSaturation(-1);
					imageWrapper.filter = colorMatrixFilter;
				}
				
				switch( touch.target.name )
				{
					case "effect_amaro" || "effect_gingham" || "effect_hefe" || "effect_willow":
					{
						imageWrapper.getChildAt(1).blendMode = BlendMode.ADD;
						break;
					}
						
					case "effect_clarendon" ||  "effect_red" || "effect_sepia" || "effect_violet":
					{
						imageWrapper.getChildAt(1).blendMode = BlendMode.SCREEN;
						break;
					}
						
					default:
					{
						imageWrapper.getChildAt(1).blendMode = BlendMode.MULTIPLY;
						break;
					}
				}
			}
		}
		
		
		private function onShareTouch( event:TouchEvent ):void
		{
			var touch:Touch = event.getTouch( this, TouchPhase.BEGAN );
			if( touch )
			{
				switch( touch.target.name )
				{
					case "email":
					{
						if(mailBox == null) {
							mailBox = new Sprite();
							mailBox.addChild( new Image( Assets.assetsManager.getTexture( "email_box" ) ) );
							//				emailField = new TextField( 673, 79, "foo@foo.com", "Verdana", 40 );
							//				emailField.x = mailBox.width / 2 - 673 / 2;
							//				emailField.y = 143;
							//				mailBox.addChild( emailField );
							Assets.fixScale( mailBox );
							mailBox.x = stage.stageWidth / 2 - mailBox.width / 2;
							mailBox.y = stage.stageHeight / 2 - mailBox.height / 2;
							mailBox.filter = BlurFilter.createDropShadow();
							
							sendButton = new Sprite();
							sendButton.addChild( new Image( Assets.assetsManager.getTexture( "send_button" ) ) );
							sendButton.getChildAt( sendButton.numChildren - 1 ).x = 594;
							sendButton.getChildAt( sendButton.numChildren - 1 ).y = 243;
							sendButton.addEventListener( TouchEvent.TOUCH, onSendEmailTouch );
							mailBox.addChild( sendButton );
							
							emailFormat = new TextFormat( "Verdana", 40 * Assets.aspect );
							
							emailField = new flash.text.TextField();
							emailField.defaultTextFormat = emailFormat;
							emailField.text = "";
							emailField.border = true;
							emailField.width = 673 * Assets.aspect;
							emailField.type = TextFieldType.INPUT;
							emailField.height = 79 * Assets.aspect;
							emailField.y = mailBox.y + 143 * Assets.aspect;
							emailField.x = mailBox.x + mailBox.width / 2 - emailField.width / 2;
						}
						addChild( mailBox );
						Starling.current.nativeStage.addChild( emailField );
						Starling.current.nativeStage.focus = emailField;
						removeChild( mailIcon );
						removeChild( fbIcon );
						removeChild( twitterIcon );
						break;
					}
						
					case "facebook":
					{
						removeChild( mailIcon );
						removeChild( fbIcon );
						removeChild( twitterIcon );
						activateFacebook();
						break;
					}
						
					case "twitter":
					{
						removeChild( mailIcon );
						removeChild( fbIcon );
						removeChild( twitterIcon );
						activateTwitter();
						break;
					}
						
					default:
					{
						if( contains( mailIcon ) ){
							removeChild( mailIcon );
							removeChild( fbIcon );
							removeChild( twitterIcon );
						} else {
							addChild( mailIcon );
							addChild( fbIcon );
							addChild( twitterIcon );
						}
						break;
					}
				}
			}
		}
		
		private function activateTwitter():void
		{
			twitter = new Twitter( "0yangWj9bpkpJlzlZQDGzczNa", "sSWvNkardudWDcQINRzg7ADjvo0zfS6RFDH1WLepNDUCEBCVw1", "705077258050883585-jNsAEP213P4CqwGbElsJuaKNazFWvrg", "qYeOUiJ93nKihjhACJkeq7ujONNNMZSoduraS8ybYywfQ" );
			twitterRequest = twitter.oauth_requestToken( );
			twitterRequest.addEventListener(TwitterRequestEvent.COMPLETE, onTwitterComplete);
			twitterRequest.addEventListener(TwitterErrorEvent.CLIENT_ERROR, onOAuthRequestTokenError);
			twitterRequest.addEventListener(TwitterErrorEvent.SERVER_ERROR, onOAuthRequestTokenError);
			twitter.getOAuthAuthorizeURL();
		}
		
		private function onOAuthRequestTokenError(event:TwitterErrorEvent):void
		{
			trace(event.message);
			trace(event.statusCode);
		}
		
		private function onTwitterComplete(event:TwitterRequestEvent):void
		{
			twitterRequest.removeEventListener(TwitterRequestEvent.COMPLETE, onTwitterComplete);
			twitterRequest.removeEventListener(TwitterErrorEvent.CLIENT_ERROR, onOAuthRequestTokenError);
			twitterRequest.removeEventListener(TwitterErrorEvent.SERVER_ERROR, onOAuthRequestTokenError);
			// Open the authorization page in browser
			webView = new StageWebView();
			webView.stage = Starling.current.nativeStage;
			webView.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			webView.loadURL(twitter.getOAuthAuthorizeURL());
			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onWebView );
		}
		
		private function onWebView(event:LocationChangeEvent):void
		{
			if(event.location.search("oauth_token") < 0)
			{
				webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, onWebView );
				webView.dispose();
//				webView = null;
				twitterUploadEnabled = true;
				onWebComplete();
			}
		}
		
		private function onWebComplete(event:flash.events.Event = null):void
		{
			if(twitterUploadEnabled)
			{
				imageWrapper.scaleX = imageWrapper.scaleY = 1;
				
				imageWrapper.y = 0;
				frameWrapper.scaleX = frameWrapper.scaleY = 1;
				frameWrapper.y = 0;
				
				Assets.centerDisplay( imageWrapper, stage );
				Assets.centerDisplay( frameWrapper, stage );
				
				removeChild( topQuad );
				removeChild( bottomQuad );
				removeChild( effectAmaro );
				removeChild( effectGingham );
				removeChild( effectClarendon );
				removeChild( effectHefe );
				removeChild( effectNashville );
				removeChild( lineQuad );
				removeChild( frameConnectedButton );
				removeChild( frameCoolButton );
				removeChild( frameFestiveButton );
				removeChild( frameFantasticButton );
				removeChild( framePumpedButton );
				removeChild( frameAnticipatoryButton );
				removeChild( rightButton );
				removeChild( leftButton );
				removeChild( effectWrapper );
				removeChild( shareIcon );
				
				sendEmailStatus = new starling.text.TextField( topQuad.width, 100 * Assets.aspect, "SENDING PHOTO", "Verdana", 80 * Assets.aspect, 0xFFFFFF );
				addChild( sendEmailStatus );
				sendEmailStatus.bold = true;
				sendEmailStatus.x = topQuad.x;
				sendEmailStatus.y = stage.stageHeight - 100 * Assets.aspect * 2;
				
				eaze( imageWrapper ).to( 0.5 ).onComplete( sendContentTwitter );
			}
		}
		
		private function sendContentTwitter():void
		{
			var data:Object = saveImageData();
			twitterRequest = twitter.statuses_updateWithMedia( "COCA-COLA #TasteTheFeeling photobooth", data.byteArray );
			
			twitterRequest.addEventListener(TwitterRequestEvent.COMPLETE, onTwitterStatusSent);
			twitterRequest.addEventListener(TwitterErrorEvent.CLIENT_ERROR, onOAuthRequestTokenError);
			twitterRequest.addEventListener(TwitterErrorEvent.SERVER_ERROR, onOAuthRequestTokenError);
		}
		
		private function onTwitterStatusSent(event:flash.events.Event):void
		{
//			var urlLoader:URLLoader = new URLLoader(  );
//			urlLoader.load( new URLRequest("https://twitter.com/logout") );
//			urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onStatus );
//			urlLoader.addEventListener(flash.events.Event.COMPLETE, onLogout );
			
			webView = new StageWebView();
			webView.stage = Starling.current.nativeStage;
			webView.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			webView.loadURL("https://twitter.com/logout");
//			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onWebView );
			webView.addEventListener(flash.events.Event.COMPLETE, onLogout );
		}
		
		protected function onStatus(event:HTTPStatusEvent):void
		{
			trace(event.responseURL);
			trace(event.responseHeaders);
			trace(event.status);
		}
		
		protected function onLogout(event:flash.events.Event):void
		{
			trace(webView.location)
//			StatesMaster(parent).NEXT_STATE = "result";
//			dispatchEvent( new starling.events.Event( StatesMaster.SWITCH ) );
		}
		
		private function activateFacebook():void
		{
			FacebookDesktop.manageSession = false;
			FacebookDesktop.init( '197026163987650', handleInit );
			isUploaded = false;
		}
		
		private function handleInit( response:Object, fail:Object ):void
		{
			trace(fail);
			FacebookDesktop.login( handleLogin, ['publish_actions']);
		}
		
		private function  handleLogin( response:Object, fail:Object ):void
		{
			if(response && !isUploaded)
			{
				trace(response);
				
				isUploaded = true;
				
				imageWrapper.scaleX = imageWrapper.scaleY = 1;
				
				imageWrapper.y = 0;
				frameWrapper.scaleX = frameWrapper.scaleY = 1;
				frameWrapper.y = 0;
				
				Assets.centerDisplay( imageWrapper, stage );
				Assets.centerDisplay( frameWrapper, stage );
				
				removeChild( topQuad );
				removeChild( bottomQuad );
				removeChild( effectAmaro );
				removeChild( effectGingham );
				removeChild( effectClarendon );
				removeChild( effectHefe );
				removeChild( effectNashville );
				removeChild( lineQuad );
				removeChild( frameConnectedButton );
				removeChild( frameCoolButton );
				removeChild( frameFestiveButton );
				removeChild( frameFantasticButton );
				removeChild( framePumpedButton );
				removeChild( frameAnticipatoryButton );
				removeChild( rightButton );
				removeChild( leftButton );
				removeChild( effectWrapper );
				removeChild( shareIcon );
				
				sendEmailStatus = new starling.text.TextField( topQuad.width, 100 * Assets.aspect, "SENDING PHOTO", "Verdana", 80 * Assets.aspect, 0xFFFFFF );
				addChild( sendEmailStatus );
				sendEmailStatus.bold = true;
				sendEmailStatus.x = topQuad.x;
				sendEmailStatus.y = stage.stageHeight - 100 * Assets.aspect * 2;
				
				eaze( imageWrapper ).to( 0.5 ).onComplete( sendContentFacebook );
			}
		}
		
		private function sendContentFacebook():void
		{
			var data:Object = saveImageData();
			
			var values:Object = {message:'COCA-COLA #TasteTheFeeling photobooth', fileName: timestamp + ".jpg",image:data.file};
			FacebookDesktop.api('/me/photos', handleUploadComplete, values,'POST');
		}
		
		private function saveImageData():Object
		{
			var jpg:JPGEncoder = new JPGEncoder(100);
			imageByteArray  = jpg.encode( Starling.current.stage.drawToBitmapData( new BitmapData( 1080*Assets.aspect,1620*Assets.aspect ) ) );
			
			var file:File = File.desktopDirectory.resolvePath("CokePhoto");
			file.createDirectory();
			var now:Date = new Date();
			timestamp = now.valueOf().toString();
			filenumber = ( file.exists ? file.getDirectoryListing().length : 0 );
			file = File.desktopDirectory.resolvePath("CokePhoto/" + "tastethefeeling_" + filenumber + ".jpg");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			//			stream.addEventListener(ProgressEvent.PROGRESS, onProgress );
			stream.writeBytes(imageByteArray,0,imageByteArray.length);
			stream.close();
			return {fileName: filenumber, file: file, byteArray: imageByteArray };
		}
		
		private function handleUploadComplete(response:Object, fail:Object):void
		{
			if(response){
				/*
				All the following liners are required to logout successfully.
				*/
				var uri:String = 'http://www.tastethefeeling-photobooth.com/';
				var params:URLVariables = new URLVariables();
				params.next = uri;
				params.access_token = FacebookDesktop.getSession().accessToken;
				
				var req:URLRequest = new URLRequest("https://www.facebook.com/logout.php");
				req.method = URLRequestMethod.GET;
				req.data = params;
				
				var netLoader:URLLoader = new URLLoader();
				netLoader.load(req);
				
				StatesMaster(parent).NEXT_STATE = "result";
				dispatchEvent( new starling.events.Event( StatesMaster.SWITCH ) );
			}
		}
		
		private function onSendEmailTouch( event:TouchEvent ):void
		{
			var touch:Touch = event.getTouch( this, TouchPhase.BEGAN );
			if( touch )
			{
				sendEmail();
			}
		}
		
		private function sendEmail():void
		{
			removeChild( topQuad );
			removeChild( bottomQuad );
			removeChild( mailBox );
			removeChild( effectAmaro );
			removeChild( effectGingham );
			removeChild( effectClarendon );
			removeChild( effectHefe );
			removeChild( effectNashville );
			removeChild( lineQuad );
			removeChild( frameConnectedButton );
			removeChild( frameCoolButton );
			removeChild( frameFestiveButton );
			removeChild( frameFantasticButton );
			removeChild( framePumpedButton );
			removeChild( frameAnticipatoryButton );
			removeChild( mailIcon );
			removeChild( rightButton );
			removeChild( leftButton );
			removeChild( effectWrapper );
			removeChild( shareIcon );
			Starling.current.nativeStage.removeChild( emailField );
			
			imageWrapper.scaleX = imageWrapper.scaleY = 1;
			
			imageWrapper.y = 0;
			frameWrapper.scaleX = frameWrapper.scaleY = 1;
			frameWrapper.y = 0;
			
			sendEmailStatus = new starling.text.TextField( topQuad.width, 100 * Assets.aspect, "SENDING PHOTO", "Verdana", 80 * Assets.aspect, 0xFFFFFF );
			addChild( sendEmailStatus );
			sendEmailStatus.bold = true;
			sendEmailStatus.x = topQuad.x;
			sendEmailStatus.y = stage.stageHeight - 100 * Assets.aspect * 2;
			
			Assets.centerDisplay( imageWrapper, stage );
			Assets.centerDisplay( frameWrapper, stage );
			
			eaze( imageWrapper ).to( 0.5 ).onComplete( sendContentEmail );
		}
		
		private function sendContentEmail():void
		{
			var jpg:JPGEncoder = new JPGEncoder(100);
			imageByteArray  = jpg.encode( Starling.current.stage.drawToBitmapData( new BitmapData( 1080*Assets.aspect,1620*Assets.aspect ) ) );
			
			var file:File = File.desktopDirectory.resolvePath("CokePhoto");
			file.createDirectory();
			var now:Date = new Date();
			filenumber = ( file.getDirectoryListing().length > 0 ? file.getDirectoryListing().length : 0 );
			file = File.desktopDirectory.resolvePath("CokePhoto/" + "tastethefeeling_" + filenumber + ".jpg");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			//			stream.addEventListener(ProgressEvent.PROGRESS, onProgress );
			stream.writeBytes(imageByteArray,0,imageByteArray.length);
			stream.close();
			
			myMailer = new SMTPMailer("mail.tastethefeeling-photobooth.com", 587);
			// register events
			// event dispatched when mail is successfully sent
			myMailer.addEventListener(SMTPEvent.MAIL_SENT, onMailSent);
			// event dispatched when mail could not be sent
			myMailer.addEventListener(SMTPEvent.MAIL_ERROR, onMailError);
			// event dispatched when SMTPMailer successfully connected to the SMTP server
			myMailer.addEventListener(SMTPEvent.CONNECTED, onConnected);
			// event dispatched when SMTP server disconnected the client for different reasons
			myMailer.addEventListener(SMTPEvent.DISCONNECTED, onDisconnected);
			// event dispatched when the client has authenticated successfully
			myMailer.addEventListener(SMTPEvent.AUTHENTICATED, onAuthSuccess);
			// event dispatched when the client could not authenticate
			myMailer.addEventListener(SMTPEvent.BAD_SEQUENCE, onAuthFailed);
			// encode as JPEG with quality 100
			
			myMailer.authenticate('noreply@tastethefeeling-photobooth.com', 'Tma7[$#([b!e' );//'Bqwa%(A.o^CZ');
			
			myMailer.sendAttachedMail('noreply@tastethefeeling-photobooth.com',emailField.text,'COCA-COLA #TasteTheFeeling photobooth','Thanks for capturing your COCA-COLA moment with our #TasteTheFeeling photobooth!\n\nDon\'t forget to share this amazing moment by uploading it online with the hashtag #TasteTheFeeling.',imageByteArray,timestamp +".jpg");
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			trace(event.bytesLoaded / event.bytesTotal);
		}
		
		protected function onImageComplete(event:flash.events.Event):void
		{
			trace('hooray');
			myMailer = new SMTPMailer("mail.waveplayinteractive.com", 587);
			// register events
			// event dispatched when mail is successfully sent
			myMailer.addEventListener(SMTPEvent.MAIL_SENT, onMailSent);
			// event dispatched when mail could not be sent
			myMailer.addEventListener(SMTPEvent.MAIL_ERROR, onMailError);
			// event dispatched when SMTPMailer successfully connected to the SMTP server
			myMailer.addEventListener(SMTPEvent.CONNECTED, onConnected);
			// event dispatched when SMTP server disconnected the client for different reasons
			myMailer.addEventListener(SMTPEvent.DISCONNECTED, onDisconnected);
			// event dispatched when the client has authenticated successfully
			myMailer.addEventListener(SMTPEvent.AUTHENTICATED, onAuthSuccess);
			// event dispatched when the client could not authenticate
			myMailer.addEventListener(SMTPEvent.BAD_SEQUENCE, onAuthFailed);
			// encode as JPEG with quality 100
			
			myMailer.authenticate('noreply@waveplayinteractive.com','Bqwa%(A.o^CZ');
			
			myMailer.sendAttachedMail('noreply@waveplayinteractive.com',emailField.text,'COCA-COLA #TasteTheFeeling photobooth','Thanks for capturing your COCA-COLA moment with our #TasteTheFeeling photobooth!\n\nDon\'t forget to share this amazing moment by uploading it online with the hashtag #TasteTheFeeling.',imageByteArray,timestamp +".jpg");
		}
		
		protected function onAuthFailed(event:SMTPEvent):void
		{
			trace('Auth Failed');
		}
		
		protected function onAuthSuccess(event:SMTPEvent):void
		{
			trace('Auth Success');
		}
		
		protected function onDisconnected(event:SMTPEvent):void
		{
			trace('Disconnected' + event.result.message + '-' + event.result.code);
			sendEmail();
		}
		
		protected function onConnected(event:SMTPEvent):void
		{
			trace('Connected' + event.result.message + '-' + event.result.code);
		}
		
		protected function onMailError(event:SMTPEvent):void
		{
			trace('Mail Error' + event.result.message + '-' + event.result.code);
			if(event.result.code == 250)
			{
				trace('Mail Sent!');
				StatesMaster(parent).NEXT_STATE = "result";
				dispatchEvent( new starling.events.Event( StatesMaster.SWITCH ) );
			}
		}
		
		protected function onMailSent(event:SMTPEvent):void
		{
			trace('Mail Sent!');
			StatesMaster(parent).NEXT_STATE = "result";
			dispatchEvent( new starling.events.Event( StatesMaster.SWITCH ) );
		}
		
		
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch( this, TouchPhase.BEGAN );
			if( touch )
			{
				frameWrapper.removeChildAt(0);
				frameWrapper.addChild( new Image( Assets.assetsManager.getTexture( touch.target.name ) ) );
				Assets.fixScale( frameWrapper.getChildAt(0) );
			}
		}
	}
}