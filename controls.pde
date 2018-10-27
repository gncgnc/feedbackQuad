// KEYBOARD //
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

		case 's': case 'S':
			save("stills/feedback"+getTimestamp()+".png");
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

// OSC //
void oscEvent(OscMessage theOscMessage) {  
	if (!mouseInput) {
		if (theOscMessage.checkAddrPattern("/1/xy1")) {
			if (theOscMessage.checkTypetag("ff")) {
				float rot = theOscMessage.get(0).floatValue();
				float sc  = theOscMessage.get(1).floatValue();
				
				rotation = map(rot, 0, 1, MIN_ROT, MAX_ROT);	
				scale = map(sc, 0, 1, MIN_SCALE, MAX_SCALE);

				animating = false;
			}  
		} 		

		if (theOscMessage.checkAddrPattern("/1/fader1")) {
			if (theOscMessage.checkTypetag("f")) {
				float m = theOscMessage.get(0).floatValue();
				fb.setMargin(map(m, 0, 1, 0, 0.1));
			}
		}

		if (theOscMessage.checkAddrPattern("/1/push1")) {
			if (theOscMessage.checkTypetag("f")) {
				if (theOscMessage.get(0).floatValue() == 1) animating = true;
			}
		}

		if (theOscMessage.checkAddrPattern("/1/toggle1")) {
			if (theOscMessage.checkTypetag("f")) {
				if (theOscMessage.get(0).floatValue()==1) {
					fb.glitchyBlurOn = true;
				} else {
					fb.glitchyBlurOn = false;
				}
			}	
		}

	}

	println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}


// MIDI //
void controllerChange(ControlChange change) {
	if (!mouseInput) {
		float val = change.value();

		switch (change.number()) {
			case Korg.slider0: 
				scale = map(val, 0, 127, MIN_SCALE, MAX_SCALE);				
			break;	

			case Korg.knob0:
				rotation = map(val, 0, 127, MIN_ROT, MAX_ROT);				
			break;

			case Korg.solo0:
				if (val==127) rotation = MIN_ROT * 0.5 + MAX_ROT * 0.5;
			break;

			case Korg.mute0:
				if (val==127) fb.filtersOn = !fb.filtersOn;
				bus.sendControllerChange(0, Korg.mute0, fb.filtersOn ? 127 : 0);
				// glitchyBlur is also off if filters are off
				bus.sendControllerChange(0, Korg.rec0, (fb.glitchyBlurOn && fb.filtersOn) ? 127 : 0);
			break;

			case Korg.rec0:
				if (val==127) fb.glitchyBlurOn = !fb.glitchyBlurOn;
				bus.sendControllerChange(0, Korg.rec0, (fb.glitchyBlurOn && fb.filtersOn) ? 127 : 0);
			break;

			case Korg.slider1: 
				fb.setMargin(map(val, 0, 127, 0, 0.1));			
			break;
				
			case Korg.slider7:
				fb.controlTightness = map(val, 0, 127, 0.05, 1);
			break;
		}
	}
}