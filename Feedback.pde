import processing.video.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

class Feedback {
	PShape s;
	Capture cam;
	PImage prev;
	PApplet papplet;

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
	}


	public void update() {
		if (cam.available()) {
			cam.read();
		}

		pushMatrix();
		scale(-1.0, 1.0); // invert to make mirror
		image(cam, 0, 0, 1f*width*cam.width/cam.height, height);			
		popMatrix();

		float sc = map(mouseX,0,width,0.9,0.995);
		float rot = map(mouseY, 0, height, -TAU/8, TAU/8);		

		pushMatrix();
		rotate(rot);
		scale(sc);
		shape(s);	
		popMatrix();

		prev = papplet.get();
		
		makeQuad();
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
}