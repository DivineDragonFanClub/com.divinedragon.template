Shader "CustomRP/Map/MapGrass" {
	Properties {
		[Space(20)] [Header(Texture Settings)] _GroundTex ("GroundTexture", 2D) = "white" {}
		_GroundLightmap ("GroundLightmap", 2D) = "white" {}
		_GroundShadowMask ("GroundShadowMask", 2D) = "white" {}
		_Cutoff ("CutoffThreshold", Range(0, 1)) = 0.5
		[Space(20)] [Header(Grass Settings)] _DrawDistanceSq ("DrawDistanceSq", Float) = 10
		_WavingTint ("WaveColor", Vector) = (0.7,0.6,0.5,0)
		_WaveSpeed ("WaveSpeed", Float) = 1
		_WaveSize ("WaveSize", Float) = 0.5
		_WaveBending ("WaveBending", Float) = 1
		_GrassBrightness ("GrassBrightness", Float) = 1
		_GrassTintColor ("GrassColor", Vector) = (1,1,1,1)
		_BaseColor ("GrassColor", Vector) = (1,1,1,1)
		_GroundColorCoefficient ("GroundColorCoefficient", Float) = 1
		_GroundColorAttenuation ("GroundColorAttenuation", Float) = 1
		_DistanceClipScale ("DistanceClipScale", Vector) = (0,0,0,0)
		_NearClipDistanceSq ("NearClipDistanceSq", Float) = 0
		_NearDownDistance ("NearDownDistance", Float) = 3
		_NearDownOffset ("NearDownOffset", Float) = 0.1
		_RandomOffset ("RandomOffset", Float) = 0
		_RandomScale ("RandomScale", Float) = 1
		_LightingMin ("LightingMin", Float) = 0
		_InteractionCenter ("Interaction Center", Vector) = (0,0,0,1)
		_InteractionRadiusSqR ("Interaction Radius Square R", Float) = 1
		_InteractionAngle ("Interaction Angle", Float) = 0.2
		_InteractionHeightCorrection ("Interaction Height Correction", Float) = 1
		[HideInInspector] _GroundLightmapScaleOffset ("GroundLightmapST", Vector) = (1,1,0,0)
		[HideInInspector] _TerrainSize ("Terrain Size", Vector) = (1,1,1,1)
		[HideInInspector] _TerrainSize ("Terrain Offset", Vector) = (0,0,0,1)
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
}