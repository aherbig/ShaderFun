// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/NewOcclusionOutline" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _RimCol ("Rim Colour" , Color) = (1,0,0,1)
        _RimPow ("Rim Power", Float) = 1.0

        _RndTex ("RandomClouds", 2D) = "white" {}
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
               
                sampler2D _MainTex;
				sampler2D _RndTex;
                float4 _RimCol;
                float _RimPow;
               
                float4 _MainTex_ST;
               
                v2f vert (appdata_tan v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                    o.normal = normalize(v.normal);
                    o.viewDir = normalize(ObjSpaceViewDir(v.vertex));       //this could also be WorldSpaceViewDir, which would
                    return o;                                               //return the World space view direction.
                }
               
                fixed4 frag (v2f i) : COLOR
                {
				if(i.uv.x < 0.2) {
				return fixed4(1,0.55,0,1);
				}
					half4 rndseed = tex2D(_MainTex,i.uv);
                    half Rim = saturate(dot(normalize(i.viewDir),  i.normal));       //Calculates where the model view falloff is       
                    
					fixed4 RimOut = _RimCol;// *Rim;
					
					RimOut.a = Rim;
					return RimOut;
                }
                ENDCG
            }
                 
        }
    FallBack "VertexLit"
}