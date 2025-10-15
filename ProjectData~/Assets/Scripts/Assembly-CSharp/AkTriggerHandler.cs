using System.Collections.Generic;
using UnityEngine;

public abstract class AkTriggerHandler : MonoBehaviour
{
	public const int AWAKE_TRIGGER_ID = 1151176110;

	public const int START_TRIGGER_ID = 1281810935;

	public const int DESTROY_TRIGGER_ID = -358577003;

	public const int ON_ENABLE_TRIGGER_ID = -320808462;

	public const int MAX_NB_TRIGGERS = 32;

	public static Dictionary<uint, string> triggerTypes;

	private bool didDestroy;

	public List<int> triggerList;

	public bool useOtherObject;
}
