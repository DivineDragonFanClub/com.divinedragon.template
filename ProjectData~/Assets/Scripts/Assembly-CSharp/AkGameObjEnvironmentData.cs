using System.Collections.Generic;
using UnityEngine;

public class AkGameObjEnvironmentData
{
	private readonly List<AkEnvironment> activeEnvironments;

	private readonly List<AkEnvironment> activeEnvironmentsFromPortals;

	private readonly List<AkEnvironmentPortal> activePortals;

	private readonly AkAuxSendArray auxSendValues;

	private Vector3 lastPosition;

	private bool hasEnvironmentListChanged;

	private bool hasActivePortalListChanged;

	private bool hasSentZero;
}
