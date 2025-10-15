using UnityEngine;

public class AkEnvironmentPortal : MonoBehaviour
{
	public const int MAX_ENVIRONMENTS_PER_PORTAL = 2;

	public Vector3 axis;

	public AkEnvironment[] environments;

	private BoxCollider m_BoxCollider;

	private BoxCollider BoxCollider;

	public bool EnvironmentsShareAuxBus;
}
