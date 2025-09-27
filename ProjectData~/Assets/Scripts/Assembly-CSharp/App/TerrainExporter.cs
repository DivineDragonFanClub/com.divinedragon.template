using UnityEngine;

namespace App
{
	[ExecuteAlways]
	public abstract class TerrainExporter : MonoBehaviour
	{
		[HideInInspector] // RVA: 0x1731F0 Offset: 0x1732F1 VA: 0x1731F0
		[SerializeField] // RVA: 0x1731F0 Offset: 0x1732F1 VA: 0x1731F0
		private Vector3 m_TerrainSize; // 0x18
		[SerializeField] // RVA: 0x173230 Offset: 0x173331 VA: 0x173230
		[HideInInspector] // RVA: 0x173230 Offset: 0x173331 VA: 0x173230
		private string m_OriginalTerrainGuid; // 0x28
	}
}