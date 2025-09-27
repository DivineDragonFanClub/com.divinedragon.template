using System;
using UnityEngine;
using App;

namespace Bridge
{
    [Serializable]
    public class CustomShadowData : ScriptableObject // TypeDefIndex: 5435
    {
        // Fields
        public ShadowResolution MainLightShadowmapResolution; // 0x18
        public float ShadowDistance; // 0x1C
        public float CascadeSplit1; // 0x20
        public float ShadowDepthBias; // 0x24
        public float ShadowNormalBias; // 0x28
    }

    [ExecuteInEditMode]
    public class MapEnvironment : SingletonMonoBehaviour<MapEnvironment>
    {
        [Serializable]
        public class Param // TypeDefIndex: 14073
        {
            // Fields
            public Color color; // 0x10
            [Range(1, 1000)] // RVA: 0x18ADA0 Offset: 0x18AEA1 VA: 0x18ADA0
            public float start; // 0x20
            [Range(1, 1000)] // RVA: 0x18ADC0 Offset: 0x18AEC1 VA: 0x18ADC0
            public float end; // 0x24
            [SpaceAttribute] // RVA: 0x18ADE0 Offset: 0x18AEE1 VA: 0x18ADE0
            public bool useDefaultShadowPreset; // 0x28
            public CustomShadowData overrideShadowPresetData; // 0x30
        }

        public Param Bmap; // 0x20
        public Param Combat; // 0x28

        void Start()
        {
                
        }
    
        // Update is called once per frame
        void Update()
        {
            
        }
    }
}