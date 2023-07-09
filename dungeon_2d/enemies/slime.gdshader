shader_type canvas_item;

void vertex() {
  VERTEX += vec2(1.0, 0.0) * sin(TIME);
//  VERTEX += vec2(cos(TIME)*100.0, sin(TIME)*100.0);
}

void fragment() {
	// Place fragment code here.
	COLOR = texture(TEXTURE, UV);
}
