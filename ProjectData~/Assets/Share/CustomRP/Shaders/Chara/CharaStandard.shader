Shader "CustomRP/Chara/CharaStandard"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _BaseMap ("Albedo", 2D) = "white" { }
        [Toggle(_NORMALMAP)]
        _S_Key_NormalMap ("Use Normal Map", Float) = 1
        _BumpMap ("Normal Map", 2D) = "bump" { }
        _BumpScale ("Bump Scale", Range(0.01, 2)) = 1
        _MultiMap ("Multi Map", 2D) = "black" { }
        _ToonRamp ("Toon Ramp", 2D) = "white" { }
        _ToonRampMetal ("Toon Ramp Metal", 2D) = "white" { }
        _ToonShadowColor ("Toon Shadow Color", Color) = (1,1,1,1)
        _Makeup ("Makeup", Range(0, 1)) = 0
        _OcclusionIntensity ("Occlusion Intensity", Range(0, 1)) = 1
        [Toggle(_EMISSION)]
        _S_Key_Emission ("Use Emission", Float) = 1
        _EmissionMap ("Emission Map", 2D) = "white" { }
        [HDR]
        _EmissionColor ("Emission Color", Color) = (0,0,0,1)
        _OutlineColor ("Outline Color", Color) = (0.5,0.5,0.5,1)
        _OutlineScale ("Outline Scale", Range(0, 10)) = 5
        _OutlineTexMipLevel ("Outline Tex Mip Level", Range(0, 12)) = 4
        _OutlineOriginalColorRate ("Outline Original Color Rate", Range(0, 1)) = 0
        _OutlineGameScale ("Outline Game Scale", Range(0, 1)) = 1
        [Toggle(_S_KEY_RIMLIGHT_ON)]
        _S_Key_RimLight ("Use Rim Light", Float) = 1
        _RimLightColorLight ("Rim Light Color Light", Color) = (1,1,1,1)
        _RimLightColorShadow ("Rim Light Color Shadow", Color) = (1,1,1,1)
        _RimLightBlend ("Rim Light Blend", Range(0, 1)) = 0
        _RimLightScale ("Rim Light Scale", Range(0, 1)) = 0
        [Toggle(_S_KEY_COLOR_CHANGE_MASK)]
        _S_Key_ColorChangeMask ("Color Change Mask", Float) = 0
        _ColorChangeMask100 ("Mask 1.0", Color) = (1,1,1,1)
        _ColorChangeMask075 ("Mask 0.75", Color) = (1,1,1,1)
        _ColorChangeMask050 ("Mask 0.5", Color) = (1,1,1,1)
        _ColorChangeMask025 ("Mask 0.25", Color) = (1,1,1,1)
        _LightColorToWhite ("Light Color To White", Range(0, 1)) = 0
        _LightShadowToWhite ("Light Shadow To White", Range(0, 1)) = 0
        [Toggle(_KEY_DITHER_ALPHA)]
        _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
        [Toggle(_S_KEY_BUMP_ATTENUATION)]
        _S_Key_BumpAttenuation ("Bump Attenuation", Float) = 0
        _BumpCameraAttenuation ("Bump Camera Attenuation", Range(0, 1)) = 0.2
        [Toggle(_KEY_ENGAGE)]
        _Key_Engage ("Engage", Float) = 0
        _EngageEmissionColor ("Engage Emission Color", Color) = (0.314,0.314,0.47,1)
        [Toggle(_S_KEY_MORPH_SKIN)]
        _S_Key_MorphSkin ("Morph (Skin)", Float) = 0
        _MorphPatternMap ("Morph Pattern Map", 2D) = "white" { }
        _MorphEmissionMap ("Morph Emission Map", 2D) = "white" { }
        [Toggle(_S_KEY_MORPH_DRESS)]
        _S_Key_MorphDress ("Morph (Dress)", Float) = 0
        _ToonRamp_Morph ("Toon Ramp Morph", 2D) = "white" { }
        _ToonRampMetal_Morph ("Toon Ramp Metal Morph", 2D) = "white" { }
        [Toggle(_S_KEY_STANDARD_COLOR)]
        _S_Key_StandardColor ("Standard Color", Float) = 0
        [Toggle(_S_KEY_STANDARD_SKIN)]
        _S_Key_StandardSkin ("Standard Skin", Float) = 0
        [Toggle(_DEV_KEY_TOON_SPECULAR_BY_LIGHT)]
        _Dev_KeyToonSpecularByLight ("(DEV) Metal Type", Float) = 0
        [Toggle(_DEBUG_CUSTOM_OUTLINE_ONLY)]
        _DEBUG_CUSTOM_OUTLINE_ONLY ("Debug Outline Only", Float) = 0
        [Toggle]
        _DisableOutline ("Disable Outline", Float) = 0
        _Preset ("Preset", Float) = 0
    }
    SubShader
    {
        Tags {"RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "IgnoreProjector"="True"}

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

        // 公共寄存器
        SAMPLER(sampler_LinearClamp);
        SAMPLER(sampler_LinearRepeat);
        SAMPLER(sampler_PointClamp);
        SAMPLER(sampler_PointRepeat);

        TEXTURE2D(_BaseMap);
        TEXTURE2D(_BumpMap);
        TEXTURE2D(_MultiMap);
        TEXTURE2D(_ToonRamp);
        TEXTURE2D(_ToonRampMetal);
        uniform real _DitherAlphaValue;

        CBUFFER_START(UnityPerMaterial)
        uniform real4 _BaseColor;
        uniform real4 _ToonShadowColor;
        uniform real _BumpScale;
        uniform real _OcclusionIntensity;
        uniform real4 _OutlineColor;
        uniform real _OutlineScale;
		uniform real4 _ColorChangeMask100;
		uniform real4 _ColorChangeMask075;
		uniform real4 _ColorChangeMask050;
		uniform real4 _ColorChangeMask025;
        uniform real _OutlineOriginalColorRate;
        uniform real _OutlineTexMipLevel;

        uniform real4 _RimLightColorLight;
        uniform real4 _RimLightColorShadow;
        uniform real _RimLightBlend;
        uniform real _RimLightScale;
        uniform real _S_Key_ColorChangeMask;
        CBUFFER_END

        real DitherClip(real ditherAlpha, real2 positionPixel)
        {
            real DITHER_THRESHOLDS[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };
            uint index = (uint(positionPixel.x) % 4) * 4 + uint(positionPixel.y) % 4;
            clip(ditherAlpha - DITHER_THRESHOLDS[index]);
            return 0;
        }

        struct VertexInput
        {
            real3 positionOS  : POSITION;
            real3 normalDirOS : NORMAL;
            real4 tangentDirOS : TANGENT;
            real4 color       : COLOR;
            real2 uv0         : TEXCOORD0;
        };

        struct VertexOutput
        {
            real4 positionCS  : SV_POSITION;
            real3 positionWS  : TEXCOORD0;
            real3 normalDirWS : TEXCOORD1;
            real4 color       : TEXCOORD2;
            real2 uv          : TEXCOORD3;
            real3 tangentDirWS   : TEXCOORD4;
            real3 bitangentDirWS : TEXCOORD5;
        };

        VertexOutput vert(VertexInput i)
        {
            VertexOutput o = (VertexOutput)0;
            o.positionCS = TransformObjectToHClip(i.positionOS);
            o.positionWS = TransformObjectToWorld(i.positionOS);
            o.normalDirWS = TransformObjectToWorldNormal(i.normalDirOS);
            o.tangentDirWS = TransformObjectToWorldDir(i.tangentDirOS.xyz);
            o.bitangentDirWS = cross(o.normalDirWS, o.tangentDirWS) * i.tangentDirOS.w * unity_WorldTransformParams.w;
            o.color = i.color;
            o.uv = i.uv0;
            return o;
        }

        real4 frag(VertexOutput i):SV_TARGET
        {
            // 坐标准备
            real3 positionWS = i.positionWS;
            real2 positionPixel = i.positionCS.xy;
            
            // 向量准备
            real3x3 TBN = transpose(real3x3(normalize(i.tangentDirWS), normalize(i.bitangentDirWS), normalize(i.normalDirWS)));
            real3 normalDirTS = UnpackNormalScale(SAMPLE_TEXTURE2D(_BumpMap, sampler_LinearClamp, i.uv).rgba, _BumpScale);
            real3 normalDirWS = normalize(mul(TBN, normalDirTS));
            real3 normalDirVS = TransformWorldToViewDir(normalDirWS, true);
            real3 viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);
            Light mainLight = GetMainLight();
            real3 lightDirWS = normalize(mainLight.direction);
            real3 halfDirWS = normalize(viewDirWS + lightDirWS);

            // 向量计算
            real NL01 = dot(normalDirWS, lightDirWS) * 0.5+ 0.5;
            real NV01 = max(0.0, dot(normalDirWS, viewDirWS));
            real NH01 = max(0.0, dot(normalDirWS, halfDirWS));

            // 贴图采样
            real4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_LinearClamp, i.uv);
            real4 multiMap = SAMPLE_TEXTURE2D_LOD(_MultiMap, sampler_LinearClamp, real2(i.uv.x, i.uv.y), 0); // 这里是因为原图没翻过来，所以shader里手动翻了一下

            // 通道分离
            real roughness = multiMap.r;
            real metallic = multiMap.g;
            real occlusion = lerp(1, multiMap.b, _OcclusionIntensity);
            real faceMask = multiMap.a;

            // 采样ToonRamp
            real2 toonRampUV = real2(NL01 * occlusion, 0.5); 
            real4 toonRamp = SAMPLE_TEXTURE2D_LOD(_ToonRamp, sampler_LinearClamp, toonRampUV, 0);
            toonRamp *= _ToonShadowColor;

            // 采样ToonMetalRamp
            real2 toonMetalRampUV = real2(pow(NH01, 1-roughness), saturate(roughness*1.2)); // uv.y是自己试出来的，无特殊意义
            real4 toonMetalRamp = SAMPLE_TEXTURE2D_LOD(_ToonRampMetal, sampler_LinearClamp, toonMetalRampUV, 0);
            // toonMetalRamp *= NL01;

            real3 finalRamp = lerp(toonRamp.rgb, toonMetalRamp.rgb, metallic);

            // 边缘光
            real rimLightScale = smoothstep((1-_RimLightBlend), 1.0, 1-NV01) * _RimLightScale;
            real3 rimLight = lerp(_RimLightColorShadow.rgb, _RimLightColorLight.rgb, NL01*occlusion) * rimLightScale; // * i.color.r; //最后的强度再乘顶点色描边强度

            if (_S_Key_ColorChangeMask == 1){
				if (multiMap.a > 0.75){
					baseMap.rgba = baseMap.rgba * _ColorChangeMask100;
				}
				else if (multiMap.a > 0.65){
					baseMap.rgba = baseMap.rgba * _ColorChangeMask075;
				}
				else if (multiMap.a > 0.25){
					baseMap.rgba = baseMap.rgba * _ColorChangeMask050;
				}
				else if (multiMap.a > 0){
					baseMap.rgba = baseMap.rgba * _ColorChangeMask025;
				}
			}
			
			real3 realbaseMap = baseMap.rgb * _BaseColor.rgb;

            // 最终混合
            real3 finalColor = rimLight + finalRamp * baseMap.rgb * _BaseColor.rgb;
            finalColor = lerp(finalColor, finalColor * (mainLight.color), 0.4);  // 受灯光影响因子，考虑到融合物理光照，将平行光颜色归一化，但是整体颜色会变暗

            // finalColor = multiMap.r;
            // finalColor = i.color.r;

            real finalAlpha = 1;
            DitherClip(_DitherAlphaValue, positionPixel);
            return real4(finalColor, finalAlpha);
        }

        VertexOutput vertOutline(VertexInput i)
        {
            VertexOutput o = (VertexOutput)0;
            real3 outline = i.normalDirOS * 0.001 * _OutlineScale * i.color.r;  // 放大100倍的模型缩放因子为0.00001，默认为0.001
            o.positionCS = TransformObjectToHClip(i.positionOS + outline);
            return o;
        }

        real4 fragOutline(VertexOutput i): SV_TARGET
        {
            real4 output;
    
            float3 temp_2 = SAMPLE_TEXTURE2D_LOD(_BaseMap, sampler_LinearClamp, i.uv, _OutlineTexMipLevel);

            float temp_3 = temp_2.r;
            float temp_4 = temp_2.g;
            float temp_5 = temp_2.b;
    
            float temp_8 = 0.0 - _BaseColor.r;
            float temp_6 = 0.0 - _BaseColor.g;
            float temp_10 = 0.0 - _BaseColor.b;
            
            float temp_9 = temp_3 * temp_8;
            float temp_7 = temp_4 * temp_6;
            float temp_11 = temp_5 * temp_10;
    
            float temp_13 = mad(temp_9, _OutlineOriginalColorRate, _OutlineOriginalColorRate);
            float temp_12 = mad(temp_7, _OutlineOriginalColorRate, _OutlineOriginalColorRate);
            float temp_14 = mad(temp_11, _OutlineOriginalColorRate, _OutlineOriginalColorRate);
    
            float temp_16 = mad(temp_3, _BaseColor.r, temp_13);
            float temp_17 = mad(temp_4, _BaseColor.g, temp_12);
            float temp_15 = mad(temp_5, _BaseColor.b, temp_14);
    
            float temp_19 = temp_16 * _OutlineColor.r;
            float temp_20 = temp_17 * _OutlineColor.g;
            float temp_18 = temp_15 * _OutlineColor.b;

            float temp_22 = temp_19 * 1.0;
            float temp_23 = temp_20 * 1.0;
            float temp_21 = temp_18 * 1.0;
    
            output.x = temp_22;
            output.y = temp_23;
            output.z = temp_21;
            output.w = _OutlineColor.a;
    
            return output;
        }
        ENDHLSL

        pass
        {
            Name "Forward"
            Tags {"LightMode"="UniversalForward"}
            //"LIGHTMODE" = "CharaForward"

            Cull Off

            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT

            #pragma vertex vert
            #pragma fragment frag

            ENDHLSL
        }
        pass
        {
            Name "Outline"
            Tags {"LightMode"="SRPDefaultUnlit"}
            //"LIGHTMODE" = "Outline"
            Cull Front

            HLSLPROGRAM
            #pragma vertex vertOutline
            #pragma fragment fragOutline

            ENDHLSL
        }

        pass
        {
            Name "ShadowCaster"
            Tags {"LightMode"="ShadowCaster"}
            //"LIGHTMODE" = "SHADOWCASTER"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            ENDHLSL
        }

        pass
        {
            Name "DepthOnly"
            Tags {"LightMode"="DepthOnly"}
            //"LIGHTMODE" = "CharaDepth"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            ENDHLSL
        }
    }

    Fallback "Hidden/Universal Render Pipeline/FallbackError"
}
