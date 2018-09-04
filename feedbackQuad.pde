import com.hamoid.*;
import java.util.Date;
import java.text.SimpleDateFormat;

import oscP5.*;

boolean recording = false;
boolean debug = false;
boolean mouseInput = true;

float time = 0;
int numFrames = 30;

Feedback fb;
float rotation;
float scale;
PVector translation = new PVector();

VideoExport videoExport;
int vidfps = 30;
int recordfps = 15;
int vidFrameNum = 0;

OscP5 oscP5;



void setup(){
	size(750,750, P3D);
	background(255);

	noStroke();

	fb = new Feedback(this);

	videoExport = new VideoExport(this, "feedback"+getTimestamp()+".mp4");
	videoExport.setFrameRate(vidfps);

	frameRate(30);

	oscP5 = new OscP5(this,8000);
}

void draw(){
	if (debug) println("---------------------------------");
	time = 1f*(frameCount)/numFrames;
  	
  	if (mouseInput) {
		scale = map(mouseX,0,width,0.707,1.005);
		rotation = map(mouseY, 0, height, -TAU/8, TAU/8);   		
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

void keyPressed() {
	switch (key) {
		case 'm': case 'M':
			fb.marginOn = !fb.marginOn;
		break;	

		case 'f': case 'F':
			fb.filtersOn = !fb.filtersOn;
		break;	

		case 'g': case 'G':
			fb.glitchyBlurOn = !fb.glitchyBlurOn;  
		break;

		case 'r': case 'R':
			if (!recording)  {
				videoExport.startMovie();
				recording = true;
        		frameRate(recordfps);
			} else {
				videoExport.endMovie();
				videoExport = new VideoExport(this, "feedback"+getTimestamp()+".mp4");
				recording = false;	
		        frameRate(30);
		        vidFrameNum = 0;
			}
		break;

		case 'd': case 'D':
			debug = !debug;
		break;

		case 'i': case 'İ':
			mouseInput = !mouseInput;
		break;

		// case 'x': case 'X':
		// 	fb.sharpenAmount+=0.1;
		//     println(fb.sharpenAmount);
		// break;
		// case 'z': case 'Z':
		// 	fb.sharpenAmount-=0.1;
		//     println(fb.sharpenAmount);
		// break;
    default:
	}
}

String getTimestamp() {
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd-HHmmss");
  return df.format(new Date()); 
}

void captureEvent(Capture camera) {
	float start = millis();
	camera.read();
	if (debug) println("captureEvent() --> "+(millis() - start)+"ms");
}  

void oscEvent(OscMessage theOscMessage) {  
	if (!mouseInput) {
		if (theOscMessage.checkAddrPattern("/3/xy1")) {
			if (theOscMessage.checkTypetag("ff")) {
				float sc  = theOscMessage.get(0).floatValue();
				float rot = theOscMessage.get(1).floatValue();
				scale = (map(sc,0,1,0.707,1.005));
				rotation = (map(rot, 0, 1, -TAU/8, TAU/8));	
			}  
		} 

		if (theOscMessage.checkAddrPattern("/3/xy2")) {
			if (theOscMessage.checkTypetag("ff")) {
				float x = theOscMessage.get(0).floatValue();
				float y = theOscMessage.get(1).floatValue();
				translation = new PVector(x,y).sub(new PVector(0.5,0.5)).mult(width*0.1);
			}  
		} 		
	}

	println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}