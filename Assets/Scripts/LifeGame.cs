using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class LifeGame : MonoBehaviour 
{
	int row = 8;
	int col = 8;
	int[,] states;
	int[,] cacheStates;
	public Material material;
	void Start()
	{
		InitShader();
		InitStates();
		InitColor();
	}

	void Update()
	{
		if (Time.frameCount % 20 == 0)
		{
			UpdateState();
		}
	}

	void InitShader() 
	{
		int total = row * col;
		material.SetFloat("_BoardSize", row);
		material.SetFloat("_BlockSize", 1.0f / row);
		material.SetFloat("_TotalBlock", total);
		for (int i = 0; i < total; i++)
		{
			material.SetFloat("_Vals" + i.ToString(), 0);
		}
	}

	void InitStates()
	{
		states = new int[row, col];
		cacheStates = new int[row, col];
		for (int i = 0; i < row; i++)
		{
			for (int j = 0; j < col; j++)
			{
				if (Random.value < 0.2f)
				{
					cacheStates[i, j] = states[i, j] = 1;
				}
				else
				{
					cacheStates[i,j] = states[i, j] = 0;
				}
			}
		}
	}

	void InitColor()
	{
		for (int i = 0; i < row; i++)
		{
			for (int j = 0; j < col; j++)
			{
				SetColor(i, j);
			}
		}
	}

	void SetColor(int i, int j)
	{
		material.SetFloat("_Vals" + (i * col + j).ToString(), states[i,j]);
	}

	void UpdateState()
	{
		for (int i = 0; i < row; i++)
		{
			for (int j = 0; j < col; j++)
			{
				int cnt = GetAroundLife(i, j);
				if (cnt == 3)
				{
					cacheStates[i,j] = 1;
				}
				else if(cnt == 2)
				{
					cacheStates[i,j] = states[i,j];
				}
				else
				{
					cacheStates[i,j] = 0;
				}
			}
		}
		for (int i = 0; i < row; i++)
		{
			for (int j = 0; j < col; j++)
			{
				if (states[i,j] != cacheStates[i,j])
				{
					states[i,j] = cacheStates[i,j] ;
					SetColor(i, j);
				}
			}
		}
	}

	// 获取周围存活的细胞数量
	int GetAroundLife(int r, int c)
	{
		int cnt = 0;
		// 左上
		if (r - 1 >=0 && c - 1 >= 0)
		{
			cnt += states[r - 1, c - 1];
		}
		// 上
		if (r - 1 >=0)
		{
			cnt += states[r - 1, c];
		}
		// 右上
		if (r - 1 >=0 && c + 1 < col)
		{
			cnt += states[r - 1, c + 1];
		}
		// 左
		if (c - 1 >= 0)
		{
			cnt += states[r, c-1];
		}
		// 右
		if (c + 1 < col)
		{
			cnt += states[r, c + 1];
		}
		// 左下
		if (r + 1 < row && c - 1 >= 0)
		{
			cnt += states[r + 1, c - 1];
		}
		// 上
		if (r + 1 < row)
		{
			cnt += states[r + 1, c];
		}
		// 右上
		if (r + 1 < row && c + 1 < col)
		{
			cnt += states[r + 1, c + 1];
		}
		return cnt;
	}
}
