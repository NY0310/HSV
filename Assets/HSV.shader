Shader "Hidden/HSV"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_AddHSV("AddHSV", Vector) = (0,0,0,0)
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

			float3 rgb2hsv(float3 rgb)
			{
				float3 hsv;
				// RGBで最大の成分
				float maxValue = max(rgb.r,max(rgb.g,rgb.b));
				// RGBで最小の成分
				float minValue = min(rgb.r,min(rgb.g,rgb.b));
				// 最小と最大の差
				float delta = maxValue - minValue;

				// V(明度)
				hsv.z = maxValue;
				// S(彩度)
				hsv.y = delta / maxValue;
			}

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				col.rgb = 1 - col.rgb;
				return col;
			}
			ENDCG
		}
	}
}
