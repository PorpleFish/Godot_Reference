shader_type spatial;
render_mode unshaded, blend_add;

// Prox. fade:
uniform float proximity_fade_distance : hint_range(0.05, 5.0, 0.01) = 0.75;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

// Colour
uniform vec4 first_color : source_color;
uniform vec4 second_color : source_color;
uniform bool use_second_color;

// Curve
uniform float cone_curve : hint_range(0.0, 1.0, 0.01);
uniform float cone_start_width : hint_range(0.0, 1.0, 0.01);
uniform float beam_sharpness : hint_range(0.0, 1.0, 0.01);
uniform float beam_fade : hint_range(0.0, 1.0, 0.01);

// Gradient
uniform bool use_gradient;
uniform sampler2D gradient;

// Noise
uniform bool use_noise;
uniform sampler2D noise_texture;
uniform vec2 noise_scale;
uniform vec2 noise_distortion_scroll_speed;
uniform vec2 noise_scroll_speed;
uniform float noise_distortion_intensity;
uniform float noise_intensity;

void vertex() {
	// Point towards the camera, but keep the Z facing the same direction
	// Get the z from the model's transformation matrix
	vec3 local_z = normalize(MODEL_MATRIX[2].xyz);
	// Get vector to camera
	vec3 to_camera = normalize(CAMERA_POSITION_WORLD - NODE_POSITION_WORLD);
	// Then find the new x and y rotations to use for the mesh
	// Essentially the same as finding the right and forward vector for camera transforms
	vec3 local_x = normalize(cross(to_camera, local_z));
	vec3 local_y = normalize(cross(local_z, local_x));
	// Apply this transform to the matrix directly
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		vec4(local_x * length(MODEL_MATRIX[0].xyz), 0.0), // New X basis vector
		vec4(local_y * length(MODEL_MATRIX[1].xyz), 0.0), // New Y basis vector
		MODEL_MATRIX[2], // Z basis vector stays the same
		MODEL_MATRIX[3]  // Model position stays the same
	);
}

void fragment() {
	// Prox. fade:
	float proximity_depth_tex = textureLod(depth_texture, SCREEN_UV, 0.0).r;
	vec4 proximity_view_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, proximity_depth_tex, 1.0);

	proximity_view_pos.xyz /= proximity_view_pos.w;
	ALPHA *= clamp(1.0 - smoothstep(
		proximity_view_pos.z + proximity_fade_distance,
		proximity_view_pos.z,
		VERTEX.z
		), 0.0, 1.0);

		// Normal Fragment stuff:
		vec2 uv = UV;
		vec3 input_color;
		float input_alpha;
		// Simple and clean colour blend along the Y, that's cool
		if (use_second_color){
			input_color = mix(first_color.rgb, second_color.rgb, uv.y);
			input_alpha = mix(first_color.a, second_color.a, uv.y);
		}
		else
		{
			input_color = first_color.rgb;
			input_alpha = first_color.a;
		}

		ALBEDO = input_color;
		ALPHA *= input_alpha;

		// Find width at current pos along the "cone" length
		float cone_progress_y = pow(uv.y, 1.0 - cone_curve);
		float width = mix(cone_start_width, 1.0, cone_progress_y);
		float half_width = width * 0.5;

		// Create the horizontal mask from ^^^
		float distance_from_center_x = abs(uv.x - 0.5);
		float beam_edge_start = half_width - (half_width * (1.0 - beam_sharpness));
		float horizontal_mask = 1.0 - smoothstep(beam_edge_start, half_width, distance_from_center_x);

		// Create a vertical mask
		float vertical_mask = pow(max(1.0 - uv.y, 0.001), beam_fade);
		vertical_mask *= smoothstep(0.0, cone_start_width * 0.5, uv.y);

		if (use_gradient) {
			float gradient_coord = distance_from_center_x / half_width;
			float gradient_value = texture(gradient, vec2(gradient_coord, 0.5)).r;
			horizontal_mask *= mix(1.0, gradient_value,1.0 - (vertical_mask * vertical_mask));
		}

		if (use_noise) {
			vec2 distortion_offset = noise_distortion_scroll_speed * TIME + NODE_POSITION_WORLD.xz;
			vec2 distortion_sample = texture(noise_texture, uv * noise_scale + distortion_offset).rg;
			vec2 distortion_uv = uv + (distortion_sample - 0.5) * 22.0 * noise_distortion_intensity;

			vec2 scroll_offset_1 = noise_scroll_speed * TIME + NODE_POSITION_WORLD.xz;
			vec2 scroll_offset_2 = vec2(-noise_scroll_speed.x * 0.7, noise_scroll_speed.y * 1.3) * TIME + NODE_POSITION_WORLD.xz;

			float noise_sample_1 = texture(noise_texture, distortion_uv * noise_scale + scroll_offset_1).r;
			float noise_sample_2 = texture(noise_texture, distortion_uv * noise_scale + scroll_offset_2).r;
			float combined_noise = mix(1.0, noise_sample_1 * noise_sample_2, 1.0 - vertical_mask);

			horizontal_mask *= mix(1.0, combined_noise, noise_intensity);
		}

		ALPHA *= horizontal_mask;
		ALPHA *= vertical_mask;
}
