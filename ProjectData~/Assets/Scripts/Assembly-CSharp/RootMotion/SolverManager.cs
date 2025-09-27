using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RootMotion {
    public class SolverManager : MonoBehaviour
    {
        public bool fixTransforms; // 0x18
        private Animator animator; // 0x20
        private Animation legacy; // 0x28
        private bool updateFrame; // 0x30
        private bool componentInitiated; // 0x31
        private bool skipSolverUpdate; // 0x32
        
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