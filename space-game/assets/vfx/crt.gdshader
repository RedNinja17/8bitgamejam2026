shader_type canvas_item;

uniform float crt_brightness: hint_range(0.0, 1.0) = 1.0;
uniform float crt_ghost: hint_range(0.0, 10.0) = 3.0;
uniform float crt_grid: hint_range(0.0, 1.0) = 0.4;
uniform float crt_white_noise: hint_range(0.0, 1.0) = 0.0;
uniform float crt_curve: hint_range(0.0, 1.0) = 0.05;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}
void fragment() {
	float time = TIME;
	
	vec2 crt_curve_shift = (vec2(1.0) - sin(UV.yx * PI)) * crt_curve;
	vec2 crt_curve_scale = vec2(1.0) + crt_curve_shift * 2.0;
	
	vec2 uv = UV * crt_curve_scale - crt_curve_shift;
	
	float crt_mask = float(uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0);
	
	vec3 color = texture(TEXTURE, uv).rgb * (1.0 - crt_brightness * 0.4);
	float crt_grid_uv = mod(uv.x / TEXTURE_PIXEL_SIZE.x, 3.0);
	vec3 subpixel_mask = vec3(1.0);
	if(crt_grid_uv < 1.0) {
		subpixel_mask = vec3(1.0, 1.0 - crt_grid, 1.0 - crt_grid);
	}
	else if(crt_grid_uv < 2.0) {
		subpixel_mask = vec3(1.0 - crt_grid, 1.0, 1.0 - crt_grid);
	}
	else {
		subpixel_mask = vec3(1.0 - crt_grid, 1.0 - crt_grid, 1.0);
	}
	color *= subpixel_mask;
	
	vec2 noise_pixel = vec2(floor((uv.x / TEXTURE_PIXEL_SIZE.x) / 3.0) * 3.0, uv.y);
	float white_noise = random(noise_pixel + vec2(sin(time * PI / 4.0), cos(time * PI / 8.0))) * crt_mask;
	color = mix(color, vec3(white_noise), crt_white_noise) * crt_mask;
	COLOR = vec4(color, crt_mask);
}