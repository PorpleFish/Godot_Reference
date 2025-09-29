shader_type canvas_item;

group_uniforms Basic;
uniform float radius : hint_range(0.0, 2.0, 0.001) = 0.1;
uniform float blur : hint_range(0.0, 0.01, 0.0001) = 0.05;
uniform float border_offset : hint_range(0.0, 0.1, 0.001) = 0.05;
uniform float border_width : hint_range(0.0, 0.1, 0.001) = 0.05;

void fragment() {
	vec2 centered_uv = UV - 0.5;
	float alpha;
	vec4 final_color;
	
	float dist = length(centered_uv);
	float circle_01 = 1.0 - smoothstep(radius, radius + clamp(blur, 0.0, 1.0), dist);
	float circle_02 = 1.0 - smoothstep(radius - border_offset, radius - border_offset + clamp(blur, 0.0, 1.0), dist);
	float circle_03 = 1.0 - smoothstep(radius - border_offset - border_width, radius - border_offset - border_width + clamp(blur, 0.0, 1.0), dist);
	
	alpha = circle_01- circle_02 + circle_03;
	
	final_color = vec4(1, 1, 1, alpha);
	
	COLOR = final_color;
}