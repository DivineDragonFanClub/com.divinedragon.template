using System;
using UnityEngine;

public class AkAuxSendArray : IDisposable
{
	private const int MAX_COUNT = 4;

	private readonly int SIZE_OF_AKAUXSENDVALUE;

	private IntPtr m_Buffer;

	private int m_Count;

	public AkAuxSendValue Item;

	public bool isFull;

	public void Dispose()
	{
	}
}
