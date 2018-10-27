import processing.video.*;
import com.hamoid.*;

import java.util.Date;
import java.text.SimpleDateFormat;

import oscP5.*;
import themidibus.*; 

boolean recording = false;
boolean debug = false;
boolean mouseInput = true;

boolean animating = true;
float lastInputTime = 0;
float timeSinceLastInput = 0;

float time = 0;
int numFrames = 30;

Feedback fb;

float rotation = 0;
float scale = 0.9;
PVector translation = new PVector();

float MIN_SCALE = 0.707;
float MAX_SCALE = 1.1;
float MIN_ROT = -TAU/8;
float MAX_ROT = TAU/8;
float TRANSLATION_RANGE = 0.05;

VideoExport videoExport;
int vidfps = 30;
int recordfps = 15;
int vidFrameNum = 0;

Capture cam;

OscP5 oscP5;
int oscIncomingPort = 8000; // 8338; // for faceOSC

MidiBus bus;

void setup(){
	size(750,750, P3D);
	background(255);

	noStroke();

	// String[] cameras = Capture.list();
	// printArray(cameras);
	// cam = new Capture(this, cameras[59]);
	// fb = new Feedback(cam, this);
 		fb = new Feedback(this);

	videoExport = new VideoExport(this, "feedback"+getTimestamp()+".mp4");
	videoExport.setFrameRate(vidfps);

	frameRate(30);

	oscP5 = new OscP5(this, oscIncomingPort);

	bus = new MidiBus(this, 0, 3);
}

void draw(){
	if (debug) println("---------------------------------");
	time = 1f*(frameCount)/numFrames;
  	
  	if (mouseInput) {
		scale = 	map(mouseX, 0,  width, MIN_SCALE, MAX_SCALE);
		rotation = 	map(mouseY, 0, height,   MIN_ROT, MAX_ROT);   		
		translation = new PVector(0,0);
  	}

  	fb.setScale(scale);
  	fb.setRotation(rotation);	
  	fb.setTranslation(translation);

	fb.update();

	String titleText = String.format(getClass().getName()+ "%6.2f fps", frameRate);
	if (recording) {
		videoExport.saveFrame();
		fill(255,0,0);
		ellipse(width*0.05, width*0.05, width*0.05, width*0.05); 
		 
		vidFrameNum++;

		titleText += "\trecording --> ";
		titleText += vidFrameNum/vidfps;    
	}

	surface.setTitle(titleText);
}

String getTimestamp() {
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd-HHmmss");
  return df.format(new Date()); 
}

