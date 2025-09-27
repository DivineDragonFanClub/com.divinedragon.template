using System;
using UnityEngine;

namespace Bridge
{
    public class CameraConstraint : MonoBehaviour
    {
        public Camera m_Target; // 0x18
        private Camera m_Camera; // 0x20
        private Vector3 m_Position; // 0x28
        private Quaternion m_Rotation; // 0x34
        
        void Start()
        {
                
        }
    
        // Update is called once per frame
        void Update()
        {
            
        }
    }
}