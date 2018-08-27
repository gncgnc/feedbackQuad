import processing.video.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

class Feedback {
	PShape s;
	Capture cam;
	PImage prev;
	PApplet papplet;

	PShader sharpen;
	PShader blur;

	float margin = 0.1;

	public Feedback (Capture cam, PApplet papplet) {
		this.s = createShape();
		this.cam = cam;
		this.papplet = papplet; 
		cam.start();
		this.prev = papplet.get();

		papplet.imageMode(CENTER);
		papplet.textureMode(NORMAL);
		papplet.textureWrap(REPEAT);
		makeQuad();
		loadShaders();
	}

	public Feedback(PApplet papplet) {
	    this.papplet = papplet;

		String[] cameras = Capture.list();
		cam = new Capture(papplet,cameras[1]);
	    cam.start();
	    this.prev = papplet.get();

		papplet.imageMode(CENTER);
		papplet.textureMode(NORMAL);
		papplet.textureWrap(REPEAT);
		makeQuad();
		loadShaders();
	}

	private void loadShaders() {
		sharpen = loadShader("sharpen.frag");
		blur = loadShader("blur.frag");
	}

	public void update() {
		if (cam.available()) {
			cam.read();
		}

		pushMatrix();
		scale(-1.0, 1.0); // invert to make mirror
		image(cam, 0, 0, 1f*width*cam.width/cam.height, height);			
		popMatrix();

		float sc = map(mouseX,0,width,0.9,1.005);
		float rot = map(mouseY, 0, height, -TAU/8, TAU/8);		

		pushMatrix();
		rotate(rot);
		scale(sc);
		shape(s);	
		popMatrix();

		filter(blur);
		filter(blur);
		filter(sharpen);
		filter(blur);

		prev = papplet.get();
		
		makeQuad(margin);
	}

	void makeQuad() {
		float w = width*0.5;
		s = createShape();
		s.beginShape(QUAD);
		s.texture(prev);
		s.vertex(-w, -w, 0, 0f,-1f);
		s.vertex(+w, -w, 0, 1f,-1f);
		s.vertex(+w, +w, 0, 1f, 0f);
		s.vertex(-w, +w, 0, 0f, 0f);
		s.endShape();
	}

	void makeQuad(float margin) {
		float w = width*(0.5 - margin);
		float m = margin;

		s = createShape();
		s.beginShape(QUAD);
		// two ways to do it:
		// s.texture(prev.get(
		// 	(int) (prev.width*margin), 			//x
		// 	(int) (prev.height*margin), 		//y
		// 	(int) (prev.width*(1-2*margin)),	//w
		// 	(int) (prev.height*(1-2*margin))	//h
		// 	)
		// );
		s.texture(prev);
		s.vertex(-w, -w, 0, m,m-1f);
		s.vertex(+w, -w, 0, 1f-m,m-1f);
		s.vertex(+w, +w, 0, 1f-m, -m);
		s.vertex(-w, +w, 0, m, -m);
		s.endShape();
	}
}