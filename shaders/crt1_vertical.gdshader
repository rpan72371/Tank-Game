shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform float side_bow = 0.005;      // sides bow outward
uniform float scanline_strength = 0.1;
uniform float scanline_density = 480.0;
uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
	vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;

	// positive = bow outward (barrel). y bows half as much as x.
	vec2 warped_uv = vec2(
		centered_uv.x + centered_uv.x * pow(centered_uv.y, 2.0) * side_bow,
		centered_uv.y + centered_uv.y * pow(centered_uv.x, 2.0) * side_bow * 5.0
	);

	vec3 cutoff = vec3(step(abs(warped_uv.y), 1.0) * step(abs(warped_uv.x), 1.0));
	vec3 scanlines = vec3(sin(2.0 * warped_uv.x * scanline_density) * scanline_strength + 1.0);
	vec3 screen_color = texture(screen_texture, (warped_uv + 1.0) / 2.0).rgb * cutoff * scanlines;

	COLOR = vec4(screen_color, 1.0);
}