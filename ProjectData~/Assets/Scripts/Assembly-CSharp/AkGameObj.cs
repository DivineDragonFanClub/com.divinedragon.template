using System.Collections.Generic;
using UnityEngine;

public class AkGameObj : MonoBehaviour
{
	public AkGameObjListenerList m_listeners;

	public bool isEnvironmentAware;

	public bool isStaticObject;

	private Collider m_Collider;

	private AkGameObjEnvironmentData m_envData;

	private AkGameObjPositionData m_posData;

	public AkGameObjPositionOffsetData m_positionOffsetData;

	private bool isRegistered;

	public AkGameObjPosOffsetData m_posOffsetData;

	private const int AK_NUM_LISTENERS = 8;
	
	public int listenerMask;

	private bool IsUsingDefaultListeners;

	private List<AkAudioListener> ListenerList;
}
