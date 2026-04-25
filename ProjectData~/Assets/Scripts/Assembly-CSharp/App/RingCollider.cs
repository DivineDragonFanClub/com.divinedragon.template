using System.Collections.Generic;
using UnityEngine;

namespace App
{
	public class RingCollider : MonoBehaviour
	{
		[Header("Colliders")]
		public List<CapsuleCollider> m_Colliders; // 0x18

		[Header("Settings")]
		[Range(0f, 1f)]
		public float m_Radius; // 0x20

		[Range(0f, 1f)]
		public float m_Height; // 0x24

		[Range(0f, 1f)]
		public float m_ColliderRadius; // 0x28
	}
}
