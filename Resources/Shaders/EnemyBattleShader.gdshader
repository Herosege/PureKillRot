shader_type canvas_item;

uniform bool FlashOn = false;

void fragment() {

	if (FlashOn){
		COLOR.rgb += ((1.2+sin(TIME*8.0))/2.0)*vec3(0.3,0.3,0.3);
	}
}
