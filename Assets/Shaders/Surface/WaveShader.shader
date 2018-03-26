Shader "Custom/WaveShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v, out Input o)
		{
			// oを初期化
			UNITY_INITIALIZE_OUTPUT(Input, o);
			// 時間とX座標を元に、Y軸に使う係数を算出
			float amp = 0.5 * sin(_Time * 100 + v.vertex.x * 100);
			// Y軸のみに適用
			v.vertex.xyz = float3(v.vertex.x, v.vertex.y + amp, v.vertex.z);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
