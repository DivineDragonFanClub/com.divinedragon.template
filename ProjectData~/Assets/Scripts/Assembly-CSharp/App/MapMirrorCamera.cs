using UnityEngine;

namespace App
{
	public class MapMirrorCamera : MonoBehaviour
	{
		public Camera m_renderCamera; // 0x18
		public float m_OffsetY; // 0x20
		public float m_MarginForChara; // 0x24
		public float m_MarginForMapObj; // 0x28
		public bool m_UseEditorCamera; // 0x2C
	}
}