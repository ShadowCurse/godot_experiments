shader_type canvas_item;

void vertex() {
  VERTEX += vec2(1.0, 0.0) * sin(TIME);
}

void fragment() {
	// Place fragment code here.
	COLOR = texture(TEXTURE, UV);
}
