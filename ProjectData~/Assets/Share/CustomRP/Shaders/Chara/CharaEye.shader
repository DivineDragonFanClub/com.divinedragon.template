Shader "CustomRP/Chara/CharaEye"
{
    Properties
    {
        _BaseMap ("Base Texture", 2D) = "white" { }
        _BaseColor ("Color White", Color) = (1,1,1,1)
        _BlackColor ("Color Black", Color) = (0,0,0,0)
        _UvCameraFollowRateX ("UV Camera Follow Rate X", Range(-1, 1)) = 0.05
        _UvCameraFollowRateY ("UV Camera Follow Rate Y", Range(-1, 1)) = 0.05
        _DecalCenterX ("Decal Center X", Float) = 0.5
        _DecalCenterY ("Decal Center Y", Float) = 0.5
        _DecalScale ("Decal Scale", Range(0, 1)) = 0.1
        [Toggle(_USE_UV_NOISE)] _UseBaseNoise ("UV Noise", Float) = 0
        [KeywordEnum(NONE,STD,ADD)] TEX1_OP ("Texture1 Operator", Float) = 0
        _DecalTex1 ("Decal Texture 1", 2D) = "black" { }
        _DecalColor1 ("Decal Color 1", Color) = (1,1,1,1)
        _DecalCenterX1 ("Decal Center X1", Float) = 0.5
        _DecalCenterY1 ("Decal Center Y1", Float) = 0.5
        _DecalScale1 ("Decal Scale1", Range(0, 1)) = 0.1
        [Toggle(_USE_UV_NOISE1)] _UseBaseNoise1 ("UV Noise 1", Float) = 1
        [KeywordEnum(NONE,STD,ADD)] TEX2_OP ("Texture2 Operator", Float) = 0
        _DecalTex2 ("Decal Texture 2", 2D) = "black" { }
        _DecalColor2 ("Decal Color 2", Color) = (1,1,1,1)
        _DecalCenterX2 ("Decal Center X2", Float) = 0.5
        _DecalCenterY2 ("Decal Center Y2", Float) = 0.5
        _DecalScale2 ("Decal Scale2", Range(0, 1)) = 0.1
        [Toggle(_USE_UV_NOISE2)] _UseBaseNoise2 ("UV Noise 2", Float) = 1
        [KeywordEnum(NONE,STD,ADD)] TEX3_OP ("Texture3 Operator", Float) = 0
        _DecalTex3 ("Decal Texture 3", 2D) = "black" { }
        _DecalColor3 ("Decal Color 3", Color) = (1,1,1,1)
        _DecalCenterX3 ("Decal Center X3", Float) = 0.5
        _DecalCenterY3 ("Decal Center Y3", Float) = 0.5
        _DecalScale3 ("Decal Scale3", Range(0, 1)) = 0.1
        [Toggle(_USE_UV_NOISE3)] _UseBaseNoise3 ("UV Noise 3", Float) = 1
        [KeywordEnum(NONE,STD,ADD)] TEX4_OP ("Texture4 Operator", Float) = 0
        _DecalTex4 ("Decal Texture 4", 2D) = "black" { }
        _DecalColor4 ("Decal Color 4", Color) = (1,1,1,1)
        _DecalCenterX4 ("Decal Center X4", Float) = 0.5
        _DecalCenterY4 ("Decal Center Y4", Float) = 0.5
        _DecalScale4 ("Decal Scale4", Range(0, 1)) = 0.1
        [Toggle(_USE_UV_NOISE4)] _UseBaseNoise4 ("UV Noise 4", Float) = 1
        _DecalRate ("Decal Rate", Range(0, 1)) = 0
        _LightColorToWhite ("Light Color To White", Range(0, 1)) = 0
        _LightShadowToWhite ("Light Shadow To White", Range(0, 1)) = 0
        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
        _Preset ("Preset", Float) = 0
    }
    SubShader
    {
        Tags {"RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="AlphaTest+20" "IgnoreProjector"="True"}

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

        // 公共寄存器
        SAMPLER(sampler_LinearClamp);
        SAMPLER(sampler_LinearRepeat);
        SAMPLER(sampler_PointClamp);
        SAMPLER(sampler_PointRepeat);

        TEXTURE2D(_BaseMap);
        TEXTURE2D(_DecalTex1);
        TEXTURE2D(_DecalTex2);
        TEXTURE2D(_DecalTex3);
        TEXTURE2D(_DecalTex4);
        uniform real _DitherAlphaValue;

        CBUFFER_START(UnityPerMaterial)
        uniform real4 _BaseColor;
        uniform real4 _BlackColor;
        uniform real4 _DecalColor1;
        uniform real4 _DecalColor2;
        uniform real4 _DecalColor3;
        uniform real4 _DecalColor4;

        uniform real _DecalScale1;
        uniform real _DecalScale2;
        uniform real _DecalScale3;
        uniform real _DecalScale4;

        uniform real _DecalCenterX1;
        uniform real _DecalCenterY1;
        uniform real _DecalCenterX2;
        uniform real _DecalCenterY2;
        uniform real _DecalCenterX3;
        uniform real _DecalCenterY3;
        uniform real _DecalCenterX4;
        uniform real _DecalCenterY4;
        uniform real _DecalRate;
        CBUFFER_END

        real2 ScaleUV (real2 uv, real2 center, real scale)
        {
            uv -= center;
            uv *= scale;
            uv += center;
            return uv;
        }
        real2 ScaleAnimUV (real2 uv, real2 center, real scale, real rate)
        {
            // 眼睛闪烁速率修正
            rate = rate * _Time.x * 1000;
            // 眼睛闪烁缩放值修正
            scale = scale * 0.1;
            uv -= center;
            // uv.x -= center.x;
            // uv.y += center.y;
            uv *= (sin(rate)) * scale + (scale + 1);
            uv += center;
            return uv;
        }

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
            real2 uv0         : TEXCOORD0;
        };

        struct VertexOutput
        {
            real4 positionCS  : SV_POSITION;
            real2 uv          : TEXCOORD3;
        };

        VertexOutput vert(VertexInput i)
        {
            VertexOutput o = (VertexOutput)0;
            o.positionCS = TransformObjectToHClip(i.positionOS);
            o.uv = i.uv0;
            return o;
        }

        real4 frag(VertexOutput i):SV_TARGET
        {
            // 坐标准备
            real2 positionPixel = i.positionCS.xy;
            
            // 向量准备
            Light mainLight = GetMainLight();

            // 设置眼睛闪烁UV缩放中心点
            real2 decalCenter1 = real2(_DecalCenterX1, _DecalCenterY1);
            real2 decalCenter2 = real2(_DecalCenterX2, _DecalCenterY2);
            real2 decalCenter3 = real2(_DecalCenterX3, _DecalCenterY3);
            real2 decalCenter4 = real2(_DecalCenterX4, _DecalCenterY4);

            // 设置眼睛UV
            real2 decalUV1 = ScaleAnimUV(i.uv, decalCenter1, _DecalScale1, _DecalRate);
            real2 decalUV2 = ScaleAnimUV(i.uv, decalCenter2, _DecalScale2, _DecalRate);
            real2 decalUV3 = ScaleAnimUV(i.uv, decalCenter3, _DecalScale3, _DecalRate);
            real2 decalUV4 = ScaleAnimUV(i.uv, decalCenter4, _DecalScale4, _DecalRate);

            // 贴图采样
            real4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_LinearClamp, i.uv);
            real decalTex1 = SAMPLE_TEXTURE2D(_DecalTex1, sampler_LinearClamp, decalUV1).r;
            real decalTex2 = SAMPLE_TEXTURE2D(_DecalTex2, sampler_LinearClamp, decalUV2).r;
            real decalTex3 = SAMPLE_TEXTURE2D(_DecalTex3, sampler_LinearClamp, decalUV3).r;
            real decalTex4 = SAMPLE_TEXTURE2D(_DecalTex4, sampler_LinearClamp, decalUV4).r;
            
            // 多张贴图混合
            real3 decalColor = lerp(_BlackColor.rgb, _DecalColor1.rgb, decalTex1);
            decalColor = lerp(decalColor, _DecalColor2.rgb, decalTex2);
            decalColor = lerp(decalColor, _DecalColor3.rgb, decalTex3);
            decalColor = lerp(decalColor, _DecalColor4.rgb, decalTex4);

            // 最终混合
            real3 finalColor = decalColor * _BaseColor.rgb;
            finalColor = lerp(finalColor, finalColor * (mainLight.color), 0.1);  // 受灯光影响因子
            real finalAlpha = baseMap.a;
            DitherClip(_DitherAlphaValue, positionPixel);
            return real4(finalColor, finalAlpha);
        }
        ENDHLSL

        pass
        {
            Name "Forward"
            Tags {"LightMode"="UniversalForward"}
            //"LIGHTMODE" = "CharaEyeForward"

            Blend SrcAlpha OneMinusSrcAlpha  //, SrcAlpha OneMinusSrcAlpha //原Shader里额外写了一个混合，不知道原理
            ColorMask RGB 0
            ZWrite Off

            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT

            #pragma vertex vert
            #pragma fragment frag

            ENDHLSL
        }
    }
    
    Fallback "Hidden/Universal Render Pipeline/FallbackError"
}
