shader_type canvas_item;


void fragment() {
	// Place fragment code here.
	float dist = sqrt(pow(UV.x - 0.5, 2) + pow(UV.y - 0.5, 2));
	COLOR = vec4(0.0, 0.0, 0.0, 2.5 * pow(dist, 1.5));
}
