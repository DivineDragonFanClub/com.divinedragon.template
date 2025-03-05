Shader "CustomRP/Map/MapBackground" {
	Properties {
		_BaseColor ("Color", Color) = (1,1,1,1)
		_BaseMap ("Albedo", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_BumpScale ("BumpScale", Range(0.01, 2)) = 1
		_ToonRamp ("Toon Ramp", 2D) = "white" {}
		_Standard_To_Ramp ("Standard_To_Ramp", Range(0, 1)) = 0.025
		[Toggle(_KEY_DITHER_ALPHA)] _Key_DitherAlpha ("Dither Alpha", Float) = 0
	}
	//DummyShaderTextExporter
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

        TEXTURE2D(_BaseMap);
		float4 _BaseMap_ST;
		TEXTURE2D(_BumpMap);
		TEXTURE2D(_ToonRamp);

        CBUFFER_START(UnityPerMaterial)
        uniform real4 _BaseColor;
		Vector _WorldLightDir;
		float _BumpScale;
		float _Standard_To_Ramp;
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
            real3 positionWS = i.positionWS;
            real2 positionPixel = i.positionCS.xy;
			
			// 向量准备
			real3x3 TBN = transpose(real3x3(normalize(i.tangentDirWS), normalize(i.bitangentDirWS), normalize(i.normalDirWS)));
            real3 normalDirTS = UnpackNormalScale(SAMPLE_TEXTURE2D(_BumpMap, sampler_LinearClamp, i.uv).rgba, _BumpScale);
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
			
			real4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_LinearClamp, i.uv);
			
			
			
			// 采样ToonRamp
            real2 toonRampUV = real2(NL01, 0.5); 
            real4 toonRamp = SAMPLE_TEXTURE2D_LOD(_ToonRamp, sampler_LinearClamp, toonRampUV, 0);
			
			real3 finalRamp = lerp(baseMap.rgb, toonRamp.rgb, _Standard_To_Ramp);
            	
			
			real3 finalColor = finalRamp * (baseMap.rgb * _BaseColor.rgb);
            
            return real4(finalColor, 1);
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