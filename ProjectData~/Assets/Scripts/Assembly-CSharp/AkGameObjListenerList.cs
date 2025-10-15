using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class AkGameObjListenerList : AkAudioListener.BaseListenerList
{
	private AkGameObj akGameObj;

	public List<AkAudioListener> initialListenerList;

	public bool useDefaultListeners;
}
