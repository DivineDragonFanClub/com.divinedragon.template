Shader "CustomRP/Chara/CharaRing" {
	Properties {
		_BaseColor ("Color", Vector) = (1,1,1,1)
		_BaseMap ("Albedo", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_BumpScale ("BumpScale", Range(0.01, 2)) = 1
		_MultiMap ("Multi Map", 2D) = "black" {}
		_ToonRamp ("Toon Ramp", 2D) = "white" {}
		_ToonRampMetal ("Toon Ramp Metal", 2D) = "white" {}
		_ToonShadowColor ("Toon Shadow Color", Vector) = (1,1,1,1)
		_OcclusionIntensity ("_OcclusionIntensity", Range(0, 1)) = 1
		[Toggle(_KEY_DIRTY_MODE)] _Key_DirtyMode ("Dirty Mode", Float) = 0
		[Toggle(_KEY_DIRTY_USE_NORMAL)] _Key_DirtyUseNormal ("Dirty Use Normal", Float) = 0
		_DirtyMask ("Dirty Mask", 2D) = "white" {}
		_BaseMapDirty ("Albedo Dirty", 2D) = "white" {}
		_BumpMapDirty ("Normal Dirty", 2D) = "bump" {}
		_MultiMapDirty ("Multi Dirty", 2D) = "white" {}
		_DirtToBeauty ("Dirty To Beauty", Range(0, 1)) = 0
		_DirtToBeautyBlendWidth ("Dirty To Beauty Blend Width", Range(0, 1)) = 0.1
		_OutlineColor ("OutlineColor", Vector) = (0.5,0.5,0.5,1)
		_OutlineScale ("OutlineScale", Range(0, 10)) = 5
		_OutlineTexMipLevel ("OutlineTexMipLevel", Range(0, 12)) = 4
		_OutlineOriginalColorRate ("OutlineOriginalColorRate", Range(0, 1)) = 0
		_OutlineGameScale ("OutlineGameScale", Range(0, 1)) = 1
		[Toggle] _S_Key_RimLight ("Use Rim Light", Float) = 1
		_RimLightColorLight ("RimLightColorLight", Vector) = (1,1,1,1)
		_RimLightColorShadow ("RimLightColorShadow", Vector) = (1,1,1,1)
		_RimLightBlend ("RimLightBlend", Range(0, 1)) = 0
		_RimLightScale ("RimLightScale", Range(0, 1)) = 0
		[Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
		_DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
		_BumpCameraAttenuation ("BumpCameraAttenuation", Range(0, 1)) = 0.2
		_Preset ("Preset", Float) = 0
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			float4x4 unity_ObjectToWorld;
			float4x4 unity_MatrixVP;

			struct Vertex_Stage_Input
			{
				float4 pos : POSITION;
			};

			struct Vertex_Stage_Output
			{
				float4 pos : SV_POSITION;
			};

			Vertex_Stage_Output vert(Vertex_Stage_Input input)
			{
				Vertex_Stage_Output output;
				output.pos = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.pos));
				return output;
			}

			float4 frag(Vertex_Stage_Output input) : SV_TARGET
			{
				return float4(1.0, 1.0, 1.0, 1.0); // RGBA
			}

			ENDHLSL
		}
	}
	Fallback "Hidden/Universal Render Pipeline/FallbackError"
	//CustomEditor "UnityEditor.CustomRP.CharaRingShaderGUI"
}