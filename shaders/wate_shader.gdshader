shader_type canvas_item;

// Declare the screen texture uniform
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Ripple effect parameters
uniform vec2 ripple_center : hint_range(0.0, 1.0) = vec2(0.5, 0.5); // Center of the ripple (normalized screen coords)
uniform float ripple_strength : hint_range(0.1, 10.0) = 5.0;        // Strength of the ripple distortion
uniform float ripple_speed : hint_range(0.1, 5.0) = 1.0;            // Speed at which the ripple expands
uniform float ripple_frequency : hint_range(1.0, 20.0) = 10.0;      // Frequency of the ripple waves
uniform float overlay_opacity : hint_range(0.0, 1.0) = 0.3;         // Transparency of the blue tint

void fragment() {
    vec2 uv = SCREEN_UV; // Use screen texture coordinates

    // Calculate distance from the ripple center
    float dist = distance(uv, ripple_center);

    // Create a ripple effect with a sine wave
    float ripple = sin(dist * ripple_frequency - TIME * ripple_speed) * exp(-dist * ripple_strength);

    // Apply the ripple as a distortion
    uv.x += ripple * 0.02; // Adjust distortion scale as needed
    uv.y += ripple * 0.02;

    // Sample the screen texture at the distorted UV coordinates
    vec4 screen_color = texture(SCREEN_TEXTURE, uv);

    // Apply a transparent blue tint
    vec4 blue_tint = vec4(0.1, 0.4, 0.6, overlay_opacity);
    COLOR = mix(screen_color, blue_tint, blue_tint.a);
}
