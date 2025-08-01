shader_type canvas_item;

uniform vec2 tile_scale = vec2(1.0, 1.0); // How many times to tile
uniform vec2 pan_speed = vec2(0.0, 0.0);  // Panning speed

void fragment() {
    vec2 raw_uv = UV * tile_scale + TIME * pan_speed;
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 snapped_uv = floor(raw_uv * tex_size) / tex_size;

    COLOR = texture(TEXTURE, snapped_uv);
}