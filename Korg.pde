static class Korg {
	public static final int prevTrack = 58;
	public static final int nextTrack =	59;
	public static final int cycle =	46;
	
	public static final int set = 60;
	public static final int prevMarker = 61;
	public static final int nextMarker = 62;

	public static final int rew = 43;
	public static final int ff = 44;
	public static final int stop = 42;
	public static final int play = 41;
	public static final int rec = 45;

	public static final int slider0 = 0;
	public static final int slider1 = 1;
	public static final int slider2 = 2;
	public static final int slider3 = 3;
	public static final int slider4 = 4;
	public static final int slider5 = 5;
	public static final int slider6 = 6;
	public static final int slider7 = 7;

	public static final int knob0 = 16;
	public static final int knob1 = 17;
	public static final int knob2 = 18;
	public static final int knob3 = 19;
	public static final int knob4 = 20;
	public static final int knob5 = 21;
	public static final int knob6 = 22;
	public static final int knob7 = 23;

	public static final int solo0 = 32;
	public static final int solo1 = 33;
	public static final int solo2 = 34;
	public static final int solo3 = 35;
	public static final int solo4 = 36;
	public static final int solo5 = 37;
	public static final int solo6 = 38;
	public static final int solo7 = 39;

	public static final int mute0 = 48;
	public static final int mute1 = 49;
	public static final int mute2 = 50;
	public static final int mute3 = 51;
	public static final int mute4 = 52;
	public static final int mute5 = 53;
	public static final int mute6 = 54;
	public static final int mute7 = 55;

	public static final int rec0 = 64;
	public static final int rec1 = 65;
	public static final int rec2 = 66;
	public static final int rec3 = 67;
	public static final int rec4 = 68;
	public static final int rec5 = 69;
	public static final int rec6 = 70;
	public static final int rec7 = 71;

	public static boolean isSlider(int i) {
		return 0<=i && i<8; 
	} 

	public static int slider(int i) {
		if (0<=i && i<8) return i;
		else System.err.println("No slider #"+i);
		return -1;
	}

	public static boolean isKnob(int i) {
		return 16<=i && i<24;
	}

	public static int knob(int i) {
		if (0<=i && i<8) return i+16;
		else System.err.println("No knob at #"+i);
		return -1;
	}

	public static boolean isSolo(int i) {
		return 32<=i && i<40;
	}

	public static int solo(int i) {
		if (0<=i && i<8) return i+32;
		else System.err.println("No solo #"+i);
		return -1;
	}

	public static boolean isMute(int i) {
		return 48<=i && i<56;
	}

	public static int mute(int i) {
		if (0<=i && i<8) return i+48;
		else System.err.println("No mute #"+i);
		return -1;
	}

	public static boolean isRecord(int i) {
		return 64<=i && i<72;
	}

	public static int record(int i) {
		if (0<=i && i<8) return i+64;
		else System.err.println("No record #"+i);
		return -1;
	}
}