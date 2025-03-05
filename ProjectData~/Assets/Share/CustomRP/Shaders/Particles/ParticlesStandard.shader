Shader "CustomRP/Particles/ParticlesStandard" {
	Properties {
		[Header(Texture0)]
		[Space(16)]
		[KeywordEnum(NONE,ADD,GRAB)] TEX0_OP ("Texture0 Operator", Float) = 0
		_Texture0 ("Texture", 2D) = "white" { }
		_Power0 ("Power", Vector) = (1,0,0,0)
		_UVParams0 ("UV Params", Vector) = (0,0,0,1)
		_UVScroll0 ("UV Scroll", Vector) = (0,0,0,1)
		_UVGrid0 ("UV Grid", Vector) = (4,4,0,15)
		_UVFlipbook0 ("UV Flipbook", Vector) = (1,1,0,0)
		_UVClamp0 ("UV Clamp", Vector) = (0,0,0,0)
		_UVFlip0 ("UV Flip", Vector) = (0,0,0,0)
		[Toggle(TEX0_UV_GRID)] _Tex0Grid ("Texture0 Grid", Float) = 0
		[Toggle(TEX0_UV_FLIPBOOK)] _Tex0Flipbook ("Texture0 Flipbook", Float) = 0
		[Toggle(TEX0_LERPCOLOR)] _Tex0LC ("Texture0 LerpColor", Float) = 0
		_WhiteColor0 ("White Color", Color) = (1,0.8,0.8,1)
		_MiddleColor0 ("Middle Color", Color) = (0.65,0.4,0.4,1)
		_BlackColor0 ("Black Color", Color) = (0.3,0,0,1)
		_ColorPoints0 ("Color Points", Vector) = (0,0.5,1,0)
		[Toggle(TEX0_CLUT)] _bCLUT0 ("CLUT", Float) = 0
		_CLUT0 ("Color Lookup Texture", 2D) = "white" { }
		
		[Header(Texture1)]
		[Space(16)]
		[KeywordEnum(NONE,ADD,MUL,SUB,BUMPOFFSET)] TEX1_OP ("Texture1 Operator", Float) = 0
		_Texture1 ("Texture", 2D) = "white" { }
		_Power1 ("Power", Vector) = (1,0,0,0)
		_UVParams1 ("UV Params", Vector) = (0,0,0,1)
		_UVScroll1 ("UV Scroll", Vector) = (0,0,0,1)
		_UVGrid1 ("UV Grid", Vector) = (4,4,0,15)
		_UVFlipbook1 ("UV Flipbook", Vector) = (1,1,0,0)
		_UVClamp1 ("UV Clamp", Vector) = (0,0,0,0)
		_UVFlip1 ("UV Flip", Vector) = (0,0,0,0)
		[Toggle(TEX1_UV_GRID)] _Tex1Grid ("Texture1 Grid", Float) = 0
		[Toggle(TEX1_LERPCOLOR)] _Tex1LC ("Texture1 LerpColor", Float) = 0
		_WhiteColor1 ("White Color", Color) = (0.7,1,0.7,1)
		_MiddleColor1 ("Middle Color", Color) = (0.35,0.65,0.35,1)
		_BlackColor1 ("Black Color", Color) = (0,0.3,0,1)
		_ColorPoints1 ("Lerp Color Points", Vector) = (0,0.5,1,0)
		
		[Header(Texture2)]
		[Space(16)]
		[KeywordEnum(NONE,ADD,MUL,SUB)] TEX2_OP ("Texture2 Operator", Float) = 0
		_Texture2 ("Texture", 2D) = "white" { }
		_Power2 ("Power", Vector) = (1,0,0,0)
		_UVParams2 ("UV Params", Vector) = (0,0,0,1)
		_UVScroll2 ("UV Scroll", Vector) = (0,0,0,1)
		_UVGrid2 ("UV Grid", Vector) = (4,4,0,15)
		_UVFlipbook2 ("UV Flipbook", Vector) = (1,1,0,0)
		_UVClamp2 ("UV Clamp", Vector) = (0,0,0,0)
		_UVFlip2 ("UV Flip", Vector) = (0,0,0,0)
		[Toggle(TEX2_UV_GRID)] _Tex2Grid ("Texture2 Grid", Float) = 0
		[Toggle(TEX2_LERPCOLOR)] _Tex2LC ("Texture2 LerpColor", Float) = 0
		_WhiteColor2 ("White Color", Color) = (0.8,0.8,1,1)
		_MiddleColor2 ("Middle Color", Color) = (0.4,0.4,0.6,1)
		_BlackColor2 ("Black Color", Color) = (0,0,0.2,1)
		_ColorPoints2 ("Lerp Color Points", Vector) = (0,0.5,1,0)

		[Header(Misc)]
		[Space(16)]
		_EdgeFade_SoftPtcl ("_EdgeFade_SoftPtcl", Vector) = (0,0.7071068,1,0)
		_AC_Params0 ("AC Params 0", Vector) = (0.5,0.5,0,0.2)
		_AC_Params1 ("AC Params 1", Vector) = (0.5,0.5,0.8,1)
		_AC_Params2 ("AC Params 2", Vector) = (0,0,0,0)
		_AC_MiddleColor ("AC MiddleColor", Color) = (1,0,0,1)
		_GameColor ("Game Color", Color) = (1,1,1,1)
		[HDR]_EnvColor ("Environment Color", Color) = (1,1,1,1)
		[Toggle(APPLY_SUN_OCCLUSION)] _ApplySunOcclusion ("Apply Sun Occlusion", Float) = 0
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOp ("Blend Operation", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend Source", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend Destination", Float) = 10
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTestMode ("Z-Test Equation", Float) = 4
		[Toggle] _ZWriteParam ("Z-Write", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", Float) = 2
		[Enum(RGBA,15,RGB,14)] _ColorMask ("Color Mask", Float) = 15
		_Version ("Version", Float) = 2
		_MiscValue ("MiscValue", Vector) = (0,0,0,0)
		_LuminanceScale ("LuminanceScale", Vector) = (1,1,1,1)
	}
    SubShader
    {
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector"="True" }		
        LOD 100
		BlendOp[_BlendOp]
		Blend [_BlendSrc][_BlendDst]
		ColorMask [_ColorMask]
		Cull [_CullMode]
		ZTest [_ZTestMode]
		ZWrite [_ZWriteParam]

		HLSLINCLUDE
			#pragma target 2.0
			
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
						
			#pragma multi_compile_instancing

			#pragma multi_compile_local TEX0_OP_ADD TEX0_OP_GRAB TEX0_OP_NONE
			#pragma multi_compile_local TEX1_OP_ADD TEX1_OP_MUL TEX1_OP_BUMPOFFSET TEX1_OP_NONE TEX1_OP_SUB
			#pragma multi_compile_local TEX2_OP_ADD TEX2_OP_MUL TEX2_OP_SUB TEX2_OP_NONE
			#pragma multi_compile_local TEX0_LERPCOLOR
			#pragma multi_compile_local TEX1_LERPCOLOR
			#pragma multi_compile_local TEX2_LERPCOLOR

			CBUFFER_START(UnityPerMaterial)
			// Vert color is multiplied by this
			half4 _GameColor;
			half4 _EnvColor;
			
			// Seems to have a value at _Power#.x unknown what its for.
			float4 _Power0;
			float4 _Power1;
			float4 _Power2;
			
			// End of material, seems to be the same case as Power.
			float4 _LuminanceScale;
			
			// Seems to be under LerpColor toggle and Color stuff, unknown, probably the factors for lerp.
			float4 _ColorPoints0;
			float4 _ColorPoints1;
			float4 _ColorPoints2;
			
			// Seems to be used in vert shader, didnt see much when editing them in it though
			float4 _AC_Params0;
			float4 _AC_Params1;
			float4 _AC_Params2;

			// Lerp Color
			real _Tex0LC;
			real _Tex1LC;
			real _Tex2LC;
		
			// Texture0
			TEXTURE2D(_Texture0);
			SAMPLER(sampler_Texture0);
			float4 _Texture0_ST;
			half4 _WhiteColor0;
			half4 _MiddleColor0;
			half4 _BlackColor0;
			float4 _UVParams0;
			float4 _UVScroll0;
			float4 _UVGrid0;
			float4 _UVFlipbook0;
			float4 _UVClamp0;
			float4 _UVFlip0;
			
			// Texture1
			TEXTURE2D(_Texture1);
			SAMPLER(sampler_Texture1);
			float4 _Texture1_ST;
			half4 _WhiteColor1;
			half4 _MiddleColor1;
			half4 _BlackColor1;
			float4 _UVParams1;
			float4 _UVScroll1;
			float4 _UVGrid1;
			float4 _UVFlipbook1;
			float4 _UVClamp1;
			float4 _UVFlip1;
			
			// Texture2
			TEXTURE2D(_Texture2);
			SAMPLER(sampler_Texture2);
			float4 _Texture2_ST;
			half4 _WhiteColor2;
			half4 _MiddleColor2;
			half4 _BlackColor2;
			float4 _UVParams2;
			float4 _UVScroll2;
			float4 _UVGrid2;
			float4 _UVFlipbook2;
			float4 _UVClamp2;
			float4 _UVFlip2;

			// Misc
			float4 _MiscValue; // Seems to be 0 in a chunk of materials, but thunder_Main has y = 1
			float4 _EdgeFade_SoftPtcl; // Name alone makes me think its for the edge of a pixel to give an AA'd look
			CBUFFER_END
			
			struct Attributes
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				half4 color: COLOR;
                float4 texcoord0 : TEXCOORD0;
				float4 texcoord1: TEXCOORD1;
				float4 tangent: TANGENT;
            };

            struct Varyings
            {
			    float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				half4 color: COLOR;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1: TEXCOORD1;
				float4 tangent: TANGENT;
            };

		ENDHLSL
		
        Pass
        {
			Tags { "LightMode" = "UniversalForward" }
			HLSLPROGRAM

			#pragma vertex vert
            #pragma fragment frag
			
			Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.vertex = TransformObjectToHClip(IN.vertex.xyz);
				OUT.normal = TransformObjectToWorldNormal(IN.normal);
				OUT.color = IN.color * _GameColor * _EnvColor;
                OUT.texcoord0 = float4 (IN.texcoord0.xy, IN.texcoord0.z + _MiscValue.w, IN.texcoord0.w);
				OUT.texcoord1 = IN.texcoord1;
				OUT.tangent = IN.tangent;
                return OUT;
            }

            float4 frag(Varyings IN) : SV_Target
            {
				// TEXTURE 0
				#if TEX0_OP_NONE
					float4 tex0 = float4(1,1,1,1);
				#else
					float2 uv0 = float2(IN.texcoord0.x, IN.texcoord0.y);
					if	( _UVFlip0.w > 0 ) {
						uv0 = float2(IN.texcoord0.y, 0 - IN.texcoord0.x);
					}

					float4 tex0 = SAMPLE_TEXTURE2D(_Texture0, sampler_Texture0, TRANSFORM_TEX(uv0, _Texture0));

					tex0 = log2(tex0);

					tex0.x *= _Power0.x;
					tex0.y *= _Power0.x;
					tex0.z *= _Power0.x;
					tex0.w *= _Power0.x;

					tex0 = exp2(tex0);

					if ( _Tex0LC == 1) {
						float4 lerpcolor0 = lerp( lerp( _MiddleColor0, _WhiteColor0, _ColorPoints0.y), lerp( _MiddleColor0, _BlackColor0, _ColorPoints0.y), _ColorPoints0.z);
						float4 color0 = float4(lerpcolor0.rgb + IN.color.rgb, lerpcolor0.a * IN.color.a);
						tex0 = tex0.rgba * color0.rgba;
					} else {
						float4 wtcolor0 = float4(_WhiteColor0.rgb + IN.color.rgb, _WhiteColor0.a * IN.color.a);
						float4 blcolor0 = float4(_BlackColor0.rgb + IN.color.rgb, _BlackColor0.a * IN.color.a);
						float4 mdcolor0 = float4(_MiddleColor0.rgb + IN.color.rgb, _MiddleColor0.a * IN.color.a);

						if ( tex0.r == 1 && tex0.g == 1 && tex0.b == 1 ) {
							tex0.rgb = tex0.rgb * wtcolor0.rgb;
							tex0.a *= wtcolor0.a;						
						} else if ( tex0.r == 0 && tex0.g == 0 && tex0.b == 0) {
							tex0.rgb = tex0.rgb * blcolor0.rgb ;
							tex0.a *= blcolor0.a;						
						} else {
							tex0.rgb = tex0.rgb * mdcolor0.rgb;
							tex0.a *= mdcolor0.a;
						}
					}
				#endif

				// TEXTURE 1

				#if TEX1_OP_NONE
					float4 tex1 = float4(1,1,1,0);
				#else
					float2 uv1 = float2(IN.texcoord0.x, IN.texcoord0.y);
					if	( _UVFlip1.w > 0 ) {
						uv1 = float2(IN.texcoord0.y, 0 - IN.texcoord0.x);
					}

					float4 tex1 = SAMPLE_TEXTURE2D(_Texture1, sampler_Texture1, TRANSFORM_TEX(uv1, _Texture1));

					tex1 = log2(tex1);

					tex1.x *= _Power1.x;
					tex1.y *= _Power1.x;
					tex1.z *= _Power1.x;
					tex1.w *= _Power1.x;

					tex1 = exp2(tex1);

					if ( _Tex1LC == 1) {
						float4 lerpcolor1 = lerp( lerp( _MiddleColor1, _WhiteColor1, _ColorPoints1.y), lerp( _MiddleColor1, _BlackColor1, _ColorPoints1.y), _ColorPoints1.z);
						float4 color1 = float4(lerpcolor1.rgb + IN.color.rgb, lerpcolor1.a * IN.color.a);
						tex1 = tex1.rgba * color1.rgba;
					} else {
						float4 wtcolor1 = float4(_WhiteColor1.rgb + IN.color.rgb, _WhiteColor1.a * IN.color.a);
						float4 blcolor1 = float4(_BlackColor1.rgb + IN.color.rgb, _BlackColor1.a * IN.color.a);
						float4 mdcolor1 = float4(_MiddleColor1.rgb + IN.color.rgb, _MiddleColor1.a * IN.color.a);

						if ( tex1.r == 1 && tex1.g == 1 && tex1.b == 1 ) {
							tex1.rgb = tex1.rgb * wtcolor1.rgb;
							tex1.a *= wtcolor1.a;						
						} else if ( tex1.r == 0 && tex1.g == 0 && tex1.b == 0) {
							tex1.rgb = tex1.rgb * blcolor1.rgb ;
							tex1.a *= blcolor1.a;						
						} else {
							tex1.rgb = tex1.rgb * mdcolor1.rgb;
							tex1.a *= mdcolor1.a;
						}
					}
				#endif

				// TEXTURE 2
				#if TEX2_OP_NONE
					float4 tex2 = float4(1,1,1,0);
				#else
					float2 uv2 = float2(IN.texcoord0.x, IN.texcoord0.y);
					if	( _UVFlip2.w > 0 ) {
						uv2 = float2(IN.texcoord0.y, 0 - IN.texcoord0.x);
					}

					float4 tex2 = SAMPLE_TEXTURE2D(_Texture2, sampler_Texture2, TRANSFORM_TEX(uv2, _Texture2));

					tex2 = log2(tex2);

					tex2.x *= _Power2.x;
					tex2.y *= _Power2.x;
					tex2.z *= _Power2.x;
					tex2.w *= _Power2.x;

					tex2 = exp2(tex2);

					if ( _Tex2LC == 1) {
						float4 lerpcolor2 = lerp( lerp( _MiddleColor2, _WhiteColor2, _ColorPoints2.y), lerp( _MiddleColor2, _BlackColor2, _ColorPoints2.y), _ColorPoints2.z);
						float4 color2 = float4(lerpcolor2.rgb + IN.color.rgb, lerpcolor2.a * IN.color.a);
						tex2 = tex2.rgba * color2.rgba;
					} else {
						float4 wtcolor2 = float4(_WhiteColor2.rgb + IN.color.rgb, _WhiteColor2.a * IN.color.a);
						float4 blcolor2 = float4(_BlackColor2.rgb + IN.color.rgb, _BlackColor2.a * IN.color.a);
						float4 mdcolor2 = float4(_MiddleColor2.rgb + IN.color.rgb, _MiddleColor2.a * IN.color.a);

						if ( tex2.r == 1 && tex2.g == 1 && tex2.b == 1 ) {
							tex2.rgb = tex2.rgb * wtcolor2.rgb;
							tex2.a *= wtcolor2.a;						
						} else if ( tex2.r == 0 && tex2.g == 0 && tex2.b == 0) {
							tex2.rgb = tex2.rgb * blcolor2.rgb ;
							tex2.a *= blcolor2.a;						
						} else {
							tex2.rgb = tex2.rgb * mdcolor2.rgb;
							tex2.a *= mdcolor2.a;
						}
					}
				#endif

				#if TEX0_OP_ADD
					float4 tex = tex0;
				#elif TEX0_OP_GRAB
					float4 tex = tex0;
				#else
					float4 tex = float4(0,0,0,1);
				#endif
				
				#if TEX1_OP_ADD || TEX1_OP_SUB
					tex = tex1 + tex;
				#elif TEX1_OP_MUL
					tex = tex1 * tex;
				#elif TEX1_OP_BUMPOFFSET
					tex = tex1 + tex;
				#endif
				
				#if TEX2_OP_ADD || TEX2_OP_SUB
					tex = tex2 + tex;
				#elif TEX2_OP_MUL
					tex = tex1 * tex;
				#endif
				
				tex.x *= _LuminanceScale.x;
				tex.y *= _LuminanceScale.x;
				tex.z *= _LuminanceScale.x;
				tex.w = saturate(tex.w);
	            return tex ;
            }
			
            ENDHLSL
        }
		
    }
}
