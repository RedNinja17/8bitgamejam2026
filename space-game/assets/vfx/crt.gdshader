shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float crt_brightness: hint_range(0.0, 1.0) = 1.0;
uniform float crt_ghost: hint_range(0.0, 10.0) = 3.0;
uniform float crt_grid: hint_range(0.0, 1.0) = 0.4;

void fragment() {
	vec2 screen_uv = SCREEN_UV;
	vec3 color = texture(screen_texture, screen_uv).rgb * (1.0 - crt_brightness * 0.5);
	color += texture(screen_texture, screen_uv - vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb;
	color += texture(screen_texture, screen_uv + vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb;
	color *= crt_brightness * 0.25;
	
	float crt_grid_uv = mod(SCREEN_UV.x / SCREEN_PIXEL_SIZE.x, 3.0);
	vec3 crt_grid_color;
	crt_grid_color.r = clamp(1.0 - crt_grid_uv, 0.0, 1.0);
	crt_grid_color.g = clamp(1.0 - abs(1.0 - crt_grid_uv), 0.0, 1.0);
	crt_grid_color.b = 1.0 - crt_grid_color.r - crt_grid_color.g;
	color += clamp(normalize(clamp(crt_grid_color, crt_grid, 1.0)), vec3(0.0), vec3(1.0));
	
	COLOR = vec4(color, 1.0);
}