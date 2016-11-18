Shader "Custom/Board" 
{
	Properties 
	{
		_ColorA ("ColorA", Color) = (1,1,1,1)
		_ColorB ("ColorB", Color) = (0,1,0,1)
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
			uniform half _BoardSize = 8;
			uniform half _BlockSize = 0.125;
			uniform half _TotalBlock = 0;
			uniform half _Vals[64];
			
			half4 frag(v2f_img i) : SV_Target
			{
				half4 colour = _ColorA;
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
