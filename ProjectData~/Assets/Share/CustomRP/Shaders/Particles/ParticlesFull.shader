Shader "CustomRP/Particles/ParticlesFull" {
    Properties {
        [Header(Texture0)]
        [Space(16)]
        [KeywordEnum(NONE,ADD)] TEX0_OP ("Texture0 Operator", Float) = 0
        _Texture0 ("Texture", 2D) = "white" { }
        _Power0 ("Power", Vector) = (1, 0, 0, 0)
        _UVParams0 ("UV Params", Vector) = (0, 0, 0, 1)
        _UVScroll0 ("UV Scroll", Vector) = (0, 0, 0, 1)
        _UVGrid0 ("UV Grid", Vector) = (4, 4, 0, 15)
        _UVFlipbook0 ("UV Flipbook", Vector) = (1, 1, 0, 0)
        _UVClamp0 ("UV Clamp", Vector) = (0, 0, 0, 0)
        _UVFlip0 ("UV Flip", Vector) = (0, 0, 0, 0)
        _WhiteColor0 ("White Color", Color) = (1, 0.8, 0.8, 1)
        _MiddleColor0 ("Middle Color", Color) = (0.65, 0.4, 0.4, 1)
        _BlackColor0 ("Black Color", Color) = (0.3, 0, 0, 1)
        _ColorPoints0 ("Color Points", Vector) = (0, 0.5, 1, 0)

        [Header(Texture1)]
        [Space(16)]
        [KeywordEnum(NONE,ADD,MUL)] TEX1_OP ("Texture1 Operator", Float) = 0
        _Texture1 ("Texture", 2D) = "white" { }
        _Power1 ("Power", Vector) = (1, 0, 0, 0)
        _UVParams1 ("UV Params", Vector) = (0, 0, 0, 1)
        _UVScroll1 ("UV Scroll", Vector) = (0, 0, 0, 1)
        _UVGrid1 ("UV Grid", Vector) = (4, 4, 0, 15)
        _UVFlipbook1 ("UV Flipbook", Vector) = (1, 1, 0, 0)
        _UVClamp1 ("UV Clamp", Vector) = (0, 0, 0, 0)
        _UVFlip1 ("UV Flip", Vector) = (0, 0, 0, 0)
        _WhiteColor1 ("White Color", Color) = (0.7, 1, 0.7, 1)
        _MiddleColor1 ("Middle Color", Color) = (0.35, 0.65, 0.35, 1)
        _BlackColor1 ("Black Color", Color) = (0, 0.3, 0, 1)
        _ColorPoints1 ("Lerp Color Points", Vector) = (0, 0.5, 1, 0)

        [Header(Misc)]
        [Space(16)]
        _EdgeFade_SoftPtcl ("_EdgeFade_SoftPtcl", Vector) = (0, 0.7071068, 1, 0)
        _AC_Params0 ("AC Params 0", Vector) = (0.5, 0.5, 0, 0.2)
        _AC_Params1 ("AC Params 1", Vector) = (0.5, 0.5, 0.8, 1)
        _AC_Params2 ("AC Params 2", Vector) = (0, 0, 0, 0)
        _AC_MiddleColor ("AC MiddleColor", Color) = (1, 0, 0, 1)
        _GameColor ("Game Color", Color) = (1, 1, 1, 1)
        [HDR] _EnvColor ("Environment Color", Color) = (1, 1, 1, 1)
        [Enum(UnityEngine.Rendering.BlendOp)] _BlendOp ("Blend Operation", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend Source", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend Destination", Float) = 10
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTestMode ("Z-Test Equation", Float) = 4
        [Toggle] _ZWriteParam ("Z-Write", Float) = 0
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", Float) = 2
        [Enum(RGBA,15,RGB,14)] _ColorMask ("Color Mask", Float) = 15
        _Version ("Version", Float) = 2
        _MiscValue ("MiscValue", Vector) = (0, 0, 0, 0)
        _LuminanceScale ("LuminanceScale", Vector) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
        LOD 100
        BlendOp [_BlendOp]
        Blend [_BlendSrc] [_BlendDst]
        ColorMask [_ColorMask]
        Cull [_CullMode]
        ZTest [_ZTestMode]
        ZWrite [_ZWriteParam]

        Pass
        {
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma target 2.0
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_instancing
            #pragma multi_compile _ PROCEDURAL_INSTANCING_ON

            #pragma shader_feature_local TEX0_OP_NONE TEX0_OP_ADD
            #pragma shader_feature_local TEX1_OP_NONE TEX1_OP_ADD TEX1_OP_MUL

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            CBUFFER_START(UnityPerMaterial)
                half4 _GameColor;
                half4 _EnvColor;

                float4 _Power0;
                float4 _Power1;

                float4 _LuminanceScale;

                float4 _ColorPoints0;
                float4 _ColorPoints1;

                float4 _AC_Params0;
                float4 _AC_Params1;
                float4 _AC_Params2;
                half4  _AC_MiddleColor;

                float4 _Texture0_ST;
                half4  _WhiteColor0;
                half4  _MiddleColor0;
                half4  _BlackColor0;
                float4 _UVParams0;
                float4 _UVScroll0;
                float4 _UVGrid0;
                float4 _UVFlipbook0;
                float4 _UVClamp0;
                float4 _UVFlip0;

                float4 _Texture1_ST;
                half4  _WhiteColor1;
                half4  _MiddleColor1;
                half4  _BlackColor1;
                float4 _UVParams1;
                float4 _UVScroll1;
                float4 _UVGrid1;
                float4 _UVFlipbook1;
                float4 _UVClamp1;
                float4 _UVFlip1;

                float4 _MiscValue;
                float4 _EdgeFade_SoftPtcl;
            CBUFFER_END

            TEXTURE2D(_Texture0); SAMPLER(sampler_Texture0);
            TEXTURE2D(_Texture1); SAMPLER(sampler_Texture1);

            struct Attributes
            {
                float4 vertex    : POSITION;
                half4  color     : COLOR;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 vertex    : SV_POSITION;
                half4  color     : COLOR;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT = (Varyings)0;
                UNITY_SETUP_INSTANCE_ID(IN);
                UNITY_TRANSFER_INSTANCE_ID(IN, OUT);

                OUT.vertex = TransformObjectToHClip(IN.vertex.xyz);
                OUT.color = IN.color * _GameColor * _EnvColor;
                OUT.texcoord0 = float4(IN.texcoord0.xy, IN.texcoord0.z + _MiscValue.w, IN.texcoord0.w);
                OUT.texcoord1 = IN.texcoord1;
                return OUT;
            }

            float4 SampleStage(
                Texture2D tex, SamplerState samp, float4 stST,
                float2 baseUV, float4 uvFlip, float4 uvClamp,
                float power, half4 vertCol)
            {
                float2 uv = baseUV;
                if (uvFlip.w > 0.0) uv = float2(baseUV.y, -baseUV.x);
                uv = uv * stST.xy + stST.zw;

                float4 t = SAMPLE_TEXTURE2D(tex, samp, uv);
                t = exp2(log2(max(t, 1e-6)) * power);

                float3 maskedRGB = lerp(t.rgb, float3(1, 1, 1), uvClamp.z);
                float  alpha     = lerp(t.a,   t.r,             uvClamp.z);
                return float4(maskedRGB * vertCol.rgb, alpha * vertCol.a);
            }

            float4 frag(Varyings IN) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(IN);
                half4 vertCol = IN.color;

                #if defined(TEX0_OP_NONE)
                    float4 tex0 = float4(1, 1, 1, 1);
                #else
                    float4 tex0 = SampleStage(
                        _Texture0, sampler_Texture0, _Texture0_ST,
                        IN.texcoord0.xy, _UVFlip0, _UVClamp0,
                        _Power0.x, vertCol);
                #endif

                #if defined(TEX1_OP_NONE)
                    float4 tex1 = float4(1, 1, 1, 0);
                #else
                    float4 tex1 = SampleStage(
                        _Texture1, sampler_Texture1, _Texture1_ST,
                        IN.texcoord0.xy, _UVFlip1, _UVClamp1,
                        _Power1.x, vertCol);
                #endif

                #if defined(TEX0_OP_ADD)
                    float4 tex = tex0;
                #else
                    float4 tex = float4(0, 0, 0, 1);
                #endif

                #if defined(TEX1_OP_ADD)
                    tex = tex1 + tex;
                #elif defined(TEX1_OP_MUL)
                    tex = tex1 * tex;
                #endif

                tex.rgb *= _LuminanceScale.x;
                tex.w = saturate(tex.w);
                return tex;
            }
            ENDHLSL
        }
    }
}
