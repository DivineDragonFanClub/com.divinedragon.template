using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace App {
    public abstract class MapLightProbe : MonoBehaviour
    {
        [Range(0, 1000)] // RVA: 0x18AE00 Offset: 0x18AF01 VA: 0x18AE00
        public int m_Width; // 0x18
        [Range(0, 1000)] // RVA: 0x18AE20 Offset: 0x18AF21 VA: 0x18AE20
        public int m_Height; // 0x1C
        [Range(0, 1000)] // RVA: 0x18AE40 Offset: 0x18AF41 VA: 0x18AE40
        public int m_Blank; // 0x20
        [Range(0, 1000)] // RVA: 0x18AE60 Offset: 0x18AF61 VA: 0x18AE60
        public int m_Split; // 0x24
        
        // Start is called before the first frame update
        void Start()
        {
            
        }
    
        // Update is called once per frame
        void Update()
        {
            
        }
    }
}
