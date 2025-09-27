shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_strength : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // Much stronger base offset for dramatic blur
    float offset = blur_strength * 0.1;

    // Start with center sample
    vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV) * 0.2;

    // Multiple rings of samples for smoother, stronger blur
    // Inner ring
    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(offset * 0.5, 0.0)) * 0.1;
    col += texture(SCREEN_TEXTURE, SCREEN_UV - vec2(offset * 0.5, 0.0)) * 0.1;
    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, offset * 0.5)) * 0.1;
    col += texture(SCREEN_TEXTURE, SCREEN_UV - vec2(0.0, offset * 0.5)) * 0.1;

    // Outer ring for stronger effect
    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(offset, 0.0)) * 0.08;
    col += texture(SCREEN_TEXTURE, SCREEN_UV - vec2(offset, 0.0)) * 0.08;
    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, offset)) * 0.08;
    col += texture(SCREEN_TEXTURE, SCREEN_UV - vec2(0.0, offset)) * 0.08;

    // Diagonal samples for smoother blur
    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(offset * 0.7, offset * 0.7)) * 0.06;
    col += texture(SCREEN_TEXTURE, SCREEN_UV - vec2(offset * 0.7, offset * 0.7)) * 0.06;
    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(offset * 0.7, -offset * 0.7)) * 0.06;
    col += texture(SCREEN_TEXTURE, SCREEN_UV - vec2(offset * 0.7, -offset * 0.7)) * 0.06;

    COLOR = col;
}