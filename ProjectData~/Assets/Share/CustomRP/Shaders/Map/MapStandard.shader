Shader "CustomRP/Map/MapStandard" {
    Properties {
        _BaseColor ("Color", Color) = (1,1,1,1)
        _BaseMap ("Albedo", 2D) = "white" { }
        _BumpMap ("Normal Map", 2D) = "bump" { }
        _BumpScale ("BumpScale", Range(0.01, 2)) = 1
        _MultiMap ("Multi Map (R=Rough G=Metal B=AO A=FaceMask)", 2D) = "black" { }
        _ToonRamp ("Toon Ramp", 2D) = "white" { }
        _Standard_To_Ramp ("Standard_To_Ramp", Range(0, 1)) = 0.025
        [Toggle(_S_KEY_TOON_SHADOW)] _S_Key_ToonShadow ("ApplyToonShadow", Float) = 0
        _ToonShadowRate ("ToonShadowRate", Range(0, 1)) = 0.5
        _EmissionMap ("Emission Map", 2D) = "black" { }
        [HDR] _EmissionColor ("Emission Color", Color) = (0,0,0,1)
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
        [Toggle(_S_KEY_DETAIL)] _S_Key_Detail ("Detail", Float) = 0
        _DetailBumpMap ("Detail Normal Map", 2D) = "bump" { }
        _DetailBumpScale ("DetailScale", Range(0.01, 2)) = 1
        [Toggle(_S_KEY_RIM_LIGHT)] _S_Key_RimLight ("Use Rim Light", Float) = 0
        _RimLightColorLight ("RimLightColorLight", Color) = (1,1,1,1)
        _RimLightColorShadow ("RimLightColorShadow", Color) = (1,1,1,1)
        _RimLightBlend ("RimLightBlend", Range(0, 1)) = 0
        _RimLightScale ("RimLightScale", Range(0, 1)) = 0
        [Toggle(_S_KEY_MUL_VERTEX_COLOR)] _S_Key_MulVertexColor ("Use Vertex Color", Float) = 0
        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
        [Toggle(_S_KEY_MASK_COLOR)] _S_Key_MaskColor ("Mask Color", Float) = 0
        _MaskColorMain ("Mask Color Main", Color) = (1,1,1,0)
        _MaskColorSub ("Mask Color Sub", Color) = (1,1,1,0)
        [Toggle(_S_KEY_MAP_SKIP_SPECULAR)] _S_Key_MapSkipSpecular ("Skip Specular", Float) = 0
        [Toggle(_S_KEY_SKIP_FOG)] _S_Key_SkipFog ("Skip Fog", Float) = 0
        _Surface ("__surface", Float) = 0
        _AlphaClip ("__clip", Float) = 0
        _SrcBlend ("__src", Float) = 1
        _DstBlend ("__dst", Float) = 0
        _ZWrite ("__zw", Float) = 1
        _Cull ("__cull", Float) = 2
        _MainTex ("BaseMap", 2D) = "white" { }
        _Preset ("Preset", Float) = 0
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "IgnoreProjector" = "True" }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

        TEXTURE2D(_BaseMap);            SAMPLER(sampler_BaseMap);
        TEXTURE2D(_BumpMap);            SAMPLER(sampler_BumpMap);
        TEXTURE2D(_MultiMap);           SAMPLER(sampler_MultiMap);
        TEXTURE2D(_ToonRamp);           SAMPLER(sampler_ToonRamp);
        TEXTURE2D(_EmissionMap);        SAMPLER(sampler_EmissionMap);
        TEXTURE2D(_DetailBumpMap);      SAMPLER(sampler_DetailBumpMap);


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
            float4 _MaskColorMain;
            float4 _MaskColorSub;
            float _BumpScale;
            float _DetailBumpScale;
            float _Standard_To_Ramp;
            float _ToonShadowRate;
            float _RimLightBlend;
            float _RimLightScale;
            float _DitherAlphaValue;
            float _Cutoff;
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
            float4 positionOS : POSITION;
            float3 normalOS  : NORMAL;
            float4 tangentOS : TANGENT;
            float4 color     : COLOR;
            float2 uv        : TEXCOORD0;
            float2 lightmapUV : TEXCOORD1;
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
            o.uv         = TRANSFORM_TEX(i.uv, _BaseMap);
            o.color      = i.color;
            o.shadowCoord = TransformWorldToShadowCoord(o.positionWS);
            o.fogFactor  = ComputeFogFactor(o.positionCS.z);


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
            float3 N = normalize(mul(normalTS, TBN));

            float3 V = SafeNormalize(GetWorldSpaceViewDir(i.positionWS));

            Light mainLight = GetMainLight(i.shadowCoord);
            float3 L = SafeNormalize(mainLight.direction);
            float NdotL01 = dot(N, L) * 0.5 + 0.5;
            float NdotV   = saturate(dot(N, V));


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


            float3 bakedGI = SAMPLE_GI(i.lightmapUV, i.vertexSH, normalize(i.normalWS));
            #if !defined(LIGHTMAP_ON)
                bakedGI = max(bakedGI, float3(0.18, 0.18, 0.21));
            #endif


            float3 lighting = saturate(toonRamp.xxx + bakedGI) * occlusion;
            float3 finalColor = rim + albedo * lighting + emission;

            #if defined(_S_KEY_MASK_COLOR)
                float faceMask = multiMap.a;
                finalColor *= lerp(_MaskColorSub.rgb, _MaskColorMain.rgb, faceMask);
            #endif

            #if defined(_S_KEY_MUL_VERTEX_COLOR)
                finalColor *= i.color.rgb;
            #endif

            #if !defined(_S_KEY_SKIP_FOG)
                finalColor = MixFog(finalColor, i.fogFactor);
            #endif

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
            #pragma multi_compile _ _ALPHATEST_ON
            #pragma multi_compile _ _S_KEY_RIM_LIGHT
            #pragma multi_compile _ _S_KEY_TOON_SHADOW
            #pragma multi_compile _ _S_KEY_DETAIL
            #pragma multi_compile _ _S_KEY_MUL_VERTEX_COLOR
            #pragma multi_compile _ _S_KEY_MASK_COLOR
            #pragma multi_compile _ _S_KEY_MAP_SKIP_SPECULAR
            #pragma multi_compile _ _S_KEY_SKIP_FOG
            #pragma multi_compile _ _EMISSION
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
            #pragma multi_compile _ _ALPHATEST_ON

            struct ShadowV2F { float4 positionCS : SV_POSITION; float2 uv : TEXCOORD0; };

            ShadowV2F shadowVert(Attributes i)
            {
                ShadowV2F o;
                o.positionCS = TransformWorldToHClip(TransformObjectToWorld(i.positionOS.xyz));
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
            #pragma multi_compile _ _ALPHATEST_ON

            struct DepthV2F { float4 positionCS : SV_POSITION; float2 uv : TEXCOORD0; };

            DepthV2F depthVert(Attributes i)
            {
                DepthV2F o;
                o.positionCS = TransformWorldToHClip(TransformObjectToWorld(i.positionOS.xyz));
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
            #pragma multi_compile _ _ALPHATEST_ON

            struct DnVaryings
            {
                float4 positionCS : SV_POSITION;
                float3 normalWS   : TEXCOORD0;
                float2 uv         : TEXCOORD1;
            };

            DnVaryings dnVert(Attributes i)
            {
                DnVaryings o;
                o.positionCS = TransformWorldToHClip(TransformObjectToWorld(i.positionOS.xyz));
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
