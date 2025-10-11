shader_type spatial;

uniform sampler2D noise_texture : filter_nearest;

uniform vec2 uv_scale;

uniform float power;

varying vec3 view_direction;

void fragment() {
	vec3 random_direction = texture(noise_texture, UV * uv_scale).rgb;
	random_direction = random_direction - 0.5;
	random_direction = normalize(random_direction);
	float sparkle = pow( dot( -VIEW , normalize( random_direction + NORMAL )) , power );
	EMISSION = vec3(sparkle, sparkle, sparkle);
}