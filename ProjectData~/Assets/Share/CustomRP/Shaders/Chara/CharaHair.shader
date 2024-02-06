Shader "CustomRP/Chara/CharaHair"
{
    Properties
    {
        _BaseColor ("Color", Color) = (1,1,1,1)
        _BaseMap_ST ("BaseMap_ST", Vector) = (1,1,0,0)
        _MultiMap ("Multi Map", 2D) = "black" { }
        _ToonRamp ("Toon Ramp", 2D) = "white" { }
        _OcclusionIntensity ("_OcclusionIntensity", Range(0, 1)) = 1
        _EmissionMap ("Emission Map", 2D) = "white" { }
        _EmissionColor ("Emission Color", Color) = (0,0,0,1)
        _OutlineColor ("OutlineColor", Color) = (0.5,0.5,0.5,1)
        _OutlineScale ("OutlineScale", Range(0, 10)) = 5
        _OutlineTexMipLevel ("OutlineTexMipLevel", Range(0, 12)) = 4
        _OutlineOriginalColorRate ("OutlineOriginalColorRate", Range(0, 1)) = 0
        _OutlineGameScale ("OutlineGameScale", Range(0, 1)) = 1
        [Toggle] _S_Key_RimLight ("Use Rim Light", Float) = 1
        _RimLightColorLight ("RimLightColorLight", Color) = (1,1,1,1)
        _RimLightColorShadow ("RimLightColorShadow", Color) = (1,1,1,1)
        _RimLightBlend ("RimLightBlend", Range(0, 1)) = 0
        _RimLightScale ("RimLightScale", Range(0, 1)) = 0
        _AngelRingMap ("AngelRingMap", 2D) = "black" { }
        _AngelRingColor ("AngelRingColor", Color) = (1,1,1,1)
        _AngelRingOffsetU ("AR_OffsetU", Range(0, 1)) = 0
        _AngelRingOffsetV ("AR_OffsetV", Range(0, 1)) = 0.3
        _LightColorToWhite ("Light Color To White", Range(0, 1)) = 0
        _LightShadowToWhite ("Light Shadow To White", Range(0, 1)) = 0
        [Toggle(_KEY_ENGAGE)] _Key_Engage ("Engage", Float) = 0
        _GradationColor ("GradationColor", Color) = (1,1,1,0)
        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
        [Toggle(_DEBUG_CUSTOM_OUTLINE_ONLY)] _DEBUG_CUSTOM_OUTLINE_ONLY ("Debug Outline Only", Float) = 0
        _StencilGroup ("Stencil Group", Float) = 1
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

        TEXTURE2D(_MultiMap);
        TEXTURE2D(_ToonRamp);
        TEXTURE2D(_AngelRingMap);
        uniform real _DitherAlphaValue;

        CBUFFER_START(UnityPerMaterial)
        uniform real4 _BaseColor;
        uniform real _OcclusionIntensity;
        uniform real4 _AngelRingColor;
        uniform real4 _AngelRingMap_ST;
        uniform real _AngelRingOffsetU;
        uniform real _AngelRingOffsetV;
        uniform real4 _RimLightColorLight;
        uniform real4 _RimLightColorShadow;
        uniform real _RimLightBlend;
        uniform real _RimLightScale;

        uniform real4 _OutlineColor;
        uniform real _OutlineScale;
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
            real4 color       : COLOR;
            real2 uv0         : TEXCOORD0;
            real2 uv1         : TEXCOORD1;
        };

        struct VertexOutput
        {
            real4 positionCS  : SV_POSITION;
            real3 positionWS  : TEXCOORD0;
            real3 normalDirWS : TEXCOORD1;
            real4 color       : TEXCOORD2;
            real4 uv          : TEXCOORD3;
        };

        VertexOutput vert(VertexInput i)
        {
            VertexOutput o = (VertexOutput)0;
            o.positionCS = TransformObjectToHClip(i.positionOS);
            o.positionWS = TransformObjectToWorld(i.positionOS);
            o.normalDirWS = TransformObjectToWorldNormal(i.normalDirOS);
            o.color = i.color;
            o.uv.xy = i.uv0;
            o.uv.zw = i.uv1;
            return o;
        }

        real4 frag(VertexOutput i):SV_TARGET
        {
            // 坐标准备
            real3 positionWS = i.positionWS;
            real2 positionPixel = i.positionCS.xy;
            
            // 向量准备
            real3 normalDirWS = normalize(i.normalDirWS);
            real3 normalDirVS = TransformWorldToViewDir(normalDirWS, true);
            real3 viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);
            Light mainLight = GetMainLight();
            real3 lightDirWS = normalize(mainLight.direction);

            // 向量计算
            real NL01 = dot(normalDirWS, lightDirWS) * 0.5+ 0.5;
            real NV01 = max(0.0, dot(normalDirWS, viewDirWS));

            // 贴图采样
            real multiMap = SAMPLE_TEXTURE2D(_MultiMap, sampler_PointRepeat, i.uv.xy).z;
            
            // 通道命名
            real occlusion = lerp(1, multiMap, _OcclusionIntensity);

            // 采样ToonRamp
            real2 toonRampUV = real2(NL01*occlusion, 0.5); 
            real3 toonRamp = SAMPLE_TEXTURE2D_LOD(_ToonRamp, sampler_LinearClamp, toonRampUV, 0.0).xyz;

            // 天使环
            real2 angleRingUV = lerp(normalDirVS, real3(0, 0, 1), _AngelRingOffsetU).xy * 0.5 + 0.5;
            angleRingUV.y = lerp(i.uv.w, angleRingUV.y, _AngelRingOffsetV);
            real4 angelRingMap = SAMPLE_TEXTURE2D_LOD(_AngelRingMap, sampler_LinearClamp, angleRingUV, 0.0);
            real3 angleRing = angelRingMap.rgb * _AngelRingColor.rgb;

            // 边缘光
            real rimLightScale = smoothstep(_RimLightBlend, 1.0, 1-NV01) * _RimLightScale;
            real3 rimLight = lerp(_RimLightColorShadow.rgb, _RimLightColorLight.rgb, NL01*(1-occlusion)) * rimLightScale * i.color.r; //最后的强度再乘顶点色发梢灰度

            // 最终混合
            real3 finalColor = (angleRing + _BaseColor.rgb ) * toonRamp + rimLight;
            finalColor = lerp(finalColor, finalColor * (mainLight.color), 0.4);  // 受灯光影响因子

            // finalColor = multiMap.r;

            real finalAlpha = 1;
            DitherClip(_DitherAlphaValue, positionPixel);
            return real4(finalColor , finalAlpha);
        }

        VertexOutput vertOutline(VertexInput i)
        {
            VertexOutput o = (VertexOutput)0;
            real3 outline = i.normalDirOS * 0.001 * _OutlineScale * i.color.r;  // 放大100倍的模型缩放因子为0.00001，默认为0.001
            o.positionCS = TransformObjectToHClip(i.positionOS + outline);
            return o;
        }

        real4 fragOutline(VertexOutput i):SV_TARGET
        {
            real2 positionPixel = i.positionCS.xy;
            DitherClip(_DitherAlphaValue, positionPixel);
            return _OutlineColor;
        }

        ENDHLSL

        pass
        {
            Name "Forward"
            Tags {"LightMode"="UniversalForward"}
            //"LIGHTMODE" = "CharaHairForward"

            Stencil
            {
                Comp Always
                Pass Replace
                Fail Keep
                ZFail Keep
            }

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
