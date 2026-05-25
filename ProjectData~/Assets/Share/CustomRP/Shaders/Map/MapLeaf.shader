Shader "CustomRP/Map/MapLeaf" {
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
        [Toggle(_S_KEY_MUL_VERTEX_COLOR)] _S_Key_MulVertexColor ("Use Vertex Color", Float) = 0
        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
        [Toggle(_S_KEY_MAP_SKIP_SPECULAR)] _S_Key_MapSkipSpecular ("Skip Specular", Float) = 0
        [HideInInspector] _Cull ("__cull", Float) = 0
        [HideInInspector] _MainTex ("BaseMap", 2D) = "white" { }
        _Preset ("Preset", Float) = 0
        _WindVector ("Wind Vector (xyz=dir, w=phase frequency)", Vector) = (1, 0, 0, 1)
        _WindPower ("Wind Power", Range(0, 1)) = 0.1
        _WindSpeed ("Wind Speed", Range(0, 500)) = 50
        _TranslucentRange ("Translucent Range", Range(0, 1)) = 0.5
        _LambertScale ("Lambert Scale", Range(0, 10)) = 2
        _LightEmmision ("Light Emmision", Range(0, 5)) = 1
        [Toggle(_S_KEY_VERTEX_COLOR_WEIGHT)] _VertexColorWeight ("Vertex Color Wind Weight", Float) = 0
    }

    SubShader
    {
        Tags { "Queue" = "AlphaTest" "RenderPipeline" = "UniversalPipeline" "RenderType" = "TransparentCutout" "IgnoreProjector" = "True" }

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
            float4 _WindVector;
            float _BumpScale;
            float _DetailBumpScale;
            float _Standard_To_Ramp;
            float _ToonShadowRate;
            float _RimLightBlend;
            float _RimLightScale;
            float _DitherAlphaValue;
            float _Cutoff;
            float _WindPower;
            float _WindSpeed;
            float _TranslucentRange;
            float _LambertScale;
            float _LightEmmision;
            float _Preset;
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


        float3 ApplyWind(float3 positionWS, float2 uv)
        {
            float phase      = positionWS.x + positionWS.y + positionWS.z + _Time.x * _WindSpeed;
            float swayFactor = sin(phase) + _WindPower;
            float weight     = uv.y * uv.y * _WindPower;
            return positionWS + _WindVector.xyz * (weight * swayFactor);
        }

        Varyings vert(Attributes i)
        {
            Varyings o = (Varyings)0;
            float3 positionWS = TransformObjectToWorld(i.positionOS.xyz);
            positionWS = ApplyWind(positionWS, i.uv);

            o.positionWS  = positionWS;
            o.positionCS  = TransformWorldToHClip(positionWS);
            o.normalWS    = TransformObjectToWorldNormal(i.normalOS);
            o.tangentWS   = TransformObjectToWorldDir(i.tangentOS.xyz);
            o.bitangentWS = cross(o.normalWS, o.tangentWS) * i.tangentOS.w * unity_WorldTransformParams.w;
            o.uv          = TRANSFORM_TEX(i.uv, _BaseMap);
            o.color       = i.color;
            o.shadowCoord = TransformWorldToShadowCoord(positionWS);
            o.fogFactor   = ComputeFogFactor(o.positionCS.z);
            OUTPUT_LIGHTMAP_UV(i.lightmapUV, unity_LightmapST, o.lightmapUV);
            OUTPUT_SH(o.normalWS, o.vertexSH);
            return o;
        }

        float4 frag(Varyings i) : SV_TARGET
        {
            float4 baseMap   = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv);

            clip(baseMap.a - _Cutoff);

            float4 bumpRaw   = SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, i.uv);
            float4 multiMap  = SAMPLE_TEXTURE2D(_MultiMap, sampler_MultiMap, i.uv);
            float occlusion  = multiMap.b;


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

            float2 toonUV  = float2(saturate(NdotL01 * occlusion), 0.5);
            float toonRamp = SAMPLE_TEXTURE2D(_ToonRamp, sampler_ToonRamp, toonUV).x;


            toonRamp = min(toonRamp, saturate(NdotL01));

            #if defined(_S_KEY_TOON_SHADOW)
                toonRamp = lerp(_ToonShadowRate, toonRamp, mainLight.shadowAttenuation);
            #endif

            float3 albedo = baseMap.rgb * _BaseColor.rgb;


            float wrap = saturate(dot(-N, L) + _TranslucentRange);
            float3 transmission = albedo * (wrap * _LambertScale * _LightEmmision)
                                * mainLight.shadowAttenuation;


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
            float3 finalColor = rim + albedo * lighting + transmission + emission;

            #if defined(_S_KEY_MUL_VERTEX_COLOR)
                finalColor *= i.color.rgb;
            #endif

            finalColor = MixFog(finalColor, i.fogFactor);

            return float4(finalColor, baseMap.a * _BaseColor.a);
        }
        ENDHLSL

        Pass
        {
            Name "Forward"
            Tags { "LightMode" = "UniversalForward" }
            Cull Off
            ZWrite On

            HLSLPROGRAM
            #pragma shader_feature _ _S_KEY_RIM_LIGHT
            #pragma shader_feature _ _S_KEY_TOON_SHADOW
            #pragma shader_feature _ _S_KEY_DETAIL
            #pragma shader_feature _ _S_KEY_MUL_VERTEX_COLOR
            #pragma shader_feature _ _S_KEY_MAP_SKIP_SPECULAR
            #pragma shader_feature _ _S_KEY_VERTEX_COLOR_WEIGHT
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
            Cull Off

            HLSLPROGRAM
            #pragma shader_feature _ _S_KEY_VERTEX_COLOR_WEIGHT
            #pragma vertex shadowVert
            #pragma fragment shadowFrag

            struct ShadowVaryings { float4 positionCS : SV_POSITION; float2 uv : TEXCOORD0; };

            ShadowVaryings shadowVert(Attributes i)
            {
                ShadowVaryings o;
                float3 positionWS = TransformObjectToWorld(i.positionOS.xyz);
                positionWS = ApplyWind(positionWS, i.uv);
                o.positionCS = TransformWorldToHClip(positionWS);
                o.uv = TRANSFORM_TEX(i.uv, _BaseMap);
                return o;
            }
            half4 shadowFrag(ShadowVaryings i) : SV_TARGET
            {
                float a = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv).a;
                clip(a - _Cutoff);
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
            Cull Off

            HLSLPROGRAM
            #pragma shader_feature _ _S_KEY_VERTEX_COLOR_WEIGHT
            #pragma vertex depthVert
            #pragma fragment depthFrag

            struct DepthVaryings { float4 positionCS : SV_POSITION; float2 uv : TEXCOORD0; };

            DepthVaryings depthVert(Attributes i)
            {
                DepthVaryings o;
                float3 positionWS = TransformObjectToWorld(i.positionOS.xyz);
                positionWS = ApplyWind(positionWS, i.uv);
                o.positionCS = TransformWorldToHClip(positionWS);
                o.uv = TRANSFORM_TEX(i.uv, _BaseMap);
                return o;
            }
            half4 depthFrag(DepthVaryings i) : SV_TARGET
            {
                float a = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv).a;
                clip(a - _Cutoff);
                return 0;
            }
            ENDHLSL
        }


        Pass
        {
            Name "DepthNormals"
            Tags { "LightMode" = "DepthNormals" }
            ZWrite On
            Cull Off

            HLSLPROGRAM
            #pragma shader_feature _ _S_KEY_VERTEX_COLOR_WEIGHT
            #pragma vertex dnVert
            #pragma fragment dnFrag

            struct DnVaryings
            {
                float4 positionCS : SV_POSITION;
                float3 normalWS   : TEXCOORD0;
                float2 uv         : TEXCOORD1;
            };

            DnVaryings dnVert(Attributes i)
            {
                DnVaryings o;
                float3 positionWS = TransformObjectToWorld(i.positionOS.xyz);
                positionWS = ApplyWind(positionWS, i.uv);
                o.positionCS = TransformWorldToHClip(positionWS);
                o.normalWS   = TransformObjectToWorldNormal(i.normalOS);
                o.uv         = TRANSFORM_TEX(i.uv, _BaseMap);
                return o;
            }
            half4 dnFrag(DnVaryings i) : SV_TARGET
            {
                float a = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv).a;
                clip(a - _Cutoff);
                return half4(normalize(i.normalWS) * 0.5 + 0.5, 0);
            }
            ENDHLSL
        }
    }

    Fallback "Hidden/Universal Render Pipeline/FallbackError"
}
