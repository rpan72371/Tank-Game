shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform float curvature = 8.5;
uniform float scanline_strength = 0.1;
uniform float scanline_density = 480.0;
uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
	vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;

	// bow strength derived from curvature: higher curvature = flatter
	float bow = 1.0 / (curvature * curvature);

	vec2 warped_uv = vec2(
		centered_uv.x + centered_uv.x * pow(centered_uv.y, 2.0) * bow,
		centered_uv.y + centered_uv.y * pow(centered_uv.x, 2.0) * bow * 0.75
	);

	vec3 cutoff = vec3(step(abs(warped_uv.x), 1.0) * step(abs(warped_uv.y), 1.0));
	vec3 scanlines = vec3(sin(2.0 * warped_uv.x * scanline_density) * scanline_strength + 1.0);
	vec3 screen_color = texture(screen_texture, (warped_uv + 1.0) / 2.0).rgb * cutoff * scanlines;

	COLOR = vec4(screen_color, 1.0);
}