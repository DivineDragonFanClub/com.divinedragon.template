using System;
using UnityEngine;

public class WwiseObjectReference : ScriptableObject
{
	public string objectName = "EventName";
	public uint id = 0;
	public string guid = Guid.NewGuid().ToString();
	public Guid Guid = new Guid();
	private string ObjectName;
	private string DisplayName;
	private uint Id;
}
