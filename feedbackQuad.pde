import com.hamoid.*;
import java.util.Date;
import java.text.SimpleDateFormat;

int numFrames = 30;
boolean recording = false;

float time = 0;

Feedback fb;

VideoExport videoExport;
int vidfps = 15;
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
	time = 1f*(frameCount)/numFrames;

	pushMatrix();
	translate(width*0.5, height*0.5);
	fb.update();
	popMatrix();
  
  
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
        frameRate(vidfps);
			} else {
				videoExport.endMovie();
				videoExport = new VideoExport(this, "feedback"+getTimestamp()+".mp4");
				recording = false;	
        frameRate(30);
        vidFrameNum = 0;
			}
		break;

    default:
	}
}

String getTimestamp() {
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd-HHmmss");
  return df.format(new Date()); 
}
