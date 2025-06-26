shader_type canvas_item;

uniform bool FlashOn = false;
uniform float AlphaAmnt = 0.0;

void fragment() {
	if (AlphaAmnt > 0.0){
		COLOR.rgb += AlphaAmnt;
	}
	if (FlashOn){
		COLOR.rgb += ((1.2+sin(TIME*8.0))/2.0)*vec3(0.3,0.3,0.3);
	}
}
