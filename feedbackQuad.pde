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
	translate(width*0.5, height*0.5);

	fb.update();

	if (recording) saveFrame("frames/###"+getClass().getSimpleName()+".png");
	if (frameCount==numFrames && recording) exit();
}
