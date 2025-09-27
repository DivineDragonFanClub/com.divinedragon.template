using UnityEngine;

using System.Collections.Generic;

using Bridge;

namespace App
{
	public abstract class TerrainPaintGetter : MonoBehaviour
	{
		public TerrainPaintData m_Data; // 0x18
		public bool m_drawDebugGizmo; // 0x20
		public float m_debugGizmoHeight; // 0x24
		public Color m_debugGizmoGridColor; // 0x28
		public List<int> m_debugGizmoDrawIndex; // 0x38
		[RangeAttribute(0, 1)] // RVA: 0x173370 Offset: 0x173471 VA: 0x173370
		public float m_debugGizmoDrawAlpha; // 0x40
		public List<Color> m_debugGizmoDrawColor; // 0x48
	}
}