Shader "CustomRP/Chara/CharaJewel" {
	Properties {
		_BaseColor ("Base Color", Color) = (0.7,0.7,0.7,1)
		_RimLightColor ("RimLight Color", Color) = (0.2,0.2,0.2,1)
		_RimLightPower ("RimLight Power", Range(0.1, 1)) = 0.25
		[HDR] _EmissionColor ("Emission Color", Color) = (0,0,0,1)
		_Matcap1 ("Matcap1", 2D) = "black" {}
		_Matcap2 ("Matcap2", 2D) = "black" {}
		_Matcap1Scale ("Matcap1 Scale", Range(0, 2)) = 1
		_Matcap2Scale ("Matcap2 Scale", Range(0, 2)) = 1
		_ReflectionPower ("Reflection Power", Range(0.1, 16)) = 3
		_Refraction ("Refraction", Range(0, 1)) = 0.5
		_Transparency ("Transparency", Range(0, 1)) = 0.25
		[Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
		_DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
		[Toggle(_KEY_DIRTY_MODE)] _Key_DirtyMode ("Dirty Mode", Float) = 0
		_DirtToBeauty ("Dirty To Beauty", Range(0, 1)) = 0
		_DirtScale ("Dirty Scale", Range(0, 1)) = 0.5
	}
	//DummyShaderTextExporter
	SubShader{
		Tags {"RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "IgnoreProjector"="True"}
		
		HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

		SAMPLER(sampler_LinearClamp);
        SAMPLER(sampler_LinearRepeat);
        SAMPLER(sampler_PointClamp);
        SAMPLER(sampler_PointRepeat);

		uniform real4 _BaseColor;
		uniform real4 _RimLightColor;
		uniform real _RimLightPower;
		uniform real4 _EmissionColor;
		TEXTURE2D(_Matcap1);
		TEXTURE2D(_Matcap2);
		uniform real _Matcap1Scale;
		uniform real _Matcap2Scale;
		uniform real _ReflectionPower;
		uniform real _Refraction;
		uniform real _Transparency;

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
			real4 m4 = mul(UNITY_MATRIX_V, float4(i.normalDirWS.x, i.normalDirWS.y, i.normalDirWS.z, 0));
			real2 matcapUV = real2(m4.x, m4.y) * 0.5 +real2(0.5, 0.5);
			real4 matcap1 = SAMPLE_TEXTURE2D(_Matcap1, sampler_LinearRepeat, matcapUV * _Matcap1Scale);
			real4 matcap2 = SAMPLE_TEXTURE2D(_Matcap2, sampler_LinearRepeat, matcapUV * _Matcap2Scale);

			return real4(_BaseColor + matcap1 + matcap2);
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
	//CustomEditor "UnityEditor.CustomRP.CharaJewelShaderGUI"
}