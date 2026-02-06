shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	SPECULAR_LIGHT = vec3(dot(normalize(VIEW + LIGHT), NORMAL));
}
