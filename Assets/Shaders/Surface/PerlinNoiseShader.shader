Shader "Custom/PerlinNoiseShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};
		
		float random(fixed2 st) {
		    st    = fixed2(
		        dot(st, fixed2(127.1, 311.7)),
		        dot(st, fixed2(269.5, 183.3)));
		    return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
		}
			
		float2 perlinNoise(fixed2 st) {
		    // 小数部を切り捨て
		    fixed2 p = floor(st);
		    // 整数部を切り捨て
		    fixed2 f = frac(st);
		    // これは補完の式
		    fixed2 u = f * f * (3.0 - 2.0 * f);
		    
		    // ブロックの四隅の色
		    float v00   = random(p + fixed2(0, 0));
		    float v10   = random(p + fixed2(1, 0));
		    float v01   = random(p + fixed2(0, 1));
		    float v11   = random(p + fixed2(1, 1));
		    
		    return lerp(
		        lerp(dot(v00, f - fixed2(0, 0)), dot(v10, f - fixed2(1, 0)), u.x),
		        lerp(dot(v01, f - fixed2(0, 1)), dot(v11, f - fixed2(1, 1)), u.x),
		        u.y) + 0.5f;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
		    float c         = perlinNoise(IN.uv_MainTex * 8);
		    o.Albedo        = fixed4(c, c, c, 1);
		    o.Metallic      = 0;
		    o.Smoothness    = 0;
		    o.Alpha         = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
