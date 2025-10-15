using System;
using System.Runtime.InteropServices;
using UnityEngine;

public class AkPositionArray : IDisposable
{
	private struct FloatInt32Union
	{
		public float f;

		public int i;
	}

	public IntPtr m_Buffer;

	private IntPtr m_Current;

	private uint m_MaxCount;

	private uint _003CCount_003Ek__BackingField;

	private static FloatInt32Union FloatToInt;

	public uint Count;

	public void Dispose()
	{ }

}