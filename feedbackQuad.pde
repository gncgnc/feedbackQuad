int numFrames = 30;
boolean recording = false;

float time = 0;

Feedback fb;

void setup(){
	size(750,750, P3D);
	background(255);

	noStroke();

	fb = new Feedback(this);
}

void draw(){
	time = 1f*(frameCount)/numFrames;

	pushMatrix();
	translate(width*0.5, height*0.5);
	fb.update();
	popMatrix();

	String txt_fps = String.format(getClass().getName()+ "%6.2f fps", frameRate);
    surface.setTitle(txt_fps);

	if (recording) saveFrame("frames/###"+getClass().getSimpleName()+".png");
	if (frameCount==numFrames && recording) exit();
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
	}
}
