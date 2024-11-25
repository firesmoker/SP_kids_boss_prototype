shader_type canvas_item;
uniform vec4 color: source_color;
uniform float alpha = 1;


void fragment() {
	COLOR.rgb = color.rgb;
	if (COLOR.a > alpha) {
		COLOR.a = alpha;
	}
}