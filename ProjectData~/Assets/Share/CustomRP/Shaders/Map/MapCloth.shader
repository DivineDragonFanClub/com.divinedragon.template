Shader "CustomRP/Map/MapCloth" {
	Properties {
		_BaseColor ("Color", Vector) = (1,1,1,1)
		_BaseMap ("Albedo", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_BumpScale ("BumpScale", Range(0.01, 2)) = 1
		_MultiMap ("Multi Map", 2D) = "black" {}
		_ToonRamp ("Toon Ramp", 2D) = "white" {}
		_Standard_To_Ramp ("Standard_To_Ramp", Range(0, 1)) = 0.025
		[Toggle(_S_KEY_TOON_SHADOW)] _S_Key_ToonShadow ("ApplyToonShadow", Float) = 0
		_ToonShadowRate ("ToonShadowRate", Range(0, 1)) = 0.5
		_EmissionMap ("Emission Map", 2D) = "white" {}
		_EmissionColor ("Emission Color", Vector) = (0,0,0,1)
		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
		[Toggle(_S_KEY_DETAIL)] _S_Key_Detail ("Detail", Float) = 0
		_DetailBumpMap ("Detail Normal Map", 2D) = "bump" {}
		_DetailBumpScale ("DetailScale", Range(0.01, 2)) = 1
		[Toggle(_S_KEY_RIM_LIGHT)] _S_Key_RimLight ("Use Rim Light", Float) = 0
		_RimLightColorLight ("RimLightColorLight", Vector) = (1,1,1,1)
		_RimLightColorShadow ("RimLightColorShadow", Vector) = (1,1,1,1)
		_RimLightBlend ("RimLightBlend", Range(0, 1)) = 0
		_RimLightScale ("RimLightScale", Range(0, 1)) = 0
		[Toggle(_S_KEY_MUL_VERTEX_COLOR)] _S_Key_MulVertexColor ("Use Vertex Color", Float) = 0
		[Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
		_DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
		[HideInInspector] _Surface ("__surface", Float) = 0
		[HideInInspector] _AlphaClip ("__clip", Float) = 0
		[HideInInspector] _SrcBlend ("__src", Float) = 1
		[HideInInspector] _DstBlend ("__dst", Float) = 0
		[HideInInspector] _ZWrite ("__zw", Float) = 1
		[HideInInspector] _MainTex ("BaseMap", 2D) = "white" {}
		_Preset ("Preset", Float) = 0
		_WindPower ("Wind Power", Vector) = (1,1,1,1)
		_WaveSpeed ("Wave Speed", Range(0, 30)) = 1
		_WaveSpan ("Wave Span", Range(0, 10)) = 0.5
		_Delta ("Delta Normal", Range(0, 10)) = 0.1
		_OffsetScale ("Offset Scale", Range(0, 1)) = 0
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		sampler2D _MainTex;
		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	Fallback "Hidden/Universal Render Pipeline/FallbackError"
	//CustomEditor "UnityEditor.CustomRP.MapClothShaderGUI"
}