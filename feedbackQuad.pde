import com.hamoid.*;
import java.util.Date;
import java.text.SimpleDateFormat;

int numFrames = 30;
boolean recording = false;
boolean debug = false;

float time = 0;

Feedback fb;

VideoExport videoExport;
int vidfps = 30;
int recordfps = 15;
int vidFrameNum = 0;

void setup(){
	size(750,750, P3D);
	background(255);

	noStroke();

	fb = new Feedback(this);

	videoExport = new VideoExport(this, "feedback"+getTimestamp()+".mp4");
	videoExport.setFrameRate(vidfps);

	frameRate(30);
}

void draw(){
	if (debug) println("---------------------------------");
	time = 1f*(frameCount)/numFrames;

	pushMatrix();
	translate(width*0.5, height*0.5);
	fb.update();
	popMatrix();
  	
  	// input transformations 
  	fb.scale = lerp(fb.scale, map(mouseX,0,width,0.707,1.005), 0.1);
  	fb.rotation =  lerp(fb.rotation, map(mouseY, 0, height, -TAU/8, TAU/8), 0.1);	
  	// fb.translation = new PVector(mouseX-width*0.5, mouseY-height*0.5).mult(0.1);
  
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
    
    

	// if (recording) saveFrame("frames/###"+getClass().getSimpleName()+".png");
	// if (frameCount==numFrames && recording) exit();
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
