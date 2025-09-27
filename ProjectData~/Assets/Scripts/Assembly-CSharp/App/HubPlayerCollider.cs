using System.Collections.Generic;

using UnityEngine;

namespace App
{
	public class HubPlayerCollider : MonoBehaviour
	{
		public bool m_isFront; // 0x18
		public HubPlayerController m_Notification; // 0x20
		public Queue<Collider> m_EnterColliders; // 0x28
		public Queue<Collider> m_ExitColliders; // 0x30
	}
}