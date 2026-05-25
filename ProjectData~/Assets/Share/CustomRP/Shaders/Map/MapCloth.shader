Shader "CustomRP/Map/MapCloth" {
    Properties {
        _BaseColor ("Color", Color) = (1, 1, 1, 1)
        _BaseMap ("Albedo", 2D) = "white" { }
        _BumpMap ("Normal Map", 2D) = "bump" { }
        _BumpScale ("BumpScale", Range(0.01, 2)) = 1
        _MultiMap ("Multi Map (R=Rough G=Metal B=AO A=FaceMask)", 2D) = "black" { }
        _ToonRamp ("Toon Ramp", 2D) = "white" { }
        _Standard_To_Ramp ("Standard_To_Ramp", Range(0, 1)) = 0.025
        [Toggle(_S_KEY_TOON_SHADOW)] _S_Key_ToonShadow ("ApplyToonShadow", Float) = 0
        _ToonShadowRate ("ToonShadowRate", Range(0, 1)) = 0.5
        _EmissionMap ("Emission Map", 2D) = "black" { }
        _EmissionColor ("Emission Color", Color) = (0, 0, 0, 1)
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
        [Toggle(_S_KEY_DETAIL)] _S_Key_Detail ("Detail", Float) = 0
        _DetailBumpMap ("Detail Normal Map", 2D) = "bump" { }
        _DetailBumpScale ("DetailScale", Range(0.01, 2)) = 1
        [Toggle(_S_KEY_RIM_LIGHT)] _S_Key_RimLight ("Use Rim Light", Float) = 0
        _RimLightColorLight ("RimLightColorLight", Color) = (1, 1, 1, 1)
        _RimLightColorShadow ("RimLightColorShadow", Color) = (1, 1, 1, 1)
        _RimLightBlend ("RimLightBlend", Range(0, 1)) = 0
        _RimLightScale ("RimLightScale", Range(0, 1)) = 0
        [Toggle(_S_KEY_MUL_VERTEX_COLOR)] _S_Key_MulVertexColor ("Use Vertex Color", Float) = 0
        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
        [HideInInspector] _Surface ("__surface", Float) = 0
        [HideInInspector] _AlphaClip ("__clip", Float) = 0
        [HideInInspector] _SrcBlend ("__src", Float) = 1
        [HideInInspector] _DstBlend ("__dst", Float) = 0
        [HideInInspector] _ZWrite ("__zw", Float) = 1
        [HideInInspector] _Cull ("__cull", Float) = 0
        _Preset ("Preset", Float) = 0
        _WindPower ("Wind Power (xyz=dir, w=global weight)", Vector) = (1, 1, 1, 1)
        _WaveSpeed ("Wave Speed", Range(0, 30)) = 1
        _WaveSpan ("Wave Span", Range(0, 10)) = 0.5
        _Delta ("Delta Normal", Range(0, 10)) = 0.1
        _OffsetScale ("Offset Scale (worldspace radial term)", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "IgnoreProjector" = "True" }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

        TEXTURE2D(_BaseMap);          SAMPLER(sampler_BaseMap);
        TEXTURE2D(_BumpMap);          SAMPLER(sampler_BumpMap);
        TEXTURE2D(_MultiMap);         SAMPLER(sampler_MultiMap);
        TEXTURE2D(_ToonRamp);         SAMPLER(sampler_ToonRamp);
        TEXTURE2D(_EmissionMap);      SAMPLER(sampler_EmissionMap);
        TEXTURE2D(_DetailBumpMap);    SAMPLER(sampler_DetailBumpMap);

        CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _BumpMap_ST;
            float4 _MultiMap_ST;
            float4 _ToonRamp_ST;
            float4 _EmissionMap_ST;
            float4 _DetailBumpMap_ST;
            float4 _BaseColor;
            float4 _EmissionColor;
            float4 _RimLightColorLight;
            float4 _RimLightColorShadow;
            float4 _WindPower;
            float _BumpScale;
            float _DetailBumpScale;
            float _Standard_To_Ramp;
            float _ToonShadowRate;
            float _RimLightBlend;
            float _RimLightScale;
            float _DitherAlphaValue;
            float _Cutoff;
            float _WaveSpeed;
            float _WaveSpan;
            float _Delta;
            float _OffsetScale;
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

        float3 ApplyClothWind(float3 positionOS, float3 normalOS, float vertexColorR)
        {
            float3 worldPosForRadial = TransformObjectToWorld(positionOS) * _OffsetScale;
            float radialPhase = length(worldPosForRadial.xz);
            float phase = (radialPhase + _Time.y) * _WaveSpeed
                        + dot(positionOS, _WindPower.xyz) * 2.0 * _WaveSpan;
            float wave = sin(phase);
            float weight = vertexColorR * _WindPower.w;
            return positionOS + wave * weight * float3(normalOS.x, normalOS.y, -normalOS.z);
        }

        Varyings vert(Attributes i)
        {
            Varyings o = (Varyings)0;
            float3 displacedOS = ApplyClothWind(i.positionOS.xyz, i.normalOS, i.color.r);
            o.positionWS  = TransformObjectToWorld(displacedOS);
            o.positionCS  = TransformWorldToHClip(o.positionWS);
            o.normalWS    = TransformObjectToWorldNormal(i.normalOS);
            o.tangentWS   = TransformObjectToWorldDir(i.tangentOS.xyz);
            o.bitangentWS = cross(o.normalWS, o.tangentWS) * i.tangentOS.w * unity_WorldTransformParams.w;
            o.uv          = TRANSFORM_TEX(i.uv, _BaseMap);
            o.color       = i.color;
            o.shadowCoord = TransformWorldToShadowCoord(o.positionWS);
            o.fogFactor   = ComputeFogFactor(o.positionCS.z);
            OUTPUT_LIGHTMAP_UV(i.lightmapUV, unity_LightmapST, o.lightmapUV);
            OUTPUT_SH(o.normalWS, o.vertexSH);
            return o;
        }

        float4 frag(Varyings i) : SV_TARGET
        {
            float4 baseMap   = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv);

            #if defined(_ALPHATEST_ON)
                clip(baseMap.a - _Cutoff);
            #endif

            float4 bumpRaw   = SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, i.uv);
            float4 multiMap  = SAMPLE_TEXTURE2D(_MultiMap, sampler_MultiMap, i.uv);
            float occlusion = multiMap.b;

            float3 N_geo = normalize(i.normalWS);
            float3 T     = normalize(i.tangentWS);
            float3 B     = normalize(i.bitangentWS);
            float3x3 TBN = float3x3(T, B, N_geo);

            float3 normalTS = UnpackNormalScale(bumpRaw, _BumpScale);
            #if defined(_S_KEY_DETAIL)
                float3 ndetTS = UnpackNormalScale(
                    SAMPLE_TEXTURE2D(_DetailBumpMap, sampler_DetailBumpMap,
                        i.uv * _DetailBumpMap_ST.xy + _DetailBumpMap_ST.zw),
                    _DetailBumpScale * 0.5);
                normalTS = normalize(float3(normalTS.xy + ndetTS.xy, normalTS.z * ndetTS.z));
            #endif
            float3 N = normalize(mul(normalTS, TBN));

            float3 V = SafeNormalize(GetWorldSpaceViewDir(i.positionWS));

            Light mainLight = GetMainLight(i.shadowCoord);
            float3 L = SafeNormalize(mainLight.direction);
            float NdotL01 = dot(N, L) * 0.5 + 0.5;
            float NdotV   = saturate(dot(N_geo, V));

            float2 toonUV = float2(saturate(NdotL01 * occlusion), 0.5);
            float toonRamp = SAMPLE_TEXTURE2D(_ToonRamp, sampler_ToonRamp, toonUV).x;

            toonRamp = min(toonRamp, saturate(NdotL01));

            #if defined(_S_KEY_TOON_SHADOW)
                toonRamp = lerp(_ToonShadowRate, toonRamp, mainLight.shadowAttenuation);
            #endif

            float3 albedo = baseMap.rgb * _BaseColor.rgb;

            float3 rim = 0;
            #if defined(_S_KEY_RIM_LIGHT)
                float rimEdge   = smoothstep(1.0 - _RimLightBlend, 1.0, 1.0 - NdotV) * _RimLightScale;
                float3 rimColor = lerp(_RimLightColorShadow.rgb, _RimLightColorLight.rgb, NdotL01 * occlusion);
                rim = rimColor * rimEdge;
            #endif

            float3 emission = SAMPLE_TEXTURE2D(_EmissionMap, sampler_EmissionMap, i.uv).rgb * _EmissionColor.rgb;

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
                float3 lighting    = (bakedGI + directLight * 0.3 * directGate) * occlusion;
            #else
                float3 lighting = (directLight + bakedGI) * occlusion;
            #endif
            float3 finalColor = rim + albedo * lighting + emission;

            #if defined(_S_KEY_MUL_VERTEX_COLOR)
                finalColor *= i.color.rgb;
            #endif

            #if defined(_KEY_DITHER_ALPHA)
                int2 px = int2(i.positionCS.xy) & 3;
                float bayer = (px.y * 4 + px.x) * (1.0 / 16.0);
                clip(_DitherAlphaValue - bayer);
            #endif

            finalColor = MixFog(finalColor, i.fogFactor);

            return float4(finalColor, baseMap.a * _BaseColor.a);
        }
        ENDHLSL

        Pass
        {
            Name "Forward"
            Tags { "LightMode" = "UniversalForward" }
            Cull [_Cull]
            ZWrite [_ZWrite]

            HLSLPROGRAM
            #pragma shader_feature _ _ALPHATEST_ON
            #pragma shader_feature _ _S_KEY_TOON_SHADOW
            #pragma shader_feature _ _S_KEY_DETAIL
            #pragma shader_feature _ _S_KEY_RIM_LIGHT
            #pragma shader_feature _ _S_KEY_MUL_VERTEX_COLOR
            #pragma shader_feature _ _KEY_DITHER_ALPHA
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
            #pragma shader_feature _ _ALPHATEST_ON

            struct ShadowV2F { float4 positionCS : SV_POSITION; float2 uv : TEXCOORD0; };

            ShadowV2F shadowVert(Attributes i)
            {
                ShadowV2F o;
                float3 displacedOS = ApplyClothWind(i.positionOS.xyz, i.normalOS, i.color.r);
                o.positionCS = TransformWorldToHClip(TransformObjectToWorld(displacedOS));
                o.uv = TRANSFORM_TEX(i.uv, _BaseMap);
                return o;
            }
            half4 shadowFrag(ShadowV2F i) : SV_TARGET
            {
                #if defined(_ALPHATEST_ON)
                    float a = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv).a * _BaseColor.a;
                    clip(a - _Cutoff);
                #endif
                return 0;
            }
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
            #pragma shader_feature _ _ALPHATEST_ON

            struct DepthV2F { float4 positionCS : SV_POSITION; float2 uv : TEXCOORD0; };

            DepthV2F depthVert(Attributes i)
            {
                DepthV2F o;
                float3 displacedOS = ApplyClothWind(i.positionOS.xyz, i.normalOS, i.color.r);
                o.positionCS = TransformWorldToHClip(TransformObjectToWorld(displacedOS));
                o.uv = TRANSFORM_TEX(i.uv, _BaseMap);
                return o;
            }
            half4 depthFrag(DepthV2F i) : SV_TARGET
            {
                #if defined(_ALPHATEST_ON)
                    float a = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv).a * _BaseColor.a;
                    clip(a - _Cutoff);
                #endif
                return 0;
            }
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
            #pragma shader_feature _ _ALPHATEST_ON

            struct DnVaryings
            {
                float4 positionCS : SV_POSITION;
                float3 normalWS   : TEXCOORD0;
                float2 uv         : TEXCOORD1;
            };

            DnVaryings dnVert(Attributes i)
            {
                DnVaryings o;
                float3 displacedOS = ApplyClothWind(i.positionOS.xyz, i.normalOS, i.color.r);
                o.positionCS = TransformWorldToHClip(TransformObjectToWorld(displacedOS));
                o.normalWS   = TransformObjectToWorldNormal(i.normalOS);
                o.uv         = TRANSFORM_TEX(i.uv, _BaseMap);
                return o;
            }
            half4 dnFrag(DnVaryings i) : SV_TARGET
            {
                #if defined(_ALPHATEST_ON)
                    float a = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv).a * _BaseColor.a;
                    clip(a - _Cutoff);
                #endif
                return half4(normalize(i.normalWS) * 0.5 + 0.5, 0);
            }
            ENDHLSL
        }
    }

    Fallback "Hidden/Universal Render Pipeline/FallbackError"
}
