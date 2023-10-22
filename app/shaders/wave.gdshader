shader_type canvas_item;

uniform float intensity : hint_range(-1.0, 1.0) = 0.2;

uniform vec2 tiling = vec2(1.0, 1.0);
uniform vec2 offset_speed;

uniform sampler2D noise : filter_nearest, repeat_enable;
 
void fragment() {
	vec4 base_text = texture(TEXTURE, UV);
	vec4 noise_tex = texture(noise, UV + tiling + offset_speed * TIME);
	vec4 distortion = texture(TEXTURE, UV + noise_tex.r * intensity);
	
	COLOR = distortion;
	COLOR.a *= base_text.a;
}
