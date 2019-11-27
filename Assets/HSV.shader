Shader "Hidden/HSV"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[Color]
		_Color("Color", Color) = (0,0,0,0)
		_AddHSV("AddHSV", Color) = (0,0,0,0)
	}
	SubShader
	{
		// No culling or depth
		//Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

        // RGB->HSV変換
        float3 rgb2hsv(float3 rgb)
        {
            float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            float4 p = rgb.g < rgb.b ? float4(rgb.bg, K.wz) : float4(rgb.gb, K.xy);
            float4 q = rgb.r < p.x ? float4(p.xyw, rgb.r) : float4(rgb.r, p.yzx);

            float d = q.x - min(q.w, q.y);
            float e = 1.0e-10;
            return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
        }



			   // HSV->RGB変換
        float3 hsv2rgb(float3 hsv)
        {
            float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            float3 p = abs(frac(hsv.xxx + K.xyz) * 6.0 - K.www);
            return hsv.z * lerp(K.xxx, saturate(p - K.xxx), hsv.y);
        }

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float3 _Color;
			float3 _AddHSV;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 col = _Color + hsv2rgb(_AddHSV);
				return fixed4(col,1);
			}
			ENDCG
		}
	}
}
