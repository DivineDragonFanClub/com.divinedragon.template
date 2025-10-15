using System.Collections.Generic;
using UnityEngine;

public class AkAudioListener : MonoBehaviour
{
	public class BaseListenerList
	{
		private readonly List<ulong> listenerIdList;

		private readonly List<AkAudioListener> listenerList;

		private readonly List<AkAudioListener> ListenerList;
	}

	public class DefaultListenerList : BaseListenerList
	{

	}

	private static readonly DefaultListenerList defaultListeners;

	private ulong akGameObjectID;

	private List<AkGameObj> EmittersToStartListeningTo;

	private List<AkGameObj> EmittersToStopListeningTo;

	public bool isDefaultListener;

	public int listenerId;

	public static DefaultListenerList DefaultListeners;
}
