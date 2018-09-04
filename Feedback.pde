import processing.video.*;

class Feedback {
	PShape s;
	Capture cam;
	PImage prev;
	PApplet papplet;

	// SHADERS
	PShader sharpen;
	PShader blur;
	PShader gblur;

	float sharpenAmount = 0.5;

	// TRANSFORM PARAMS
	float scale = 0.9;
	float rotation = 0;
	PVector translation = new PVector();

	float targetScale = 0.9;
	float targetRotation = 0;
	PVector targetTranslation = new PVector();

	// OPTIONS
	boolean filtersOn = true;
	boolean marginOn = true; 
	boolean glitchyBlurOn = true;

	float margin = 0.1;
	float controlTightness = 0.1;

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
		cam = new Capture(papplet,cameras[13]); // 1
		cam.start();	
		this.prev = papplet.get();
		printArray(cameras);

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

		sharpen.set("amount", sharpenAmount);
	}

	public void update() {
		pushMatrix();
		translate(width*0.5, height*0.5);

		// draw image in background
		pushMatrix();
		scale(-1.0, 1.0); // invert to make mirror
		image(cam, 0, 0, 1f*width*cam.width/cam.height, height);			
		popMatrix();

		// transforms are input from outside class
		updateTransforms();

		pushMatrix();
		rotate(this.rotation);
		scale(this.scale);
		translate(this.translation.x, this.translation.y, this.translation.z);
		shape(s);	
		popMatrix();

		if (filtersOn) {
			applyFilters();
		}

		float start = millis();
		prev = papplet.get();
		if (debug) println("papplet.get() --> "+(millis() - start)+"ms");

		if (marginOn) {
			makeQuad(margin);			
		} else {
			makeQuad();
		}
		
		popMatrix();
	}

	void applyFilters() {
		float start = millis();
		// sharpen.set("amount",sharpenAmount);
		if (glitchyBlurOn) {
			filter(sharpen);
			filter(gblur);			
		} else  {			
			filter(sharpen);
			filter(blur);
		}
		if (debug) println("applyFilters() --> "+(millis() - start)+"ms");
	}

	void makeQuad() {
		makeQuad(0);
	}

	void makeQuad(float margin) {
		float start = millis();

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

		if (debug) println("makeQuad() --> "+(millis() - start)+"ms");
	}

	public void setRotation(float rot) {
		targetRotation = rot;
	}

	public void setScale(float sc) {
		targetScale = sc;
	}

	public void setTranslation(PVector tr) {
		targetTranslation = tr;
	} 

	private void updateTransforms() {
		scale = lerp(scale, targetScale, controlTightness);
		rotation = lerp(rotation, targetRotation, controlTightness);
		translation = PVector.lerp(translation, targetTranslation, controlTightness);
	}
}
