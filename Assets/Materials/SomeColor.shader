Shader "groen/someColor"  {
    Properties {
		_Temperature ("Temperature", Range (-50.0, 50.0)) = 20
        _HeatMapTex ("Temperature Map", 2D) = "white" {}
		_RandomizeStrength ("Randomize Strength", Range (0.0, 200)) = 30
    }
    SubShader {
        Pass {
                Name "Regular"
                Tags { "RenderType"="Transparent"
				"Queue"="Transparent" }
				Blend SrcAlpha OneMinusSrcAlpha
                ZTest LEqual                // this checks for depth of the pixel being less than or equal to the shader
                ZWrite On                   // and if the depth is ok, it renders the main texture.
                Cull Back
                LOD 200
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
               
                struct v2f {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normal : TEXCOORD1;      // Normal needed for rim lighting
                    float3 viewDir : TEXCOORD2;     // as is view direction.
                };
               
                float _Temperature;
				sampler2D _HeatMapTex;
				float _RandomizeStrength;
                float4 _HeatMapTex_ST;

                v2f vert (appdata_tan v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.normal = normalize(v.normal);
                    o.uv = TRANSFORM_TEX(v.texcoord, _HeatMapTex);
                    o.viewDir = normalize(ObjSpaceViewDir(v.vertex));       //this could also be WorldSpaceViewDir, which would
                    return o;                                               //return the World space view direction.
                }
               
                fixed4 frag (v2f i) : COLOR
                {  
					half4 rndseed = tex2D(_HeatMapTex,i.uv);
					
					float heatOffset = rndseed.r * _RandomizeStrength;
					float resultTemperature = _Temperature - _RandomizeStrength/2 + heatOffset;

					float temperatureMinimum = -50.0;
					float temperatureMaximum = 50.0;

					float temperatureRange = (temperatureMaximum - temperatureMinimum);

					float tempPercent = saturate((resultTemperature - temperatureMinimum) / temperatureRange);
					
					
					fixed4 col = 0;
					col.a = 1;

					
					float temperatureRangeBlue = saturate(1 - ((tempPercent - 0.25f) / 0.25f));
					float temperatureRangeGreen = saturate(tempPercent / 0.25f) - saturate((tempPercent - 0.75f) / 0.25f); 
					float temperatureRangeRed = saturate((tempPercent - 0.5f) / 0.25f);

					col.r = temperatureRangeRed;
					col.g = temperatureRangeGreen;
					col.b = temperatureRangeBlue;

					/*
					col.r = 
					0   -> 0,0,1
					.25 -> 0,1,1
					.5  -> 0,1,0
					.75 -> 1,1,0
					1   -> 1,0,0
					*/

					return col;
                }
                ENDCG
            }
                 
        }
    FallBack "VertexLit"
}