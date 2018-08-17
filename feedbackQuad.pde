import processing.video.*;

int numFrames = 30;
boolean recording = false;

float time = 0;

Capture cam; 

PImage prev;

PImage img;
PShape s;


float rot = 0;

void setup(){
	size(750,750, P3D);
	background(255);
	rect(width*0.1, height*0.1, width*0.9, height*0.9);
	textureMode(NORMAL);
	textureWrap(REPEAT);


	img = loadImage("scan0003.jpg");
	imageMode(CENTER);

	s = createShape();
	noStroke();

	String[] cameras = Capture.list();
	cam = new Capture(this,cameras[1]);
    cam.start();
}

void draw(){
	time = 1f*(frameCount)/numFrames;
	translate(width*0.5, height*0.5);
	
	// if (frameCount%7==0)((PGraphicsOpenGL)g).textureSampling(POINT);
	// else if(frameCount%7==3) ((PGraphicsOpenGL)g).textureSampling(5); //trilinear


	if (mousePressed) {
		// rainbow time
		colorMode(HSB,360,100,100);
		tint(360f*(time%1),100,100,100);
		colorMode(RGB,255,255,255);
	}

	if (cam.available() == true) {
		cam.read();
	}

	pushMatrix();
	scale(-1.0, 1.0); // invert to make mirror
	image(cam, 0, 0, width*4f/3, height);			
	popMatrix();
	noTint(); // draw feedback quad without rainbow effect

	rot = map(mouseY, 0, height, -TAU/8, TAU/8);
	rotate(rot);
	shape(s);	

	prev = get();

	float w = map(mouseX,0,width,0.34,0.499)*width;
	float xoff = width*0.5;
	float yoff = width*0.5;
	float texM = 1;//map(mouseY, 0, height, 1.0, 5); 

	s = createShape();
	s.beginShape(QUAD);
	s.texture(prev);
	s.vertex(xoff-width*0.5-w, yoff-height*0.5-w, 0, 0*texM, -1*texM);
	s.vertex(xoff-width*0.5+w, yoff-height*0.5-w, 0, 1*texM, -1*texM);
	s.vertex(xoff-width*0.5+w, yoff-height*0.5+w, 0, 1*texM, 0*texM);
	s.vertex(xoff-width*0.5-w, yoff-height*0.5+w, 0, 0*texM, 0*texM);
	s.endShape();


	if (recording) saveFrame("frames/###"+getClass().getSimpleName()+".png");
	if (frameCount==numFrames && recording) exit();
}
