shader_type canvas_item;

uniform sampler2D Texture1 : filter_nearest;

uniform float Above;

//void vertex(){
	//
//}
//
//void fragment() {
	//
	//COLOR.rgb = texture(Texture1,UV).rgb * 0.0;
	//float CurveAmt = 1.0;
	//
	//float uvx = ((1.01*UV.x+(CurveAmt - UV.y)*sin(TIME*0.5)*0.8)-0.175);
	//float uvy = (UV.y-Above);
	//
	//COLOR.a = texture(Texture1,vec2(uvx*2.0 ,uvy*1.1)).a *0.5;
//}
uniform float pivot;
uniform vec2 displacement;
uniform vec2 skewAmnt;
uniform vec2 Scale = vec2(1.0);

uniform float borderScale = 1.0;
uniform float defpos = 0.66666666666;

void vertex(){
	VERTEX.x *= borderScale;
}

void fragment() {

	float SkewOffset;
	float uvx = Scale.x * UV.x + (pivot-UV.y)*skewAmnt.x+displacement.x;
	float uvy = (UV.y)*skewAmnt.y-(skewAmnt.y-1.0)*defpos;

	float scaledUV = uvx * borderScale - (0.5 * (borderScale-1.0));

	COLOR.rgb = texture(Texture1,vec2(scaledUV,uvy)).rgb * 0.0;
	COLOR.a = texture(Texture1,vec2(scaledUV,uvy)).a * 0.4;
}
