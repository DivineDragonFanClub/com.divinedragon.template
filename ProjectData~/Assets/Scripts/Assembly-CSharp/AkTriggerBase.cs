using System.Collections.Generic;
using UnityEngine;

public abstract class AkTriggerBase : MonoBehaviour
{
	public delegate void Trigger(GameObject in_gameObject);

	public Trigger triggerDelegate;

	public static Dictionary<uint, string> GetAllDerivedTypes()
	{
		return null;
	}

}
