Shader "CustomRP/Map/MapWater" {
    Properties {
        [HideInInspector] _Surface ("__surface", Float) = 0
        [HideInInspector] _SrcBlend ("__src", Float) = 5
        [HideInInspector] _DstBlend ("__dst", Float) = 10
        _BaseMap ("Color Map", 2D) = "white" { }
        _BumpMap ("Bump Map", 2D) = "bump" { }
        _ReflectionTexCube ("Reflection Cube", Cube) = "black" { }
        _ShoreTex ("Shore Texture (unused — slot kept for material compat)", 2D) = "black" { }
        _ReflectionIntensity ("Reflection Intensity", Range(0, 1)) = 0.25
        _BaseColor ("Base Color", Color) = (0.745, 0.587, 0.552, 0.447)
        _DeepColor ("Deep Color", Color) = (0.102, 0.189, 0.171, 0.325)
        [HDR] _ReflectionColor ("Reflection Color", Color) = (0.877, 0.877, 0.877, 1)
        [HDR] _SpecularColor ("Specular Color", Color) = (0.32, 0.27, 0.27, 1)
        _Shininess ("Shininess", Range(2, 500)) = 199
        _FresnelScale ("Fresnel Scale", Range(0.15, 4)) = 0.15
        _WorldLightDir ("Specular Light Direction", Vector) = (0.314, -0.938, -0.146, 1)
        _DistortParams ("Distortion (BumpAmp, _, FresnelPower, FresnelBias)", Vector) = (4, 1, 0.5, 0.5)
        _InvFadeParameter ("Auto Fade (Edge, Shore, Blend Depth)", Vector) = (0.28, 1.3, 1, 1)
        _BumpTiling ("Bump Tiling (XY=tile1, ZW=tile2)", Vector) = (8, 8, 8, 8)
        _BumpSpeed ("Bump Speed", Range(0, 10)) = 0.12
        _SkySpeed ("Sky Rotation Speed", Range(-1, 1)) = 0.1
        _FlowDir ("Flow Direction (xy=dir, zw=unused)", Vector) = (0.94, 0.34, 0, 1)
        _FoamIntensity ("Foam Intensity", Range(0, 1)) = 0.125
        _FoamInterval ("Shore Interval", Range(0.1, 10)) = 0.55
        _FoamDistortion ("Shore Distortion", Range(0, 16)) = 2.57
        [Toggle(WATER_REFLECTIVE)] _UseReflection ("Use Reflection Cubemap", Float) = 1
        [Toggle(WATER_SPECULAR)] _SpecularEnabled ("Use Specular", Float) = 1
        _Preset ("Preset", Float) = 3
    }

    SubShader
    {
        Tags { "Queue" = "Transparent-10" "RenderPipeline" = "UniversalPipeline" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
        LOD 100

        Pass
        {
            Name "Forward"
            Tags { "LightMode" = "UniversalForward" }
            Blend [_SrcBlend] [_DstBlend]
            ZWrite Off
            Cull Back

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _ WATER_REFLECTIVE
            #pragma shader_feature _ WATER_SPECULAR
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

            TEXTURE2D(_BumpMap);             SAMPLER(sampler_BumpMap);
            TEXTURE2D(_BaseMap);             SAMPLER(sampler_BaseMap);
            TEXTURE2D(_ShoreTex);            SAMPLER(sampler_ShoreTex);
            TEXTURECUBE(_ReflectionTexCube); SAMPLER(sampler_ReflectionTexCube);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                float4 _BumpMap_ST;
                float4 _BaseColor;
                float4 _DeepColor;
                float4 _ReflectionColor;
                float4 _SpecularColor;
                float4 _WorldLightDir;
                float4 _DistortParams;
                float4 _InvFadeParameter;
                float4 _BumpTiling;
                float4 _FlowDir;
                float _ReflectionIntensity;
                float _Shininess;
                float _FresnelScale;
                float _BumpSpeed;
                float _SkySpeed;
                float _FoamIntensity;
                float _FoamInterval;
                float _FoamDistortion;
                float _Preset;
                float _Surface;
                float _SrcBlend;
                float _DstBlend;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv         : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv         : TEXCOORD0;
                float3 viewDirWS  : TEXCOORD1;
                float4 screenPos  : TEXCOORD2;
                float  fogFactor  : TEXCOORD3;
                float3 positionWS : TEXCOORD4;
                float  eyeDepth   : TEXCOORD5;
            };

            Varyings vert(Attributes i)
            {
                Varyings o;
                float3 positionWS = TransformObjectToWorld(i.positionOS.xyz);
                o.positionWS = positionWS;
                o.positionCS = TransformWorldToHClip(positionWS);
                o.uv         = i.uv;
                o.viewDirWS  = _WorldSpaceCameraPos.xyz - positionWS;
                o.screenPos  = ComputeScreenPos(o.positionCS);
                o.fogFactor  = ComputeFogFactor(o.positionCS.z);


                o.eyeDepth   = -TransformWorldToView(positionWS).z;
                return o;
            }


            float2 SampleBumpXY(float2 uv)
            {
                float4 b = SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, uv);
                float nx = (b.x * b.w) * 2.0 - 1.0;
                float ny = b.y * 2.0 - 1.0;
                return float2(nx, ny);
            }

            float4 frag(Varyings i) : SV_TARGET
            {


                float t  = _Time.y * _BumpSpeed;
                float t2 = t + 0.5;
                float t3 = 0.5 * _Time.x;

                float2 uv1 = i.uv * _BumpTiling.xy + float2(frac(-t  * _FlowDir.x), frac(-t  * _FlowDir.y));
                float2 uv2 = i.uv * _BumpTiling.xy + float2(frac( t2 * -_FlowDir.y), frac( t2 * -_FlowDir.x));
                float2 uv3 = i.uv * _BumpTiling.zw + float2(t3, t3);

                float2 n1 = SampleBumpXY(uv1);
                float2 n2 = SampleBumpXY(uv2);
                float2 n3 = SampleBumpXY(uv3);


                float2 nXY = (n1 + n2 + n3) * (1.0 / 3.0);
                nXY *= 0.5 * _DistortParams.x;


                float3 normalWS = normalize(float3(nXY.x, 1.0, nXY.y));


                float3 V = normalize(i.viewDirWS);
                float NdotV = saturate(dot(normalWS, V));


                float3 reflectVec = reflect(-V, normalWS);
                float skyAngle = _Time.y * _SkySpeed;
                float skyCos = cos(skyAngle);
                float skySin = sin(skyAngle);
                float3 rotatedReflect = float3(
                    reflectVec.x * skyCos - reflectVec.z * skySin,
                    reflectVec.y,
                    reflectVec.x * skySin + reflectVec.z * skyCos);

                float3 reflectionRGB = 0;
                #if defined(WATER_REFLECTIVE)
                    reflectionRGB = SAMPLE_TEXTURECUBE(_ReflectionTexCube, sampler_ReflectionTexCube, rotatedReflect).rgb
                                  * _ReflectionColor.rgb;
                #endif


                float2 screenUV     = i.screenPos.xy / i.screenPos.w;
                float sceneDepthRaw = SampleSceneDepth(screenUV);
                float sceneEyeDepth = LinearEyeDepth(sceneDepthRaw, _ZBufferParams);
                float fragEyeDepth  = i.eyeDepth;
                float depthDelta = max(0, sceneEyeDepth - fragEyeDepth);
                float depthFade  = saturate(depthDelta * _InvFadeParameter.z);


                float3 mixedColor = lerp(_BaseColor.rgb, _DeepColor.rgb, depthFade);
                float  alphaFactor = lerp(_BaseColor.w, _DeepColor.w, depthFade);
                float3 waterColor = lerp(_DeepColor.rgb, mixedColor, alphaFactor);


                float fresnel = pow(saturate(1.0 - NdotV), _DistortParams.z);
                float reflectMix = saturate(fresnel * (1.0 - _DistortParams.w) + _DistortParams.w)
                                 * _ReflectionIntensity;
                float3 finalColor = lerp(waterColor, reflectionRGB, reflectMix);


                #if defined(WATER_SPECULAR)
                    float3 L = normalize(-_WorldLightDir.xyz);
                    float3 H = normalize(V + L);
                    float NdotH = saturate(dot(normalWS, H));
                    float spec = pow(NdotH, _Shininess);
                    finalColor += spec * _SpecularColor.rgb;
                #endif


                finalColor = MixFog(finalColor, i.fogFactor);


                float shoreFade = saturate(depthDelta * _InvFadeParameter.x);
                float alpha = shoreFade * alphaFactor;

                return float4(finalColor, alpha);
            }
            ENDHLSL
        }
    }

    Fallback "Hidden/Universal Render Pipeline/FallbackError"
    CustomEditor "MapWaterShaderGUI"
}
