#pragma header

uniform float intensity;
uniform float contrast;
uniform float desaturation;
uniform float blueTint;
uniform float vignetteStrength;
uniform float shadowDepth;
uniform float grainAmount;

#define iChannel0 bitmap
#define texture flixel_texture2D

// Grain for melancholy atmosphere
float random(vec2 co)
{
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float getGrain(vec2 uv, float amount)
{
    if (amount < 0.001) return 1.0;
    float n = random(uv * openfl_TextureSize + openfl_TextureSize * 0.5);
    return 1.0 + (n - 0.5) * amount;
}

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec4 original = texture(iChannel0, uv);
    vec3 color = original.rgb;

    // 1. Desaturation: wash out colors for melancholy
    float grey = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(color, vec3(grey), desaturation);

    // 2. Blue-tinted cold tone: shift towards deep blue
    vec3 coldTone = vec3(0.65, 0.72, 0.95);
    color = mix(color, color * coldTone, blueTint);

    // 3. Contrast boost: crush blacks, push highlights
    color = (color - 0.5) * contrast + 0.5;

    // 4. Shadow crush: deepen darks further
    float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
    float shadowMask = 1.0 - smoothstep(0.0, shadowDepth, lum);
    color -= shadowMask * shadowDepth * 0.3;

    // 5. Heavy vignette
    vec2 center = uv - 0.5;
    float dist = length(center);
    float vignette = 1.0 - smoothstep(0.2, 0.75, dist * vignetteStrength * 1.8);
    // Tint vignette with dark blue for extra melancholy
    vec3 vignetteColor = vec3(0.85, 0.88, 1.05);
    color *= mix(vignetteColor, vec3(1.0), vignette);

    // 6. Subtle film grain
    float grain = getGrain(uv, grainAmount);
    color *= grain;

    // 7. Final intensity blend
    gl_FragColor = vec4(color, original.a);
}
