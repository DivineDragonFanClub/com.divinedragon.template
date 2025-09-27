using System.Collections.Generic;
using UnityEngine;

namespace App
{
	public abstract class HubCullingPlayerCollider : MonoBehaviour
	{
		public static readonly string kHubCullingTag; // 0x0
		private GameObject ManualCullingManager; // 0x18
		private Queue<Collider> m_EnterColliders; // 0x20
		private Queue<Collider> m_ExitColliders; // 0x28
	}
}