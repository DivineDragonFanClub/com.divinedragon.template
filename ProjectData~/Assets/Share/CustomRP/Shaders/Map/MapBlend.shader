Shader "CustomRP/Map/MapBlend" {
    Properties {
        _AlbedoMap0 ("AlbedoMap0", 2D) = "white" { }
        _AlbedoMap1 ("AlbedoMap1", 2D) = "white" { }
        _AlbedoMap2 ("AlbedoMap2", 2D) = "white" { }
        _AlbedoMap3 ("AlbedoMap3", 2D) = "white" { }
        _AlbedoMap4 ("AlbedoMap4", 2D) = "black" { }
        _NormalMap0 ("NormalMap0", 2D) = "bump" { }
        _NormalScale0 ("NormalScale0", Range(0.01, 2)) = 1
        _MaskMap ("MaskMap", 2D) = "white" { }
        _BakedAlbedoMap ("BakedAlbedoMap", 2D) = "white" { }
        _BlendBakedAlbedo_MaxDistance ("BlendBakedAlbedo MaxDistance", Range(1, 1000)) = 50
        _BlendBakedAlbedo_CurveExp ("BlendBakedAlbedo CurveExp", Range(0, 8)) = 2
        _BlendBakedAlbedo_MipBias ("BlendBakedAlbedo MipBias", Range(0, 10)) = 2
        _ToonRamp ("Toon Ramp", 2D) = "white" { }
        _Standard_To_Ramp ("Standard_To_Ramp", Range(0, 1)) = 0.025
        [Toggle(_S_KEY_TOON_SHADOW)] _S_Key_ToonShadow ("ApplyToonShadow", Float) = 0
        _ToonShadowRate ("ToonShadowRate", Range(0, 1)) = 0.5
        _EmissionMap ("Emission Map", 2D) = "black" { }
        _EmissionColor ("Emission Color", Color) = (0,0,0,1)
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
        [Toggle(_S_KEY_DETAIL)] _S_Key_Detail ("Detail", Float) = 0
        _DetailBumpMap ("Detail Normal Map", 2D) = "bump" { }
        _DetailBumpScale ("DetailScale", Range(0.01, 2)) = 1
        [Toggle(_S_KEY_RIM_LIGHT)] _S_Key_RimLight ("Use Rim Light", Float) = 0
        _RimLightColorLight ("RimLightColorLight", Color) = (1,1,1,1)
        _RimLightColorShadow ("RimLightColorShadow", Color) = (1,1,1,1)
        _RimLightBlend ("RimLightBlend", Range(0, 1)) = 0
        _RimLightScale ("RimLightScale", Range(0, 1)) = 0
        [Toggle(_S_KEY_ROUGHNESS)] _S_Key_Roughness ("Roughness", Float) = 0
        _RoughnessMap ("RoughnessMap", 2D) = "white" { }
        _RoughnessToWhite ("Roughness To White", Range(0, 1)) = 0
        [Toggle(_S_KEY_MUL_VERTEX_COLOR)] _S_Key_MulVertexColor ("Use Vertex Color", Float) = 0
        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
        [Toggle(_S_KEY_MAP_SKIP_SPECULAR)] _S_Key_MapSkipSpecular ("Skip Specular", Float) = 0
        [Toggle(_S_KEY_SKIP_FOG)] _S_Key_SkipFog ("Skip Fog", Float) = 0
        [Toggle(_S_KEY_5_ALBEDO_LAYERS)] _S_Key_5AlbedoLayers ("5 Albedo Layers", Float) = 0
        [Toggle(_S_KEY_BLEND_BAKED_ALBEDO)] _S_Key_BlendBakedAlbedo ("Blend Baked Albedo Map", Float) = 0
        _Surface ("__surface", Float) = 0
        _AlphaClip ("__clip", Float) = 0
        _SrcBlend ("__src", Float) = 1
        _DstBlend ("__dst", Float) = 0
        _ZWrite ("__zw", Float) = 1
        _Cull ("__cull", Float) = 2
        _Preset ("Preset", Float) = 0
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "IgnoreProjector" = "True" }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

        TEXTURE2D(_AlbedoMap0);     SAMPLER(sampler_AlbedoMap0);
        TEXTURE2D(_AlbedoMap1);     SAMPLER(sampler_AlbedoMap1);
        TEXTURE2D(_AlbedoMap2);     SAMPLER(sampler_AlbedoMap2);
        TEXTURE2D(_AlbedoMap3);     SAMPLER(sampler_AlbedoMap3);
        TEXTURE2D(_AlbedoMap4);     SAMPLER(sampler_AlbedoMap4);
        TEXTURE2D(_NormalMap0);     SAMPLER(sampler_NormalMap0);
        TEXTURE2D(_DetailBumpMap);  SAMPLER(sampler_DetailBumpMap);
        TEXTURE2D(_MaskMap);        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_RoughnessMap);   SAMPLER(sampler_RoughnessMap);
        TEXTURE2D(_BakedAlbedoMap); SAMPLER(sampler_BakedAlbedoMap);
        TEXTURE2D(_EmissionMap);    SAMPLER(sampler_EmissionMap);
        TEXTURE2D(_ToonRamp);       SAMPLER(sampler_ToonRamp);

        CBUFFER_START(UnityPerMaterial)
            float4 _AlbedoMap0_ST;
            float4 _AlbedoMap1_ST;
            float4 _AlbedoMap2_ST;
            float4 _AlbedoMap3_ST;
            float4 _AlbedoMap4_ST;
            float4 _NormalMap0_ST;
            float4 _DetailBumpMap_ST;
            float4 _MaskMap_ST;
            float4 _RoughnessMap_ST;
            float4 _BakedAlbedoMap_ST;
            float4 _EmissionMap_ST;
            float4 _ToonRamp_ST;
            float4 _RimLightColorLight;
            float4 _RimLightColorShadow;
            float4 _EmissionColor;
            float _NormalScale0;
            float _DetailBumpScale;
            float _Standard_To_Ramp;
            float _ToonShadowRate;
            float _RimLightBlend;
            float _RimLightScale;
            float _RoughnessToWhite;
            float _DitherAlphaValue;
            float _Cutoff;
            float _BlendBakedAlbedo_MaxDistance;
            float _BlendBakedAlbedo_CurveExp;
            float _BlendBakedAlbedo_MipBias;
            float _Preset;
            float _Surface;
            float _AlphaClip;
            float _SrcBlend;
            float _DstBlend;
            float _ZWrite;
            float _Cull;
        CBUFFER_END

        struct Attributes
        {
            float4 positionOS  : POSITION;
            float3 normalOS    : NORMAL;
            float4 tangentOS   : TANGENT;
            float4 color       : COLOR;
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
            float4 color       : TEXCOORD5;
            float4 shadowCoord : TEXCOORD6;
            float  fogFactor   : TEXCOORD7;
            DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 8);
        };

        Varyings vert(Attributes i)
        {
            Varyings o = (Varyings)0;
            o.positionWS = TransformObjectToWorld(i.positionOS.xyz);
            o.positionCS = TransformWorldToHClip(o.positionWS);
            o.normalWS   = TransformObjectToWorldNormal(i.normalOS);
            o.tangentWS  = TransformObjectToWorldDir(i.tangentOS.xyz);
            o.bitangentWS = cross(o.normalWS, o.tangentWS) * i.tangentOS.w * unity_WorldTransformParams.w;
            o.uv         = i.uv;
            o.color      = i.color;
            o.shadowCoord = TransformWorldToShadowCoord(o.positionWS);
            o.fogFactor  = ComputeFogFactor(o.positionCS.z);
            OUTPUT_LIGHTMAP_UV(i.lightmapUV, unity_LightmapST, o.lightmapUV);
            OUTPUT_SH(o.normalWS, o.vertexSH);
            return o;
        }


        float3 BlendAlbedo(float2 uv, float4 mask)
        {
            float3 a0 = SAMPLE_TEXTURE2D(_AlbedoMap0, sampler_AlbedoMap0, uv * _AlbedoMap0_ST.xy + _AlbedoMap0_ST.zw).rgb;
            float3 a1 = SAMPLE_TEXTURE2D(_AlbedoMap1, sampler_AlbedoMap1, uv * _AlbedoMap1_ST.xy + _AlbedoMap1_ST.zw).rgb;
            float3 a2 = SAMPLE_TEXTURE2D(_AlbedoMap2, sampler_AlbedoMap2, uv * _AlbedoMap2_ST.xy + _AlbedoMap2_ST.zw).rgb;
            float3 a3 = SAMPLE_TEXTURE2D(_AlbedoMap3, sampler_AlbedoMap3, uv * _AlbedoMap3_ST.xy + _AlbedoMap3_ST.zw).rgb;
            float3 blended = a0 * mask.r + a1 * mask.g + a2 * mask.b + a3 * mask.a;

            #if defined(_S_KEY_5_ALBEDO_LAYERS)
                float3 a4 = SAMPLE_TEXTURE2D(_AlbedoMap4, sampler_AlbedoMap4, uv * _AlbedoMap4_ST.xy + _AlbedoMap4_ST.zw).rgb;
                float w4 = saturate(1.0 - mask.r - mask.g - mask.b - mask.a);
                blended += a4 * w4;
            #endif

            return blended;
        }

        float4 frag(Varyings i) : SV_TARGET
        {

            float4 mask = SAMPLE_TEXTURE2D(_MaskMap, sampler_MaskMap, i.uv * _MaskMap_ST.xy + _MaskMap_ST.zw);


            float3 albedo = BlendAlbedo(i.uv, mask);


            float3 N_geo = normalize(i.normalWS);
            float3 T     = normalize(i.tangentWS);
            float3 B     = normalize(i.bitangentWS);
            float3x3 TBN = float3x3(T, B, N_geo);


            float3 nmainTS = UnpackNormalScale(
                SAMPLE_TEXTURE2D(_NormalMap0, sampler_NormalMap0,
                                 i.uv * _NormalMap0_ST.xy + _NormalMap0_ST.zw),
                _NormalScale0);
            #if defined(_S_KEY_DETAIL)
                float3 ndetTS = UnpackNormalScale(
                    SAMPLE_TEXTURE2D(_DetailBumpMap, sampler_DetailBumpMap,
                                     i.uv * _DetailBumpMap_ST.xy + _DetailBumpMap_ST.zw),
                    _DetailBumpScale * 0.5);
                nmainTS = normalize(float3(nmainTS.xy + ndetTS.xy, nmainTS.z * ndetTS.z));
            #endif
            float3 N = normalize(mul(nmainTS, TBN));

            float3 V = SafeNormalize(GetWorldSpaceViewDir(i.positionWS));


            Light mainLight = GetMainLight(i.shadowCoord);
            float3 L = SafeNormalize(mainLight.direction);
            float NdotL01 = dot(N, L) * 0.5 + 0.5;


            float NdotV   = saturate(dot(N_geo, V));

            float2 toonUV = float2(saturate(NdotL01), 0.5);
            float toonRamp = SAMPLE_TEXTURE2D(_ToonRamp, sampler_ToonRamp, toonUV).x;


            toonRamp = min(toonRamp, saturate(NdotL01));

            #if defined(_S_KEY_TOON_SHADOW)
                toonRamp = lerp(_ToonShadowRate, toonRamp, mainLight.shadowAttenuation);
            #endif


            float3 rim = 0;
            #if defined(_S_KEY_RIM_LIGHT)
                float rimEdge   = smoothstep(1.0 - _RimLightBlend, 1.0, 1.0 - NdotV) * _RimLightScale;
                float3 rimColor = lerp(_RimLightColorShadow.rgb, _RimLightColorLight.rgb, NdotL01);
                rim = rimColor * rimEdge;
            #endif


            float3 emission = SAMPLE_TEXTURE2D(_EmissionMap, sampler_EmissionMap,
                                               i.uv * _EmissionMap_ST.xy + _EmissionMap_ST.zw).rgb * _EmissionColor.rgb;


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
            float3 finalColor = rim + albedo * lighting + emission;

            #if defined(_S_KEY_MUL_VERTEX_COLOR)
                finalColor *= i.color.rgb;
            #endif

            #if !defined(_S_KEY_SKIP_FOG)
                finalColor = MixFog(finalColor, i.fogFactor);
            #endif

            return float4(finalColor, 1);
        }
        ENDHLSL

        Pass
        {
            Name "Forward"
            Tags { "LightMode" = "UniversalForward" }
            Cull [_Cull]
            ZWrite [_ZWrite]

            HLSLPROGRAM
            #pragma shader_feature _ _S_KEY_RIM_LIGHT
            #pragma shader_feature _ _S_KEY_TOON_SHADOW
            #pragma shader_feature _ _S_KEY_DETAIL
            #pragma shader_feature _ _S_KEY_MUL_VERTEX_COLOR
            #pragma shader_feature _ _S_KEY_5_ALBEDO_LAYERS
            #pragma shader_feature _ _S_KEY_BLEND_BAKED_ALBEDO
            #pragma shader_feature _ _S_KEY_MAP_SKIP_SPECULAR
            #pragma shader_feature _ _S_KEY_SKIP_FOG
            #pragma shader_feature _ _S_KEY_ROUGHNESS
            #pragma multi_compile_fog
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ LOD_FADE_CROSSFADE
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
            Cull [_Cull]

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
            Cull [_Cull]

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
            Cull [_Cull]

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
