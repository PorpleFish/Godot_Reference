shader_type spatial;
render_mode unshaded, blend_add;
uniform vec2 center = vec2(0.5);

uniform float size: hint_range(0.0,5.0) = 1.0;
uniform vec4 color_inner : source_color;
uniform vec4 color_outer : source_color;

//choose how far the colors are from each other in the inspector
uniform float step1 : hint_range(0.0,1.0) = 0.159;
uniform float step2 : hint_range(0.0,1.0) = 0.182;

void fragment() {
	float dist = distance(center, UV);
	vec4 color = mix(
		color_inner,
		color_outer,
		smoothstep(
			step1 * size,
			step2 * size,
			dist
		)
	);
	ALBEDO = color.rgb;
}