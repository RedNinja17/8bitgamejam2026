shader_type canvas_item;

//uniform vec4 glow_color : source_color = vec4(0.2, 1.0, 0.4, 1.0); // Neon green
uniform float glow_power : hint_range(0.0, 10.0) = 2.5;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    // Multiplies the texture's original pixels to create an emissive bloom
    COLOR = tex * glow_power;
}