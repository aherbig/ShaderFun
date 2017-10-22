Shader "groen/AnimatedOutline"
{
	Properties
	{
		_ReferenceSizeWidth ("RefSize Width", Float) = 100
		_ReferenceSizeHeight ("RefSize Height", Float) = 100
		_Color ("Color", Color) = (1,1,1,0)
		_BorderWidth ("Border Width", Range (0, 200)) = 5
		_LineLength ("Line Length", Range (0, 500)) = 10
		_AnimationSpeed ("Animation Speed", Float) = 10
		_TiltFactor ("Tilt Factor", Range (-500, 500)) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" 
		"Queue"="Transparent"}
				Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			float4 _Color;
			float _BorderWidth;
			float _LineLength;
			float _AnimationSpeed;
			float _TiltFactor;
			float _ReferenceSizeWidth;
			float _ReferenceSizeHeight;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = fixed4(0,0,0,0);//tex2D(_MainTex, i.uv);

				float pixPositionX = i.uv.x * _ReferenceSizeWidth;
				float pixPositionY = i.uv.y * _ReferenceSizeHeight;
				
				col.a = 0;
				if(pixPositionX <= _BorderWidth)
				{
					float tilt = i.uv.x * _TiltFactor;
					float a = (tilt +pixPositionY - _Time[1]*_AnimationSpeed) % _LineLength*2;
					if(a < 0)
						a += _LineLength*2;
					if(a < _LineLength)
						col = _Color;				
				}
				else if (pixPositionX > _ReferenceSizeWidth -_BorderWidth)
				{
					float tilt = i.uv.x * _TiltFactor;
					float a = (tilt + pixPositionY + _Time[1]*_AnimationSpeed) % _LineLength*2;
					if(a < _LineLength)
						col = _Color;
				}
				if(pixPositionY <= _BorderWidth)
				{
					float tilt = i.uv.y * _TiltFactor;
					float a = (-tilt + pixPositionX + _Time[1]*_AnimationSpeed) % _LineLength*2;
					if(a < _LineLength)
						col = _Color;
				}
				else if(pixPositionY > _ReferenceSizeHeight -_BorderWidth)
				{
					float tilt = i.uv.y * _TiltFactor;
					float a = (-tilt + pixPositionX - _Time[1]*_AnimationSpeed) % _LineLength*2;
					if(a < 0)
						a += _LineLength*2;
					if(a < _LineLength)
						col = _Color;
				}
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
