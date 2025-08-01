shader_type canvas_item;

uniform float min_alpha : hint_range(0,1) = 0.3;
uniform float max_alpha : hint_range(0,1) = 1.0;
uniform float speed = 2.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float alpha_factor = (sin(TIME * speed) + 1.0) / 2.0;
    float alpha = mix(min_alpha, max_alpha, alpha_factor);
    COLOR = vec4(tex_color.rgb, tex_color.a * alpha);
}
