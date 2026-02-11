shader_type canvas_item;

uniform vec2 speed = vec2(0.2, 0.2);

void vertex() {
	UV.x += TIME * speed.x;
	UV.y += TIME * speed.y;
}

void fragment() {
	COLOR = texture(TEXTURE, mod(UV + TIME * speed, 1.0));
}


