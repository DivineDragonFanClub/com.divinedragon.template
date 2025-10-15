using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AkAmbient : AkEvent
{
	public static Dictionary<uint, AkMultiPosEvent> multiPosEventTree;
	public AkMultiPositionType MultiPositionType;
	public MultiPositionTypeLabel multiPositionTypeLabel;
	public AkAmbientLargeModePositioner[] LargeModePositions;
	private static uint EmitterPosCountMax;
	private Vector3[] EmitterPosArray;
	private Vector3[] EmitterFowardArray;
	private Vector3[] EmitterUpArray;
	private AkPositionArray PositionArray;
	private List<AkAmbientLargeModePositioner> ValidPositionList;
	public List<Vector3> multiPositionArray;
}
