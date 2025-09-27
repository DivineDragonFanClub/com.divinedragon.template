using System;
using UnityEngine;
using App;

namespace Bridge
{

    [ExecuteInEditMode]
    public class MapProjection : SingletonMonoBehaviour<MapProjection>
    {
        public Texture m_Texture; // 0x20
        [Range(0, 100)] // RVA: 0x18AE80 Offset: 0x18AF81 VA: 0x18AE80
        public float m_OffsetX; // 0x28
        [Range(0, 100)] // RVA: 0x18AEA0 Offset: 0x18AFA1 VA: 0x18AEA0
        public float m_OffsetY; // 0x2C
        [Range(0, 100)] // RVA: 0x18AEC0 Offset: 0x18AFC1 VA: 0x18AEC0
        public float m_SpeedX; // 0x30
        [Range(0, 100)] // RVA: 0x18AEE0 Offset: 0x18AFE1 VA: 0x18AEE0
        public float m_SpeedY; // 0x34
        [Range(0, 100)] // RVA: 0x18AF00 Offset: 0x18B001 VA: 0x18AF00
        public float m_Scale; // 0x38
        [Range(0, 100)] // RVA: 0x18AF20 Offset: 0x18B021 VA: 0x18AF20
        public float m_Alpha; // 0x3C
        public Color32 m_SightSideColor; // 0x40
        public Color32 m_SightDarkColor; // 0x44
        public Color32 m_SightMaskColor; // 0x48
        private Texture2D m_SightTexture; // 0x50
        private Color32[] m_SightColors; // 0x58
        //private MapImageSight m_SightImage; // 0x60
        private int m_SightWidth; // 0x68
        private int m_SightHeight; // 0x6C
        private int m_MapProjectionTex; // 0x70
        private int m_MapProjectionScale; // 0x74
        private int m_MapProjectionAlpha; // 0x78
        private int m_MapProjectionOffset; // 0x7C
        private int m_MapProjectionSpeed; // 0x80

        void Start()
        {
                
        }
    
        // Update is called once per frame
        void Update()
        {
            
        }
    }
}