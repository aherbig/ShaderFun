Shader "groen/PostEffectShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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
			//_Time[0]  seconds/20
			//_Time[1]  seconds
			//_Time[2]  seconds*2
			//_Time[3]  seconds*3

				fixed4 col = tex2D(_MainTex, i.uv + float2( 0, sin(i.vertex.x/50 + _Time[1]) /50));
				// just invert the colors
				
				//col = 1 - col;

				float borderWidth = 0.1f;

				if(i.uv[0] < borderWidth) {
					col = col * i.uv[0]/borderWidth;
				}
				if(i.uv[0] > (1-borderWidth)) {
					float colormulti = 1- ((i.uv[0] - (1-borderWidth))/borderWidth);
					col = col * colormulti;
				}
				if(i.uv[1] < borderWidth) {
					col = col * i.uv[1]/borderWidth;
				}
				if(i.uv[1] > 1-borderWidth) {
					float colormulti = 1- ((i.uv[1] - (1-borderWidth))/borderWidth);
					col = col * colormulti;
				}

				return col;
			}
			ENDCG
		}
	}
}
