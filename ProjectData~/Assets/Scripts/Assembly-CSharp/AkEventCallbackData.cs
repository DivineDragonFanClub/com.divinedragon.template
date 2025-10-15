using System.Collections.Generic;
using UnityEngine;

public class AkEventCallbackData : ScriptableObject
{
	public List<int> callbackFlags;
	public List<string> callbackFunc;
	public List<GameObject> callbackGameObj;
	public int uFlags;

	public AkEventCallbackData()
	{
	}
}
