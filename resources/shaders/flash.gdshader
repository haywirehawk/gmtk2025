shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0);
uniform float flash_intensity: hint_range(0.0, 1.0, 0.05) = 0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color = mix(color, flash_color, flash_intensity * color.a);
	
	COLOR = color;
}