using System.Collections.Generic;
using AK.Wwise;
using UnityEngine;

public class AkEnvironment : MonoBehaviour
{
	public class AkEnvironment_CompareByPriority : IComparer<AkEnvironment>
	{
		public virtual int Compare(AkEnvironment a, AkEnvironment b)
		{
			return default(int);
		}
	}

	public class AkEnvironment_CompareBySelectionAlgorithm : AkEnvironment_CompareByPriority
	{
		public override int Compare(AkEnvironment a, AkEnvironment b)
		{
			return default(int);
		}

	}

	public const int MAX_NB_ENVIRONMENTS = 4;

	public static AkEnvironment_CompareByPriority s_compareByPriority;

	public static AkEnvironment_CompareBySelectionAlgorithm s_compareBySelectionAlgorithm;

	public bool excludeOthers;

	public bool isDefault;

	public AuxBus data;

	private Collider _003CCollider_003Ek__BackingField;

	public int priority;

	private int auxBusIdInternal;

	private byte[] valueGuidInternal;

	public Collider Collider;

	public int m_auxBusID;

	public byte[] valueGuid;
}
