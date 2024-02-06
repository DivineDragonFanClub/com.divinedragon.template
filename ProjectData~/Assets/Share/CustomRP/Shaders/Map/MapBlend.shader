Shader "CustomRP/Map/MapBlend" {
    Properties {
        _AlbedoMap0 ("AlbedoMap0", 2D) = "white" { }
        _AlbedoMap1 ("AlbedoMap1", 2D) = "white" { }
        _AlbedoMap2 ("AlbedoMap2", 2D) = "white" { }
        _AlbedoMap3 ("AlbedoMap3", 2D) = "white" { }
        _AlbedoMap4 ("AlbedoMap4", 2D) = "white" { }
        _NormalMap0 ("NormalMap0", 2D) = "bump" { }
        _NormalScale0 ("NormalScale0", Range(0.01, 2)) = 1
        _MaskMap ("MaskMap", 2D) = "white" { }
        _BakedAlbedoMap ("BakedAlbedoMap", 2D) = "white" { }
        _BlendBakedAlbedo_MaxDistance ("BlendBakedAlbedo MaxDistance", Range(1, 1000)) = 50
        _BlendBakedAlbedo_CurveExp ("BlendBakedAlbedo CurveExp", Range(0, 8)) = 2
        _BlendBakedAlbedo_MipBias ("BlendBakedAlbedo MipBias", Range(0, 10)) = 2
        _ToonRamp ("Toon Ramp", 2D) = "white" { }
        _Standard_To_Ramp ("Standard_To_Ramp", Range(0, 1)) = 0.025
        [Toggle(_S_KEY_TOON_SHADOW)] _S_Key_ToonShadow ("ApplyToonShadow", Float) = 0
        _ToonShadowRate ("ToonShadowRate", Range(0, 1)) = 0.5
        _EmissionMap ("Emission Map", 2D) = "white" { }
        _EmissionColor ("Emission Color", Color) = (0,0,0,1)
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
        [Toggle(_S_KEY_DETAIL)] _S_Key_Detail ("Detail", Float) = 0
        _DetailBumpMap ("Detail Normal Map", 2D) = "bump" { }
        _DetailBumpScale ("DetailScale", Range(0.01, 2)) = 1
        [Toggle(_S_KEY_RIM_LIGHT)] _S_Key_RimLight ("Use Rim Light", Float) = 0
        _RimLightColorLight ("RimLightColorLight", Color) = (1,1,1,1)
        _RimLightColorShadow ("RimLightColorShadow", Color) = (1,1,1,1)
        _RimLightBlend ("RimLightBlend", Range(0, 1)) = 0
        _RimLightScale ("RimLightScale", Range(0, 1)) = 0
        [Toggle(_S_KEY_ROUGHNESS)] _S_Key_Roughness ("Roughness", Float) = 0
        _RoughnessMap ("RoughnessMap", 2D) = "white" { }
        _RoughnessToWhite ("Roughness To White", Range(0, 1)) = 0
        [Toggle(_S_KEY_MUL_VERTEX_COLOR)] _S_Key_MulVertexColor ("Use Vertex Color", Float) = 0
        [Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
        _DitherAlphaValue ("Dither Alpha Value", Range(0, 1)) = 1
        [Toggle(_S_KEY_MAP_SKIP_SPECULAR)] _S_Key_MapSkipSpecular ("Skip Specular", Float) = 0
        [Toggle(_S_KEY_SKIP_FOG)] _S_Key_SkipFog ("Skip Fog", Float) = 0
        [Toggle(_S_KEY_5_ALBEDO_LAYERS)] _S_Key_5AlbedoLayers ("5 Albedo Layers", Float) = 0
        [Toggle(_S_KEY_BLEND_BAKED_ALBEDO)] _S_Key_BlendBakedAlbedo ("Blend Baked Albedo Map", Float) = 0
        _Surface ("__surface", Float) = 0
        _AlphaClip ("__clip", Float) = 0
        _SrcBlend ("__src", Float) = 1
        _DstBlend ("__dst", Float) = 0
        _ZWrite ("__zw", Float) = 1
        _Cull ("__cull", Float) = 2
        _Preset ("Preset", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
