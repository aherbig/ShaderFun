Shader "groen/BasicUV" {
	SubShader {
		
		PASS 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v) {
				v2f output;
				output.vertex = UnityObjectToClipPos(v.vertex);
				output.uv = v.uv;
				return output;
			}

			float4 frag(v2f i) : SV_Target
			{

				return float4(i.uv[0], i.uv[1], 1, 1);
			}

			ENDCG
		}
	}
}
