Shader "CustomRP/Map/MapBlend" {
    Properties {
        _AlbedoMap0 ("AlbedoMap0", 2D) = "white" { }
        _AlbedoMap1 ("AlbedoMap1", 2D) = "white" { }
        _AlbedoMap2 ("AlbedoMap2", 2D) = "white" { }
        _AlbedoMap3 ("AlbedoMap3", 2D) = "white" { }
        _AlbedoMap4 ("AlbedoMap4", 2D) = "black" { }
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
        Tags {"RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "IgnoreProjector"="True"}

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

        // 公共寄存器
		SAMPLER(sampler_LinearClamp);
        SAMPLER(sampler_LinearRepeat);
        SAMPLER(sampler_PointClamp);
        SAMPLER(sampler_PointRepeat);

        TEXTURE2D(_AlbedoMap0);
		float4 _AlbedoMap0_ST;
		TEXTURE2D(_AlbedoMap1);
		float4 _AlbedoMap1_ST;
		TEXTURE2D(_AlbedoMap2);
		float4 _AlbedoMap2_ST;
		TEXTURE2D(_AlbedoMap3);
		float4 _AlbedoMap3_ST;
		TEXTURE2D(_AlbedoMap4);
		float4 _AlbedoMap4_ST;
		TEXTURE2D(_MaskMap);
		TEXTURE2D(_BakedAlbedoMap);
		float4 _BakedAlbedoMap_ST;
		TEXTURE2D(_NormalMap0);
		TEXTURE2D(_EmissionMap);
		TEXTURE2D(_ToonRamp);

        CBUFFER_START(UnityPerMaterial)
		uniform real4 _RimLightColorLight;
		uniform real4 _RimLightColorShadow;
		uniform real4 _EmissionColor;
		Vector _WorldLightDir;
		float _RimLightBlend;
		float _RimLightScale;
		float _S_Key_RimLight;
		float _NormalScale0;
		float _Standard_To_Ramp;
        CBUFFER_END

        struct VertexInput
        {
            real3 positionOS  : POSITION;
            real3 normalDirOS : NORMAL;
            real4 tangentDirOS : TANGENT;
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
            //o.uv = i.uv0;
            o.uv = TRANSFORM_TEX(i.uv0, _BakedAlbedoMap);
            return o;
        }

        real4 frag(VertexOutput i):SV_TARGET
        {
            real3 positionWS = i.positionWS;
            real2 positionPixel = i.positionCS.xy;
			
			// 向量准备
			real3x3 TBN = transpose(real3x3(normalize(i.tangentDirWS), normalize(i.bitangentDirWS), normalize(i.normalDirWS)));
            real3 normalDirTS = UnpackNormalScale(SAMPLE_TEXTURE2D(_NormalMap0, sampler_LinearClamp, i.uv).rgba, _NormalScale0);
			real3 normalDirWS = normalize(mul(TBN, normalDirTS));
            real3 normalDirVS = TransformWorldToViewDir(normalDirWS, true);
            real3 viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);
            Light mainLight = GetMainLight();
            real3 lightDirWS = normalize(mainLight.direction);
            real3 halfDirWS = normalize(viewDirWS + lightDirWS);
			
			// 向量计算
            real NL01 = dot(normalDirWS, lightDirWS) * 0.5+ 0.5;
            real NV01 = max(0.0, dot(normalDirWS, viewDirWS));
            real NH01 = max(0.0, dot(normalDirWS, halfDirWS));
			
			real rimLightScale = smoothstep((1-_RimLightBlend), 1.0, 1-NV01) * _RimLightScale;
            if (_S_Key_RimLight == 0){
				rimLightScale = 0;
			}			
			real4 baseMap0 = SAMPLE_TEXTURE2D(_AlbedoMap0, sampler_PointRepeat, TRANSFORM_TEX(i.uv, _AlbedoMap0));
			real4 baseMap1 = SAMPLE_TEXTURE2D(_AlbedoMap1, sampler_PointRepeat, TRANSFORM_TEX(i.uv, _AlbedoMap1));
			real4 baseMap2 = SAMPLE_TEXTURE2D(_AlbedoMap2, sampler_PointRepeat, TRANSFORM_TEX(i.uv, _AlbedoMap2));
			real4 baseMap3 = SAMPLE_TEXTURE2D(_AlbedoMap3, sampler_PointRepeat, TRANSFORM_TEX(i.uv, _AlbedoMap3));
			real4 baseMap4 = SAMPLE_TEXTURE2D(_AlbedoMap4, sampler_PointRepeat, TRANSFORM_TEX(i.uv, _AlbedoMap4));
			real4 maskMap = SAMPLE_TEXTURE2D(_MaskMap, sampler_LinearClamp, i.uv);
			real4 bakedAlbedoMap = SAMPLE_TEXTURE2D(_BakedAlbedoMap, sampler_LinearClamp, i.uv);
			real4 emissionMap = SAMPLE_TEXTURE2D(_EmissionMap, sampler_LinearClamp, i.uv);
			
			
			
			// 采样ToonRamp
            real2 toonRampUV = real2(NL01, 0.5); 
            real4 toonRamp = SAMPLE_TEXTURE2D_LOD(_ToonRamp, sampler_LinearClamp, toonRampUV, 0);
			
			real3 finalRamp = lerp(bakedAlbedoMap.rgb, toonRamp.rgb, _Standard_To_Ramp);
            	
			real3 rimLight = lerp(_RimLightColorShadow.rgb, _RimLightColorLight.rgb, NL01) * rimLightScale; // * i.color.r; //最后的强度再乘顶点色描边强度
			
			real3 basemap = (baseMap0.rgb * maskMap.r);
			//real3 basemap = lerp(baseMap4.rgb,(1 - (maskMap.r + maskMap.g + maskMap.b)),1);
			basemap = basemap + (baseMap4.rgb * (1 - (maskMap.r + maskMap.g + maskMap.b))) + (baseMap1.rgb * maskMap.g) + (baseMap2.rgb * maskMap.b) + (baseMap3.rgb * maskMap.a);
			
			real3 finalColor = basemap + (emissionMap.rgb * _EmissionColor.rgb);
            
            return real4(basemap.rgb, 1);
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
}

