shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;

void fragment() {
    vec2 uv = UV;
    vec4 color = vec4(0.0);
    float total = 0.0;
    float step_size = blur_amount / 100.0;

    for (float x = -blur_amount; x <= blur_amount; x++) {
        for (float y = -blur_amount; y <= blur_amount; y++) {
            vec2 offset = vec2(x, y) * step_size;
            color += texture(TEXTURE, uv + offset);
            total += 1.0;
        }
    }

    color /= total;
    COLOR = color;
}
