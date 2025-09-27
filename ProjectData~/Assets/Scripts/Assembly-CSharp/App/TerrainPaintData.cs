using UnityEngine;

namespace App
{
    public abstract class TerrainPaintData : ScriptableObject
    {
        [SerializeField] // RVA: 0x173270 Offset: 0x173371 VA: 0x173270
        private int SplitCount; // 0x18
        [SerializeField] // RVA: 0x1732B0 Offset: 0x1733B1 VA: 0x1732B0
        private Vector2 TerrainSize; // 0x1C
        [SerializeField] // RVA: 0x1732F0 Offset: 0x1733F1 VA: 0x1732F0
        private string[] Name; // 0x28
        [SerializeField] // RVA: 0x173330 Offset: 0x173431 VA: 0x173330
        private int[] Index; // 0x30
    }
}
