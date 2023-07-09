shader_type canvas_item;

float cubicPulse(float c, float w, float x) {
    x = abs(x - c);
    if (x > w) return 0.0;
    x /= w;
    return 1.0 - x * x * (3.0 - 2.0 * x);
}

void fragment() {
	vec4 white = vec4(1.0, 1.0, 1.0, 0.0);
	COLOR = texture(TEXTURE, UV) + white * cubicPulse(mod(TIME, 5.0), 0.2, UV.x);
}
