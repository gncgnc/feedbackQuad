#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;
uniform float time;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
	vec4 col = texture2D(texture, vertTexCoord.st);	 
	gl_FragColor = col;
}
