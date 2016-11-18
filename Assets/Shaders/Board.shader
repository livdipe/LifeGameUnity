Shader "Custom/Board" 
{
	Properties 
	{
		_ColorA ("ColorA", Color) = (1,1,1,1)
		_ColorB ("ColorB", Color) = (0,1,0,1)
		_ColorC ("ColorC", Color) = (0,0,0,0)
		_BorderWidth ("Board width (uv)", Range(0,1)) = 0.012
		_LineWidthHalf ("Half width of middle line (uv)", Range(0,1)) = 0.003
		_BoardSize ("Board Size", Float) = 8
		_BlockSize ("Block Size", Float) = 0.125
		_TotalBlock ("Total Block", Float) = 64
	}
	
	SubShader 
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			half4 _ColorA;
			half4 _ColorB;
			half4 _ColorC;
			half _BorderWidth;
			half _LineWidthHalf;
			half _BoardSize;
			half _BlockSize;
			half _TotalBlock;
			uniform half _Vals[64];

			bool isborder(half2 uv)
			{
				if (uv.x <= _BorderWidth || uv.x >= 1 - _BorderWidth)
				{
					return true;
				}
				else if (uv.y <= _BorderWidth || uv.y >= 1 - _BorderWidth)
				{
					return true;
				}
				return false;
			}
			
			bool isline(half2 uv)
			{
				for (int k = 1; k < _BoardSize; k++)
				{
					if (uv.x >= k * _BlockSize - _LineWidthHalf && uv.x <= k * _BlockSize + _LineWidthHalf)
					{
						return true;
					}
					if (uv.y >= k * _BlockSize - _LineWidthHalf && uv.y <= k * _BlockSize + _LineWidthHalf)
					{
						return true;
					}
				}
				return false;
			}
			
			half4 frag(v2f_img i) : SV_Target
			{
				half4 colour = _ColorA;

				if (isborder(i.uv))
				{
					colour = _ColorC;
				}
				else if (isline(i.uv))
				{
					colour = _ColorC;
				}
				if (_TotalBlock > 0)
				{
					half row = floor(i.uv.y / _BlockSize);
					half col = floor(i.uv.x / _BlockSize);
					int idx = round(row * _BoardSize  + col);
					
					if (idx < _TotalBlock)
					{
						if (_Vals[idx] > 0)
						{
							colour = _ColorB;
						}
				    }
				}

				return colour;
			}
			ENDCG
		}
	} 
}
