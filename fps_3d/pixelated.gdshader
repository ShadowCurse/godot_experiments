shader_type spatial;
render_mode cull_disabled, unshaded;

const vec2 vertices[3] = {vec2(-1,-1), vec2(3,-1), vec2(-1, 3)};

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, source_color;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, source_color;

void vertex() {
	POSITION = vec4(vertices[VERTEX_ID],0.0,1.0);
}

void fragment() {
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	int pixel_size = int(depth * 5.0);
	
	float x = float(int(FRAGCOORD.x) % pixel_size);
	float y = float(int(FRAGCOORD.y) % pixel_size);

	x = FRAGCOORD.x + floor(float(pixel_size) / 2.0) - x;
	y = FRAGCOORD.y + floor(float(pixel_size) / 2.0) - y;

	ALBEDO = texture(SCREEN_TEXTURE, vec2(x, y) / VIEWPORT_SIZE).xyz;
}
