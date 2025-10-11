shader_type spatial;

uniform float power;

void fragment() {
	float rim =  pow(1.0 - dot(VIEW, NORMAL), power);
	EMISSION = vec3(rim, rim, rim);
}
