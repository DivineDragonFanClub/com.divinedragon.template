using System;
using UnityEngine;

public class AkAuxSendValue : IDisposable
{
	private IntPtr swigCPtr;

	protected bool swigCMemOwn;

	public ulong listenerID;

	public uint auxBusID;

	public float fControlValue;

	public virtual void Dispose()
	{
	}
}
