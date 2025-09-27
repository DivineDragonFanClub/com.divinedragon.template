using UnityEngine;

namespace App
{
	public class HubAccessCursor : MonoBehaviour
	{
		// Fields
		private HubAccess TargetAccess; // 0x18
		private GameObject CharaFader; // 0x20
		private float FadeDistance; // 0x28
		private HubPlayerController PlayerController; // 0x30
		private int m_propetyToID; // 0x38
		private Renderer[] m_renderer; // 0x40
		private Material[] m_materials; // 0x48
		private float m_alpha; // 0x50
	}
}