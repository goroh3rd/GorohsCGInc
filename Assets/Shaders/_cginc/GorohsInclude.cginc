#ifndef GOROHS_INCLUDE
    #define GOROHS_INCLUDE

    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

    // Your shader code here
    // 乱数生成
    float hash(float2 p) {
        float2 q = frac(p * float2(0.1031, 0.1030));
        q += dot(q, q.yx + 33.33);
        return frac((q.x + q.y) * q.x  * q.y);
    }

    float random(float2 pixel, float seed) {
        float2 p = pixel + float2(frac(seed * 127.1), frac(seed * 311.7)) * 1000.0;
        float h1 = hash(p);
        float h2 = hash(float2(h1 * 1732.453, p.y * 0.7653 + p.x * 0.3421));
        return hash(float2(h2 * 2841.319, h1 * 1567.823));
    }

    float2 randomVector(float2 p, float seed = 0.0) {
        float h = random(p, seed) * 6.283185; // 0 ~ 2π の範囲
        return float2(cos(h), sin(h));
    }

    float perlinNoise(float2 pixel, float seed) {
        float2 i = floor(pixel);
        float2 f = frac(pixel);

        float a = dot(randomVector(i + float2(0,0), seed), f - float2(0,0));
        float b = dot(randomVector(i + float2(1,0), seed), f - float2(1,0));
        float c = dot(randomVector(i + float2(0,1), seed), f - float2(0,1));
        float d = dot(randomVector(i + float2(1,1), seed), f - float2(1,1));

        float2 u = f * f * (3.0 - 2.0 * f);

        return lerp(lerp(a, b, u.x), lerp(c, d, u.x), u.y);

    }
#endif // GOROHS_INCLUDE