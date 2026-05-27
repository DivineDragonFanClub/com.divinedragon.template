Shader "CustomRP/Chara/CharaStandard"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        _BaseMap ("Albedo", 2D) = "white" { }
        [Toggle(_NORMALMAP)] _S_Key_NormalMap ("Use Normal Map", Float) = 1
        _BumpMap ("Normal Map", 2D) = "bump" { }
        _BumpScale ("Bump Scale", Range(0.01, 2)) = 1
        _MultiMap ("Multi Map (R=Rough G=Metal B=AO A=FaceMask)", 2D) = "black" { }
        _ToonRamp ("Toon Ramp", 2D) = "white" { }
        _ToonRampMetal ("Toon Ramp Metal", 2D) = "white" { }
        _ToonShadowColor ("Toon Shadow Color", Color) = (1, 1, 1, 1)
        _Makeup ("Makeup", Range(0, 1)) = 0
        _OcclusionIntensity ("Occlusion Intensity", Range(0, 1)) = 0.5
        _EmissionMap ("Emission Map", 2D) = "white" { }
        [HDR] _EmissionColor ("Emission Color", Color) = (0, 0, 0, 1)

        _OutlineColor ("Outline Color", Color) = (0.294, 0.243, 0.243, 1)
        _OutlineScale ("Outline Scale", Range(0, 10)) = 4
        _OutlineTexMipLevel ("Outline Tex Mip Level", Range(0, 12)) = 4
        _OutlineOriginalColorRate ("Outline Original Color Rate", Range(0, 1)) = 0
        _OutlineGameScale ("Outline Game Scale", Range(0, 1)) = 1
        [Toggle] _DisableOutline ("Disable Outline", Float) = 0

        [Toggle(_S_KEY_RIMLIGHT_ON)] _S_Key_RimLight ("Use Rim Light", Float) = 1
        _RimLightColorLight ("Rim Light Color Light", Color) = (0.690, 0.7098, 0.8980, 1)
        _RimLightColorShadow ("Rim Light Color Shadow", Color) = (0.4588, 0.4784, 0.6588, 1)
        _RimLightBlend ("Rim Light Blend", Range(0, 1)) = 0.25
        _RimLightScale ("Rim Light Scale", Range(0, 1)) = 0.45

        [Toggle(_S_KEY_COLOR_CHANGE_MASK)] _S_Key_ColorChangeMask ("Color Change Mask", Float) = 0
        _ColorChangeMask100 ("Mask 1.0",  Color) = (0.180, 0.278, 0.431, 1)
        _ColorChangeMask075 ("Mask 0.75", Color) = (0.094, 0.416, 0.529, 1)
        _ColorChangeMask050 ("Mask 0.5",  Color) = (0.192, 0.227, 0.286, 1)
        _ColorChangeMask025 ("Mask 0.25", Color) = (0.588, 0.588, 0.588, 1)

        _LightColorToWhite ("Light Color To White", Range(0, 1)) = 0
        _LightShadowToWhite ("Light Shadow To White", Range(0, 1)) = 0

        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1

        [Toggle(_KEY_ENGAGE)] _Key_Engage ("Engage", Float) = 0
        _EngageEmissionColor ("Engage Emission Color", Color) = (0.314, 0.314, 0.47, 1)


        [Toggle(_S_KEY_BUMP_ATTENUATION)] _S_Key_BumpAttenuation ("Bump Attenuation", Float) = 1
        _BumpCameraAttenuation ("Bump Camera Attenuation", Range(0, 1)) = 0.2
        [Toggle(_S_KEY_MORPH_SKIN)] _S_Key_MorphSkin ("Morph (Skin)", Float) = 0
        _MorphPatternMap ("Morph Pattern Map", 2D) = "white" { }
        _MorphEmissionMap ("Morph Emission Map", 2D) = "white" { }
        [Toggle(_S_KEY_MORPH_DRESS)] _S_Key_MorphDress ("Morph (Dress)", Float) = 0
        _ToonRamp_Morph ("Toon Ramp Morph", 2D) = "white" { }
        _ToonRampMetal_Morph ("Toon Ramp Metal Morph", 2D) = "white" { }
        [Toggle(_S_KEY_STANDARD_COLOR)] _S_Key_StandardColor ("Standard Color", Float) = 0
        [Toggle(_S_KEY_STANDARD_SKIN)] _S_Key_StandardSkin ("Standard Skin", Float) = 0
        [Toggle(_DEV_KEY_TOON_SPECULAR_BY_LIGHT)] _Dev_KeyToonSpecularByLight ("(DEV) Metal Type", Float) = 0
        [Toggle(_DEBUG_CUSTOM_OUTLINE_ONLY)] _DEBUG_CUSTOM_OUTLINE_ONLY ("Debug Outline Only", Float) = 0
        _Preset ("Preset", Float) = 0
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "IgnoreProjector" = "True" }
        LOD 300

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

        TEXTURE2D(_BaseMap);            SAMPLER(sampler_BaseMap);
        TEXTURE2D(_BumpMap);            SAMPLER(sampler_BumpMap);
        TEXTURE2D(_MultiMap);           SAMPLER(sampler_MultiMap);
        TEXTURE2D(_ToonRamp);           SAMPLER(sampler_ToonRamp);
        TEXTURE2D(_ToonRampMetal);      SAMPLER(sampler_ToonRampMetal);
        TEXTURE2D(_EmissionMap);        SAMPLER(sampler_EmissionMap);
        TEXTURE2D(_MorphPatternMap);    SAMPLER(sampler_MorphPatternMap);
        TEXTURE2D(_MorphEmissionMap);   SAMPLER(sampler_MorphEmissionMap);
        TEXTURE2D(_ToonRamp_Morph);     SAMPLER(sampler_ToonRamp_Morph);
        TEXTURE2D(_ToonRampMetal_Morph); SAMPLER(sampler_ToonRampMetal_Morph);

        CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _BumpMap_ST;
            float4 _MultiMap_ST;
            float4 _ToonRamp_ST;
            float4 _ToonRampMetal_ST;
            float4 _EmissionMap_ST;
            float4 _MorphPatternMap_ST;
            float4 _MorphEmissionMap_ST;
            float4 _ToonRamp_Morph_ST;
            float4 _ToonRampMetal_Morph_ST;

            float4 _BaseColor;
            float4 _ToonShadowColor;
            float4 _EmissionColor;

            float4 _OutlineColor;
            float4 _RimLightColorLight;
            float4 _RimLightColorShadow;
            float4 _ColorChangeMask100;
            float4 _ColorChangeMask075;
            float4 _ColorChangeMask050;
            float4 _ColorChangeMask025;
            float4 _EngageEmissionColor;

            float _BumpScale;
            float _Makeup;
            float _OcclusionIntensity;
            float _OutlineScale;
            float _OutlineTexMipLevel;
            float _OutlineOriginalColorRate;
            float _OutlineGameScale;
            float _RimLightBlend;
            float _RimLightScale;
            float _LightColorToWhite;
            float _LightShadowToWhite;
            float _DitherAlphaValue;
            float _BumpCameraAttenuation;
            float _DisableOutline;
            float _Preset;
        CBUFFER_END


        void DitherClip(float ditherAlpha, float2 fragCoord)
        {
            const float thresholds[16] = {
                 1.0/17.0,  9.0/17.0,  3.0/17.0, 11.0/17.0,
                13.0/17.0,  5.0/17.0, 15.0/17.0,  7.0/17.0,
                 4.0/17.0, 12.0/17.0,  2.0/17.0, 10.0/17.0,
                16.0/17.0,  8.0/17.0, 14.0/17.0,  6.0/17.0
            };
            uint idx = (uint(fragCoord.x) % 4) * 4 + (uint(fragCoord.y) % 4);
            clip(ditherAlpha - thresholds[idx]);
        }

        struct Attributes
        {
            float4 positionOS  : POSITION;
            float3 normalOS    : NORMAL;
            float4 tangentOS   : TANGENT;
            float4 color       : COLOR;
            float2 uv          : TEXCOORD0;
            float2 lightmapUV  : TEXCOORD1;
        };
        ENDHLSL


        Pass
        {
            Name "Forward"
            Tags { "LightMode" = "UniversalForward" }
            Cull Back
            ZWrite On

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _ _NORMALMAP
            #pragma shader_feature _ _S_KEY_RIMLIGHT_ON
            #pragma shader_feature _ _S_KEY_BUMP_ATTENUATION
            #pragma shader_feature _ _S_KEY_COLOR_CHANGE_MASK
            #pragma shader_feature _ _KEY_DITHER_ALPHA
            #pragma shader_feature _ _KEY_ENGAGE
            #pragma multi_compile_fog
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED

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
                o.positionWS  = TransformObjectToWorld(i.positionOS.xyz);
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
                float4 baseMap  = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv);
                float4 multiMap = SAMPLE_TEXTURE2D(_MultiMap, sampler_MultiMap, i.uv);


                float roughness = multiMap.r;
                float metallic  = multiMap.g;
                float occlusion = lerp(1.0, multiMap.b, _OcclusionIntensity);
                float faceMask  = multiMap.a;


                float3 V = SafeNormalize(GetWorldSpaceViewDir(i.positionWS));

                float3 N_geo = normalize(i.normalWS);
                #if defined(_NORMALMAP)
                    float3 T = normalize(i.tangentWS);
                    float3 B = normalize(i.bitangentWS);
                    float3x3 TBN = float3x3(T, B, N_geo);
                    float3 normalTS = UnpackNormalScale(
                        SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, i.uv), _BumpScale);

                    #if defined(_S_KEY_BUMP_ATTENUATION)
                        float3 N_pre    = mul(normalTS, TBN);
                        float  NdotV01  = saturate(dot(N_pre, V) * 0.5 + 0.5);
                        float  bumpFade = saturate(NdotV01 * _BumpCameraAttenuation);
                        normalTS.xy *= (1.0 - bumpFade);
                        normalTS.z   = lerp(normalTS.z, 1.0, bumpFade);
                        normalTS = normalize(normalTS);
                    #endif

                    float3 N = normalize(mul(normalTS, TBN));
                #else
                    float3 N = N_geo;
                #endif

                Light mainLight = GetMainLight(i.shadowCoord);
                float3 L = SafeNormalize(mainLight.direction);
                float3 H = SafeNormalize(V + L);

                float NdotL01 = dot(N, L) * 0.5 + 0.5;

                float NdotV   = saturate(dot(N_geo, V));
                float NdotH   = saturate(dot(N, H));


                float2 toonUV = float2(saturate(NdotL01 * occlusion), 0.5);
                float4 toonRamp = SAMPLE_TEXTURE2D(_ToonRamp, sampler_ToonRamp, toonUV) * _ToonShadowColor;


                float specPow = max(NdotH, 1e-4);
                float2 toonMetalUV = float2(pow(specPow, 1.0 - roughness), saturate(roughness * 1.2));
                float4 toonMetalRamp = SAMPLE_TEXTURE2D(_ToonRampMetal, sampler_ToonRampMetal, toonMetalUV);

                float3 finalRamp = lerp(toonRamp.rgb, toonMetalRamp.rgb, metallic);


                #if defined(_S_KEY_COLOR_CHANGE_MASK)
                    float3 maskTint = 1;
                    if (faceMask > 0.75)      maskTint = _ColorChangeMask100.rgb;
                    else if (faceMask > 0.65) maskTint = _ColorChangeMask075.rgb;
                    else if (faceMask > 0.25) maskTint = _ColorChangeMask050.rgb;
                    else if (faceMask > 0.0)  maskTint = _ColorChangeMask025.rgb;
                    baseMap.rgb *= maskTint;
                #endif

                float3 albedo = baseMap.rgb;


                if (_Makeup == 0.0) albedo *= _BaseColor.rgb;


                float3 rim = 0;
                #if defined(_S_KEY_RIMLIGHT_ON)
                    float rimEdge   = smoothstep(1.0 - _RimLightBlend, 1.0, 1.0 - NdotV) * _RimLightScale;
                    float3 rimColor = lerp(_RimLightColorShadow.rgb, _RimLightColorLight.rgb, NdotL01 * occlusion);
                    rim = rimColor * rimEdge;
                #endif


                float3 emission = SAMPLE_TEXTURE2D(_EmissionMap, sampler_EmissionMap, i.uv).rgb * _EmissionColor.rgb;
                #if defined(_KEY_ENGAGE)
                    emission += _EngageEmissionColor.rgb;
                #endif


                float3 lightColor = lerp(mainLight.color, float3(1, 1, 1), saturate(_LightColorToWhite));
                float3 finalColor = albedo * finalRamp * lightColor + rim + emission;

                #if defined(_KEY_DITHER_ALPHA)
                    DitherClip(_DitherAlphaValue, i.positionCS.xy);
                #endif

                finalColor = MixFog(finalColor, i.fogFactor);
                return float4(finalColor, baseMap.a * _BaseColor.a);
            }
            ENDHLSL
        }


        Pass
        {
            Name "Outline"
            Tags { "LightMode" = "SRPDefaultUnlit" }
            Cull Front
            ZWrite On

            HLSLPROGRAM
            #pragma vertex vertOutline
            #pragma fragment fragOutline

            struct OutlineVaryings
            {
                float4 positionCS : SV_POSITION;
                float2 uv         : TEXCOORD0;
                float4 color      : TEXCOORD1;
            };

            OutlineVaryings vertOutline(Attributes i)
            {
                OutlineVaryings o;
                if (_DisableOutline > 0.5)
                {

                    o.positionCS = float4(0, 0, -2, 1);
                    o.uv         = 0;
                    o.color      = 0;
                    return o;
                }


                float3 positionWS = TransformObjectToWorld(i.positionOS.xyz);
                float3 normalWS   = TransformObjectToWorldNormal(i.normalOS);
                float distToCam   = length(positionWS - _WorldSpaceCameraPos);
                float distFactor  = max(distToCam * 0.05, 1.0);
                float outlineW    = i.color.r * _OutlineScale * _OutlineGameScale * distFactor * 0.001;
                positionWS       += normalWS * outlineW;

                o.positionCS = TransformWorldToHClip(positionWS);
                o.uv         = TRANSFORM_TEX(i.uv, _BaseMap);
                o.color      = i.color;
                return o;
            }

            half4 fragOutline(OutlineVaryings i) : SV_TARGET
            {


                float3 baseLowMip = SAMPLE_TEXTURE2D_LOD(_BaseMap, sampler_BaseMap, i.uv, _OutlineTexMipLevel).rgb;
                float3 tinted = baseLowMip * _BaseColor.rgb
                              + _OutlineOriginalColorRate * (1.0 - baseLowMip * _BaseColor.rgb);
                float3 outlineRGB = tinted * _OutlineColor.rgb;
                return float4(outlineRGB, _OutlineColor.a);
            }
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

            float3 _LightDirection;
            float3 _LightPosition;

            float4 shadowVert(Attributes i) : SV_POSITION
            {
                float3 positionWS = TransformObjectToWorld(i.positionOS.xyz);
                float3 normalWS   = TransformObjectToWorldNormal(i.normalOS);
                float3 lightDirWS = _LightDirection;
                float4 positionCS = TransformWorldToHClip(
                    ApplyShadowBias(positionWS, normalWS, lightDirWS));
                #if UNITY_REVERSED_Z
                    positionCS.z = min(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #else
                    positionCS.z = max(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #endif
                return positionCS;
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
    CustomEditor "CharaStandardShaderGUI"
}
