package  {
 
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
 
	import flash.events.Event;
 
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
 
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.ProgressEvent;
	import flash.display.LoaderInfo;
	import flash.display.DisplayObject;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.events.Event;
	import flash.events.MouseEvent;
 
	public class ImageUploader extends Sprite {
 
		//public static const containing all loaded images
		public static var IMAGES:Array = [];
		public var imgd:Boolean=false;
 
		//some event constants
		public static const EVENT_IMAGE_LOADED:String = "eventImageLoaded";
 
		//private vars
		private var bg:Sprite;
		private var uploadbar:Sprite;
		private var label:TextField;
 
		//actual image
		private var _image:Bitmap;
		protected var fileRef:FileReference;
 
		public function ImageUploader() {
 
			/*
			Author: Chrysto Panayotov ( burnandbass [@] gmail [dot] com )
			All images are stored in static ImageUploader.IMAGES array
			you can listen for ImageUploader.EVENT_IMAGE_LOADED event - fired when the image is loaded
 
			usage
 
			var upload1:ImageUploader = new ImageUploader();
			upload1.x = 100;
			upload1.y = 20;
			addChild(upload1);
 
			upload1.addEventListener(ImageUploader.EVENT_IMAGE_LOADED, function():void{
			 var image:Bitmap = upload1.image;
			 image.y = 70;
			 image.x = 10;
			 addChild(image);
			});
 
			*/
 
			this.mouseChildren = false;
			this.buttonMode = true;
			
			bg = new Sprite();
			/*
			bg.graphics.beginFill(0x00ffff,0.7);
			bg.graphics.drawRoundRect(0,0,170,40,10,10);
			bg.graphics.endFill();
			*/
			addChild(bg);
 
			var _format:TextFormat
			_format = new TextFormat();
			_format.font = "Tw Cen MT Condensed Extra Bold";
			_format.color = 0xFFFFFF;
			_format.size = 18;
			_format.align = TextFormatAlign.CENTER;
 
			label = new TextField();
			label.embedFonts = false;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.CENTER;
			label.multiline = false;
			label.cacheAsBitmap = true;
			label.selectable = false;
			label.text = "Upload your map";
			label.defaultTextFormat = _format;
			label.setTextFormat(_format);
 
			label.x = -2;
			label.y = 5;
			label.width = this.width
 
			addChild(label);
			
			uploadbar = new Sprite();
			uploadbar.graphics.beginFill(0xffffff,1);
			uploadbar.graphics.drawRect(0,0,this.width - 30, 2);
			uploadbar.graphics.endFill();
			uploadbar.x = 15;
			uploadbar.y = 30;
			uploadbar.scaleX = 0;
			addChild(uploadbar);
 
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, onFileSelect);
 
			this.addEventListener(MouseEvent.CLICK, chooseFile);
		}
 
		private function chooseFile(event:MouseEvent):void{
			this.removeEventListener(MouseEvent.CLICK, chooseFile);
			label.text = "Map uploading";
			fileRef.browse([new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png, *.JPG)", "*.jpg;*.jpeg;*.gif;*.png; *.JPG")]);
		}
 
		protected function onFileSelect(event:Event):void {					
			this.buttonMode = false;
			fileRef.removeEventListener(Event.SELECT, onFileSelect);
			fileRef.addEventListener(Event.COMPLETE, onFileLoad);
			fileRef.addEventListener(ProgressEvent.PROGRESS, reportProgress);
			fileRef.load();
		}
 
		private function reportProgress(event:ProgressEvent):void{
			this.dispatchEvent(event.clone());
			if(event.bytesLoaded > 1){
				this.alpha = 0.9;
			}
			uploadbar.scaleX = (event.bytesLoaded / event.bytesTotal);
		}
 
		protected function onFileLoad(event:Event):void {
			fileRef.removeEventListener(Event.COMPLETE, onFileLoad);
			var image:Loader = new Loader();
			image.loadBytes(fileRef.data);
			image.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
		}
 
		protected function onImageParse(event:Event):void {
			label.text = "Map uploaded";			
			var content:DisplayObject = LoaderInfo(event.target).content;
			_image = Bitmap(content);
 
			IMAGES.push(_image);
 
			this.dispatchEvent(new Event(ImageUploader.EVENT_IMAGE_LOADED));
 
			//_image.x =0;
			addChild(_image);
			imgd = true;
			//parent.addChild(_image);
		}
 
		//getters
 
		public function get image():Bitmap{
			return _image;
		}
 
	}//end	
}