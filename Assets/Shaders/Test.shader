Shader "Custom/Test"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        _Size("Size", Float) = 10.0
        _Seed("Seed", Float) = 0.0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            // #include "../_cginc/GorohsInclude.cginc"
            #include "Assets/Shaders/_cginc/GorohsInclude.cginc"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                float _Size;
                float _Seed;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // float noise = perlinNoise(IN.uv * 10.0, _Seed);

                float noise = voronoi(IN.uv * _Size, _Seed);

                // float noise = voronoi2(IN.uv * _Size, _Seed) - voronoi(IN.uv * _Size, _Seed);
                // noise = smoothstep(0.0, 0.1, noise);
                // noise = step(0.5, noise);
                float4 color = float4(noise, noise, noise, 1.0) * _BaseColor;
                return color;
            }
            ENDHLSL
        }
    }
}
