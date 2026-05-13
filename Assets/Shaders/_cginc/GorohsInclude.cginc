#ifndef GOROHS_INCLUDE
    #define GOROHS_INCLUDE

    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

    #define Deg2Rad 0.0174532924
    #define Rad2Deg 57.2957795

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

    float voronoi(float2 pixel, float seed) {
        float2 i = floor(pixel);
        float2 f = frac(pixel);

        float minDist = 100.0;
        for (int y = -1; y <= 1; y++) {
            for (int x = -1; x <= 1; x++) {
                float2 neighbor = i + float2(x, y);
                float2 p = float2(random(neighbor, seed), random(neighbor, seed + 1.0)) + neighbor;
                float dist = length(p - pixel);
                minDist = min(minDist, dist);
            }
        }
        return minDist;
    }

    // 2番目に近い点との距離
    float voronoi2(float2 pixel, float seed) {
        float2 i = floor(pixel);
        float2 f = frac(pixel);

        float minDist1 = 100.0;
        float minDist2 = 100.0;
        for (int y = -1; y <= 1; y++) {
            for (int x = -1; x <= 1; x++) {
                float2 neighbor = i + float2(x, y);
                float2 p = float2(random(neighbor, seed), random(neighbor, seed + 1.0)) + neighbor;
                float dist = length(p - pixel);
                if (dist < minDist1) {
                    minDist2 = minDist1;
                    minDist1 = dist;
                }
                else if (dist < minDist2) {
                    minDist2 = dist;
                }
            }
        }
        return minDist2;
    }
#endif // GOROHS_INCLUDE