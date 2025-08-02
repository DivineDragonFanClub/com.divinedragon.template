using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RootMotion.FinalIK {
    public class RotationLimit : MonoBehaviour
    {
        public Vector3 axis; // 0x18
        [HideInInspector]
        public Quaternion defaultLocalRotation; // 0x24
        private bool defaultLocalRotationOverride; // 0x34
        private bool initiated; // 0x35
        private bool applicationQuit; // 0x36
        private bool defaultLocalRotationSet; // 0x37

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