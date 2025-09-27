Shader "CustomRP/Map/MapWater" {
	Properties {
		_Surface ("__surface", Float) = 0
		_SrcBlend ("__src", Float) = 1
		_DstBlend ("__dst", Float) = 0
		_ReflectionTex ("Render Map", 2D) = "black" { }
		_ReflectionTexCube ("Reflection Cube", Cube) = "black" { }
		_ReflectionIntensity ("Reflectivity", Range(0, 1)) = 0.5
		_BaseMap ("Color Map", 2D) = "White" { }
		_DepthTex ("Depth Map", 2D) = "black" { }
		_ShoreTex ("Shore & Foam Texture ", 2D) = "black" { }
		_BumpMap ("Bump Map", 2D) = "bump" { }
		_FlowMap ("Flow Map", 2D) = "bump" { }
		_SpecularMap ("Specular Map", 2D) = "gray" { }
		_DistortParams ("Distortions (Bump waves, Refraction, Fresnel power, Fresnel bias)", Vector) = (1,1,2,1.15)
		_InvFadeParameter ("Auto blend parameter (Edge, Shore, Blend Depth)", Vector) = (0.15,0.15,0.5,1)
		_BumpTiling ("Bump Tiling", Vector) = (2,2,10,10)
		_BumpSpeed ("Speed", Range(0, 10)) = 3
		_SkySpeed ("Rotation Speed", Range(-1, 1)) = 0.1
		_FresnelScale ("Fresnel Scale", Range(0.15, 4)) = 0.75
		_BaseColor ("Base Color", Color) = (0.54,0.95,0.99,0.5)
		_DeepColor ("Deep Color", Color) = (0.54,0.95,0.99,0.5)
		_ReflectionColor ("Reflection Color", Color) = (0.54,0.95,0.99,0.5)
		_SpecularColor ("Specular Color", Color) = (0.72,0.72,0.72,1)
		_WorldLightDir ("Specular light direction", Vector) = (0,0.1,-0.5,0)
		_Shininess ("Shininess", Range(2, 500)) = 200
		_FoamDistortion ("Shore Distortion", Range(0, 16)) = 0.5
		_FoamColor ("Foam Color", Color) = (0.1,0.1,0.1,1)
		_FoamInterval ("Shore Interval", Range(0.1, 10)) = 1
		_FoamIntensity ("Foam Intensity", Range(0, 1)) = 0.1
		[Toggle(WATER_SPECULAR)] _SpecularEnabled ("Specular Enabled", Float) = 0
		_ShadowColor ("Shadow Color", Color) = (0,0,0,1)
		_ShadowExp ("Shadow Exp", Range(0.1, 16)) = 1
		[Toggle(WATER_REFLECTIVE)] _UseReflection ("Use Reflection", Float) = 1
		[Toggle(WATER_RENDER_TEXTURE)] _UseRenderTexture ("Use Render Texture", Float) = 0
		[Toggle(WATER_BOX_PROJECTION)] _UseBoxProjection ("Box Projection", Float) = 0
		_BoxProjectionCenter ("Box Center", Vector) = (0,0,0,1)
		_BoxProjectionSize ("Box Size", Vector) = (1000,1000,1000,1)
		[Toggle(WATER_DEBUG_BOX_PROJECTION)] _IsDebugBoxProjection ("Debug", Float) = 0
		[Toggle(WATER_FLOWNAP)] _UseFlowMap ("Use FlowMap", Float) = 0
		_FlowDir ("Flow Direction", Vector) = (1,0,0,1)
		[Toggle(_ADDITIONAL_LIGHTS)] _UseAdditionalLights ("Additional Lights", Float) = 0
		[Toggle(WATER_GMAP)] _IsGmap ("for GMAP", Float) = 0
		[Toggle(WATER_DEBUG_SPECULAR)] _IsDebugSpecular ("Debug", Float) = 0
		[Toggle] _DebugSpecularMapView ("Image Only", Float) = 0
		[Toggle] _DebugUseR ("Use R Channel ( Shininess )", Float) = 0
		[Toggle] _DebugUseG ("Use G Channel ( Threshold )", Float) = 0
		_DebugShininess ("Shininess", Range(0, 1)) = 0.9
		_DebugThreshold ("Threshold", Range(0, 1)) = 0.9
		_CameraScale ("Min Camera Range", Range(1, 1000)) = 10
		_CameraOffset ("Max Camera Range", Range(1, 1000)) = 100
		_Saturation ("Saturation", Range(0, 5)) = 1
		_Hue ("Hue", Range(-1, 1)) = 0
		_Brightness ("Brigtness", Range(0, 2)) = 1
		[Toggle(WATER_ADDITIONAL_LIGHTS)] _IsAdditionalLights ("Additional Lights", Float) = 0
		_Metallic ("Metallic", Range(0, 1)) = 0
		_Smoothness ("Smoothness", Range(0, 1)) = 0
		_Preset ("Preset", Float) = 0
	}
    SubShader
    {
        Tags {"Queue"="Transparent" "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "IgnoreProjector"="True"}

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

        // 公共寄存器
		SAMPLER(sampler_LinearClamp);
        SAMPLER(sampler_LinearRepeat);
        SAMPLER(sampler_PointClamp);
        SAMPLER(sampler_PointRepeat);

        TEXTURE2D(_BaseMap);
		SAMPLER(sampler_BaseMap);
		float4 _BaseMap_ST;
		TEXTURE2D(_BumpMap);
		TEXTURE2D(_ShoreTex);
		TEXTURE2D(_DepthTex);

        CBUFFER_START(UnityPerMaterial)
        uniform real4 _BaseColor;
		uniform real4 _SpecularColor;
		uniform real4 _FoamColor;
		real _FoamIntensity;
		Vector _WorldLightDir;
		Vector _FlowDir;
		Vector _BumpTiling;
		real _BumpSpeed;
		real _Smoothness;
		real _DebugThreshold;
        CBUFFER_END

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
			
            o.uv = TRANSFORM_TEX(i.uv0, _BaseMap);
            return o;
        }

        real4 frag(VertexOutput i):SV_TARGET
        {
			real2 uv = i.uv;
			//ScrollUv +=  + _FlowDir.y * _Time.y;
			uv *= _BumpTiling;
			real2 horizSwapUv = uv;
			horizSwapUv.x *= -1;
			real3 positionWS = i.positionWS;
            real2 positionPixel = i.positionCS.xy;
			
			// 向量准备
			real3x3 TBN = transpose(real3x3(normalize(i.tangentDirWS), normalize(i.bitangentDirWS), normalize(i.normalDirWS)));
            real4 normalMap = SAMPLE_TEXTURE2D(_BumpMap, sampler_BaseMap,i.uv);
			real3 normalDirTS = UnpackNormal(normalMap.rgba);
			real3 normalDirWS = normalize(mul(TBN, normalDirTS));
            real3 normalDirVS = TransformWorldToViewDir(normalDirWS, true);
            real3 viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);
            Light mainLight = GetMainLight();
            real3 lightDirWS = normalize(mainLight.direction);
            real3 halfDirWS = normalize(viewDirWS + _WorldLightDir);

			// 向量计算
            real NL01 = dot(normalDirWS, _WorldLightDir) * 0.5+ 0.5;
            real NV01 = max(0.0, dot(normalDirWS, viewDirWS));
            real NH01 = max(0.0, dot(normalDirWS, halfDirWS));
			
			real4 foamMap = SAMPLE_TEXTURE2D(_ShoreTex, sampler_BaseMap,uv + (_FlowDir * _BumpSpeed) * (_Time.y / 2));
			real4 foamMap2 = SAMPLE_TEXTURE2D(_ShoreTex, sampler_BaseMap, horizSwapUv + (_FlowDir * _BumpSpeed) * _Time.y);
			real4 depthMap = SAMPLE_TEXTURE2D(_DepthTex, sampler_BaseMap, i.uv);

			foamMap *= (_FoamColor * _FoamIntensity);
			foamMap2 *= (_FoamColor * _FoamIntensity);
			
			
			
			real3 Specular = lerp(0, _SpecularColor.rgb, NL01); // * i.color.r;
			real4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv);
			real3 finalColor = Specular * (baseMap.rgb * _BaseColor.rgb);
            
			baseMap.rgb = finalColor;
			baseMap.a = 1;
            return baseMap + foamMap + foamMap2 + depthMap;
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
