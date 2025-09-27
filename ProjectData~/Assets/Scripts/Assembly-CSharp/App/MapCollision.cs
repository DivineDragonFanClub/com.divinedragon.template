using UnityEngine;

namespace App
{
	public abstract class MapCollision : MonoBehaviour
	{
		private MapObject m_MapObject; // 0x18
		private Renderer[] m_Renderers; // 0x20
		private float m_Alpha; // 0x28
		[HideInInspector] // RVA: 0x18AD80 Offset: 0x18AE81 VA: 0x18AD80
		public bool m_DisableCloseTransparent; // 0x2C
	}
}