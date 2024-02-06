Shader "CustomRP/Map/MapLeaf" {
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
		[Toggle(_S_KEY_MAP_SKIP_SPECULAR)] _S_Key_MapSkipSpecular ("Skip Specular", Float) = 0
		[HideInInspector] _Cull ("__cull", Float) = 0
		[HideInInspector] _MainTex ("BaseMap", 2D) = "white" {}
		_Preset ("Preset", Float) = 0
		_WindVector ("Wind Vector", Vector) = (1,0,0,1)
		_WindPower ("Wind Power", Range(0, 1)) = 0.1
		_WindSpeed ("Wind Speed", Range(0, 500)) = 50
		_TranslucentRange ("Range", Range(0, 1)) = 0.5
		_LambertScale ("Lambert Scale", Range(0, 10)) = 2
		_LightEmmision ("Light Emmision", Range(0, 5)) = 1
		[Toggle(_S_KEY_VERTEX_COLOR_WEIGHT)] _VertexColorWeight ("VtxColor Weight", Float) = 0
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
	//CustomEditor "UnityEditor.CustomRP.MapLeafShaderGUI"
}