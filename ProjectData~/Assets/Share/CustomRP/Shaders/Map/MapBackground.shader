Shader "CustomRP/Map/MapBackground" {
    Properties {
        _BaseColor ("Color", Color) = (1, 1, 1, 1)
        _BaseMap ("Albedo", 2D) = "white" { }
        _BumpMap ("Normal Map", 2D) = "bump" { }
        _BumpScale ("BumpScale", Range(0.01, 2)) = 1
        _ToonRamp ("Toon Ramp", 2D) = "white" { }
        _Standard_To_Ramp ("Standard_To_Ramp", Range(0, 1)) = 0.025
        [Toggle(_NORMALMAP)] _UseNormalMap ("Use Normal Map", Float) = 0
        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "IgnoreProjector" = "True" }
        LOD 300

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

        TEXTURE2D(_BaseMap);   SAMPLER(sampler_BaseMap);
        TEXTURE2D(_BumpMap);   SAMPLER(sampler_BumpMap);
        TEXTURE2D(_ToonRamp);  SAMPLER(sampler_ToonRamp);

        CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _BumpMap_ST;
            float4 _ToonRamp_ST;
            float4 _BaseColor;
            float _BumpScale;
            float _Standard_To_Ramp;
            float _DitherAlphaValue;
        CBUFFER_END

        struct Attributes
        {
            float4 positionOS  : POSITION;
            float3 normalOS    : NORMAL;
            float4 tangentOS   : TANGENT;
            float2 uv          : TEXCOORD0;
            float2 lightmapUV  : TEXCOORD1;
        };

        struct Varyings
        {
            float4 positionCS  : SV_POSITION;
            float3 positionWS  : TEXCOORD0;
            float3 normalWS    : TEXCOORD1;
            float3 tangentWS   : TEXCOORD2;
            float3 bitangentWS : TEXCOORD3;
            float2 uv          : TEXCOORD4;
            float4 shadowCoord : TEXCOORD5;
            float  fogFactor   : TEXCOORD6;
            DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 7);
        };

        Varyings vert(Attributes i)
        {
            Varyings o = (Varyings)0;
            o.positionWS  = TransformObjectToWorld(i.positionOS.xyz);
            o.positionCS  = TransformWorldToHClip(o.positionWS);
            o.normalWS    = TransformObjectToWorldNormal(i.normalOS);
            o.tangentWS   = TransformObjectToWorldDir(i.tangentOS.xyz);
            o.bitangentWS = cross(o.normalWS, o.tangentWS) * i.tangentOS.w * unity_WorldTransformParams.w;
            o.uv          = TRANSFORM_TEX(i.uv, _BaseMap);
            o.shadowCoord = TransformWorldToShadowCoord(o.positionWS);
            o.fogFactor   = ComputeFogFactor(o.positionCS.z);
            OUTPUT_LIGHTMAP_UV(i.lightmapUV, unity_LightmapST, o.lightmapUV);
            OUTPUT_SH(o.normalWS, o.vertexSH);
            return o;
        }

        float4 frag(Varyings i) : SV_TARGET
        {
            float4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv);
            float3 albedo = baseMap.rgb * _BaseColor.rgb;


            float3 N_geo = normalize(i.normalWS);
            #if defined(_NORMALMAP)
                float3 T = normalize(i.tangentWS);
                float3 B = normalize(i.bitangentWS);
                float3x3 TBN = float3x3(T, B, N_geo);
                float3 normalTS = UnpackNormalScale(
                    SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, i.uv), _BumpScale);
                float3 N = normalize(mul(normalTS, TBN));
            #else
                float3 N = N_geo;
            #endif

            float3 V = SafeNormalize(GetWorldSpaceViewDir(i.positionWS));


            #if defined(_KEY_DITHER_ALPHA)
                int2 px = int2(i.positionCS.xy) & 3;
                float bayer = (px.y * 4 + px.x) * (1.0 / 16.0);
                clip(_DitherAlphaValue - bayer);
            #endif


            Light mainLight = GetMainLight(i.shadowCoord);
            float3 L = SafeNormalize(mainLight.direction);
            float NdotL01 = dot(N, L) * 0.5 + 0.5;
            float2 toonUV = float2(saturate(NdotL01), 0.5);
            float toonRamp = SAMPLE_TEXTURE2D(_ToonRamp, sampler_ToonRamp, toonUV).x;


            toonRamp = min(toonRamp, saturate(NdotL01));


            float3 bakedGI = SAMPLE_GI(i.lightmapUV, i.vertexSH, N);
            #if defined(LIGHTMAP_ON)
                // Reinhard soft-clamp - PPv2-style Tonemapping in the shipped Volume is a
                // no-op in URP; this keeps HDR lightmap peaks from blowing out under Bloom.
                bakedGI = bakedGI / (1.0 + bakedGI);
            #else
                bakedGI = max(bakedGI, float3(0.18, 0.18, 0.21));
            #endif


            // Lightmap-trusted compose. The realtime direct contribution is gated by the
            // lightmap's luminance so it doesn't leak sun into baked-shadow regions.
            float3 directLight = toonRamp * mainLight.color;
            #if defined(LIGHTMAP_ON)
                float lightmapLumi = dot(bakedGI, float3(0.299, 0.587, 0.114));
                float directGate   = saturate(lightmapLumi * 3.0);
                float3 lighting    = bakedGI + directLight * 0.3 * directGate;
            #else
                float3 lighting = directLight + bakedGI;
            #endif
            float3 finalColor = albedo * lighting;

            finalColor = MixFog(finalColor, i.fogFactor);

            return float4(finalColor, baseMap.a * _BaseColor.a);
        }
        ENDHLSL

        Pass
        {
            Name "Forward"
            Tags { "LightMode" = "UniversalForward" }
            ZWrite On
            Cull Back

            HLSLPROGRAM
            #pragma shader_feature _ _NORMALMAP
            #pragma shader_feature _ _KEY_DITHER_ALPHA
            #pragma multi_compile_fog
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma vertex vert
            #pragma fragment frag
            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On
            ColorMask 0
            Cull Back

            HLSLPROGRAM
            #pragma vertex shadowVert
            #pragma fragment shadowFrag

            float4 shadowVert(Attributes i) : SV_POSITION
            {
                return TransformWorldToHClip(TransformObjectToWorld(i.positionOS.xyz));
            }
            half4 shadowFrag() : SV_TARGET { return 0; }
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags { "LightMode" = "DepthOnly" }
            ZWrite On
            ColorMask 0
            Cull Back

            HLSLPROGRAM
            #pragma vertex depthVert
            #pragma fragment depthFrag

            float4 depthVert(Attributes i) : SV_POSITION
            {
                return TransformWorldToHClip(TransformObjectToWorld(i.positionOS.xyz));
            }
            half4 depthFrag() : SV_TARGET { return 0; }
            ENDHLSL
        }

        Pass
        {
            Name "DepthNormals"
            Tags { "LightMode" = "DepthNormals" }
            ZWrite On
            Cull Back

            HLSLPROGRAM
            #pragma vertex dnVert
            #pragma fragment dnFrag

            struct DnVaryings { float4 positionCS : SV_POSITION; float3 normalWS : TEXCOORD0; };

            DnVaryings dnVert(Attributes i)
            {
                DnVaryings o;
                o.positionCS = TransformWorldToHClip(TransformObjectToWorld(i.positionOS.xyz));
                o.normalWS   = TransformObjectToWorldNormal(i.normalOS);
                return o;
            }
            half4 dnFrag(DnVaryings i) : SV_TARGET
            {
                return half4(normalize(i.normalWS) * 0.5 + 0.5, 0);
            }
            ENDHLSL
        }
    }

    Fallback "Hidden/Universal Render Pipeline/FallbackError"
}
