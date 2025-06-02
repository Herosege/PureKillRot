shader_type canvas_item;

uniform sampler2D ColorTex;
uniform sampler2D Vornoi;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}
varying float rot;
varying vec2 vertex_world;

void vertex(){

}

void fragment() {
	vec3 VorVal = texture(Vornoi,UV).xyz;
	float VorAngle = VorVal.x;
	COLOR.rgba = texture(TEXTURE,rotateUV(UV,vec2(VorAngle),6.0)*vec2(2.0,3.0))*texture(ColorTex,UV)+0.04;
}
