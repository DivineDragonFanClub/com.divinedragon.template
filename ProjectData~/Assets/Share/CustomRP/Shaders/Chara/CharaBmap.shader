Shader "CustomRP/Chara/CharaBmap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _EmissionColor ("Emission", Color) = (0,0,0,0)
        _BaseMap ("Albedo", 2D) = "white" { }
        _MultiMap ("Multi", 2D) = "white" { }
        _ShadowPower ("ShadowPower", Range(0, 1)) = 0.75
        _OutlineColor ("Outline Color", Color) = (0.3259881,0.2429301,0.2429301,1)
        _OutlineScale ("Outline Scale", Range(0, 1)) = 0.25
        [Toggle(_S_KEY_COLOR_CHANGE_MASK)] _Mask_ON ("Mask ON", Float) = 0
        _ColorChangeMask100 ("Mask 1.0", Color) = (0,0,0,0)
        _ColorChangeMask075 ("Mask 0.75", Color) = (0,0,0,0)
        _ColorChangeMask050 ("Mask 0.5", Color) = (0,0,0,0)
        _ColorChangeMask025 ("Mask 0.25", Color) = (0,0,0,0)
        _RimPower ("RimPower", Range(2, 20)) = 3
        [Toggle] _EmblemFlag ("Emblem", Float) = 0
        _EmblemRimColor ("Emblem RimColor", Color) = (0.2509804,1.992157,2.996078,0)
        _EmblemEmissionColor ("Emblem EmissionColor", Color) = (0.03921569,0.3529412,0.3529412,0)
        _EmblemEmissionPower ("Emblem EmissionPower", Range(0, 1)) = 0
        _EmblemOutlineEmissionColor ("Emblem OutlineEmissionColor", Color) = (0,2.573314,4.237095,1)
        _EmblemOutlineEmissionPower ("Emblem OutlineEmissionPower", Range(0, 1)) = 0
        [Toggle(_S_KEY_MORPH_DRESS)] _MorphDressFlag ("Morph Dress", Float) = 0
        [Toggle] _SpecialRimFlag ("Special Rim Flag", Float) = 0
        _SpecialRimColor ("Special Rim Color", Color) = (7.498039,0.2509804,0.2509804,0)
        [Toggle] _SpecialMaskEmissionFlag ("Special Mask Emission Flag", Float) = 0
        _SpecialEmissionMap ("Special Emission Mask", 2D) = "white" { }
        [HDR] _SpecialEmissionColor ("Special Emission Color", Color) = (0,0,0,0)
        _DangerShowingColor ("DangerShowingColor", Color) = (1,0,0,1)
        _DangerShowingRimPower ("DangerShowingRimPower", Range(0, 20)) = 1.5
        _DangerShowingRimMin ("DangerShowingRimMin", Range(0, 1)) = 0.2
        _DangerShowingRimBlendFactor ("DangerShowingRimBlendFactor", Range(0, 10)) = 4
        _DangerShowingBlendRate ("DangerShowingBlendRate", Range(0, 1)) = 0
        _ActedBlendRate ("ActedBlendRate", Range(0, 1)) = 0
        _GameEmissionColor ("GameEmissionColor", Color) = (0,0,0,0)
        _GameOutlineEmissionColor ("GameOutlineEmissionColor", Color) = (0,0,0,0)
        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Use Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
        _SilhouetteColorGroup ("Stencil Group", Float) = 1
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
        TEXTURE2D(_MultiMap);
        uniform real _DitherAlphaValue;

        CBUFFER_START(UnityPerMaterial)
        uniform real4 _Color;
        uniform real4 _OutlineColor;
        uniform real _OutlineScale;
		uniform real4 _ColorChangeMask100;
		uniform real4 _ColorChangeMask075;
		uniform real4 _ColorChangeMask050;
		uniform real4 _ColorChangeMask025;

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

            real3x3 TBN = transpose(real3x3(normalize(i.tangentDirWS), normalize(i.bitangentDirWS), normalize(i.normalDirWS)));
            real3 normalDirTS = UnpackNormal(real4(0.5,0.5,1.0,1.0));
            real3 normalDirWS = normalize(mul(TBN, normalDirTS));
            real3 normalDirVS = TransformWorldToViewDir(normalDirWS, true);
            real3 viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);
            Light mainLight = GetMainLight();
            real3 lightDirWS = normalize(mainLight.direction);
            real3 halfDirWS = normalize(viewDirWS + lightDirWS);

            // 贴图采样
            real4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_LinearClamp, i.uv);
            real4 multiMap = SAMPLE_TEXTURE2D_LOD(_MultiMap, sampler_LinearClamp, real2(i.uv.x, i.uv.y), 0); // 这里是因为原图没翻过来，所以shader里手动翻了一下

            // 通道分离
            real roughness = multiMap.r;
            real metallic = multiMap.g;
            real occlusion = multiMap.b;
            real faceMask = multiMap.a;

            // 边缘光
            real rimLightScale = smoothstep((1-_RimLightBlend), 1.0, 1-0.5) * _RimLightScale;
            real3 rimLight = lerp(_RimLightColorShadow.rgb, _RimLightColorLight.rgb, 0.5*occlusion) * rimLightScale; // * i.color.r; //最后的强度再乘顶点色描边强度

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
			
			real3 realbaseMap = baseMap.rgb * _Color.rgb;

            // 最终混合
            real3 finalColor = rimLight + 1.0 * baseMap.rgb * _Color.rgb;
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
    
            float3 temp_2 = SAMPLE_TEXTURE2D_LOD(_BaseMap, sampler_LinearClamp, i.uv, 4);

            float temp_3 = temp_2.r;
            float temp_4 = temp_2.g;
            float temp_5 = temp_2.b;
    
            float temp_8 = 0.0 - _Color.r;
            float temp_6 = 0.0 - _Color.g;
            float temp_10 = 0.0 - _Color.b;
            
            float temp_9 = temp_3 * temp_8;
            float temp_7 = temp_4 * temp_6;
            float temp_11 = temp_5 * temp_10;
    
            float temp_13 = mad(temp_9, 1, 0);
            float temp_12 = mad(temp_7, 1, 0);
            float temp_14 = mad(temp_11, 1, 0);
    
            float temp_16 = mad(temp_3, _Color.r, temp_13);
            float temp_17 = mad(temp_4, _Color.g, temp_12);
            float temp_15 = mad(temp_5, _Color.b, temp_14);
    
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
