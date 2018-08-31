import processing.video.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

class Feedback {
	PShape s;
	Capture cam;
	PImage prev;
	PApplet papplet;

	// SHADERS
	PShader sharpen;
	PShader blur;
	PShader gblur;


	// TRANSFORM PARAMS
	float scale = 0.9;
	float rotation = 0;
	PVector translation = new PVector();

	// OPTIONS
	boolean filtersOn = true;
	boolean marginOn = true; 
	boolean glitchyBlurOn = true;

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
		gblur = loadShader("gblur.frag");
	}

	public void update() {
		if (cam.available()) {
			cam.read();
		}

		// draw image in background
		pushMatrix();
		scale(-1.0, 1.0); // invert to make mirror
		image(cam, 0, 0, 1f*width*cam.width/cam.height, height);			
		popMatrix();

		// transforms are input from outside class
		pushMatrix();
		rotate(this.rotation);
		scale(this.scale);
		translate(this.translation.x, this.translation.y, this.translation.z);
		shape(s);	
		popMatrix();

		if (filtersOn) {
			applyFilters();
		}

		prev = papplet.get();
		
		if (marginOn) {
			makeQuad(margin);			
		} else {
			makeQuad();
		}
	}

	void applyFilters() {
		if (glitchyBlurOn) {
			filter(gblur);
			filter(gblur);
			filter(sharpen);
			filter(gblur);			
		} else  {			
			filter(blur);
			filter(blur);
			filter(sharpen);
			filter(blur);
		}
	}

	void makeQuad() {
		makeQuad(0);
	}

	void makeQuad(float margin) {
		float w = width*(0.5 - margin);
		float m = margin;

		s = createShape();
		s.beginShape(QUAD);
		// two ways to do it:
		// this uses array copy to copy pixels on CPU
		// s.texture(prev.get(
		// 	(int) (prev.width*margin), 			//x
		// 	(int) (prev.height*margin), 		//y
		// 	(int) (prev.width*(1-2*margin)),	//w
		// 	(int) (prev.height*(1-2*margin))	//h
		// 	)
		// );
		// s.vertex(-w, -w, 0, 0f,-1f);
		// s.vertex(+w, -w, 0, 1f,-1f);
		// s.vertex(+w, +w, 0, 1f, 0f);
		// s.vertex(-w, +w, 0, 0f, 0f);

		// OR
		// uses texture sampling, which we are already doing 
		s.texture(prev); // <-- could be bottleneck
		s.vertex(-w, -w, 0, m	, m-1f	);
		s.vertex(+w, -w, 0, 1f-m, m-1f	);
		s.vertex(+w, +w, 0, 1f-m, -m	);
		s.vertex(-w, +w, 0, m	, -m 	);
		s.endShape();
	}
}
