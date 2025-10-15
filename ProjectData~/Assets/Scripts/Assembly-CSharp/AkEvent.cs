using System;
using System.Collections.Generic;
using AK.Wwise;
using UnityEngine;
using static AkDragDropTriggerHandler;
using static AkTriggerHandler;

public class AkEvent : AkDragDropTriggerHandler
{
	[Serializable]
	public class CallbackData
	{
		public CallbackFlags Flags;
		public string FunctionName;
		public GameObject GameObject;
	}
	public AkActionOnEventType actionOnEventType;
	public AkCurveInterpolation curveInterpolation;
	public bool enableActionOnEvent;
	public AK.Wwise.Event data;
	public bool useCallbacks;
	public List<CallbackData> Callbacks;
	public uint playingId;
	public UnityEngine.Object soundEmitterObject;
	public float transitionDuration;
	private AkEventCallbackMsg EventCallbackMsg;
	public int eventIdInternal;
	public byte[] valueGuidInternal;
	public AkEventCallbackData m_callbackDataInternal;
	private int eventID;
	private byte[] valueGuid;
	private AkEventCallbackData m_callbackData;
}
