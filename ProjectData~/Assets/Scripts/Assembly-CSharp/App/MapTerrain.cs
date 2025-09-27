using System;
using System.Collections.Generic;
using UnityEngine;

namespace App
{
    [Serializable]
    public abstract class MapTerrain: ScriptableObject {

        [Serializable]
        public class LayerData // TypeDefIndex: 14088
        {
            public byte X; // 0x10
            public byte Y; // 0x11
            public byte W; // 0x12
            public byte H; // 0x13
            public int Group; // 0x14
            public string Attr; // 0x18
        }
        
        // Namespace: 
        [Serializable]
        public class OverlapData // TypeDefIndex: 14089
        {
            public byte X; // 0x10
            public byte Y; // 0x11
            public string Attr; // 0x18
        }


        //[HideInInspector] // RVA: 0x18B120 Offset: 0x18B221 VA: 0x18B120
        [SerializeField] // RVA: 0x18B120 Offset: 0x18B221 VA: 0x18B120
        public int m_X; // 0x18
        [SerializeField] // RVA: 0x18B160 Offset: 0x18B261 VA: 0x18B160
        //[HideInInspector] // RVA: 0x18B160 Offset: 0x18B261 VA: 0x18B160
        public int m_Z; // 0x1C
        [Range(1, 100)] // RVA: 0x18B1A0 Offset: 0x18B2A1 VA: 0x18B1A0
        //[HideInInspector] // RVA: 0x18B1A0 Offset: 0x18B2A1 VA: 0x18B1A0
        [SerializeField] // RVA: 0x18B1A0 Offset: 0x18B2A1 VA: 0x18B1A0
        public int m_Width; // 0x20
        [SerializeField] // RVA: 0x18B200 Offset: 0x18B301 VA: 0x18B200
        //[HideInInspector] // RVA: 0x18B200 Offset: 0x18B301 VA: 0x18B200
        [Range(1, 100)] // RVA: 0x18B200 Offset: 0x18B301 VA: 0x18B200
        public int m_Height; // 0x24
        [SerializeField] // RVA: 0x18B260 Offset: 0x18B361 VA: 0x18B260
        public List<LayerData> m_Layers; // 0x28
        [SerializeField] // RVA: 0x18B270 Offset: 0x18B371 VA: 0x18B270
        public List<OverlapData> m_Overlaps; // 0x30
        [SerializeField] // RVA: 0x18B280 Offset: 0x18B381 VA: 0x18B280
        public string[] m_Terrains; // 0x38

        // RVA: 0x201BF10 Offset: 0x201C011 VA: 0x201BF10
        public void SetTid(int x, int z, string tid) { }
    
        // RVA: 0x201BF90 Offset: 0x201C091 VA: 0x201BF90
        public string GetTid(int x, int z) {
            return "lol";
        }

        // RVA: 0x201C110 Offset: 0x201C211 VA: 0x201C110
        public void Clear(string tid) { }
    
        // RVA: 0x201C260 Offset: 0x201C361 VA: 0x201C260
        public void UpdateMapImage() { }
    }
}